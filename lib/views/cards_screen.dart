import 'package:flutter/material.dart';
import '../models/bank_card.dart';
import '../models/user.dart';
import '../controllers/card_controller.dart';
import '../services/api_service.dart';

class CardsScreen extends StatefulWidget {
  final User user;

  const CardsScreen({super.key, required this.user});

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final _cardController = TextEditingController();
  final _balanceController = TextEditingController();
  final CardController _controller = CardController();
  Future<List<BankCard>>? _futureCards;

  @override
  void initState() {
    super.initState();
    _futureCards = ApiService().getCards(widget.user.id);
  }

  void _addCard() async {
    if (_cardController.text.length == 16 && _cardController.text.isNotEmpty && _balanceController.text.isNotEmpty) {
      final balance = double.tryParse(_balanceController.text);
      if (balance == null || balance < 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Balance inválido')));
        return;
      }
      try {
        await _controller.addCard(widget.user.id, _cardController.text, balance);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarjeta agregada correctamente')));

        setState(() {
          _futureCards = ApiService().getCards(widget.user.id); // Recargar las tarjetas
        });

        _cardController.clear();
        _balanceController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, complete todos los campos')));
    }
  }

  void _freezeCard(int cardId) async {
    try {
      await _controller.freezeCard(cardId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarjeta congelada')));

      setState(() {
        _futureCards = ApiService().getCards(widget.user.id); // Recargar las tarjetas
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _cardController,
            decoration: InputDecoration(labelText: 'Número de tarjeta', icon: Icon(Icons.credit_card)),
            keyboardType: TextInputType.number,
            maxLength: 16,
          ),
          TextField(
            controller: _balanceController,
            decoration: InputDecoration(labelText: 'Balance inicial', icon: Icon(Icons.account_balance_wallet)),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Agregar Tarjeta'),
            onPressed: _addCard,
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<BankCard>>(
              future: _futureCards, // Usamos la variable en lugar de llamar directamente a la API
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error al obtener tarjetas: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No tienes tarjetas asociadas.'));
                }

                final cards = snapshot.data!;
                return ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text('Tarjeta: **** **** **** ${card.cardNumber.substring(12)}'),
                      subtitle: Text(card.isFrozen ? 'Congelada' : 'Activa'),
                      trailing: IconButton(
                        icon: Icon(Icons.lock),
                        onPressed: card.isFrozen ? null : () => _freezeCard(card.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

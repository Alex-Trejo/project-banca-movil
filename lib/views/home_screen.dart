import 'package:flutter/material.dart';
import 'package:project_banca_movil/views/payments_screen.dart';
import 'package:project_banca_movil/views/transactions_screen.dart';
import '../models/user.dart';
import '../models/bank_card.dart';
import '../services/api_service.dart'; // Asegúrate de importar el servicio que obtiene las tarjetas

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BankCard>>(
      future: ApiService().getCards(user.id), // Obtener las tarjetas del usuario
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
        final totalBalance = cards.fold(0.0, (sum, card) => sum + card.balance); // Sumar los balances de todas las tarjetas

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.person, size: 40),
                  title: Text('Bienvenido, ${user.name}', style: TextStyle(fontSize: 20)),
                  subtitle: Text('Correo: ${user.email}\nSaldo total: \$${totalBalance.toStringAsFixed(2)}'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.payment),
                    label: Text('Pagar'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentsScreen(user: user))),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.history),
                    label: Text('Historial'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionsScreen(user: user))),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text('Tarjeta: **** **** **** ${card.cardNumber.substring(12)}'),
                      subtitle: Text('Saldo: \$${card.balance.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

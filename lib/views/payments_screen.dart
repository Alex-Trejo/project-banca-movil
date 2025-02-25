import 'package:flutter/material.dart';
import '../models/user.dart';
import '../controllers/payment_controller.dart';

class PaymentsScreen extends StatefulWidget {
  final User user;

  const PaymentsScreen({super.key, required this.user});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final _amountController = TextEditingController();
  final _cardController = TextEditingController();
  final PaymentController _controller = PaymentController();

  void _processPayment() async {
    if (_amountController.text.isNotEmpty && _cardController.text.length == 16) {
      try {
        final payment = await _controller.processPayment(
          widget.user.id,
          double.parse(_amountController.text),
          _cardController.text,
        );
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Pago Exitoso'),
            content: Text('Monto: \$${payment.amount}'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Añadir Scaffold aquí para que funcione el Material Design
      appBar: AppBar(
        title: Text('Pagar'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Monto', icon: Icon(Icons.attach_money)),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cardController,
              decoration: InputDecoration(labelText: 'Número de tarjeta', icon: Icon(Icons.credit_card)),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.payment),
              label: Text('Realizar Pago'),
              onPressed: _processPayment,
            ),
          ],
        ),
      ),
    );
  }
}

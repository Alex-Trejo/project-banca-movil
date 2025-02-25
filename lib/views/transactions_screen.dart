import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../controllers/transaction_controller.dart';

class TransactionsScreen extends StatelessWidget {
  final User user;
  final TransactionController _controller = TransactionController();

  TransactionsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(title: Text('Historial de Transacciones')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Transaction>>(
          future: _controller.getTransactions(user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al obtener transacciones: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay transacciones disponibles.'));
            }

            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                    '${transaction.details}\n${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transaction.timestamp))}',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:project_banca_movil/views/payments_screen.dart';
import 'package:project_banca_movil/views/transactions_screen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/notification_service.dart';
import 'cards_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
      CardsScreen(user: widget.user),
      PaymentsScreen(user: widget.user),
      TransactionsScreen(user: widget.user),
    ];
    Provider.of<NotificationService>(context, listen: false).subscribeToUserTopic(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banca Móvil'),
        backgroundColor: Colors.teal[700], // Color de la app bar
        elevation: 4,
      ),
      drawer: NavigationDrawer(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            accountEmail: Text(widget.user.email, style: TextStyle(color: Colors.white70)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.teal[700]),
            ),
            decoration: BoxDecoration(
              color: Colors.teal[600], // Fondo del drawer
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.teal),
            title: Text('Inicio', style: TextStyle(color: Colors.teal)),
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          ListTile(
            leading: Icon(Icons.credit_card, color: Colors.teal),
            title: Text('Tarjetas', style: TextStyle(color: Colors.teal)),
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.teal),
            title: Text('Pagos', style: TextStyle(color: Colors.teal)),
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.teal),
            title: Text('Historial', style: TextStyle(color: Colors.teal)),
            onTap: () => setState(() => _selectedIndex = 3),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.teal),
            title: Text('Cerrar Sesión', style: TextStyle(color: Colors.teal)),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Consumer<NotificationService>(
        builder: (context, notificationService, _) {
          if (notificationService.message != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(notificationService.message!),
                backgroundColor: Colors.teal[600], // Color del snackbar
              ));
            });
          }
          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.teal[700]!, Colors.teal[500]!], // Gradiente sin blanco
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: (index) => setState(() => _selectedIndex = index),
    selectedItemColor: const Color.fromARGB(255, 83, 184, 92), // Color de los elementos seleccionados
    unselectedItemColor: const Color.fromARGB(179, 21, 201, 147), // Color de los elementos no seleccionados
    backgroundColor: Colors.transparent, // Fondo transparente para el BottomNavigationBar
    elevation: 0, // Opcional: Elimina la sombra para que el gradiente se vea mejor
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.credit_card),
        label: 'Tarjetas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.payment),
        label: 'Pagos',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'Historial',
      ),
    ],
  ),
),

    );
  }
}

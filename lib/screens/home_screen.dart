import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luggo/screens/login_screen.dart';
import 'package:luggo/screens/services_screen.dart';
import 'package:luggo/screens/chats_screen.dart';
import 'package:luggo/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/notification_manager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey _notificacionKey = GlobalKey();
  OverlayEntry? _notificacionOverlay;

  List<Widget> _screens = <Widget>[
    HomeScreenContent(),
    ServicesScreen(),
    ChatsScreen(),
    SettingsScreen(),
  ];

  List<Type> _screensSinBottomNav = [SettingsScreen];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRemembered', false);
    prefs.setString("userUID", "none");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<String?> _getUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userUID');
  }

  void _toggleNotificaciones() {
    if (NotificationManager.notificaciones.isEmpty) return;

    if (_notificacionOverlay == null) {
      _mostrarOverlayNotificaciones();
    } else {
      _cerrarOverlayNotificaciones();
    }
  }

  void _mostrarOverlayNotificaciones() {
    final renderBox =
        _notificacionKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _notificacionOverlay = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                onTap: _cerrarOverlayNotificaciones,
                child: Container(color: Colors.transparent),
              ),
              Positioned(
                top: position.dy + 45,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 280,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            NotificationManager.notificaciones
                                .map(
                                  (texto) => construirNotificacion(
                                    texto,
                                    _cerrarOverlayNotificaciones,
                                    () => setState(() {}),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_notificacionOverlay!);
  }

  void _cerrarOverlayNotificaciones() {
    _notificacionOverlay?.remove();
    _notificacionOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    bool _ocultarBottomNav = _screensSinBottomNav.contains(
      _screens[_selectedIndex].runtimeType,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.menu, size: 40, color: Colors.black),
            onPressed: () {
              setState(() {
                NotificationManager.agregar('Nuevo mensaje');
              });
            },
          ),
        ),
        title: Center(child: Image.asset('assets/LuggoColor.png', height: 150)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  key: _notificacionKey,
                  icon: Icon(
                    Icons.notifications_none,
                    size: 35,
                    color: Colors.black,
                  ),
                  onPressed: _toggleNotificaciones,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color:
                          NotificationManager.notificaciones.isEmpty
                              ? Colors.transparent
                              : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _getUserUID(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '¡Bienvenido a la pantalla de inicio!\nUID: ${snapshot.data}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _screens[_selectedIndex],
                ],
              );
            } else {
              return Text('No se encontró el UID');
            }
          },
        ),
      ),
      bottomNavigationBar:
          _ocultarBottomNav
              ? null
              : ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  backgroundColor: AppColors.primaryColor,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: const Color.fromARGB(255, 133, 155, 192),
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(Icons.home),
                      ),
                      label: 'Inicio',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(Icons.business),
                      ),
                      label: 'Servicios',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(Icons.chat),
                      ),
                      label: 'Chats',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(Icons.settings),
                      ),
                      label: 'Ajustes',
                    ),
                  ],
                ),
              ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Esta es la pantalla principal',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

Widget construirNotificacion(
  String texto,
  VoidCallback cerrarOverlay,
  VoidCallback refrescarUI,
) {
  return GestureDetector(
    onTap: () {
      NotificationManager.eliminar(texto);
      cerrarOverlay();
      refrescarUI();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_none, color: Colors.black, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(texto, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    ),
  );
}

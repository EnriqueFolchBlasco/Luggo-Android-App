import 'package:flutter/material.dart';
import 'package:luggo/screens/services_screen.dart';
import 'package:luggo/screens/chats_screen.dart';
import 'package:luggo/screens/settings_screen.dart';
import 'package:luggo/screens/profile_screen.dart';
import 'package:luggo/screens/sideBar_screen.dart';
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
    ProfileScreen(),
  ];

  //Llista negra de pantalles sense el bottomMenu
  List<Type> _screensSinBottomNav = [SettingsScreen];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //************************************************************
  // CONTROL DE UID
  //************************************************************

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

  //************************************************************
  // FUNCIONS GESTIÓ NOTIFICACIONS
  //************************************************************

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

  //************************************************************
  // PANTALLA ESTRUCTURA
  //************************************************************

  @override
  Widget build(BuildContext context) {
    // (!) Depen de si la pantalla esta en la blacklist enseña el bottombar o no
    bool ocultarBottomNav = _screensSinBottomNav.contains(
      _screens[_selectedIndex].runtimeType,
    );

    return Scaffold(
      //************************************************************
      // UPPER BAR
      //************************************************************
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      extendBody: true,
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
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => const SideBarScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Spacer(),
            Image.asset('assets/LuggoColor2.png', height: 30),
            Spacer(),
          ],
        ),
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

      //************************************************************
      // CENTER DE LA APP (Sense bottom/upper bars)
      //************************************************************
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

      //************************************************************
      // BOTTOM BAR
      //************************************************************
      bottomNavigationBar:
          ocultarBottomNav
              ? null
              : Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      backgroundColor: AppColors.primaryColor,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: const Color.fromARGB(
                        255,
                        133,
                        155,
                        192,
                      ),

                      selectedLabelStyle: TextStyle(
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w400,
                      ),

                      unselectedLabelStyle: TextStyle(
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w300,
                      ),
                      
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
                            child: Icon(Icons.person),
                          ),
                          label: 'Perfil',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

//************************************************************
// TO DO: FER EL APARTAT MAIN DE DINS DE L'APP (moure algun altre lloc? tbc)
//************************************************************

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

//************************************************************
// CUSTOM MENSATGE DE NOTIFICACIONS EN BLAU/BLANC
//************************************************************

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

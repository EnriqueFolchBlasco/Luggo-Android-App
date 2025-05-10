import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/home_screen_content.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/notification_manager.dart';
import 'services_screen.dart';
import 'chats_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  final GlobalKey _notificacionKey = GlobalKey();
  OverlayEntry? _notificacionOverlay;

  //Llista negra de pantalles sense el bottomMenu
  List<Type> _screensSinBottomNav = [];
  
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = <Widget>[
      HomeScreenContent(
        onAvatarTap: () {
          setState(() {
            _selectedIndex = 3;
          });
        },
      ),
      ServicesScreen(),
      ChatsScreen(),
      ProfileScreen(),
    ];

  }

  //cambiar el index del bottom menu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  //************************************************************
  // CONTROL DE UID
  //************************************************************

  // Future<String?> _getUserUID() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //  return prefs.getString('userUID');
  //}

  void _toggleNotificaciones() {
    if (NotificationManager.notificaciones.value.isEmpty) return;

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
                            NotificationManager.notificaciones.value
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
         centerTitle: true,

        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.menu, size: 40, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.of(context).push(
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

              // Condicio per a fer qe al cambiar idioma se cambie la bottombar en altres labels
              if (result == true) {
                setState(() {});
              }
            },
          ),
        ),
        title: 
           
            Image(
              image: AssetImage('assets/images/LuggoColor_noBackground.png'),
              height: 28,
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
                  child: ValueListenableBuilder<List<String>>(
                    valueListenable: NotificationManager.notificaciones,
                    builder: (_, notificaciones, __) {
                      return Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              notificaciones.isEmpty
                                  ? Colors.transparent
                                  : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreenContent(
            onAvatarTap: () {
              _pageController.jumpToPage(3);
            },
          ),
          ServicesScreen(),
          ChatsScreen(),
          ProfileScreen(),
        ],
      ),


      //************************************************************
      // BOTTOM BAR
      //************************************************************
      bottomNavigationBar: ocultarBottomNav
    ? null
    : Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 12,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _itemMenuNav(Icons.home, 'inicio'.tr(), 0),
              _itemMenuNav(Icons.business, 'servicios'.tr(), 1),
              _itemMenuNav(Icons.chat, 'chats'.tr(), 2),
              _itemMenuNav(Icons.person, 'perfil'.tr(), 3),
            ],
          ),
        ),
      ),


    );
  }

  Widget _itemMenuNav(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onItemTapped(index),
      child: SizedBox(
        width: 70,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? Colors.white
                      : const Color.fromARGB(255, 133, 155, 192),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 133, 155, 192),
                fontFamily: 'Helvetica',
                fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),
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

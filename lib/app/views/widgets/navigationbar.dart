import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navigationbar extends StatelessWidget {
  final int currentIndex;

  const Navigationbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Mapa'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendário',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Comunidade'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFF8566E0),
      unselectedItemColor: Color(0xff2F2F2F),
      selectedLabelStyle: TextStyle(color: Color(0xFF8566E0)),
      unselectedLabelStyle: TextStyle(color: Color(0xff2F2F2F)),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/mapa');
            break;
          case 2:
            context.go('/');
            break;
          case 3:
            context.go('/');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
    );
  }
}

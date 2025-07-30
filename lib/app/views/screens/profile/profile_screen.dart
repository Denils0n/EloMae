import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

       final items = [
      {'icon': Icons.edit, 'title': 'Editar perfil'},
      {'icon': Icons.folder, 'title': 'Meus arquivos'},
      {'icon': Icons.event, 'title': 'Minha agenda'},
      {'icon': Icons.security, 'title': 'Segurança', 'route': '/security'},
      {'icon': Icons.settings, 'title': 'Configurações'},
      ];                    

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
          leading: IconButton(
            onPressed: () {
                  context.go('/home');
            }, icon: Icon(Icons.arrow_back_ios_rounded, size: 25),
          ),
        ),
      body: SafeArea(
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                     child: user?.photoURL != null 
                     ? Image.network(
                      user!.photoURL!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                     )
                     : Container(
                      width: 140,
                      height: 140,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 92,
                        color: Colors.white),     
                     )
                    ),
                  ),
                 const SizedBox(height: 20.0),
                  Text(
                    user?.displayName ?? '',
                    style: TextStyle(fontWeight: FontWeight.w400,
                    fontSize: 19, color: const Color.fromARGB(255, 31, 31, 31)),
                    ),
                   const SizedBox(height: 40.0),
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                     child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isLast = index == items.length - 1;

                            return Column(
                              children: [
                                _buildListTile(
                                  icon: item['icon'] as IconData,
                                  title: item['title'] as String,
                                  onTap: () => context.go(item['route'] as String),
                                 
                                ),
                                if (!isLast)
                                  Divider(thickness: 1, color: Colors.grey[300]), // só mostra se não for o último
                              ],
                            );
                          },
                        )
                      )
                    ),
                ],
            ),
          ),
        );
  }

  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: ListTile(
           leading: 
           Padding(
             padding: const EdgeInsets.only(right: 15),
             child: Icon(icon,
             size: 30,
             color: const Color(0xFF8566E0)),
           ),
          
           title: 
           Text(title,
           style: TextStyle(
            fontSize: 17,
           ),
           ),
          
           onTap: onTap,
          ),
    );
  }
}
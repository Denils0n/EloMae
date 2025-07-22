import 'package:flutter/material.dart';
import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elomae/app/views/screens/home/program_list_screen.dart';


class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? userName = FirebaseAuth.instance.currentUser?.displayName;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 95.0,
        title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('Olá, $userName!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27.0),
        ),
                  InkWell(
                    onTap: () {
                      print('Clique notification');
                    },        
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding:  EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                         boxShadow: [
                          BoxShadow(
                            color: Colors.black12, 
                            blurRadius: 9,         
                            offset: Offset(0, 1), 
                          )
                         ],
                      ),
                      child: Icon(Icons.notifications
                      , color: Color(0xFF8566E0),
                      size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
          ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:40.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text('Programas',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
                SizedBox(height: 30), 
                Expanded(child: ProgramListScreen()),
              ],
          ),
        ),
      ),
      bottomNavigationBar: const Navigationbar(currentIndex: 0),
    );
  }
}
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
        toolbarHeight: 90.0,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0, top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Color(0xFF8566E0),
                    size: 34.0,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $userName!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27.0),
              ),
              SizedBox(height: 30.0),
              Text(
                'Programas',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              SizedBox(height: 20.0,),
            Expanded(
              child: ProgramListScreen(),
          )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navigationbar(currentIndex: 0),
    );
  }
}

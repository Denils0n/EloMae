import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreExample extends StatelessWidget {
  const FirestoreExample({super.key});

  void adicionarUsuario() async {
    final db = FirebaseFirestore.instance;

    try {
      final docRef = await db.collection('teste').add({
        'nome': 'Maria',
        'data': DateTime.now().toIso8601String(),
      });
      print('Aluno adicionado com ID: ${docRef.id}');
    } catch (e) {
      print('Erro ao adicionar usuario: $e');
    }
  }

  void lerUsuarios() async {
    final db = FirebaseFirestore.instance;

    try {
      final snapshot = await db.collection('teste').get();
      for (var doc in snapshot.docs) {
        print('${doc.id} => ${doc.data()}');
      }
    } catch (e) {
      print('Erro ao ler usuarios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teste Firestore")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: adicionarUsuario,
              child: const Text("Adicionar usuário"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: lerUsuarios,
              child: const Text("Ler usuários"),
            ),
          ],
        ),
      ),
    );
  }
}

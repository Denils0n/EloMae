import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elomae/app/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancea o firebaseFirestore
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancea o usuario atual que esta logado

  CollectionReference get _messages => _firestore.collection('community_chat'); // Acessa a coleção (community_chat), no Firestore, (ela so cria quando algum dados esta sendo passado)

  String? get currentUserId => _auth.currentUser?.uid;  //getter para pegar o UID do usuário logado

// Essa função chama sendMessage, ou seja, faz uma tarefa que demora um pouco, sem retorno. A função espera que envie um texto como argumento
  Future<void> sendMessage(String text) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final message = Message( // Criando uma variavel message que esta instânciando a classe Message
      id: _messages.doc().id, // Cria uma nova referência(id) na coleção messages(community_chat), e pega o id gerado antes de ser salvo
      text: text, // Atribui o valor da variável 'text' (geralmente vinda de um campo de texto) ao campo 'text' da mensagem.
      senderId: user.uid, // Pega o 'uid' (ID do usuário logado)
      senderName: user.displayName ?? 'UsuárioChat',  // Pega o nome do usuário logado.
      timestamp: DateTime.now(),  // Gera a data e hora atual
      );
    // referência a coleção e cria um novo documento com o ID especificado, se esse documento ja existe Se esse documento já existe, você vai sobrescrevê-lo (caso use .set()), se não, ele cria um com esse ID
      await _messages.doc(message.id).set(message.toMap()); 
  }

// Uma Stream é um fluxo contínuo de dados que pode ser escutado e vai emitindo atualizações em tempo real.
// List<Message> é uma coleção (uma lista) que contém vários objetos Message.
  Stream<List<Message>> getMessages() {
    return _messages
    .orderBy('timestamp', descending: true) // Ordena os documentos da coleção pela chave timestamp.
    .snapshots() // Abre uma stream que escuta as mudanças da coleção no Firestore.
    .map((snapshot) { // Para cada QuerSnapshot que chega transforma
      return snapshot.docs // Acessa a lista de documentos dentro do snapshot
      .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>),) //  Transforma cada documento (que vem como JSON) em um objeto Dart da sua classe Message.
      .toList(); // junta tudo numa lista 
    });
    }
  }


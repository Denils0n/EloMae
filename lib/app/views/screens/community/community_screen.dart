import 'package:elomae/app/models/message_model.dart';
import 'package:elomae/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; //importes para o upload de imagens
import 'dart:io';

class CommunityPageScreen extends StatefulWidget {
  const CommunityPageScreen({super.key});

  @override
  State<CommunityPageScreen> createState() => _CommunityPageScreenState();
}

class _CommunityPageScreenState extends State<CommunityPageScreen> {
  final TextEditingController _messageController = TextEditingController(); // Controla o texto digitado
      final FocusNode _messageFocusNode = FocusNode(); // Monitora o foco do campo
      bool _showSendIcon = false; // Estado que determina qual ícone mostrar
      final String? currentUserId =  ChatService().currentUserId;
      
  @override
  void initState() {
    super.initState();
    // Equivalente ao addEventListener em JS
    _messageFocusNode.addListener(() {
      if (_showSendIcon != _messageFocusNode.hasFocus) { // Verifica se o icon é diferente do estado no input 
      setState(() {
        _showSendIcon = _messageFocusNode.hasFocus; // Atualiza o estado
      });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await ChatService().sendMessage(text);
      _messageController.clear();
    }
  }
       // UPLOAD DE IMAGEM EM ANDAMENTO
 /* Future<void> _showImageChoice() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enviar imagem'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Escolher da galeria')),
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Tirar foto')),
        ],
      )
    );
    if (source != null) {
      await _pickAndSendImage(source);
    }
  }

  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final picker = ImagePicker(); // instância da classe, que é usada para abrir a câmera ou a galeria e selecionar imagens.
      final PickedFile = await picker.pickImage( // Usa o método pickImage para abrir a câmera ou galeria conforme o source recebido.
        source: source,
        imageQuality: 85,
      );
      if (PickedFile != null) {
        final File imageFile = File(PickedFile.path); // Cria um objeto File a partir do caminho (path) do arquivo da imagem selecionada.
        String imageUrl = await ChatService().uploadImage(imageFile); // Chama ChatService para fazer o upload da imagem. Essa função uploadImage envia o arquivo para algum servidor e retorna uma URL pública da imagem.
        await ChatService().sendImageMessage(imageUrl);//  chama outro método do ChatService para enviar uma mensagem no chat que contém a URL da imagem.
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro: ${e.toString()}")),
    );
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.15),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Comunidade',
          style: TextStyle(color: Color(0xFF8566E0)),
        ),
        centerTitle: true,
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: ChatService().getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar mensagens'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhuma mensagem'));
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) { // O itemBuilder percorre a lista de mensagens, fazendo uma “rodada” para cada mensagem, até o total de mensagens (itemCount).
                      final message = messages[index]; // Pega a mensagem no índice atual

                      final  isMe = message.senderId == currentUserId; // Verifica se message atual foi do user logado

                      final currentDate = DateTime( // Cria a variável currentDate com a data dessa mensagem atual 
                        message.timestamp.year,
                        message.timestamp.month,
                        message.timestamp.day,
                      );

                          DateTime? previousDate; // Cria uma variavel 
                          if (index + 1 < messages.length) { // Ele pega o index da mensagem anterior a atual e vai aumentando ate o utilmo valor
                            final prevMessage = messages[index + 1]; // salva essa mensangem
                            previousDate = DateTime( // pega a data
                              prevMessage.timestamp.year,
                              prevMessage.timestamp.month,
                              prevMessage.timestamp.day,
                            );
                          }

                        final bool showDateHeader =    // Verifica se for null exibe a data ou se a data anterior é diferente da data atual
                        previousDate == null || currentDate != previousDate;

                          String formattedDate; // variável onde vamos guardar a data formatada
                            final now = DateTime.now(); // Pega a data e hora exatas de agora
                            final today = DateTime(now.year, now.month, now.day); // Remove a hora/minuto/segundo do now, deixando apenas a data
                            final yesterday = today.subtract(Duration(days: 1)); // Calcula ontem, subtraindo 1 da data atual

                            if (currentDate == today) {
                              formattedDate = 'Hoje';
                            } else if (currentDate == yesterday) {
                              formattedDate = 'Ontem';
                            } else {
                              formattedDate = DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(currentDate);
                            }
  
                        return Column(
                          children: [
                            if (showDateHeader)
                           Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Container(
                                padding: 
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                           ),
                            Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                padding: EdgeInsets.all(12),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe ?  Color(0xFF8566E0).withOpacity(0.2) : Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                                      bottomRight: Radius.circular(isMe ? 0 : 16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isMe) 
                                      Text(
                                        message.senderName,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                       SizedBox(height: 4),
                                       Text(message.text),
                                      SizedBox(height: 4),
                                  Text(
                                    TimeOfDay.fromDateTime(message.timestamp).format(context),
                                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                    },
                  );
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Escreva sua mensagem',
                          hintStyle: TextStyle(
                            color: const Color.fromRGBO(47, 47, 47, 1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    _showSendIcon
                        ? IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Color.fromRGBO(47, 47, 47, 1),
                            ),
                            onPressed: _sendMessage,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Color.fromRGBO(47, 47, 47, 1),
                            ),
                            onPressed: () {} // _showImageChoice, //
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

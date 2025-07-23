import 'package:elomae/app/view_models/reminder_viewmodel.dart';
import 'package:elomae/app/views/widgets/calendar/dropdown_hour.dart';
import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreen();
}

class _AddReminderScreen extends State<AddReminderScreen> {
  final ReminderViewmodel viewModel = ReminderViewmodel();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Título',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: viewModel.dateController,
                    readOnly: true,
                    onTap: () => viewModel.updateDate(context),
                    decoration: InputDecoration(
                      hintText: 'Data',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 20,
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownHour(
                          controller: viewModel.startTimeController,
                          hintText: 'Começa',
                          timeOptions: viewModel.times,
                          onSelected: (time) {
                            setState(() {
                              viewModel.setStartDateTime(time);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: DropdownHour(
                          controller: viewModel.endTimeController,
                          hintText: 'Termina',
                          timeOptions: viewModel.times,
                          onSelected: (time) {
                            setState(() {
                              viewModel.setEndDateTime(time);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Descrição',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 20,
                      ),
                      hintMaxLines: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 340,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8566E0),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Criar Lembrete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navigationbar(currentIndex: 1),
    );
  }

  void onButtonPressed() async {
    print('User atual: ${FirebaseAuth.instance.currentUser?.uid}');
    final start = viewModel.combineDateAndTime(
      viewModel.selectedDate,
      viewModel.startDateTime,
    );
    final end = viewModel.combineDateAndTime(
      viewModel.selectedDate,
      viewModel.endDateTime,
    );

    if (start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione data e horário.')),
      );
      return;
    }

    try {
      await viewModel.reminderCreate(
        titleController.text,
        start,
        end,
        descriptionController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lembrete criado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao salvar lembrete: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao criar lembrete')));
    }
  }
}

import 'package:elomae/services/reminder_service.dart';
import 'package:elomae/app/models/reminder_model.dart';
import 'package:elomae/app/views/widgets/calendar/reminder_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final ReminderService _reminderService = ReminderService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Usuário não autenticado.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFAFAFA),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Material(
            color: const Color(0xfffafafa),
            shape: const CircleBorder(),
            elevation: 3,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => GoRouter.of(context).push('/calendar'),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back, color: const Color(0xff8566E0)),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Meus Lembretes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2F2F2F),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _reminderService.getReminders(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Ocorreu um erro: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum lembrete encontrado.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final reminders = snapshot.data!.docs;
                  final Map<String, List<ReminderModel>> groupedReminders = {};

                  for (var doc in reminders) {
                    final reminder = ReminderModel.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    );
                    final dateKey = DateFormat(
                      'dd \'de\' MMMM',
                      'pt_BR',
                    ).format(reminder.date);
                    if (!groupedReminders.containsKey(dateKey)) {
                      groupedReminders[dateKey] = [];
                    }
                    groupedReminders[dateKey]!.add(reminder);
                  }

                  final sortedDates = groupedReminders.keys.toList()
                    ..sort((a, b) {
                      final dateA = DateFormat(
                        'dd \'de\' MMMM',
                        'pt_BR',
                      ).parse(a);
                      final dateB = DateFormat(
                        'dd \'de\' MMMM',
                        'pt_BR',
                      ).parse(b);
                      return dateA.compareTo(dateB);
                    });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final dateKey = sortedDates[index];
                      final currentReminders = groupedReminders[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              dateKey ==
                                      DateFormat(
                                        'dd \'de\' MMMM',
                                        'pt_BR',
                                      ).format(DateTime.now())
                                  ? 'Hoje'
                                  : dateKey,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2F2F2F),
                              ),
                            ),
                          ),
                          ...currentReminders
                              .map(
                                (reminder) => ReminderCard(reminder: reminder),
                              )
                              .toList(),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push('/create_reminder'),
        backgroundColor: const Color(0xff8566E0),
        shape: const CircleBorder(),
        elevation: 3,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      bottomNavigationBar: const Navigationbar(currentIndex: 1),
    );
  }
}

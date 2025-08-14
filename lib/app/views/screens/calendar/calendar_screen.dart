import 'package:elomae/app/models/reminder_model.dart';
import 'package:elomae/app/views/widgets/calendar/reminder_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elomae/services/reminder_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreen();
}

class _CalendarScreen extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  final ReminderService _reminderService = ReminderService();
  final _auth = FirebaseAuth.instance;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFAFAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Calendário',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2F2F2F),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xffF3EEFF),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: TableCalendar(
                  locale: 'pt_BR',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextFormatter: (date, locale) {
                      final formatted = DateFormat.yMMMM(locale).format(date);
                      return formatted[0].toUpperCase() +
                          formatted.substring(1);
                    },
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff838383),
                    ),
                    leftChevronIcon: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF9F6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: Color(0xff7456CD),
                        size: 30,
                      ),
                    ),
                    rightChevronIcon: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF9F6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(0xff7456CD),
                        size: 30,
                      ),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xff8566E0),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xff8566E0),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  firstDay: DateTime.utc(2025, 01, 01),
                  lastDay: DateTime(2025, 12, 31),
                  focusedDay: today,
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  onDaySelected: _onDaySelected,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      isSameDay(today, DateTime.now())
                          ? 'Hoje'
                          : DateFormat('d EEE', 'pt_BR').format(today),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff2F2F2F),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => GoRouter.of(context).push('/reminders'),
                      child: Text(
                        'Todos',
                        style: TextStyle(
                          color: Color(0xff838383),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
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

                  final dailyReminders = snapshot.data!.docs
                      .map(
                        (doc) => ReminderModel.fromMap(
                          doc.id,
                          doc.data() as Map<String, dynamic>,
                        ),
                      )
                      .where((reminder) => isSameDay(reminder.date, today))
                      .toList();

                  if (dailyReminders.isEmpty) {
                    return const Center(
                      child: Text('Você não possui lembretes para esta data.'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dailyReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = dailyReminders[index];
                      return ReminderCard(reminder: reminder);
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
      bottomNavigationBar: const Navigationbar(currentIndex: 2),
    );
  }
}

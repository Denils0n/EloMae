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

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Calendário',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2F2F2F),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xffFFFFFF),
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
                  firstDay: DateTime.utc(2025, 01, 01),
                  lastDay: DateTime(2025, 12, 31),
                  focusedDay: today,
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  onDaySelected: _onDaySelected,
                ),
              ),
              SizedBox(
                child: Padding(
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
                        onPressed: () =>
                          GoRouter.of(context).push('/reminders'),
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

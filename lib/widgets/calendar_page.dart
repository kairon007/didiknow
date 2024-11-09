import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final void Function(DateTime) onSave;
  final VoidCallback onCancel;
  const CalendarPage({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  DateTime displayedMonth = DateTime.now();

  final List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildQuickDateButtons(),
            const SizedBox(height: 20),
            _buildCalendarHeader(),
            _buildCalendarGrid(),
            const SizedBox(height: 20),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDateButtons() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3,
      children: [
        _dateButton('Today', DateTime.now()),
        _dateButton('Next Monday', _getNextMonday()),
        _dateButton('Next Tuesday', _getNextTuesday()),
        _dateButton('After 1 week', DateTime.now().add(const Duration(days: 7))),
      ],
    );
  }

  Widget _dateButton(String text, DateTime date) {
    bool isSelected = DateUtils.isSameDay(selectedDate, date);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.blue.withOpacity(0.1),
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => setState(() => selectedDate = date),
      child: Text(text),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => setState(() {
            displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
          }),
        ),
        Text(
          DateFormat('MMMM yyyy').format(displayedMonth),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => setState(() {
            displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
          }),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) => Text(day)).toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _getDaysInMonth(),
          itemBuilder: (context, index) {
            final date = _getDateForIndex(index);
            final isSelected = DateUtils.isSameDay(selectedDate, date);
            final isToday = DateUtils.isSameDay(DateTime.now(), date);

            return GestureDetector(
              onTap: () => setState(() => selectedDate = date),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : null,
                  shape: BoxShape.circle,
                  border: isToday ? Border.all(color: Colors.blue) : null,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 8),
            Text(DateFormat('d MMM yyyy').format(selectedDate)),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () { widget.onCancel();},
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                widget.onSave(selectedDate);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  int _getDaysInMonth() {
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final daysInMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    return 42; // 6 rows * 7 days
  }

  DateTime _getDateForIndex(int index) {
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final day = index - firstWeekdayOfMonth + 1;
    return DateTime(displayedMonth.year, displayedMonth.month, day);
  }

  DateTime _getNextMonday() {
    DateTime date = DateTime.now();
    while (date.weekday != DateTime.monday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime _getNextTuesday() {
    DateTime date = DateTime.now();
    while (date.weekday != DateTime.tuesday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(PeriodCalculatorApp());
}

class PeriodCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Period Calculator',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
      ),
      home: PeriodCalculatorScreen(),
    );
  }
}

class PeriodCalculatorScreen extends StatefulWidget {
  @override
  _PeriodCalculatorScreenState createState() => _PeriodCalculatorScreenState();
}

class _PeriodCalculatorScreenState extends State<PeriodCalculatorScreen> {
  DateTime? _selectedDate;
  String? _nextPeriodDate;
  Map<String, String>? _phaseDetails;

  final TextEditingController _manualDateController = TextEditingController();

  void _calculateNextPeriod(DateTime startDate) {
    final nextPeriod = startDate.add(Duration(days: 28));
    final ovulationStart = startDate.add(Duration(days: 12));
    final ovulationEnd = startDate.add(Duration(days: 16));
    final lutealStart = startDate.add(Duration(days: 16));

    setState(() {
      _nextPeriodDate = DateFormat('yyyy-MM-dd').format(nextPeriod);
      _phaseDetails = {
        'Follicular Phase': 'Day 1 to Day 12: Preparation for ovulation.',
        'Ovulation Phase':
            'Day ${DateFormat('MM-dd').format(ovulationStart)} to Day ${DateFormat('MM-dd').format(ovulationEnd)}: Egg is released.',
        'Luteal Phase':
            'Day ${DateFormat('MM-dd').format(lutealStart)} to Day ${DateFormat('MM-dd').format(nextPeriod.subtract(Duration(days: 1)))}: Post-ovulation phase.',
      };
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _manualDateController.clear();
      });
      _calculateNextPeriod(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Calculator'),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Calculate your next period date',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => _pickDate(context),
                child: Text(
                  'Pick Start Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _manualDateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Start Date (yyyy-MM-dd)',
                labelStyle: TextStyle(color: Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pink, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                try {
                  final inputDate = DateFormat('yyyy-MM-dd').parse(value);
                  _calculateNextPeriod(inputDate);
                } catch (e) {
                  setState(() {
                    _nextPeriodDate = 'Invalid date format!';
                  });
                }
              },
            ),
            SizedBox(height: 30),
            if (_selectedDate != null || _nextPeriodDate != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selected Start Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'None'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Estimated Next Period Date: ${_nextPeriodDate ?? 'Not calculated yet'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            if (_phaseDetails != null)
              Column(
                children: _phaseDetails!.entries.map((entry) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

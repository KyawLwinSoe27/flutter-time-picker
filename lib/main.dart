import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;

void main() {
  /// To set fixed device orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (value) => runApp(MyApp()),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.fiveMin;

  PickedTime _inBedTime = PickedTime(h: 0, m: 0);
  PickedTime _outBedTime = PickedTime(h: 8, m: 0);
  PickedTime _intervalBedTime = PickedTime(h: 0, m: 0);

  PickedTime _disabledInitTime = PickedTime(h: 12, m: 0);
  PickedTime _disabledEndTime = PickedTime(h: 20, m: 0);

  double _sleepGoal = 8.0;
  bool _isSleepGoal = false;

  bool? validRange = true;

  @override
  void initState() {
    super.initState();
    _isSleepGoal = (_sleepGoal >= 8.0) ? true : false;
    _intervalBedTime = formatIntervalTime(
      init: _inBedTime,
      end: _outBedTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141925),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TimePicker(
              initTime: _inBedTime,
              endTime: _outBedTime,
              height: 260.0,
              width: 260.0,
              onSelectionChange: _updateLabels,
              onSelectionEnd: (start, end, isDisableRange) {},
              primarySectors: _clockTimeFormat.value,
              secondarySectors: _clockTimeFormat.value * 2,
              decoration: TimePickerDecoration(
                baseColor: Color(0xFF1F2633),
                sweepDecoration: TimePickerSweepDecoration(
                  pickerStrokeWidth: 20.0,
                  pickerColor: Colors.white,
                  showConnector: true,
                ),
                initHandlerDecoration: TimePickerHandlerDecoration(
                  color: Color(0xFF141925),
                  shape: BoxShape.circle,
                  radius: 10.0,
                  icon: Icon(
                    Icons.power_settings_new_outlined,
                    size: 15.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ), // ICON SIZE
                endHandlerDecoration: TimePickerHandlerDecoration(
                  color: Color(0xFF141925),
                  shape: BoxShape.circle,
                  radius: 10.0,
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    size: 15.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ), // ICON SIZE
                primarySectorsDecoration: TimePickerSectorDecoration(
                  color: Colors.white,
                  width: 1.0,
                  size: 1.0,
                  radiusPadding: 25.0,
                ),
                secondarySectorsDecoration: TimePickerSectorDecoration(
                  color: Color(0xFF3CDAF7),
                  width: 1.0,
                  size: 2.0,
                  radiusPadding: 25.0,
                ),
                clockNumberDecoration: TimePickerClockNumberDecoration(
                  clockIncrementHourFormat: ClockIncrementHourFormat.two,
                  defaultTextColor: Colors.white,
                  defaultFontSize: 8.0,
                  scaleFactor: 2.0,
                  showNumberIndicators: true,
                  clockTimeFormat: _clockTimeFormat,
                  clockIncrementTimeFormat: _clockIncrementTimeFormat,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(62.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${intl.NumberFormat('00').format(_intervalBedTime.h)}Hr ${intl.NumberFormat('00').format(_intervalBedTime.m)}Min',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: _isSleepGoal ? Color(0xFF3CDAF7) : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  void _updateLabels(PickedTime init, PickedTime end, bool? isDisableRange) {
    _inBedTime = init;
    _outBedTime = end;
    _intervalBedTime = formatIntervalTime(
      init: _inBedTime,
      end: _outBedTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    _isSleepGoal = validateSleepGoal(
      inTime: init,
      outTime: end,
      sleepGoal: _sleepGoal,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    setState(() {
      validRange = isDisableRange;
    });
  }
}
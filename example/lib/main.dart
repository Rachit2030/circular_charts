import 'package:circular_charts/circular_charts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.greenAccent,
        title: const Text("Circular Charts Example"),
      ),
      body: const Align(
        alignment: Alignment.center,
        child: CircularChart(
          isShowingCentreCircle: true,
          centreCircleBackgroundColor: Colors.white,
          animationTime: 800,
          chartHeight: 300,
          chartWidth: 400,
          pieChartChildNames: [
            "Child 1",
            "Child 2",
            "Child 3",
            "Child 4",
          ],
          pieChartEndColors: [
            Color(0xfffc7e00),
            Color(0xfffc6076),
            Color(0xff007ced),
            Color(0xff4e9b01),
          ],
          pieChartStartColors: [
            Color(0xffffd200),
            Color(0xffff9231),
            Color(0xff00beeb),
            Color(0xff92d108),
          ],
          centreCircleTitle: "OVERALL",
          pieChartPercentages: [0, 0, 0, 0],
          isShowingLegend: true,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  // Runs the app with a MaterialApp
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // Disables the debug banner
    debugShowCheckedModeBanner: false,
    // Wraps the HomePage in an ApiProvider that provides an API instance
    home: ApiProvider(api: Api(), child: const HomePage()),
  ));
}

// A widget that provides an API instance using InheritedWidget
class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  ApiProvider({Key? key, required this.api, required Widget child})
      // Generates a unique ID for the widget
      : uuid = const Uuid().v4(),
        super(
          key: key,
          child: child,
        );

  // Notifies when the widget is rebuilt
  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  // Helper function to get the API instance from the widget tree
  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

// The homepage widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The key used to rebuild the DateTimeWidget when a new date is fetched
  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Displays the date and time fetched from the API
        title: Text(ApiProvider.of(context).api.dateAndTime ?? ''),
      ),
      body: GestureDetector(
        onTap: () async {
          // Fetches the date and time from the API
          final api = ApiProvider.of(context).api;
          final dateAndTime = await api.getDateAndTime();
          setState(() {
            _textKey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Container(
            color: Colors.white,
            // Displays the date and time fetched from the API or a message to fetch them
            child: DateTimeWidget(key: _textKey),
          ),
        ),
      ),
    );
  }
}

// A widget that displays the date and time fetched from the API
class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(
      api.dateAndTime ?? 'Tap on screen to fetch date and time',
    );
  }
}

// An API class that fetches the date and time
class Api {
  String? dateAndTime;

  // Simulates fetching the date and time from a server
  Future<String> getDateAndTime() {
    return Future.delayed(
            const Duration(seconds: 1), () => DateTime.now().toIso8601String())
        .then((value) {
      dateAndTime = value;
      return value;
    });
  }
}

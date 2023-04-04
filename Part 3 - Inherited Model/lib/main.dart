import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'dart:developer' as devtools show log;

// Main function
void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

// Home page widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// State for Home page widget
class _HomePageState extends State<HomePage> {
  // Initialize color variables
  var color1 = Colors.yellow;
  var color2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Home Page',
          ),
        ),
        body: AvailableColorsWidget(
            color1: color1,
            color2: color2,
            child: Column(
              children: [
                Row(
                  children: [
                    // Change color1 button
                    TextButton(
                        onPressed: () {
                          setState(() {
                            color1 = colors.getRandomElement();
                          });
                        },
                        child: const Text('Change Color 1')),
                    // Change color2 button
                    TextButton(
                        onPressed: () {
                          setState(() {
                            color2 = colors.getRandomElement();
                          });
                        },
                        child: const Text('Change Color 2'))
                  ],
                ),
                // ColorWidget for AvailableColors.one
                const ColorWidget(color: AvailableColors.one),
                // ColorWidget for AvailableColors.two
                const ColorWidget(color: AvailableColors.two),
              ],
            )));
  }
}


// Define an enumeration of available colors with two options
enum AvailableColors { one, two }

// Define an InheritedModel widget to propagate data down the widget tree
class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  // The two Material colors that this widget will hold
  final MaterialColor color1;
  final MaterialColor color2;

  // Constructor for the AvailableColorsWidget
  const AvailableColorsWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(key: key, child: child);

  // Static method to retrieve the nearest instance of the widget up the widget tree
  static AvailableColorsWidget of(BuildContext context, AvailableColors aspect) {
    // Return the nearest instance of the widget that has the given aspect
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context, aspect: aspect)!;
  }

  // Override the updateShouldNotify method to compare old and new widget properties for equality
  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    // Log that the method was called
    devtools.log('updateShouldNotify');
    // Return true if any of the widget's properties have changed
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  // Override the updateShouldNotifyDependent method to compare properties of dependant widgets for equality
  @override
  bool updateShouldNotifyDependent(
      covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    // Log that the method was called
    devtools.log('updateShouldNotifyDependent');

    // Check if any of the dependant widgets have changed and return true if they have
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }

    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }
}


// A widget that displays a colored container based on the given color
class ColorWidget extends StatelessWidget {
  final AvailableColors color;

  const ColorWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    // Log a message when the widget gets rebuilt
    switch (color) {
      case AvailableColors.one:
        devtools.log('Color1 widget got rebuilt!');
        break;
      case AvailableColors.two:
        devtools.log('Color2 widget got rebuilt!');
        break;
    }

    // Get the color values from the nearest ancestor widget of type AvailableColorsWidget
    final provider = AvailableColorsWidget.of(context, color);

    // Display a colored container with the height of 100 pixels based on the given color value
    return Container(
        height: 100,
        color:
            color == AvailableColors.one ? provider.color1 : provider.color2);
  }
}

// A list of available colors
final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple,
];

// An extension on Iterable to get a random element from the list
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}


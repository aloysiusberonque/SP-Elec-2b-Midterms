import 'package:flutter/material.dart';

void main() {
  // Runs the app
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

// Data model class for a slider widget
class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != value) {
      _value = newValue;
      // Notifies all the listeners when the slider value is changed
      notifyListeners();
    }
  }
}

// An instance of the slider data model
final sliderData = SliderData();

// An inherited widget for a slider widget
class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          key: key,
          notifier: sliderData,
          child: child,
        );

  // Retrieves the slider value from the nearest ancestor widget of type SliderInheritedNotifier
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}


class HomePage extends StatelessWidget {
  const HomePage({super.key}); // constructor with a named parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'), // displays the text 'Home Page' in the app bar
      ),
      body: SliderInheritedNotifier( // wraps the body in SliderInheritedNotifier widget
        sliderData: sliderData,
        child: Builder( // builds a widget from a callback that has access to a BuildContext object
          builder: (context) {
            return Column( // a vertical arrangement of widgets
              children: [
                Slider( // creates a slider widget
                    value: SliderInheritedNotifier.of(context), // gets the slider value from SliderInheritedNotifier
                    onChanged: (value) { // called when the slider value is changed
                      sliderData.value = value; // sets the slider value to the new value
                    }),
                Row( // a horizontal arrangement of widgets
                  mainAxisSize: MainAxisSize.max, // makes the row fill the available horizontal space
                  children: [
                    Opacity( // widget that makes its child partially transparent
                      opacity: SliderInheritedNotifier.of(context), // sets the opacity to the current slider value
                      child: Container( // a box widget
                        color: Colors.yellow, // sets the background color to yellow
                        height: 200, // sets the height to 200 pixels
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context), // sets the opacity to the current slider value
                      child: Container(
                        color: Colors.blue, // sets the background color to blue
                        height: 200, // sets the height to 200 pixels
                      ),
                    )
                  ].expandEqually().toList(), // expands each child widget equally to fill the available space
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension ExpandEqually on Iterable<Widget> { // adds the expandEqually method to Iterable<Widget>
  Iterable<Widget> expandEqually() => map((w) => Expanded( // expands each widget to fill the available space equally
        child: w,
      ));
}

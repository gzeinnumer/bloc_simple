import 'f3_example_state.dart';

abstract class ExampleEvent{}

class TextChanged extends ExampleEvent{
  final String text;

  TextChanged(this.text);
}

class ExampleSubmitted extends ExampleEvent{}
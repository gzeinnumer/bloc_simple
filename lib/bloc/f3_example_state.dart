import 'package:bloc_simple/bloc/f2_example_status.dart';

class ExampleState {
  final String res;

  bool get isResValidLength => res.isNotEmpty;
  bool get isResValidSymbol => res.contains(RegExp('a')) && res.isNotEmpty;

  final ExampleStatus status;

  ExampleState({this.res = "", this.status = const ExampleInit()});

  ExampleState copyWith({String? res, ExampleStatus? status}) {
    return ExampleState(res: res ?? this.res, status: status ?? this.status);
  }
}

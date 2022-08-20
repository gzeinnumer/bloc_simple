# bloc_simple

- f1_example_repo.dart
```dart
class ExampleRepo {
  Future<String> validate(String str) async {
    await Future.delayed(const Duration(seconds: 1));

    return str + str;
  }
}
```
- f2_example_status.dart
```dart
abstract class ExampleStatus{
  const ExampleStatus();
}

class ExampleInit extends ExampleStatus{
  const ExampleInit();
}

class ExamplOnLoading extends ExampleStatus{}

class ExampleOnSuccess extends ExampleStatus{
  final String res;

  ExampleOnSuccess(this.res);
}

class ExampleOnFailed extends ExampleStatus{
  final Exception exception;

  ExampleOnFailed(this.exception);
}
```
- f3_example_state.dart
```dart
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
```
- f4_example_event.dart
```dart
abstract class ExampleEvent{}

class TextChanged extends ExampleEvent{
  final String text;

  TextChanged(this.text);
}

class ExampleSubmitted extends ExampleEvent{}
```
- f5_example_bloc.dart
```dart
import 'package:bloc_simple/bloc/f2_example_status.dart';
import 'package:bloc_simple/bloc/f3_example_state.dart';
import 'package:bloc_simple/bloc/f4_example_event.dart';
import 'package:bloc_simple/repo/f1_example_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState>{
  final ExampleRepo repo;

  ExampleBloc(this.repo) : super(ExampleState());

  @override
  Stream<ExampleState> mapEventToState(ExampleEvent event) async* {
    if(event is TextChanged){
      yield state.copyWith(res: event.text);
    } else if(event is ExampleSubmitted){
      yield state.copyWith(status: ExamplOnLoading());
      try{
        String data = await repo.validate(state.res);
        yield state.copyWith(status: ExampleOnSuccess(data));
      } on Exception catch(e){
        yield state.copyWith(status: ExampleOnFailed(e));
      }
    }
  }
}
```
- main.dart
```dart
import 'package:bloc_simple/bloc/f2_example_status.dart';
import 'package:bloc_simple/bloc/f3_example_state.dart';
import 'package:bloc_simple/bloc/f4_example_event.dart';
import 'package:bloc_simple/bloc/f5_example_bloc.dart';
import 'package:bloc_simple/repo/f1_example_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [RepositoryProvider(create: (context) => ExampleRepo())],
        child: exampleView(),
      ),
    );
  }

  Widget exampleView() {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ExampleBloc(context.read<ExampleRepo>()))
        ],
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return BlocListener<ExampleBloc, ExampleState>(
      listener: (context, state) {
        final status = state.status;
        if (status is ExampleOnFailed) {
          _showSnackBar(context, status.exception.toString());
        } else if (status is ExampleOnSuccess) {
          _showSnackBar(context, "valid String");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _textField(),
            _btn(),
            _text(),
          ],
        ),
      ),
    );
  }

  Widget _textField() {
    return BlocBuilder<ExampleBloc, ExampleState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(hintText: "Example"),
        validator: (value) {
          return state.isResValidLength ? null : "Too short";
        },
        onChanged: (value) {
          return context.read<ExampleBloc>().add(TextChanged(value));
        },
      );
    });
  }

  Widget _btn() {
    return BlocBuilder<ExampleBloc, ExampleState>(builder: (context, state) {
      return state.status is ExamplOnLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              child: const Text('Validate Symbol'),
              onPressed: () {
                if (state.isResValidLength) {
                  context.read<ExampleBloc>().add(ExampleSubmitted());
                }
              },
            );
    });
  }

  Widget _text() {
    return BlocBuilder<ExampleBloc, ExampleState>(builder: (context, state) {
      return Column(
        children: [
          Text("Result ${state.res}"),
          Text("Result Lenght ${state.isResValidLength}"),
          Text("Result Symbol ${state.isResValidSymbol}"),
        ],
      );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```
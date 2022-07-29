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

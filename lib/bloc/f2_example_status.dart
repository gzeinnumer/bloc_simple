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
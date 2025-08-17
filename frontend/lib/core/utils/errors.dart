class Failure {
  final String message;
  final Object? cause;
  Failure(this.message, {this.cause});
  @override
  String toString() => 'Failure($message)';
}
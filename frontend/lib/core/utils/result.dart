import 'package:frontend/core/utils/errors.dart';

sealed class Result<T> {
  const Result();
  R fold<R>(R Function(Failure) onErr, R Function(T) onOk);
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
  @override
  R fold<R>(R Function(Failure) onErr, R Function(T) onOk) => onOk(value);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
  @override
  R fold<R>(R Function(Failure) onErr, R Function(T) onOk) => onErr(failure);
}
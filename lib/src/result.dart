class Result<T> {
  final bool status;
  final String message;
  final List<String>? errors;
  final T data;

  Result({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
  });
}

class Success<T> extends Result<T> {
  Success({
    required super.message,
    required T data,
  }) : super(
          status: true,
          errors: const [],
          data: data,
        );
}

class Failure<T> extends Result<T?> {
  Exception? exception;

  Failure({
    this.exception,
    required super.message,
    super.errors = const [],
  }) : super(
          status: false,
          data: null,
        );
}

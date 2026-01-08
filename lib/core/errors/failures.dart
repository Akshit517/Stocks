abstract class Failure {
  final String message;

  const Failure({this.message = 'An unexpected error occurred.'});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure occurred.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache failure occurred.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network failure occurred.'});
}

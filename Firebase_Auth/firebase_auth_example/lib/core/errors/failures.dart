abstract class Failure{
  final String message;
  const Failure({required this.message});
}

class NetworkFailure extends Failure{
  const NetworkFailure() : super(message: "No Internet Connection. Please check your settings.");
}

class ServerFailure extends Failure{
  const ServerFailure() : super(message: "Something went wrong. Please try again later.");
}

class CacheFailure extends Failure{
  const CacheFailure() : super(message: "Something went wrong. Please try again later.");
}



import 'package:quickseatreservation/app/config/Environment.dart';
import 'package:quickseatreservation/core/network/DioClient.dart';
import 'package:quickseatreservation/core/network/LoggingInterceptor.dart';

Future<DioClient> createDioClient() async {
  final dioClient = await DioClient.create(
    Environment.apiUrl,
    loggingInterceptor: LoggingInterceptor(),
  );

  return dioClient;
}

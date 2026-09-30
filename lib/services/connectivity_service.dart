import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> hasNetworkConnection() async {
    final results = await _connectivity.checkConnectivity();

    print('CONNECTIVITY RESULT: $results');

    return results.any(
      (result) => result != ConnectivityResult.none,
    );
  }
}
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Check if internet is available
  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();

      // Check if any connection is available (wifi, mobile, ethernet)
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
    } catch (e) {
      return false;
    }
  }

  // Get connectivity status message
  Future<String> getConnectivityMessage() async {
    final bool connected = await isConnected();
    if (connected) {
      return 'Connected';
    } else {
      return 'No internet connection. Please check your network settings.';
    }
  }
}

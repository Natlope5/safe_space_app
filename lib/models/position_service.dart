import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class PositionService {
  final Logger logger = Logger();

  Future<Position?> getCurrentPosition() async {
    // Define settings based on current Geolocator version
    LocationAccuracy accuracy = LocationAccuracy.high;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger.e("Location services are disabled.");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          logger.e("Location permissions are denied.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        logger.e("Location permissions are permanently denied.");
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
      );
      logger.d("User location: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      logger.e("Error retrieving user location: $e");
      return null;
    }
  }
}

void fetchUserLocation() async {
  PositionService positionService = PositionService();
  Position? position = await positionService.getCurrentPosition();

  if (position != null) {
    // Use logger instead of print
    Logger().d("User location: ${position.latitude}, ${position.longitude}");
  } else {
    Logger().e("Unable to retrieve location.");
  }
}

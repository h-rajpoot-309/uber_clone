import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/common/controller/services/APIsNKeys/keys.dart';

class APIs {
  static geoCodingAPI(LatLng position) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapsPlatformCredentials';
  static placesAPI(String placeName) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapsPlatformCredentials&sessiontoken=123254251&components=country:pak';
  static directionAPI(LatLng pickup, LatLng drop) =>
      'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&mode=driving&key=$mapsPlatformCredentials';
  static getLatLngFromPlaceIDAPI(String placeID) =>
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$mapsPlatformCredentials';
}

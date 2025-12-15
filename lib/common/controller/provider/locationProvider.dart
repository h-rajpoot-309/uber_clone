import 'package:uber_clone/common/model/pickupNDropLocationModel.dart';
import 'package:uber_clone/common/model/searchAddressModel.dart';
import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {
  List<SearchedAddressModel> searchedAddress = [];
  PickupNDropLocationModel? dropLocation;
  PickupNDropLocationModel? pickupLocation;

  updateSearchAddress(List<SearchedAddressModel> newAddressList) {
    searchedAddress = newAddressList;
    notifyListeners();
  }

  emptySearchAddressList() {
    searchedAddress = [];
    notifyListeners();
  }

  updateDropLocation(PickupNDropLocationModel newAddress) {
    dropLocation = newAddress;
    notifyListeners();
  }

  updatePickupLocation(PickupNDropLocationModel newAddress) {
    pickupLocation = newAddress;
    notifyListeners();
  }
}

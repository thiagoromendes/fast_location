import 'dart:convert';

import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:hive/hive.dart';

class HomeLocalRepository {
  final String boxAddressHistory = 'addressHistory';
  final String boxAddressRecent = 'addressRecent';
  late Box<String> addressBox;

  Future<void> addAddressHistory(AddressModel address) async {
    addressBox = await Hive.openBox(boxAddressHistory);

    List<AddressModel>? addressList = await getAddressHistory();

    if (addressList != null) {
      addressList.add(address);
    } else {
      addressList = [address];
    }

    final localAddressList = jsonEncode(addressList);
    await addressBox.put(boxAddressHistory, localAddressList);
  }

  Future<void> addAddressRecent(AddressModel address) async {
    addressBox = await Hive.openBox(boxAddressRecent);

    List<AddressModel>? addressList = await getAddressRecent();

    if (addressList != null) {
      addressList.length >= 3 ? addressList.removeLast() : null;
      addressList.add(address);
    } else {
      addressList = [address];
    }

    final localAddressList = jsonEncode(addressList);
    await addressBox.put(boxAddressRecent, localAddressList);
  }

  Future<List<AddressModel>?> getAddressHistory() async {
    List<dynamic> localList = [];
    List<AddressModel> addressList = [];

    addressBox = await Hive.openBox(boxAddressHistory);
    final localData = addressBox.get(boxAddressHistory);

    if (localData != null) {
      localList.add(jsonDecode(localData));
      localList.forEach((localData) {
        addressList.add(AddressModel.fromJson(localData));
      });
      return addressList;
    } else {
      return null;
    }
  }

  Future<List<AddressModel>?> getAddressRecent() async {
    List<dynamic> localList = [];
    List<AddressModel> addressList = [];

    addressBox = await Hive.openBox(boxAddressRecent);
    final localData = addressBox.get(boxAddressRecent);

    if (localData != null) {
      localList.add(jsonDecode(localData));
      localList.forEach((localData) {
        addressList.add(AddressModel.fromJson(localData));
      });
      return addressList;
    } else {
      return null;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:fast_location/src/modules/home/repositories/home_local_repository.dart';
import 'package:fast_location/src/modules/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';

class HomeService {
  final HomeRepository _repository = HomeRepository();
  final HomeLocalRepository _localRepository = HomeLocalRepository();

  Future<AddressModel> getAddress(String cep) async {
    try {
      Response response = await _repository.getAddressViaCep(cep);
      return AddressModel.fromJson(response.data);
    } catch (ex) {
      debugPrint('HomeService.getAddress -> ${ex.toString()}');
      rethrow;
    }
  }

  Future<List<AddressModel>> getAddressRecentList() async {
    try {
      List<AddressModel>? addressRecentList =
          await _localRepository.getAddressRecent();

      return addressRecentList ?? <AddressModel>[];
    } catch (ex) {
      debugPrint('HomeService.getAddressRecentList -> ${ex.toString()}');
      rethrow;
    }
  }

  Future<void> updateAddressRecentList(AddressModel address) async {
    await _localRepository.addAddressRecent(address);
  }

  Future<List<AddressModel>> getAddressHistoryList() async {
    try {
      List<AddressModel>? addressHistoryList =
          await _localRepository.getAddressHistory();

      return addressHistoryList ?? <AddressModel>[];
    } catch (ex) {
      debugPrint('HomeService.getAddressHistoryList -> ${ex.toString()}');
      rethrow;
    }
  }
}

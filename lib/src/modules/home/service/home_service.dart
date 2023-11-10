import 'package:dio/dio.dart';
import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:fast_location/src/modules/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';

class HomeService {
  final HomeRepository _repository = HomeRepository();

  Future<AddressModel> getAddress(String cep) async {
    try {
      print('HomeService.getAddress.response -> $cep');

      Response response = await _repository.getAddressViaCep(cep);

      print('HomeService.getAddress.response -> ${response.data}');

      return AddressModel.fromJson(response.data);
    } catch (ex) {
      debugPrint('HomeService.getAddress -> ${ex.toString()}');
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:fast_location/src/http/app_dio.dart';

class HomeRepository with AppDio {
  Future<Response> getAddressViaCep(String cep) async {
    print('Entrei no HomeRepository...');
    String baseURL = "https://viacep.com.br/ws";

    Dio clientHTTP = await AppDio.getConnection();

    Response response = await clientHTTP.get('$baseURL/$cep/json/');

    print('HomeService.getAddress.response -> ${response.data}');

    return response;
  }
}

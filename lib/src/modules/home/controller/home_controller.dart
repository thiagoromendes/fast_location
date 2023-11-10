import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:fast_location/src/modules/home/service/home_service.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final HomeService _service = HomeService();

  @observable
  bool isLoading = false;

  @observable
  bool hasAddress = false;

  @observable
  late AddressModel lastAddress;

  @action
  void getAddress(String cep) async {
    isLoading = true;
    lastAddress = await _service.getAddress(cep);
    print('HomeController.getAddress.address -> ${lastAddress.toJson()}');
    hasAddress = true;
    isLoading = false;
  }
}

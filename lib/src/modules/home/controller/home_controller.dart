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

  @observable
  late List<AddressModel> addressRecentList;

  @action
  Future<void> loadData() async {
    isLoading = true;
    addressRecentList = await _service.getAddressRecentList();
    isLoading = false;
  }

  @action
  Future<void> getAddress(String cep) async {
    isLoading = true;
    lastAddress = await _service.getAddress(cep);
    await updateAddressRecent(lastAddress);
    hasAddress = true;
    isLoading = false;
  }

  @action
  Future<void> updateAddressRecent(AddressModel address) async {
    await _service.updateAddressRecentList(address);
    addressRecentList = await _service.getAddressRecentList();
  }
}

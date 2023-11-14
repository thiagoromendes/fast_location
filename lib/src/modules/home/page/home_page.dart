import 'package:fast_location/src/modules/home/components/address_list.dart';
import 'package:fast_location/src/modules/home/components/search_address.dart';
import 'package:fast_location/src/modules/home/components/search_empty.dart';
import 'package:fast_location/src/modules/home/controller/home_controller.dart';
import 'package:fast_location/src/routes/app_router.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';
import 'package:fast_location/src/shared/components/app_button.dart';
import 'package:fast_location/src/shared/components/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  TextEditingController searchController = TextEditingController();
  late ReactionDisposer errorReactionDiposer;
  late ReactionDisposer errorRouteReactionDiposer;

  @override
  void initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reactsToError();
    reactsToRouteError();
  }

  @override
  void dispose() {
    searchController.dispose();
    errorReactionDiposer();
    errorRouteReactionDiposer();
    super.dispose();
  }

  void reactsToError() {
    errorReactionDiposer = reaction((_) => _controller.hasError, (
      bool error,
    ) {
      if (error) openDialog("Endereço não localizado");
      _controller.hasError = false;
    });
  }

  void reactsToRouteError() {
    errorReactionDiposer = reaction((_) => _controller.hasRouteError, (
      bool routeError,
    ) {
      if (routeError) {
        openDialog(
          "Busque um endereço para traçar sua rota",
          height: 120,
        );
      }
      _controller.hasRouteError = false;
    });
  }

  void openDialog(String message, {double? height}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: height ?? 100,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppButton(
                  label: "Fechar",
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return _controller.isLoading
          ? const AppLoading()
          : Scaffold(
              backgroundColor: AppColors.appPageBackground,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 25,
                        right: 25,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.multiple_stop,
                                size: 35,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Fast Location",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 30,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: _controller.hasAddress
                                    ? SearchAddress(
                                        address: _controller.lastAddress!,
                                      )
                                    : const SearchEmpty(),
                              )),
                            ),
                          ),
                          AppButton(
                            label: "Localizar endereço",
                            action: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 120,
                                        child: Column(children: [
                                          TextFormField(
                                            enabled: true,
                                            controller: searchController,
                                            textAlign: TextAlign.start,
                                            autofocus: false,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                label: Text("Digite o CEP")),
                                          ),
                                          AppButton(
                                            label: "Buscar",
                                            action: () {
                                              _controller.getAddress(
                                                  searchController.text);
                                              Navigator.of(context).pop();
                                              searchController.text = '';
                                            },
                                          ),
                                        ]),
                                      ),
                                    );
                                  });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.place,
                                  color: Colors.green,
                                ),
                                Text("Últimos endereços localizados",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: AddressList(
                              addressList: _controller.addressRecentList,
                            ),
                          ),
                          AppButton(
                            label: "Histórico de endereços",
                            action: () {
                              Navigator.of(context)
                                  .pushNamed(AppRouter.history);
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                child: Container(height: 40),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () => _controller.route(context),
                tooltip: 'Traçar rota',
                child:
                    const Icon(Icons.fork_right, color: Colors.white, size: 45),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
    });
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import '../../../data/model/pokemon.dart';
import '../../../data/services/services.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final isLimitReached = false.obs;
  final page = 0.obs;

  final pokemons = <Pokemon>[].obs;

  @override
  void onInit() {
    getPokemonList();

    super.onInit();
  }

  // @override
  void onReady() {
    super.onReady();
  }

  // @override
  void onClose() {
    super.onClose();
  }

  getPokemonList() async {
    if (isLoading.value != true) {
      isLoading.value = true;

      List<String> index = [];

      Map<String, dynamic> response = await PokeServices.getPokemonList(
        page.value,
      );

      if (response["status_code"] == 200) {
        Map data = json.decode(response["message"]);
        // print(data["results"][0].runtimeType);

        if (data["next"] == null) isLimitReached.value = true;
        data["results"].forEach((element) {
          index.add(element['url']);
        });
      }

      if (index.isNotEmpty) {
        for (String url in index) {
          Map<String, dynamic> dataResponse = await PokeServices.getPokemonData(
            url,
          );

          if (dataResponse['status_code'] == 200) {
            pokemons.add(pokemonFromJson(dataResponse['message']));
          }
        }
      }

      page.value++;

      isLoading.value = false;

      Get.printInfo(info: "next page ${page.value}");
    }
  }

  goToDetails(Pokemon pokemon) {
    Get.toNamed('/details', arguments: {"pokemon": pokemon});
  }
}

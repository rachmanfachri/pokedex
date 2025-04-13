import 'dart:convert';
import 'package:get/get.dart';
import 'package:pokedex/app/global/tools.dart' show typeColorGetter;
import '../../../data/services/services.dart';
import '../../../global/configs.dart' show typeColors;

class SplashController extends GetxController {
  final typeTotal = 0.0.obs;
  final currentType = 0.0.obs;

  @override
  void onInit() {
    getTypesColor();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getTypesColor() async {
    List typeUrls = [];
    List icons = [];

    Map<String, dynamic> response = await PokeServices.getPokemonTypes();

    if (response["status_code"] == 200) {
      Map data = json.decode(response["message"]);
      for (Map type in data["results"]) {
        typeUrls.add(type['url']);
      }
    }

    if (typeUrls.isNotEmpty) {
      for (String link in typeUrls) {
        Map<String, dynamic> res = await PokeServices.getPokemonData(link);
        if (res["status_code"] == 200) {
          Map data = json.decode(res["message"]);
          String? icon =
              data['sprites']['generation-viii']['brilliant-diamond-and-shining-pearl']['name_icon'];
          if (icon != null) {
            icons.add({"name": data['name'], "icon": icon});
          }
        }
      }

      typeUrls.clear();
    }

    if (icons.isNotEmpty) {
      typeTotal.value = icons.length.roundToDouble();
      for (var icon in icons) {
        currentType.value++;
        typeColors.add({
          "name": icon['name'],
          "color": await typeColorGetter(icon['icon']),
        });
      }
      if (currentType.value == typeTotal.value) Get.offAllNamed('/home');
    }
  }
}

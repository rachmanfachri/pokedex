import 'dart:convert';

import 'package:flutter/material.dart' show Color, Orientation, TabController;
import 'package:get/get.dart';
import '../../../data/model/pokemon.dart';
import '../../../data/model/evolution.dart';
import '../../../data/model/pokemon_species.dart';
import '../../../data/services/services.dart';
import '../../../global/configs.dart';
import '../../../global/tools.dart';

class DetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final pokemon = Rx<Pokemon?>(null);
  final pokeSpecies = Rx<PokemonSpecies?>(null);
  final evolution = Rx<Evolution?>(null);
  final evolutionTarget = Rx<Pokemon?>(null);
  final typeColor = Rx<Color?>(null);

  final tabCtrl = Rx<TabController?>(null);
  final tabName = ["About", "Base Stats", "Evolution", "Moves"];

  final orientation = Orientation.portrait.obs;

  @override
  void onInit() {
    getPokemonData();
    tabCtrl.value = TabController(length: 4, vsync: this);
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

  getPokemonData() async {
    Map data = Get.arguments;
    pokemon.value = data["pokemon"];
    typeColor.value = darkenColor(
      typeColors
          .where((type) => type['name'] == pokemon.value!.types[0].type.name)
          .toList()[0]["color"],
      0.05,
    );
    await getPokemonSpecies();
  }

  getPokemonSpecies() async {
    Map<String, dynamic> speciesResp = await PokeServices.getPokemonSpecies(
      pokemon.value!.id,
    );
    if (speciesResp["status_code"] == 200) {
      Map data = json.decode(speciesResp["message"]);
      // print(data);
      pokeSpecies.value = pokemonSpeciesFromJson(json.encode(data));
      await getPokemonEvolutions(pokeSpecies.value!.evolutionChain.url);
    }
  }

  getPokemonEvolutions(String url) async {
    Map<String, dynamic> evoResp = await PokeServices.getPokemonData(url);
    if (evoResp["status_code"] == 200) {
      Map data = json.decode(evoResp["message"]);
      // print(data);
      evolution.value = evolutionFromJson(json.encode(data));
      for (Chain poke in evolution.value!.chain.evolvesTo) {
        for (Chain to in poke.evolvesTo) {
          Map<String, dynamic> dataResponse =
              await PokeServices.getPokemonDetails(
                getIdFromChainUrl(to.species.url),
              );

          if (dataResponse['status_code'] == 200) {
            evolutionTarget.value = pokemonFromJson(dataResponse['message']);
          }
        }
      }
    }
  }

  int getIdFromChainUrl(String url) {
    print('url: $url');
    int id = 0;
    RegExp regExp = RegExp(r'pokemon-species/(\d+)/');
    Match? match = regExp.firstMatch(url);

    if (match != null) {
      String number = match.group(1)!;
      id = int.parse(number);
    }
    return id;
  }

  String generatePokemonId() {
    String id = "#0000";
    String index = "${pokemon.value!.id}";
    List splitId = id.split("");

    for (int i = index.length - 1; i >= 0; i--) {
      splitId[splitId.length - 1 - i] = index[index.length - 1 - i];
    }

    id = splitId.join();

    return id;
  }

  String getHeight() {
    String height = "";
    int measure = pokemon.value!.height;

    if (measure < 10) {
      height = "${measure * 10} cm";
    } else {
      double convertedMeasurement = measure.roundToDouble() / 10;
      height =
          "${convertedMeasurement == convertedMeasurement.roundToDouble() ? convertedMeasurement : (measure.roundToDouble() / 10).toStringAsFixed(2)} m";
    }
    return height;
  }

  String spreadAbilities() {
    List abilities = [];

    for (Ability ab in pokemon.value!.abilities.sublist(
      0,
      pokemon.value!.abilities.length >= 2 ? 2 : 1,
    )) {
      abilities.add(ab.ability!.name.capitalizeFirst);
    }

    if (pokemon.value!.abilities.length > 2) abilities.add("...");

    return abilities.join(", ");
  }
}

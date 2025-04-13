import 'package:pokedex/app/global/configs.dart';

import 'request.dart';

class PokeServices {
  static Future<Map<String, dynamic>> getPokemonList(int page) async {
    Map<String, dynamic> req = await getRequest(
      '/pokemon?limit=20&offset=${20 * page}',
    );
    return req;
  }

  static Future<Map<String, dynamic>> getPokemonDetails(int id) async {
    Map<String, dynamic> req = await getRequest('/pokemon/$id');
    return req;
  }

  static Future<Map<String, dynamic>> getPokemonData(String url) async {
    Map<String, dynamic> req = await getRequest(url.replaceAll(baseUrl, ''));
    return req;
  }

  static Future<Map<String, dynamic>> getPokemonSpecies(int id) async {
    Map<String, dynamic> req = await getRequest('/pokemon-species/$id');
    return req;
  }

  static Future<Map<String, dynamic>> getPokemonEvolution(int id) async {
    Map<String, dynamic> req = await getRequest('/evolution-chain/$id');
    return req;
  }

  static Future<Map<String, dynamic>> getPokemonTypes() async {
    Map<String, dynamic> req = await getRequest('/type/?limit=1000');
    return req;
  }
}

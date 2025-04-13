import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/app/global/configs.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/model/pokemon.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final c = Get.put(HomeController());
  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
        ),
        Positioned(
          top: -kToolbarHeight + 2.5,
          right: -105,
          child: Image.asset(
            'assets/images/pokeball.png',
            opacity: AlwaysStoppedAnimation(.15),
            height: Get.width * 2 / 3,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Pokedex'),
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu_rounded, color: Colors.black),
              ),
            ],
            backgroundColor: Colors.white.withAlpha(0),
          ),
          body: itemGrid(),
        ),
      ],
    );
  }

  Widget itemGrid() {
    return Obx(() {
      Get.printInfo(info: c.page.value.toString());
      return Stack(
        children: [
          Visibility(
            visible: c.pokemons.isEmpty,
            child: loadingPageIndicator(),
          ),
          OrientationBuilder(
            builder: (context, orientation) {
              return GridView.builder(
                padding: EdgeInsets.all(15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                  childAspectRatio: 4 / 3,
                ),
                shrinkWrap: true,
                itemCount: c.pokemons.length,
                itemBuilder: (context, index) {
                  if (!c.isLimitReached.value &&
                      index == c.pokemons.length - 5) {
                    c.getPokemonList();
                    Get.printInfo(info: 'end of list reached');
                  }
                  return itemCard(c.pokemons[index]);
                },
              );
            },
          ),
        ],
      );
    });
  }

  Widget loadingPageIndicator() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.lightBlue[200]!,
        highlightColor: Colors.lightBlue[50]!,
        child: Image.asset('assets/images/pokeball.png', height: Get.width / 2),
      ),
    );
  }

  Widget loadingCard() {
    return Card(
      child: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.blue[300]!,
          highlightColor: Colors.blue[700]!,
          child: Image.asset('assets/images/pokeball.png', height: 50),
        ),
      ),
    );
  }

  Widget itemCard(Pokemon pokemon) {
    Color bgColor =
        typeColors
            .where((type) => type['name'] == pokemon.types[0].type.name)
            .toList()[0]["color"];

    return Card(
      color: bgColor,
      child: Stack(
        children: [
          // filter layer
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // pokeball deco
          Positioned(
            bottom: -30,
            right: -25,
            child: Image.asset(
              'assets/images/pokeball.png',
              opacity: AlwaysStoppedAnimation(.2),
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          // image
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.network(
              pokemon.sprites.other!.officialArtwork.frontDefault,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return SizedBox(
                  height: 1 / 5.5 * 475,
                  width: 1 / 5.5 * 475,
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              scale: 5.5,
            ),
          ),
          // name and types
          Positioned(
            top: 10,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name.capitalizeFirst!,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                for (Type type in pokemon.types.sublist(
                  0,
                  pokemon.types.length < 3 ? pokemon.types.length : 3,
                ))
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withAlpha((.35 * 255).round()),
                    ),
                    child: Text(
                      type.type.name.capitalizeFirst!,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // clickable surface
          InkWell(
            onTap: () => c.goToDetails(pokemon),
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(width: double.infinity, height: double.infinity),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/app/global/tools.dart';
import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  final c = Get.put(DetailsController());
  DetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        c.orientation.value = orientation;
        return Scaffold(
          appBar:
              c.orientation.value == Orientation.portrait
                  ? AppBar(
                    backgroundColor: c.typeColor.value,
                    foregroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                  )
                  : null,
          backgroundColor: c.typeColor.value,
          body:
              c.orientation.value == Orientation.portrait
                  ? detailsPagePortrait()
                  : detailsPageLandscape(),
        );
      },
    );
  }

  Widget portraitAppBar() {
    return SliverAppBar(
      backgroundColor: c.typeColor.value,
      foregroundColor: Colors.white,
      surfaceTintColor: darkenColor(c.typeColor.value!, 0),
      automaticallyImplyLeading: false,
      title: detailsTitle(),
      pinned: true,
    );
  }

  Widget detailsTitle() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(
        horizontal: c.orientation.value == Orientation.landscape ? 0 : 15,
      ),
      margin:
          c.orientation.value == Orientation.landscape
              ? EdgeInsets.only(
                top: MediaQuery.of(Get.context!).viewPadding.top,
              )
              : null,
      child: Row(
        children: [
          Visibility(
            visible: c.orientation.value == Orientation.landscape,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Text(
            c.pokemon.value!.name.capitalizeFirst!,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Text(
            c.generatePokemonId(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Visibility(
            visible: c.orientation.value == Orientation.landscape,
            child: SizedBox(width: 10),
          ),
        ],
      ),
    );
  }

  Widget detailsPagePortrait() {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [portraitAppBar()],
      body: detailsBody(),
    );
  }

  Widget detailsPageLandscape() {
    return Row(
      children: [
        SizedBox(
          width: Get.width / 2,
          child: Column(children: [detailsTitle(), detailsBody()]),
        ),
        Container(
          width: Get.width / 2,
          margin: EdgeInsets.only(
            top: MediaQuery.of(Get.context!).viewPadding.top,
          ),
          child: Column(children: [detailsTabBar(), detailsTabView()]),
        ),
      ],
    );
  }

  Widget detailsBody() {
    return c.orientation.value == Orientation.portrait
        ? Column(children: [detailsHeader(), detailsTabBar(), detailsTabView()])
        : Column(children: [detailsHeader()]);
  }

  Widget detailsHeader() {
    return SizedBox(
      width: Get.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom:
                -(c.orientation.value == Orientation.portrait
                    ? Get.width
                    : Get.height) *
                2 /
                3 *
                .2,
            right:
                c.orientation.value == Orientation.portrait
                    ? -Get.width * 2 / 3 * .4
                    : null,
            child: Image.asset(
              'assets/images/pokeball.png',
              opacity: AlwaysStoppedAnimation(.2),
              width:
                  c.orientation.value == Orientation.portrait
                      ? Get.width
                      : Get.height * 2 / 3,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width:
                  c.orientation.value == Orientation.portrait
                      ? Get.width
                      : Get.width / 3,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(Get.width / 3, 40),
                  topLeft: Radius.elliptical(Get.width / 3, 40),
                  bottomLeft:
                      c.orientation.value == Orientation.landscape
                          ? Radius.elliptical(Get.width / 3, 40)
                          : Radius.zero,
                  bottomRight:
                      c.orientation.value == Orientation.landscape
                          ? Radius.elliptical(Get.width / 3, 40)
                          : Radius.zero,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  SizedBox(width: 30),
                  for (var type in c.pokemon.value!.types)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withAlpha((.35 * 255).round()),
                      ),
                      child: Text(
                        type.type.name.capitalizeFirst!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              Center(
                child: SizedBox(
                  height:
                      c.orientation.value == Orientation.portrait
                          ? Get.width * .75
                          : Get.height * .5,
                  child: Image.network(
                    c.pokemon.value!.sprites.other!.home.frontDefault,
                    fit: BoxFit.contain,
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
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailsTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: c.tabCtrl.value,
        indicatorColor: c.typeColor.value,
        labelColor: c.typeColor.value,
        automaticIndicatorColorAdjustment: false,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        labelPadding: EdgeInsets.symmetric(horizontal: 0),
        dividerColor: Colors.black12,
        tabs: [for (String name in c.tabName) Tab(text: name)],
      ),
    );
  }

  Widget detailsTabView() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: TabBarView(
          controller: c.tabCtrl.value,
          children: [aboutTab(), statsTab(), evolutionTab(), movesTab()],
        ),
      ),
    );
  }

  Widget aboutTab() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          aboutItem("Height", c.getHeight()),
          aboutItem("Weight", "${c.pokemon.value!.weight / 10} kg"),
          aboutItem("Abilities", c.spreadAbilities()),
        ],
      ),
    );
  }

  Widget aboutItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.lightBlue[900],
            ),
          ),
          Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget statsTab() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var stat in c.pokemon.value!.stats)
            statsItem(
              stat.stat.name.replaceAll("-", " ").capitalizeFirst!,
              stat.baseStat,
            ),
        ],
      ),
    );
  }

  Widget statsItem(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.lightBlue[900],
            ),
          ),
          Spacer(),
          SizedBox(
            width:
                (c.orientation.value == Orientation.portrait
                    ? Get.width
                    : Get.height) /
                2,
            height: 10,
            child: LinearProgressIndicator(
              value: value.roundToDouble() / 100,
              color: Colors.blue,
              backgroundColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 25,
            child: Text(
              value.toString(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget evolutionTab() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Obx(
        () => c.evolutionTarget.value != null ? evolutionChain() : SizedBox(),
      ),
    );
  }

  Widget evolutionChain() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            evolutionThumbnail(
              c.pokemon.value!.sprites.frontDefault,
              c.pokemon.value!.name,
            ),
            Icon(Icons.double_arrow_rounded),
            evolutionThumbnail(
              c.evolutionTarget.value!.sprites.frontDefault,
              c.evolutionTarget.value!.name,
            ),
          ],
        ),
      ],
    );
  }

  Widget evolutionThumbnail(String imgUrl, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height:
              (c.orientation.value == Orientation.portrait
                  ? Get.width
                  : Get.height) /
              3,
          child: Image.network(
            imgUrl,
            fit: BoxFit.contain,
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
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: c.typeColor.value,
          ),
          child: Text(
            name.capitalizeFirst!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget movesTab() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var move in c.pokemon.value!.abilities)
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: c.typeColor.value!.withAlpha((.5 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    move.ability!.name.capitalizeFirst!.replaceAll("-", " "),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: darkenColor(c.typeColor.value!, .25),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    child: Image.network(
                      c.pokemon.value!.sprites.other!.showdown.frontDefault,
                      fit: BoxFit.contain,
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
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

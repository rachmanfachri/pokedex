import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  final c = Get.put(SplashController());
  SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/pokeball_icon.png',
                  width:
                      (orientation == Orientation.portrait
                          ? Get.width
                          : Get.height) /
                      2,
                ),
                SizedBox(height: 10),
                Text(
                  'Loading Pokedex...',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.lightBlue[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 15,
                  child: Obx(
                    () =>
                        c.typeTotal.value > 0
                            ? Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                  width: Get.width * 3 / 5,
                                  child: LinearProgressIndicator(
                                    value:
                                        c.currentType.value / c.typeTotal.value,
                                    color: Colors.blue,
                                    backgroundColor: Colors.lightBlue[100]!,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Text(
                                  "${((c.currentType.value / c.typeTotal.value) * 100).round()}%",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[900],
                                  ),
                                ),
                              ],
                            )
                            : Shimmer.fromColors(
                              baseColor: Colors.lightBlue[200]!,
                              highlightColor: Colors.lightBlue[50]!,
                              child: Container(
                                height: 15,
                                width: Get.width * 3 / 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

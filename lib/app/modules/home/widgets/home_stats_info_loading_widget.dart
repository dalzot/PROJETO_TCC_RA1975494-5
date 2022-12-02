//import 'package:flutter/material.dart';
//import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//import 'package:shimmer/shimmer.dart';
//
//import '../../../core/theme/app_color.dart';
//import '../../../global/shimmers/card_shimmer.dart';
//
//class HomeStatsInfoLoadingWidget extends StatelessWidget {
//  const HomeStatsInfoLoadingWidget({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return AnimationLimiter(
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: AnimationConfiguration.toStaggeredList(
//            duration: const Duration(milliseconds: 375),
//            childAnimationBuilder: (widget) => SlideAnimation(
//                verticalOffset: 50,
//                child: Padding(
//                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
//                    child: Column(children: [
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [_buildCardShimmer(), _buildCardShimmer()],
//                      ),
//                      Column(
//                        children: const [
//                          SizedBox(height: 16),
//                          SizedBox(
//                              width: double.infinity,
//                              child: CardShimmer(
//                                borderRadius: 4,
//                                height: 50,
//                              )),
//                        ],
//                      )
//                    ]))),
//            children: [Container()]),
//      ),
//    );
//  }
//}
//
//Widget _buildCardShimmer() {
//  return Shimmer.fromColors(
//    period: const Duration(seconds: 1),
//    baseColor: Colors.white,
//    highlightColor: appExtraLightGreyColor,
//    child: Card(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//      elevation: 2,
//      child: const SizedBox(
//        height: 104,
//        width: 147,
//      ),
//    ),
//  );
//}

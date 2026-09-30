import '../models/brand.dart';
import 'package:flutter/material.dart';

import 'add_brand_screen.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class BrandDetailScreen extends StatefulWidget {
  final Brand brand;

  const BrandDetailScreen({
    super.key,
    required this.brand,
  });

  @override
  State<BrandDetailScreen> createState() =>
      _BrandDetailScreenState();
}

class _BrandDetailScreenState
    extends State<BrandDetailScreen> {
      late Brand _brand;
  // ============================================================
  // THEME
  // ============================================================

  ThemeController get themeController =>
      ThemeController.instance;

  bool get isDark =>
      themeController.isDarkMode;

  Color get backgroundTop =>
      isDark
          ? AppColors.darkBackgroundTop
          : AppColors.backgroundTop;

  Color get backgroundMiddle =>
      isDark
          ? AppColors.darkBackgroundMiddle
          : AppColors.backgroundMiddle;

  Color get backgroundBottom =>
      isDark
          ? AppColors.darkBackgroundBottom
          : AppColors.backgroundBottom;

  Color get cardBackground =>
      isDark
          ? AppColors.darkCardBackground
          : AppColors.cardBackground;

  Color get primaryBlue =>
      isDark
          ? AppColors.darkPrimaryBlue
          : AppColors.primaryBlue;

  Color get brightBlue =>
      isDark
          ? AppColors.darkBrightBlue
          : AppColors.brightBlue;

  Color get primaryText =>
      isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get secondaryText =>
      isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get cardBorder =>
      isDark
          ? AppColors.darkCardBorder
          : AppColors.cardBorder;

  Color get gradientBlueLight =>
      isDark
          ? AppColors.darkGradientBlueLight
          : AppColors.gradientBlueLight;

  Color get gradientBlueDark =>
      isDark
          ? AppColors.darkGradientBlueDark
          : AppColors.gradientBlueDark;

  Color get blueGlow =>
      isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _brand = widget.brand;

    themeController.addListener(
      _refreshTheme,
    );
  }

  // ============================================================
  // THEME REFRESH
  // ============================================================

  void _refreshTheme() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    themeController.removeListener(
      _refreshTheme,
    );

    super.dispose();
  }

  // ============================================================
  // BRAND VALUES
  // ============================================================

  String get brandName =>
      _brand.varName;

  String get brandId =>
      _brand.intSeqId.toString();

  // ============================================================
  // EDIT BRAND
  // ============================================================

Future<void> _editBrand() async {
  final updatedBrand = await Navigator.push<Brand>(
    context,
    MaterialPageRoute(
      builder: (_) => AddBrandScreen(
        brand: {
          'id': widget.brand.intSeqId.toString(),
          'name': widget.brand.varName,
        },
      ),
    ),
  );

  if (!mounted || updatedBrand == null) {
    return;
  }

  setState(() {
    _brand = updatedBrand;
  });

  _showMessage(
    'Brand updated successfully.',
    color: primaryBlue,
  );
}
  // ============================================================
  // DELETE BRAND
  // ============================================================

  Future<void> _deleteBrand() async {
    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              cardBackground,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              22,
            ),
          ),

          title: Text(
            'Delete Brand?',
            style: TextStyle(
              color: primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            'Are you sure you want to delete '
            '"$brandName"?\n\n'
            'This will remove the brand from '
            'your current brand list.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
              height: 1.45,
            ),
          ),

          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: secondaryText,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFE05252,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    // ----------------------------------------------------------
    // USER CANCELLED
    // ----------------------------------------------------------

    if (confirmed != true) {
      return;
    }

    // ----------------------------------------------------------
    // TEMPORARY DELETE
    // ----------------------------------------------------------
    //
    // There is no API/database yet.
    // Returning null tells BrandScreen to remove the brand.
    //
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    Navigator.pop(
  context,
  true,
);
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    Color? color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
              color ?? primaryBlue,
          behavior:
              SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topCenter,
          end:
              Alignment.bottomCenter,
          colors: [
            backgroundTop,
            backgroundMiddle,
            backgroundBottom,
          ],
        ),
      ),

      child: Scaffold(
        backgroundColor:
            Colors.transparent,

        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          backgroundColor:
              Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: Padding(
            padding:
                const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                color:
                    cardBackground,
                shape:
                    BoxShape.circle,
                border:
                    Border.all(
                  color:
                      primaryBlue
                          .withValues(
                    alpha: 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        primaryBlue
                            .withValues(
                      alpha:
                          isDark
                              ? 0.18
                              : 0.10,
                    ),
                    blurRadius: 15,
                  ),
                ],
              ),
              child:
                  IconButton(
                padding:
                    EdgeInsets.zero,
                icon: Icon(
                  Icons
                      .arrow_back_rounded,
                  color:
                      primaryText,
                  size: 22,
                ),
                onPressed: () {
  Navigator.of(context).pop();
},
              ),
            ),
          ),

          title: Text(
            'Brand Details',
            style: TextStyle(
              color: primaryText,
              fontSize: 20,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          centerTitle: true,

          // ====================================================
          // EDIT + DELETE
          // ====================================================

          actions: [
            // --------------------------------------------------
            // EDIT
            // --------------------------------------------------

            Container(
              width: 42,
              height: 42,
              margin:
                  const EdgeInsets.only(
                right: 8,
              ),
              decoration:
                  BoxDecoration(
                color:
                    cardBackground,
                shape:
                    BoxShape.circle,
                border:
                    Border.all(
                  color:
                      primaryBlue
                          .withValues(
                    alpha: 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        primaryBlue
                            .withValues(
                      alpha:
                          isDark
                              ? 0.18
                              : 0.10,
                    ),
                    blurRadius: 15,
                  ),
                ],
              ),
              child:
                  IconButton(
                padding:
                    EdgeInsets.zero,
                tooltip:
                    'Edit Brand',
                icon: Icon(
                  Icons
                      .edit_rounded,
                  color:
                      primaryBlue,
                  size: 20,
                ),
                onPressed:
                    _editBrand,
              ),
            ),

            // --------------------------------------------------
            // DELETE
            // --------------------------------------------------

            Container(
              width: 42,
              height: 42,
              margin:
                  const EdgeInsets.only(
                right: 12,
              ),
              decoration:
                  BoxDecoration(
                color:
                    cardBackground,
                shape:
                    BoxShape.circle,
                border:
                    Border.all(
                  color:
                      const Color(
                    0xFFE05252,
                  ).withValues(
                    alpha: 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(
                      0xFFE05252,
                    ).withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 15,
                  ),
                ],
              ),
              child:
                  IconButton(
                padding:
                    EdgeInsets.zero,
                tooltip:
                    'Delete Brand',
                icon:
                    const Icon(
                  Icons
                      .delete_outline_rounded,
                  color:
                      Color(
                    0xFFE05252,
                  ),
                  size: 21,
                ),
                onPressed:
                    _deleteBrand,
              ),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: Stack(
          children: [
            // --------------------------------------------------
            // BACKGROUND GLOWS
            // --------------------------------------------------

            Positioned(
              top: -130,
              left: -110,
              child: _glow(
                size: 350,
                color:
                    blueGlow,
                opacity:
                    isDark
                        ? 0.14
                        : 0.10,
              ),
            ),

            Positioned(
              top: 190,
              right: -160,
              child: _glow(
                size: 380,
                color:
                    primaryBlue,
                opacity:
                    isDark
                        ? 0.10
                        : 0.08,
              ),
            ),

            Positioned(
              bottom: 40,
              left: -150,
              child: _glow(
                size: 360,
                color:
                    primaryBlue,
                opacity:
                    isDark
                        ? 0.08
                        : 0.06,
              ),
            ),

            // --------------------------------------------------
            // CONTENT
            // --------------------------------------------------

            SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                15,
                20,
                35,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  // ============================================
                  // BRAND ICON
                  // ============================================

                  Container(
                    width: 100,
                    height: 100,
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            Alignment.topLeft,
                        end:
                            Alignment.bottomRight,
                        colors: [
                          gradientBlueLight,
                          gradientBlueDark,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                      border:
                          Border.all(
                        color:
                            brightBlue
                                .withValues(
                          alpha: 0.35,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              primaryBlue
                                  .withValues(
                            alpha: 0.20,
                          ),
                          blurRadius: 25,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child:
                        const Icon(
                      Icons
                          .storefront_rounded,
                      color:
                          Colors.white,
                      size: 48,
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  // ============================================
                  // BRAND NAME
                  // ============================================

                  Text(
                    brandName,
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          primaryText,
                      letterSpacing:
                          -0.7,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Brand information',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 14,
                      color:
                          secondaryText,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ============================================
                  // BRAND INFORMATION CARD
                  // ============================================

                  _buildInformationCard(),

                  const SizedBox(
                    height: 22,
                  ),

                  // ============================================
                  // EDIT BRAND BUTTON
                  // ============================================

                  // SizedBox(
                  //   width:
                  //       double.infinity,
                  //   height: 56,
                  //   child:
                  //       ElevatedButton.icon(
                  //     onPressed:
                  //         _editBrand,
                  //     icon:
                  //         const Icon(
                  //       Icons
                  //           .edit_rounded,
                  //       size: 21,
                  //     ),
                  //     label:
                  //         const Text(
                  //       'Edit Brand',
                  //       style:
                  //           TextStyle(
                  //         fontSize: 16,
                  //         fontWeight:
                  //             FontWeight
                  //                 .w800,
                  //       ),
                  //     ),
                  //     style:
                  //         ElevatedButton
                  //             .styleFrom(
                  //       backgroundColor:
                  //           primaryBlue,
                  //       foregroundColor:
                  //           Colors.white,
                  //       elevation: 0,
                  //       shape:
                  //           RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius
                  //                 .circular(
                  //           17,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(
                  //   height: 12,
                  // ),

                  // ============================================
                  // BACK TO BRANDS
                  // ============================================

                  // SizedBox(
                  //   width:
                  //       double.infinity,
                  //   height: 52,
                  //   child:
                  //       OutlinedButton.icon(
                  //     onPressed: () {
                  //       Navigator.pop(
                  //         context,
                  //         widget.brand,
                  //       );
                  //     },
                  //     icon:
                  //         const Icon(
                  //       Icons
                  //           .arrow_back_rounded,
                  //       size: 20,
                  //     ),
                  //     label:
                  //         const Text(
                  //       'Back to Brands',
                  //       style:
                  //           TextStyle(
                  //         fontWeight:
                  //             FontWeight
                  //                 .w700,
                  //       ),
                  //     ),
                  //     style:
                  //         OutlinedButton
                  //             .styleFrom(
                  //       foregroundColor:
                  //           primaryBlue,
                  //       side:
                  //           BorderSide(
                  //         color:
                  //             primaryBlue
                  //                 .withValues(
                  //           alpha: 0.35,
                  //         ),
                  //         width: 1.2,
                  //       ),
                  //       backgroundColor:
                  //           primaryBlue
                  //               .withValues(
                  //         alpha: 0.03,
                  //       ),
                  //       shape:
                  //           RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius
                  //                 .circular(
                  //           17,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color:
            cardBackground,
        borderRadius:
            BorderRadius.circular(
          23,
        ),
        border:
            Border.all(
          color:
              primaryBlue.withValues(
            alpha: 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black
                        .withValues(
                      alpha: 0.20,
                    )
                    : AppColors
                        .primaryText
                        .withValues(
                      alpha: 0.06,
                    ),
            blurRadius: 25,
            offset:
                const Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          // ----------------------------------------------------
          // BRAND ID
          // ----------------------------------------------------

          _buildInfoRow(
            icon:
                Icons.tag_rounded,
            title:
                'Brand ID',
            value:
                brandId,
          ),

          const SizedBox(
            height: 18,
          ),

          Divider(
            height: 1,
            color:
                cardBorder,
          ),

          const SizedBox(
            height: 18,
          ),

          // ----------------------------------------------------
          // BRAND NAME
          // ----------------------------------------------------

          _buildInfoRow(
            icon:
                Icons.storefront_rounded,
            title:
                'Brand Name',
            value:
                brandName,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION ROW
  // ============================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration:
              BoxDecoration(
            color:
                primaryBlue.withValues(
              alpha:
                  isDark
                      ? 0.16
                      : 0.10,
            ),
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          child:
              Icon(
            icon,
            color:
                primaryBlue,
            size: 23,
          ),
        ),

        const SizedBox(
          width: 14,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    TextStyle(
                  color:
                      secondaryText,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                value,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    TextStyle(
                  color:
                      primaryText,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GLOW
  // ============================================================

  Widget _glow({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return IgnorePointer(
      child:
          Container(
        width: size,
        height: size,
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          gradient:
              RadialGradient(
            colors: [
              color.withValues(
                alpha: opacity,
              ),
              color.withValues(
                alpha: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

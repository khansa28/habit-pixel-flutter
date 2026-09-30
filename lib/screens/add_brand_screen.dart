import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

import '../models/add_brand_request.dart';
// import '../services/prime_ledge_api_service.dart';

import '../services/brand_sync_service.dart';

import '../models/brand.dart';

class AddBrandScreen extends StatefulWidget {
  final Map<String, String>? brand;

  const AddBrandScreen({super.key, this.brand});

  bool get isEditing => brand != null;

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController = TextEditingController();

  // ============================================================
  // THEME COLORS
  // ============================================================

  bool get isDark => ThemeController.instance.isDarkMode;

  Color get backgroundTop =>
      isDark ? AppColors.darkBackgroundTop : AppColors.backgroundTop;

  Color get backgroundMiddle =>
      isDark ? AppColors.darkBackgroundMiddle : AppColors.backgroundMiddle;

  Color get backgroundBottom =>
      isDark ? AppColors.darkBackgroundBottom : AppColors.backgroundBottom;

  Color get primaryBlue =>
      isDark ? AppColors.darkPrimaryBlue : AppColors.primaryBlue;

  Color get brightBlue =>
      isDark ? AppColors.darkBrightBlue : AppColors.brightBlue;

  Color get primaryText =>
      isDark ? AppColors.darkPrimaryText : AppColors.primaryText;

  Color get secondaryText =>
      isDark ? AppColors.darkSecondaryText : AppColors.secondaryText;

  Color get cardBackground =>
      isDark ? AppColors.darkCardBackground : AppColors.cardBackground;

  Color get blueGlow => isDark ? AppColors.darkBlueGlow : AppColors.blueGlow;

  Color get gradientBlueLight =>
      isDark ? AppColors.darkGradientBlueLight : AppColors.gradientBlueLight;

  Color get gradientBlueDark =>
      isDark ? AppColors.darkGradientBlueDark : AppColors.gradientBlueDark;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // Populate fields when editing an existing brand.
    // ----------------------------------------------------------

    if (widget.brand != null) {
      nameController.text = widget.brand!['name'] ?? '';
    }

    ThemeController.instance.addListener(_themeChanged);
  }

  // ============================================================
  // THEME CHANGE
  // ============================================================

  void _themeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    ThemeController.instance.removeListener(_themeChanged);

    nameController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE / UPDATE BRAND
  // ============================================================

Future<void> saveBrand() async {
  final name = nameController.text.trim();

  if (name.isEmpty) {
    _showMessage('Please enter a brand name.');
    return;
  }

  try {
    if (widget.isEditing) {
      final brand = Brand(
        intSeqId: int.parse(widget.brand!['id']!),
        intCompanyId: 108,
        varName: name,
        varDescription: 'Updated description',
        intCreatedBy: null,
      );

      final updatedBrand =
          await BrandSyncService.instance.updateBrand(brand);

      _showMessage('Brand updated successfully.');

      Navigator.pop(context, updatedBrand);
      return;
    } else {
      final request = AddBrandRequest(
        intSeqId: 0,
        intCompanyId: 108,
        varName: name,
        varDescription: 'Test brand description',
        intCreatedBy: null,
      );

      await BrandSyncService.instance.saveBrand(request);

      _showMessage('Brand added successfully.');

      Navigator.pop(context);
    }
  } catch (e) {
    _showMessage(
      widget.isEditing
          ? 'Failed to update brand.'
          : 'Failed to add brand.',
    );

    print(
      '${widget.isEditing ? 'UPDATE' : 'ADD'} BRAND ERROR: $e',
    );
  }
}

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
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
          backgroundColor: primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      labelStyle: TextStyle(color: secondaryText, fontSize: 14),

      floatingLabelStyle: TextStyle(
        color: primaryBlue,
        fontWeight: FontWeight.w600,
      ),

      hintStyle: TextStyle(color: secondaryText.withValues(alpha: 0.60)),

      prefixIcon: Icon(icon, color: primaryBlue),

      filled: true,

      fillColor: cardBackground,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryBlue.withValues(alpha: 0.20)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryBlue, width: 1.4),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryBlue.withValues(alpha: 0.20)),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [backgroundTop, backgroundMiddle, backgroundBottom],
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,

        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 20,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryText,
              size: 20,
            ),
          ),

          title: Text(
            isEditing ? 'Edit Brand' : 'Add Brand',
            style: TextStyle(
              color: primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
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
              top: -100,
              right: -130,
              child: _glow(
                size: 330,
                color: blueGlow,
                opacity: isDark ? 0.16 : 0.10,
              ),
            ),

            Positioned(
              top: 360,
              left: -150,
              child: _glow(
                size: 350,
                color: primaryBlue,
                opacity: isDark ? 0.10 : 0.07,
              ),
            ),

            // --------------------------------------------------
            // CONTENT
            // --------------------------------------------------
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============================================
                  // HEADING
                  // ============================================

                  Text(
                    isEditing ? 'Update your brand ✨' : 'Create a new brand ✨',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                      letterSpacing: -0.7,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isEditing
                        ? 'Update the brand information below.'
                        : 'Add a brand to manage your business.',
                    style: TextStyle(
                      fontSize: 15,
                      color: secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ============================================
                  // BRAND NAME
                  // ============================================
                  Text(
                    'Brand name',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: primaryText, fontSize: 15),
                    cursorColor: primaryBlue,
                    decoration: _inputDecoration(
                      label: 'Brand name',
                      hint: 'e.g. Nike',
                      icon: Icons.storefront_rounded,
                    ),
                    onSubmitted: (_) {
                      saveBrand();
                    },
                  ),

                  const SizedBox(height: 30),

                  // ============================================
                  // BRAND INFO CARD
                  // ============================================
                  _buildInfoCard(isEditing),

                  const SizedBox(height: 24),

                  // ============================================
                  // SAVE / UPDATE BUTTON
                  // ============================================
                  SizedBox(
                    width: double.infinity,
                    height: 57,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [gradientBlueLight, gradientBlueDark],
                        ),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: brightBlue.withValues(alpha: 0.65),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withValues(alpha: 0.28),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(17),
                          onTap: saveBrand,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isEditing
                                    ? Icons.save_rounded
                                    : Icons.add_business_rounded,
                                color: Colors.white,
                                size: 21,
                              ),

                              const SizedBox(width: 9),

                              Text(
                                isEditing ? 'Update Brand' : 'Save Brand',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BRAND INFO CARD
  // ============================================================

  Widget _buildInfoCard(bool isEditing) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryBlue.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(color: primaryBlue.withValues(alpha: 0.07), blurRadius: 20),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientBlueLight, gradientBlueDark],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit brand information' : 'Brand information',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  isEditing
                      ? 'Update the brand name below.'
                      : 'Enter the brand name to create a new brand.',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BACKGROUND GLOW
  // ============================================================

  Widget _glow({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

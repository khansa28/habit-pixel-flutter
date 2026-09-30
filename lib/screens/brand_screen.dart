import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/connectivity_service.dart';

import 'package:flutter/material.dart';

import 'add_brand_screen.dart';
import 'brand_detail_screen.dart';

import '../models/brand.dart';

import '../services/brand_sync_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  ThemeController get themeController => ThemeController.instance;

  bool get _isDark => themeController.isDarkMode;

  Color get _backgroundTop =>
      _isDark ? AppColors.darkBackgroundTop : AppColors.backgroundTop;

  Color get _backgroundMiddle =>
      _isDark ? AppColors.darkBackgroundMiddle : AppColors.backgroundMiddle;

  Color get _backgroundBottom =>
      _isDark ? AppColors.darkBackgroundBottom : AppColors.backgroundBottom;

  Color get _card =>
      _isDark ? AppColors.darkCardBackground : AppColors.cardBackground;

  Color get _primary =>
      _isDark ? AppColors.darkPrimaryBlue : AppColors.primaryBlue;

  Color get _textPrimary =>
      _isDark ? AppColors.darkPrimaryText : AppColors.primaryText;

  Color get _textSecondary =>
      _isDark ? AppColors.darkSecondaryText : AppColors.secondaryText;

  Color get _border =>
      _isDark ? AppColors.darkCardBorder : AppColors.cardBorder;

  final BrandSyncService _syncService = BrandSyncService.instance;

  final ConnectivityService _connectivityService = ConnectivityService();

StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  List<Brand> _brands = [];

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    themeController.addListener(_refreshTheme);

    _syncService.addListener(_loadBrands);


    _loadBrands();

    _connectivitySubscription =
    _connectivityService.onConnectivityChanged.listen((results) {
  _loadBrands();
});
  }

  void _refreshTheme() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await _syncService.getBrands();

      if (!mounted) {
        return;
      }

      setState(() {
        _brands = brands;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    themeController.removeListener(_refreshTheme);
    _syncService.removeListener(_loadBrands);
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _addNewBrand() async {
    await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddBrandScreen()),
    );

    await _loadBrands();
  }

Future<void> _openBrandDetail(Brand brand) async {
  final bool? deleted = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => BrandDetailScreen(
        brand: brand,
      ),
    ),
  );

  if (!mounted) {
    return;
  }

  if (deleted == true) {
    setState(() {
      _brands.removeWhere(
        (item) => item.intSeqId == brand.intSeqId,
      );
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Brand deleted successfully.'),
        ),
      );

    return;
  }

  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_backgroundTop, _backgroundMiddle, _backgroundBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 20,
          title: Text(
            'Brands',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: Stack(
          children: [
            Positioned(
              top: -100,
              right: -130,
              child: _glow(
                size: 330,
                color: _primary,
                opacity: _isDark ? 0.16 : 0.10,
              ),
            ),

            Positioned(
              bottom: -180,
              left: -130,
              child: _glow(
                size: 360,
                color: _primary,
                opacity: _isDark ? 0.10 : 0.06,
              ),
            ),

            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [],
                ),

                const SizedBox(height: 14),

                if (_isLoading)
                  _buildLoadingState()
                else if (_errorMessage != null)
                  _buildErrorState()
                else if (_brands.isEmpty)
                  _buildEmptyState()
                else
                  ..._brands.map(
                    (brand) => Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: _buildBrandItem(brand),
                    ),
                  ),
              ],
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _addNewBrand,
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Widget _buildBrandItem(Brand brand) {
    final name = brand.varName;
    final id = brand.intSeqId.toString();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openBrandDetail(brand),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: _isDark ? 0.10 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: _isDark ? 0.16 : 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: _primary,
                  size: 23,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'ID: $id',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                Icons.chevron_right_rounded,
                color: _textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      child: Center(child: CircularProgressIndicator(color: _primary)),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: _primary, size: 42),

          const SizedBox(height: 12),

          Text(
            'Unable to load brands',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            _errorMessage ?? 'Please try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: _loadBrands,
            child: Text(
              'Retry',
              style: TextStyle(color: _primary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Icon(Icons.storefront_outlined, color: _primary, size: 42),

          const SizedBox(height: 12),

          Text(
            'No brands yet',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Add your first brand to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

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

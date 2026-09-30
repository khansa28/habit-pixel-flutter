import '../models/add_brand_request.dart';
import '../models/brand.dart';

import 'brand_database_service.dart';
import 'connectivity_service.dart';
import 'prime_ledge_api_service.dart';

import 'package:flutter/foundation.dart';

class BrandSyncService extends ChangeNotifier {
  static final BrandSyncService instance = BrandSyncService._();

  BrandSyncService._();

  static const int _maxRetryAttempts = 3;
  final BrandDatabaseService _databaseService = BrandDatabaseService();

  final ConnectivityService _connectivityService = ConnectivityService();

  final PrimeLedgeApiService _apiService = PrimeLedgeApiService();

  Brand _requestToBrand(AddBrandRequest request) {
    return Brand(
      intSeqId: DateTime.now().millisecondsSinceEpoch,
      intCompanyId: request.intCompanyId,
      varName: request.varName,
      varDescription: request.varDescription,
      intCreatedBy: request.intCreatedBy,
    );
  }

  Future<void> saveBrand(AddBrandRequest request) async {
    final isOnline = await _connectivityService.hasNetworkConnection();

    if (isOnline) {
      await _apiService.addBrand(request);
    } else {
      final brand = _requestToBrand(request);

      await _databaseService.insertBrand(brand);
    }
  }

Future<Brand> updateBrand(Brand brand) async {
  final isOnline = await _connectivityService.hasNetworkConnection();

  if (isOnline) {
    final updatedBrand = await _apiService.updateBrand(brand);
    notifyListeners();
    return updatedBrand;
  }

  throw Exception('No network connection.');
}

  Future<List<Brand>> getBrands() async {
    final isOnline = await _connectivityService.hasNetworkConnection();

    if (isOnline) {
      return await _apiService.getBrands();
    } else {
      return await _databaseService.getBrands();
    }
  }

  Future<void> syncLocalBrands() async {
    final isOnline = await _connectivityService.hasNetworkConnection();

    if (!isOnline) {
      return;
    }

    final localBrands = await _databaseService.getPendingBrands();

    for (final brand in localBrands) {
      final request = AddBrandRequest(
        intSeqId: 0,
        intCompanyId: brand.intCompanyId,
        varName: brand.varName,
        varDescription: brand.varDescription ?? '',
        intCreatedBy: brand.intCreatedBy,
      );

      for (int attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
        try {
          await _apiService.addBrand(request);

          await _databaseService.markBrandAsSynced(brand.intSeqId);
          notifyListeners();
          print('SYNC SUCCESS: ${brand.varName} (Attempt $attempt)');

          break;
        } catch (e) {
          print('SYNC FAILED: ${brand.varName} (Attempt $attempt)');

          if (attempt == _maxRetryAttempts) {
            print('MAX RETRIES REACHED: ${brand.varName}');
          }
        }
      }
    }
    await _databaseService.printPendingBrands();
  }
}

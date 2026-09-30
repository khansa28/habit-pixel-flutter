import 'dart:async';

import 'brand_sync_service.dart';

class BrandSyncScheduler {
final BrandSyncService _syncService = BrandSyncService.instance;

  Timer? _timer;

  void start() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 16),
      (_) async {
        await _syncService.syncLocalBrands();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/brand.dart';
import '../models/add_brand_request.dart';

class PrimeLedgeApiService {
  static const String _baseUrl = 'http://192.168.0.174:5204/api/Setup';

  // Developer instructed us to use companyId 108 statically for now.
  static const int _companyId = 108;

  Future<List<Brand>> getBrands() async {
    final url = Uri.parse('$_baseUrl/GetBrands/$_companyId');

    final response = await http.get(url);

    print('GET BRANDS STATUS: ${response.statusCode}');
    print('GET BRANDS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData
          .map((json) => Brand.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load brands. '
      'Status code: ${response.statusCode}',
    );
  }

  Future<void> addBrand(AddBrandRequest request) async {
    final url = Uri.parse('$_baseUrl/AddBrand');
    print('ADD BRAND REQUEST: ${jsonEncode(request.toJson())}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    print('ADD BRAND STATUS: ${response.statusCode}');
    print('ADD BRAND BODY: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw Exception(
      'Failed to add brand. '
      'Status code: ${response.statusCode}',
    );
  }

  Future<Brand> updateBrand(Brand brand) async {
  final url = Uri.parse(
    '$_baseUrl/UpdateBrand/${brand.intSeqId}',
  );

  print('UPDATE BRAND REQUEST: ${jsonEncode(brand.toJson())}');

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(brand.toJson()),
  );

  print('UPDATE BRAND STATUS: ${response.statusCode}');
  print('UPDATE BRAND BODY: ${response.body}');

  if (response.statusCode >= 200 &&
      response.statusCode < 300) {
    return Brand.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  throw Exception(
    'Failed to update brand. '
    'Status code: ${response.statusCode}',
  );
}
}

import 'package:habit_gamification_new/models/brand.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BrandDatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<List<Brand>> getBrands() async {
    final db = await database;

    final maps = await db.query('brands');

     print('LOCAL DB BRANDS: $maps');
    return maps.map((map) => Brand.fromMap(map)).toList();
  }

  Future<void> insertBrand(Brand brand) async {
    final db = await database;

    await db.insert('brands', brand.toMap());
  }

  Future<void> updateBrand(Brand brand) async {
    final db = await database;

    await db.update(
      'brands',
      brand.toMap(),
      where: 'intSeqId = ?',
      whereArgs: [brand.intSeqId],
    );
  }

  Future<void> deleteBrand(int intSeqId) async {
  final db = await database;

  await db.delete(
    'brands',
    where: 'intSeqId = ?',
    whereArgs: [intSeqId],
  );
}

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'habit_pixel.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE brands (
        intSeqId INTEGER PRIMARY KEY,
        intCompanyId INTEGER NOT NULL,
        varName TEXT NOT NULL,
        varDescription TEXT,
        dtCreationDate TEXT,
        intCreatedBy INTEGER,
        dtUpdatedDate TEXT,
        intUpdatedBy INTEGER,
        syncStatus INTEGER NOT NULL DEFAULT 0
)
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
      ALTER TABLE brands
      ADD COLUMN syncStatus INTEGER NOT NULL DEFAULT 0
    ''');
  }
},
    );
  }

  Future<List<Brand>> getPendingBrands() async {
  final db = await database;

  final maps = await db.query(
    'brands',
    where: 'syncStatus = ?',
    whereArgs: [0],
  );

  return maps
      .map((map) => Brand.fromMap(map))
      .toList();
}
Future<void> markBrandAsSynced(int intSeqId) async {
  final db = await database;

  await db.update(
    'brands',
    {'syncStatus': 1},
    where: 'intSeqId = ?',
    whereArgs: [intSeqId],
  );
}

//below is the temporary test

Future<void> printPendingBrands() async {
  final brands = await getPendingBrands();

  print('PENDING LOCAL BRANDS: ${brands.map((b) => b.varName).toList()}');
}
}

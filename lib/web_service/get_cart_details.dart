import 'dart:convert';
import 'package:atlantis_di_photos_app/model/image.dart';
import 'package:atlantis_di_photos_app/model/store/parkM.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<ParkM>> getCartDetails() async {
  final String response = await rootBundle.loadString('assets/cart.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => ParkM.fromJson(json)).toList();
}

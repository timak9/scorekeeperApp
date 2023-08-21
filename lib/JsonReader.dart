import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<dynamic>> readJson() async {
  final String response = await rootBundle.loadString('assets/leagues.json');
  final data = await json.decode(response);
  return data;
}

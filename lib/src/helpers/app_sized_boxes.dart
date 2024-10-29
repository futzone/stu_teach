// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget HBox(double height) => SizedBox(height: height, width: 0.0);

Widget WBox(double width) => SizedBox(width: width, height: 0.0);

Widget SBox(double height) => SliverToBoxAdapter(child: HBox(height));
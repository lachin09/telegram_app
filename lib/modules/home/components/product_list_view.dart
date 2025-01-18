import 'package:flutter/material.dart';

Widget productsView(
    {required Widget image,
    required Widget name,
    required Widget price,
    required Widget description}) {
  return SizedBox(
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 158, 149, 149),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [image, name, price, description],
          ),
        )
      ],
    ),
  );
}

import 'package:flutter/material.dart';

import '../models/shoe_model.dart';
import '../screen/detail_screen.dart';
import 'shoe_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Shoe> shoes;

  const ProductGrid({
    super.key,
    required this.shoes,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: shoes.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 0.60,
      ),

      itemBuilder: (context, index) {
        final shoe = shoes[index];

        return ShoeCard(
          shoe: shoe,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(
                  shoe: shoe,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
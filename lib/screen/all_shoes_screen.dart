import 'package:flutter/material.dart';

import '../models/shoe_model.dart';
import '../services/nike_service.dart';
import '../widgets/shoe_card.dart';
import 'detail_screen.dart';

class AllShoesScreen extends StatefulWidget {
  const AllShoesScreen({
    super.key,
  });

  @override
  State<AllShoesScreen> createState() => _AllShoesScreenState();
}

class _AllShoesScreenState extends State<AllShoesScreen> {
  late Future<List<Shoe>> shoes;

  @override
  void initState() {
    super.initState();
    shoes = NikeService.fetchShoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "All Shoes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.tune,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // CATEGORY TAB
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _tab("All", true),
                _tab("Lifestyle", false),
                _tab("Jordan", false),
                _tab("Running", false),
                _tab("Basketball", false),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Shoe>>(
              future: shoes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Không có sản phẩm"),
                  );
                }

                final data = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Giảm childAspectRatio để tăng chiều cao thẻ (tránh bị cấn/tràn chữ)
                    childAspectRatio: 0.53,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final shoe = data[index];

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
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _tab(String title, bool active) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            if (active)
              Container(
                height: 2,
                width: 24,
                color: Colors.black,
              )
            else
              const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
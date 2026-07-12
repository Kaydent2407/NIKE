import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/shoe_model.dart';
import '../services/nike_service.dart';

import '../widgets/search_bar_widget.dart';
import '../widgets/product_grid.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NikeService nikeService = NikeService();

  List<Shoe> shoes = [];

  bool isLoading = true;
  bool isLoadMore = false;

  String? error;

  @override
  void initState() {
    super.initState();
    loadShoes();
  }

  Future<void> loadShoes() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        error = null;
      });
    }

    try {
      final result = await nikeService.getWomenShoes();

      if (!mounted) return;

      setState(() {
        shoes = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  Future<void> loadMore() async {
    if (isLoadMore) return;

    if (nikeService.nextToken == null) return;

    setState(() {
      isLoadMore = true;
    });

    try {
      final more = await nikeService.loadMore();

      if (!mounted) return;

      setState(() {
        shoes.addAll(more);
        isLoadMore = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "NICE",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadShoes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Hello, ${user?.email?.split("@")[0] ?? "Member"}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Find Your Style",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 24),

              const SearchBarWidget(),

              const SizedBox(height: 25),

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                )
              else if (error != null)
                ErrorWidgetView(
                  error: error!,
                  onRetry: loadShoes,
                )
              else if (shoes.isEmpty)
                const EmptyWidget()
              else
                ProductGrid(
                  shoes: shoes,
                ),

              const SizedBox(height: 30),

              if (!isLoading && nikeService.nextToken != null)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: isLoadMore ? null : loadMore,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(180, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    icon: isLoadMore
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.expand_more),

                    label: Text(
                      isLoadMore
                          ? "Loading..."
                          : "Load More",
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
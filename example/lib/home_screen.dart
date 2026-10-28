import 'package:flutter/material.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home screen"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount:
            commonController.getAllProductModel.value.products?.length ?? 0,
        itemBuilder: (context, index) {
          var data = commonController.getAllProductModel.value.products?[index];
          return Card(
            surfaceTintColor: Colors.white,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.title.toString() ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "\$${data?.price.toString() ?? ""}",
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

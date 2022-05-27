import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/api_response.dart';

class BestStoreCard extends StatelessWidget {
  final ApiResponse store;
  final int itemCount;

  const BestStoreCard({
    Key? key,
    required this.store,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        shadowColor: Colors.blue,
        child: FractionallySizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Best Store Found!",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(store.storeName!, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text(store.storeAddress!, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("${store.matchRank!}% Tag Match",
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("Total Cost: \$${store.averagePrice! * itemCount}"),
              const SizedBox(
                height: 20,
              ),
              Text("Last Upload: ${store.daysSinceUpload} days ago")
            ],
          ),
          widthFactor: 0.75,
          heightFactor: 0.75,
        ),
      ),
    );
  }
}

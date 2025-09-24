import 'package:flutter/material.dart';
import 'package:my_api_templates/model/vendor_categories_list_model.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Data category;

  const CategoryDetailScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.categoryName ?? 'Category Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.categoryName ?? 'Unknown',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Number of Products: ${category.productCount ?? 'N/A'}",
              style: TextStyle(fontSize: 18),
            ),
            // Add more fields if needed
          ],
        ),
      ),
    );
  }
}

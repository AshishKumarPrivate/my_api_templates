import 'package:flutter/material.dart';
import 'package:my_api_templates/model/vendor_categories_list_model.dart';
import 'package:provider/provider.dart';

import '../controller/api_provider.dart';
import 'category_detail_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  String _searchQuery = '';
  Data? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchController.addListener(_onSearchChanged);

    // Fetch categories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories();
    });
  }

  void _fetchCategories() {
    final provider = Provider.of<ApiProvider>(context, listen: false);
    provider.getAllVendorCategoryList(context).then((_) {
      final categoryData =
          provider.getVendorCategoryListModelResponse?.data?.data;
      if (categoryData != null && categoryData.isNotEmpty) {
        setState(() {
          _selectedCategory = categoryData[0]; // default selected
        });
      }
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildDropdown(), _buildCategoryGridSection()],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Consumer<ApiProvider>(
      builder: (context, apiProvider, child) {
        final categoryData =
            apiProvider.getVendorCategoryListModelResponse?.data;
        final bool isLoading = apiProvider.isLoading;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          width: double.infinity,
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // 1. Loading state
              : (categoryData?.data == null || categoryData!.data!.isEmpty)
              ? Center(child: Text("No categories found.")) // 2. No data state
              : DropdownButton<Data>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: const SizedBox(),
                  onChanged: (Data? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                    print('Selected category: ${newValue?.categoryName}');
                  },
                  items: categoryData.data!.map<DropdownMenuItem<Data>>((
                    Data category,
                  ) {
                    return DropdownMenuItem<Data>(
                      value: category,
                      child: Text(category.categoryName ?? 'Unknown'),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  Widget _buildCategoryGridSection() {
    return Consumer<ApiProvider>(
      builder: (context, apiProvider, child) {
        final categoryData =
            apiProvider.getVendorCategoryListModelResponse?.data;
        final bool isLoading = apiProvider.isLoading;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Product Categories')],
              ),
              const SizedBox(height: 16),
              if (isLoading)
                CircularProgressIndicator()
              else if (categoryData == null)
                Text("No Data Found")
              else
                _buildCategoryGrid(categoryData.data ?? []),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryGrid(List<Data> categories) {
    // Show maximum 6 categories in grid (2x3)
    final displayCategories = categories.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        return _buildGridCategoryItem(displayCategories[index]);
      },
    );
  }

  Widget _buildGridCategoryItem(Data category) {
    // Define a single color for the icon background
    const Color iconBackgroundColor = Colors.black;

    return Card(
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: InkWell(
        onTap: () {
          print("Selected ${category.categoryName}");
          // Add your navigation or detail screen logic here
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            // image: const DecorationImage(
            //   image: AssetImage('assets/images/img_pattern2.jpg'),
            //   fit: BoxFit.cover,
            //   opacity: 0.4,
            // ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon and background circle
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor, // Use the single color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.folder, // Use a fixed icon instead of a dynamic one
                  color: Colors.white, // Use a single color for the icon
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.categoryName ?? 'Unknown',
                      maxLines: 1,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${category.productCount ?? 'N/A'} Products",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Trailing icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

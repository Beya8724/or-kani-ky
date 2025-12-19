import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Sample data simulating products
  final List<Map<String, dynamic>> allDrinks = [
    {"name": "Cappuccino", "price": 120, "category": "Hot", "image": "assets/products/Cappuccino.jpg"},
    {"name": "Iced Latte", "price": 130, "category": "Cold", "image": "assets/products/iced_latte.jpg"},
    {"name": "Espresso Shot", "price": 80, "category": "Hot", "image": "assets/products/espresso.jpg"},
    {"name": "Cold Brew", "price": 150, "category": "Cold", "image": "assets/products/cold_brew.jpg"},
    {"name": "Mocha", "price": 140, "category": "Hot", "image": "assets/products/mocha.jpg"},
    {"name": "Iced Americano", "price": 100, "category": "Cold", "image": "assets/productsamericano.jpg"},
  ];

  String selectedCategory = 'All'; // State for category filter
  List<Map<String, dynamic>> filteredDrinks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDrinks = allDrinks;
    searchController.addListener(_filterDrinks);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterDrinks);
    searchController.dispose();
    super.dispose();
  }

  void _filterDrinks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredDrinks = allDrinks.where((drink) {
        final nameMatches = drink['name'].toLowerCase().contains(query);
        final categoryMatches = selectedCategory == 'All' || drink['category'] == selectedCategory;
        return nameMatches && categoryMatches;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      _filterDrinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/orderHistory'),
            tooltip: 'Order History',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,

      // FLOATING ACTION BUTTON FOR CART
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        backgroundColor: const Color(0xFFD4A056),
        foregroundColor: Colors.black,
        child: const Icon(Icons.shopping_cart),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/yes.jpg'), 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black87, 
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
           
            const SizedBox(height: 100), 

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for a drink...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFD4A056)),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            
            // CATEGORY CHIPS (HOT / COLD)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'All', 
                    isSelected: selectedCategory == 'All', 
                    onTap: () => _selectCategory('All')
                  ),
                  _CategoryChip(
                    label: 'Hot Drinks', 
                    isSelected: selectedCategory == 'Hot', 
                    onTap: () => _selectCategory('Hot')
                  ),
                  _CategoryChip(
                    label: 'Cold Drinks', 
                    isSelected: selectedCategory == 'Cold', 
                    onTap: () => _selectCategory('Cold')
                  ),
                ],
              ),
            ),

            // GRID VIEW OF FILTERED DRINKS
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.75),
                itemCount: filteredDrinks.length,
                itemBuilder: (context, index) {
                  final drink = filteredDrinks[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/drinkDetails"),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // DRINK IMAGE
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                              child: Image.asset(
                                drink['image'], 
                                fit: BoxFit.cover,
                                // Placeholder icon if the specific asset image is missing
                                errorBuilder: (context, error, stackTrace) => 
                                  const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.white70)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  drink['name'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "₱${drink['price']}",
                                  style: const TextStyle(
                                      color: Color(0xFFD4A056),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      drink['category'],
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    const Icon(Icons.add_circle, color: Color(0xFFD4A056), size: 24),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Chip Widget for categories
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: isSelected ? const Color(0xFFD4A056) : Colors.black38,
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected ? BorderSide.none : const BorderSide(color: Colors.white38),
        ),
      ),
    );
  }
}
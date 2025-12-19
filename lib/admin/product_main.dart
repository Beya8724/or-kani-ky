import 'package:flutter/material.dart';

class ProductMainScreen extends StatefulWidget {
  const ProductMainScreen({super.key});

  @override
  State<ProductMainScreen> createState() => _ProductMainScreenState();
}

class _ProductMainScreenState extends State<ProductMainScreen> {
  List<Map<String, dynamic>> products = [];

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();

  String? selectedCategory;
  String? selectedImage;

  // Fake sample images
  final List<String> sampleImages = [
    "assets/products",
    
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          const Text(
            "Products",
            style: TextStyle(
              color: Color(0xFFD4A056),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // ADD PRODUCT PANEL
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE PICKER (FAKE for now)
                GestureDetector(
                  onTap: () {
                    _pickImage(context);
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                      image: selectedImage != null
                          ? DecorationImage(
                              image: AssetImage(selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: selectedImage == null
                        ? const Center(
                            child: Text(
                              "Tap to choose image",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 15),

                // Product Name
                _inputField(
                  controller: nameCtrl,
                  label: "Product Name",
                  icon: Icons.local_cafe,
                ),

                const SizedBox(height: 12),

                // Price
                _inputField(
                  controller: priceCtrl,
                  label: "Price",
                  icon: Icons.attach_money,
                  isNumber: true,
                ),

                const SizedBox(height: 12),

                // STOCK QUANTITY
                _inputField(
                  controller: stockCtrl,
                  label: "Stock Quantity",
                  icon: Icons.storage,
                  isNumber: true,
                ),

                const SizedBox(height: 12),

                // CATEGORY DROPDOWN
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.black87,
                    underline: const SizedBox(),
                    hint: const Text("Select Category",
                        style: TextStyle(color: Colors.white70)),
                    value: selectedCategory,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4A056)),
                    items: const [
                      DropdownMenuItem(
                        value: "Hot",
                        child: Text("Hot", style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: "Cold",
                        child: Text("Cold", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedCategory = value);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // ADD BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A056),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _addProduct,
                    child: const Text(
                      "Add Product",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // PRODUCT LIST
          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Text(
                      "No products added yet.",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item["image"],
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item["name"],
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "₱${item["price"]} • Stock: ${item["stock"]} • ${item["category"]}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() => products.removeAt(index));
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- Widgets & Methods ---

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Color(0xFFD4A056)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD4A056)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _pickImage(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (_) {
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: sampleImages.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                setState(() => selectedImage = sampleImages[i]);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(sampleImages[i]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addProduct() {
    if (nameCtrl.text.isEmpty ||
        priceCtrl.text.isEmpty ||
        stockCtrl.text.isEmpty ||
        selectedCategory == null ||
        selectedImage == null) {
      return;
    }

    setState(() {
      products.add({
        "name": nameCtrl.text,
        "price": double.tryParse(priceCtrl.text) ?? 0,
        "stock": int.tryParse(stockCtrl.text) ?? 0,
        "category": selectedCategory!,
        "image": selectedImage!,
      });
    });

    nameCtrl.clear();
    priceCtrl.clear();
    stockCtrl.clear();
    selectedCategory = null;
    selectedImage = null;
  }
}

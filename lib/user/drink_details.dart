import 'package:flutter/material.dart';

class DrinkDetails extends StatelessWidget { 
  const DrinkDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drink Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/drink.jpg'), 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black87,
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Use a real image placeholder here
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/cappuccino.jpg', 
                  height: 200, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.local_cafe, size: 120, color: Color(0xFFD4A056)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Cappuccino",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4A056))),
              const Text("₱120",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70)),
              const SizedBox(height: 10),
              const Text(
                "A rich espresso with steamed milk and foam, topped with a dusting of cocoa powder. Customize your size and milk preference below.",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Options (e.g., Size Selector - using placeholders)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _OptionChip(label: 'Small', isSelected: false),
                  _OptionChip(label: 'Medium', isSelected: true),
                  _OptionChip(label: 'Large', isSelected: false),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A056),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, "/cart"),
                  child: const Text("Add to Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _OptionChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected ? const Color(0xFFD4A056) : Colors.black38,
      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
    );
  }
}
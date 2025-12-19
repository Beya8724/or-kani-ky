import 'package:flutter/material.dart';

class RateDrink extends StatefulWidget {
  // Pass the item name and image URL (or asset path) to make the widget dynamic
  final String itemName;
  final String itemImage;

  const RateDrink({
    super.key,
    this.itemName = "Cappuccino", 
    this.itemImage = "assets/espresso.jpg", // Placeholder image
  });

  @override
  State<RateDrink> createState() => _RateDrinkState();
}

class _RateDrinkState extends State<RateDrink> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  // Function to handle submission and show confirmation
  void _submitRating(BuildContext context) {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a star rating first!")));
      return;
    }

    // In a real app, send _rating and _commentController.text to your server here.

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('Rating Submitted! 🎉', style: TextStyle(color: Color(0xFFD4A056))),
        content: Text(
          'Thank you for rating your ${widget.itemName} $_rating stars!',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A056)),
            onPressed: () {
              // Close dialog and go back to the previous screen (like Order History)
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Helper to build the star rating row
  Widget _buildRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star_rate_rounded : Icons.star_border_rounded, // Use rounded icons
            size: 48,
            color: const Color(0xFFD4A056),
          ),
          onPressed: () {
            setState(() {
              _rating = starValue;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Your Drink"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/yes.jpg'), // Consistent background
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black87,
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),

              // Item Visual and Name
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  widget.itemImage,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.local_cafe, size: 100, color: Color(0xFFD4A056)),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "How was this drink?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              Text(
                widget.itemName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFD4A056)),
              ),
              const SizedBox(height: 40),

              // Star Rating Section
              _buildRatingBar(),
              const SizedBox(height: 10),
              Text(
                _rating == 0 ? "Tap a star to rate" : "Selected Rating: $_rating / 5",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Comment Field
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Add a comment (optional)",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Your Feedback',
                  labelStyle: const TextStyle(color: Color(0xFFD4A056)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A056),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _submitRating(context),
                  child: const Text("Submit Rating", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
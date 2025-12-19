import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // State variable to hold the selected payment method
  String _selectedPaymentMethod = 'gcash'; 
  
  // Example data for Order Summary (Mocked total from Cart/Checkout)
  final double _orderTotal = 390.00;

  // Helper widget to build stylish RadioListTile cards
  Widget _buildPaymentCard({
    required String value,
    required String title,
    required IconData icon,
    required Color iconColor,
    String? subtitle,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    
    return Card(
      color: isSelected ? const Color(0xFFD4A056).withOpacity(0.2) : Colors.white10,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isSelected
            ? const BorderSide(color: Color(0xFFD4A056), width: 2)
            : BorderSide.none,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (v) {
          setState(() {
            _selectedPaymentMethod = v!;
          });
        },
        activeColor: const Color(0xFFD4A056),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white70)) : null,
        secondary: Icon(icon, color: iconColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/drink.jpg'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              
              // Payment Header
              const Text("Choose Payment Method", 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4A056))),
              const SizedBox(height: 20),
              
              // GCash Option
              _buildPaymentCard(
                value: "gcash",
                title: "GCash (Recommended)",
                subtitle: "Pay instantly via GCash mobile wallet.",
                icon: Icons.phone_android,
                iconColor: Colors.blueAccent,
              ),

              // COD Option
              _buildPaymentCard(
                value: "cash",
                title: "Cash on Delivery (COD)",
                subtitle: "Pay the driver when your order arrives.",
                icon: Icons.money,
                iconColor: Colors.greenAccent,
              ),

              const SizedBox(height: 30),

              // Order Summary Card
              Card(
                color: Colors.black54,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Order Total:",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₱${_orderTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Color(0xFFD4A056), 
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              
              // Confirm Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A056),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // Action based on selected method
                    if (_selectedPaymentMethod == 'gcash') {
                      // Logic for GCash payment (e.g., prompt for QR/number)
                      _showGcashPrompt(context);
                    } else {
                      // Logic for COD (simple confirmation)
                      Navigator.pushReplacementNamed(context, "/trackOrder");
                    }
                  },
                  child: const Text("Confirm Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Separate function to handle the GCash interaction
  void _showGcashPrompt(BuildContext context) {
    // You would integrate a payment SDK here. For now, this is a mock confirmation dialog.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('GCash Payment', style: TextStyle(color: Color(0xFFD4A056))),
        content: Text(
          'Total: ₱${_orderTotal.toStringAsFixed(2)}\n\n'
          'You will be redirected to the GCash app/interface to complete the payment using your linked account.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A056)),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacementNamed(context, "/trackOrder"); // Navigate to confirmation/tracking
            },
            child: const Text('Proceed to GCash'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// NOTE: Ensure these imports point to your actual files
import '../providers/cart_provider.dart'; // Must define 'cartNotifierProvider'
import '../providers/checkout_data_provider.dart'; // Must define 'checkoutDataProvider'
import '../providers/order_provider.dart'; // Must define 'orderListProvider'

import '../models/order_submission_model.dart'; 

class Payment extends ConsumerStatefulWidget {
  const Payment({super.key});

  @override
  ConsumerState<Payment> createState() => _PaymentState();
}

class _PaymentState extends ConsumerState<Payment> {
  String _selectedPaymentMethod = 'gcash';
  
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

  // Function to handle the entire order submission process
  Future<void> _processPaymentAndSubmitOrder(BuildContext context) async {
    // Access providers directly via ref
    final cartState = ref.read(cartNotifierProvider); 
    final checkoutData = ref.read(checkoutDataProvider); 

    if (cartState.items.isEmpty || checkoutData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Cart is empty or checkout data is missing.')),
      );
      return;
    }

    String initialStatus = (_selectedPaymentMethod == 'gcash') ? 'Pending' : 'Processing';

    // Map checkout data and cart items to the OrderSubmissionData model
    final orderData = OrderSubmissionData(
      cartItems: cartState.items,
      totalAmount: cartState.totalPrice, 
      status: initialStatus,
      orderType: checkoutData.orderType, 
      deliveryAddress: checkoutData.address,
      contactNumber: checkoutData.contactNumber,
      paymentMethod: _selectedPaymentMethod,
    );

    final messenger = ScaffoldMessenger.of(context);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: Color(0xFFD4A056)),
            SizedBox(width: 15),
            Text("Submitting order...", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black87,
      ),
    );

    try {
      // Submit the order
      await ref.read(orderListProvider.notifier).submitOrder(orderData); 
      
      // Clear the cart on success
      ref.read(cartNotifierProvider.notifier).clearCart(); 

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      
      if (_selectedPaymentMethod == 'gcash') {
        _showGcashPrompt(context, cartState.totalPrice);
      } else {
        // Navigate to the order tracking screen for COD/processing orders
        Navigator.pushReplacementNamed(context, "/trackOrder"); 
      }
      
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      messenger.showSnackBar(
        SnackBar(content: Text('Order submission failed: ${e.toString()}')),
      );
    }
  }


  // Function to handle the GCash interaction
  void _showGcashPrompt(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('GCash Payment', style: TextStyle(color: Color(0xFFD4A056))),
        content: Text(
          'Total: ₱${total.toStringAsFixed(2)}\n\n'
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
              Navigator.pop(context); 
              // After the user "proceeds," they are theoretically waiting for payment confirmation, so we move to tracking.
              Navigator.pushReplacementNamed(context, "/trackOrder"); 
            },
            child: const Text('Proceed to GCash'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the cart total price from Riverpod
    final orderTotal = ref.watch(cartNotifierProvider.select((cart) => cart.totalPrice));

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
            image: AssetImage('assets/background/drink,jpg.jpg'),
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
              
              const Text("Choose Payment Method", 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4A056))),
              const SizedBox(height: 20),
              
              _buildPaymentCard(
                value: "gcash",
                title: "GCash (Recommended)",
                subtitle: "Pay instantly via GCash mobile wallet.",
                icon: Icons.phone_android,
                iconColor: Colors.blueAccent,
              ),

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
                        "₱${orderTotal.toStringAsFixed(2)}",
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
                  onPressed: orderTotal > 0
                    ? () => _processPaymentAndSubmitOrder(context)
                    : null, 
                  child: const Text("Confirm Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
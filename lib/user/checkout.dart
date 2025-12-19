import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String _orderType = 'pickup'; 
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  Widget _buildCheckoutField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFD4A056)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              
              const Text("Select Order Type", 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4A056))),
              const SizedBox(height: 15),

              _buildRadioCard(
                value: "pickup",
                title: "Pick Up",
                subtitle: "Collect your order at the counter.",
                icon: Icons.storefront,
              ),

              _buildRadioCard(
                value: "delivery",
                title: "Delivery",
                subtitle: "Get your order delivered to your address (₱50 Fee).",
                icon: Icons.delivery_dining,
              ),

              if (_orderType == 'delivery') ...[
                const SizedBox(height: 30),
                const Text("Delivery Details", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4A056))),
                const SizedBox(height: 15),
                
                _buildCheckoutField(
                  controller: _addressController,
                  hintText: 'Full Delivery Address (Street, City)',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 15),

                _buildCheckoutField(
                  controller: _contactController,
                  hintText: 'Contact Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
              ],
              
              const SizedBox(height: 50),

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
                    if (_orderType == 'delivery' && (_addressController.text.isEmpty || _contactController.text.isEmpty)) {
                       ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Please enter your address and contact details for delivery.")));
                       return;
                    }
                    Navigator.pushNamed(context, "/payment");
                  },
                  child: const Text("Continue to Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      color: _orderType == value ? const Color(0xFFD4A056).withOpacity(0.2) : Colors.white10,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: _orderType == value
            ? const BorderSide(color: Color(0xFFD4A056), width: 2)
            : BorderSide.none,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _orderType,
        onChanged: (v) {
          setState(() {
            _orderType = v!;
          });
        },
        activeColor: const Color(0xFFD4A056),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        secondary: Icon(icon, color: const Color(0xFFD4A056)),
      ),
    );
  }
}
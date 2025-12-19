import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/admin_order_provider.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  final List<String> statuses = ['Pending', 'Processing', 'Delivered', 'Cancelled'];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green.shade400;
      case 'Cancelled':
        return Colors.red.shade400;
      case 'Pending':
        return Colors.amber.shade400;
      case 'Processing':
        return Colors.blue.shade400;
      default:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrderListProvider);
    final notifier = ref.read(adminOrderListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Order Management'),
        backgroundColor: const Color(0xFF1D1D1D),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFD4A056)),
            onPressed: notifier.fetchAllOrders,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1D1D1D),
      body: ordersAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4A056))),
        error: (err, stack) => Center(
          child: Text(
            'Error loading orders. Check Supabase RLS/network.\nDetails: ${err.toString().split(':').last.trim()}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent, fontSize: 16),
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text("No orders currently placed.",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final customerName = order.userFullName ?? 'User ID: ${order.id}';

              return Card(
                color: Colors.black38,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(15),
                  iconColor: const Color(0xFFD4A056),
                  collapsedIconColor: Colors.white70,
                  title: Text('Order #${order.id} - $customerName',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMM dd, hh:mm a').format(order.createdAt),
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w300)),
                      Text("₱${order.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Color(0xFFD4A056), fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  children: [
                    const Divider(color: Colors.white38, height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Items:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              "${item.productName} x${item.quantity} (₱${(item.unitPrice * item.quantity).toStringAsFixed(2)})",
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          )),

                          const SizedBox(height: 15),

                          // Status Selector and Updater
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Update Status:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                              DropdownButton<String>(
                                value: order.status,
                                dropdownColor: Colors.black,
                                style: TextStyle(color: _getStatusColor(order.status), fontWeight: FontWeight.bold),
                                underline: Container(),
                                items: statuses.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(color: _getStatusColor(value))),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    notifier.updateOrderStatus(order.id, newValue);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
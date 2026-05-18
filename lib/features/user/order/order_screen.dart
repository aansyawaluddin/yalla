import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/models/order_model.dart';
import 'package:yalla/core/providers/order_provider.dart';
import 'package:yalla/core/widgets/button/custom_bottom_nav_bar.dart';
import 'package:yalla/core/widgets/card/order/order_flight_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final isLoading = provider.isLoading;

    final List<OrderModel> currentOrders = _selectedTabIndex == 0
        ? provider.activeOrders
        : provider.historyOrders;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -90.0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55 + 70,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.5),
                      const Color(0xFFF5F6F8),
                    ],
                    stops: const [0.4, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Pesanan",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003875),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                _buildMainTabs(),
                const SizedBox(height: 16),
                _buildCategoryChips(),
                const SizedBox(height: 20),

                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0084FF),
                          ),
                        )
                      : currentOrders.isEmpty
                      ? Center(
                          child: Text(
                            _selectedTabIndex == 0
                                ? "Belum ada pesanan aktif."
                                : "Belum ada riwayat pesanan.",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 2.0,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: currentOrders.length,
                          itemBuilder: (context, index) {
                            final orderData = currentOrders[index];
                            return OrderFlightCard(order: orderData);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildMainTabs() {
    return Container(
      color: Colors.white,
      height: 48,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 0),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedTabIndex == 0
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: _selectedTabIndex == 0
                              ? const Color(0xFF004CBF)
                              : Colors.grey.shade400,
                        ),
                        child: const Text("Aktif"),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 1),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedTabIndex == 1
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: _selectedTabIndex == 1
                              ? const Color(0xFF004CBF)
                              : Colors.grey.shade400,
                        ),
                        child: const Text("Riwayat"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: _selectedTabIndex == 0
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(height: 3, color: const Color(0xFF004CBF)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    List<String> categories = ["Semua", "Pesawat", "Hotel", "Visa"];
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 10.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  bool isActive = cat == "Semua";
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF004CBF)
                            : Colors.grey.shade500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Text("Filter", style: TextStyle(color: Colors.black87)),
            label: const Icon(Icons.tune, color: Colors.black87, size: 18),
          ),
        ],
      ),
    );
  }
}

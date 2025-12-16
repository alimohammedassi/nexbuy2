import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/product.dart';
import '../services/firestore_product_service.dart';
import '../services/admin_service.dart';
import '../providers/category_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_orders_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _adminService = AdminService();
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _adminService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
      _isLoading = false;
    });

    if (!isAdmin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.lock, color: Colors.white),
                SizedBox(width: 12),
                Text('Access denied. Admin privileges required.'),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF2563EB)),
                  strokeWidth: 3,
                ),
                SizedBox(height: 24),
                Text(
                  'Verifying Access...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isAdmin) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: Text('Access Denied')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(
          0xFF1C1C1C,
        ), // Dark background for Supabase look
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1C),
              border: Border(bottom: BorderSide(color: Color(0xFF2E2E2E))),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: const Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage your store & view analytics',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E), // Darker tab bar bg
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3E3E3E)),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: const Color(0xFF3E3E3E), // Dark active tab
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Orders'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [_AnalyticsOverviewTab(), AdminOrdersScreen()],
        ),
      ),
    );
  }
}

class _AnalyticsOverviewTab extends StatefulWidget {
  const _AnalyticsOverviewTab();

  @override
  State<_AnalyticsOverviewTab> createState() => _AnalyticsOverviewTabState();
}

class _AnalyticsOverviewTabState extends State<_AnalyticsOverviewTab> {
  final AdminService _adminService = AdminService();
  final FirestoreProductService _productService = FirestoreProductService();

  bool _isLoading = true;
  int _totalOrders = 0;
  int _totalProducts = 0;
  double _totalRevenue = 0;
  int _pendingOrders = 0;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      // Fetch orders
      final orders = await _adminService.getAllOrders();
      _totalOrders = orders.length;
      _totalRevenue = orders.fold(
        0.0,
        (sum, order) =>
            sum + ((order['total_amount'] as num?)?.toDouble() ?? 0.0),
      );
      _pendingOrders = orders.where((o) => o['status'] == 'pending').length;

      // Fetch products
      final products = await _productService.getAllProducts();
      _totalProducts = products.length;
    } catch (e) {
      debugPrint('Error loading analytics: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF3ECF8E)),
      ); // Supabase Green
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          // Summary Row (like Supabase header)
          Row(
            children: [
              _buildSummaryItem(
                'Total Revenue',
                '\$${_totalRevenue.toStringAsFixed(0)}',
              ),
              const SizedBox(width: 24),
              _buildSummaryItem(
                'Pending Orders',
                _pendingOrders.toString(),
                isHigh: _pendingOrders > 0,
              ),
              const SizedBox(width: 24),
              _buildSummaryItem('Products', _totalProducts.toString()),
            ],
          ),
          const SizedBox(height: 32),

          // Cards Grid
          SizedBox(
            height: 220,
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Database',
                    'Orders',
                    _totalOrders.toString(),
                    const Color(0xFF3ECF8E),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Auth',
                    'Users',
                    '12',
                    const Color(0xFF3ECF8E),
                  ),
                ), // Dummy user count
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Storage',
                    'Media',
                    '248 Files',
                    const Color(0xFF3ECF8E),
                  ),
                ), // Dummy storage
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Realtime',
                    'Active',
                    '4',
                    const Color(0xFF3ECF8E),
                  ),
                ), // Dummy realtime
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isHigh = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isHigh ? const Color(0xFFFF4B4B) : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String subtitle,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF232323), // Card bg
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storage_rounded, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Mock Bar Chart
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(12, (index) {
                // Generate varied heights
                final height = 10 + (index * 7 % 40) + ((index % 3) * 10);
                return Container(
                  width: 6,
                  height: height.toDouble(),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last 24 hours',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }
}

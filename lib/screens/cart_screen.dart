import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/cart_service.dart';
import '../models/user.dart' as models;
import 'package:slide_to_act/slide_to_act.dart';
import '../localization/app_localizations.dart';
import '../utils/snackbar_utils.dart';

import 'address_management_screen.dart';
import 'payment_page.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  final CartService _cartService = CartService();

  List<models.CartItem> _cartItems = [];
  bool _isLoadingCart = true;
  bool _isProcessingCheckout = false;
  AnimationController? _slideAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchCartData();
  }

  @override
  void dispose() {
    _slideAnimationController?.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _fetchCartData() async {
    setState(() => _isLoadingCart = true);

    _userService.initialize();
    _cartItems = List<models.CartItem>.from(_cartService.cartItems);

    _cartService.cartStream.listen((items) {
      if (!mounted) return;
      setState(() {
        _cartItems = List<models.CartItem>.from(items);
      });
    });

    setState(() => _isLoadingCart = false);
    if (mounted) {
      _slideAnimationController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      body: CustomScrollView(
        slivers: [
          _buildHeaderAppBar(),
          if (_isLoadingCart)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_cartItems.isEmpty)
            SliverFillRemaining(child: _buildEmptyCartView())
          else
            _buildCartItemsList(),
        ],
      ),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  Widget _buildHeaderAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _buildBackButton(),
      actions: [if (_cartItems.isNotEmpty) _buildClearCartButton()],
      flexibleSpace: FlexibleSpaceBar(
        title: _buildAppBarTitle(),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black87,
          size: 18,
        ),
      ),
      onPressed: _navigateBack,
    );
  }

  Widget _buildClearCartButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton.icon(
        onPressed: _showClearCartDialog,
        icon: const Icon(Icons.delete_sweep_outlined, size: 18),
        label: Text(AppLocalizations.of(context).clear),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: Colors.red.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).shoppingCart,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_cartItems.isNotEmpty) _buildItemCountText(),
      ],
    );
  }

  Widget _buildItemCountText() {
    return Text(
      '${_cartItems.length} ${_cartItems.length == 1 ? AppLocalizations.of(context).item : AppLocalizations.of(context).items}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyCartIcon(),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context).yourCartIsEmpty,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildEmptyCartSubtitle(),
          const SizedBox(height: 40),
          _buildStartShoppingButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyCartIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2563EB).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.05),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shopping_cart_outlined,
        size: 70,
        color: Color(0xFF2563EB),
      ),
    );
  }

  Widget _buildEmptyCartSubtitle() {
    return Text(
      AppLocalizations.of(context).startAddingItems,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
    );
  }

  Widget _buildStartShoppingButton() {
    return ElevatedButton.icon(
      onPressed: _navigateBack,
      icon: const Icon(Icons.shopping_bag_outlined),
      label: Text(AppLocalizations.of(context).startShopping),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    );
  }

  Widget _buildCartItemsList() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildAnimatedCartItem(index),
          childCount: _cartItems.length,
        ),
      ),
    );
  }

  Widget _buildAnimatedCartItem(int index) {
    return FadeTransition(
      opacity: _createFadeAnimation(index),
      child: SlideTransition(
        position: _createSlideAnimation(index),
        child: _buildCartItemCard(_cartItems[index], index),
      ),
    );
  }

  Animation<double> _createFadeAnimation(int index) {
    if (_slideAnimationController == null) {
      return const AlwaysStoppedAnimation(1.0);
    }
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _slideAnimationController!,
        curve: Interval(index * 0.1, (index + 1) * 0.1, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _createSlideAnimation(int index) {
    if (_slideAnimationController == null) {
      return const AlwaysStoppedAnimation(Offset.zero);
    }
    return Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _slideAnimationController!,
        curve: Interval(index * 0.1, (index + 1) * 0.1, curve: Curves.easeOut),
      ),
    );
  }

  Widget _buildCartItemCard(models.CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildDismissibleItem(item, index),
      ),
    );
  }

  Widget _buildDismissibleItem(models.CartItem item, int index) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteCartItem(index),
      background: _buildDismissBackground(),
      child: _buildItemContent(item, index),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    );
  }

  Widget _buildItemContent(models.CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildProductImage(item),
          const SizedBox(width: 16),
          Expanded(child: _buildProductDetails(item, index)),
        ],
      ),
    );
  }

  Widget _buildProductImage(models.CartItem item) {
    final isNetwork = item.productImage.startsWith('http');
    final heroTag =
        'cart_item_${item.id.isNotEmpty ? item.id : item.productId}_${item.productId}';
    return Hero(
      tag: heroTag,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: isNetwork
              ? Image.network(
                  item.productImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.laptop_mac,
                      color: Colors.grey,
                      size: 48,
                    );
                  },
                )
              : Image.asset(
                  item.productImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.laptop_mac,
                      color: Colors.grey,
                      size: 48,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(models.CartItem item, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductNameRow(item, index),
        const SizedBox(height: 8),
        _buildPriceChip(item),
        const SizedBox(height: 12),
        _buildQuantityRow(item, index),
      ],
    );
  }

  Widget _buildProductNameRow(models.CartItem item, int index) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.productName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildRemoveButton(index),
      ],
    );
  }

  Widget _buildRemoveButton(int index) {
    return IconButton(
      onPressed: () => _deleteCartItem(index),
      icon: const Icon(Icons.close, size: 20),
      color: Colors.grey[400],
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildPriceChip(models.CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '\$${item.price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildQuantityRow(models.CartItem item, int index) {
    return Row(
      children: [
        _buildQuantityControl(
          icon: Icons.remove,
          onPressed: item.quantity > 1
              ? () => _modifyItemQuantity(index, item.quantity - 1)
              : null,
        ),
        _buildQuantityDisplay(item.quantity),
        _buildQuantityControl(
          icon: Icons.add,
          onPressed: () => _modifyItemQuantity(index, item.quantity + 1),
        ),
        const Spacer(),
        _buildItemTotalPrice(item),
      ],
    );
  }

  Widget _buildQuantityDisplay(int quantity) {
    return Container(
      width: 50,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          quantity.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildItemTotalPrice(models.CartItem item) {
    return Text(
      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildQuantityControl({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              )
            : null,
        color: onPressed == null ? Colors.grey[300] : null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Icon(
            icon,
            color: onPressed != null ? Colors.white : Colors.grey[600],
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    final cartSummary = _calculateCartSummary();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              _buildSummaryRow(
                AppLocalizations.of(context).subtotal,
                cartSummary['subtotal']!,
              ),
              _buildSummaryRow(
                AppLocalizations.of(context).shipping,
                cartSummary['shipping']!,
                isFree: true,
              ),
              _buildSummaryRow(
                AppLocalizations.of(context).taxPercent,
                cartSummary['tax']!,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              _buildSummaryRow(
                AppLocalizations.of(context).total,
                cartSummary['total']!,
                isTotal: true,
              ),
              const SizedBox(height: 24),
              _buildCheckoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Map<String, double> _calculateCartSummary() {
    final subtotal = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final shipping = 0.0;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return {
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
    };
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isFree = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[600],
              letterSpacing: -0.2,
            ),
          ),
          Text(
            isFree
                ? AppLocalizations.of(context).free
                : '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 22 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? const Color(0xFF2563EB) : Colors.black87,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SlideAction(
      text: AppLocalizations.of(context).slideToCheckout,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      outerColor: const Color(0xFF2563EB),
      innerColor: Colors.white,
      elevation: 8,
      borderRadius: 30,
      sliderButtonIcon: Icon(
        _isProcessingCheckout ? Icons.hourglass_bottom : Icons.arrow_forward,
        color: const Color(0xFF2563EB),
      ),
      submittedIcon: const Icon(Icons.check, color: Colors.white),
      onSubmit: () async {
        if (_isProcessingCheckout) return;
        await _navigateToPayment();
      },
    );
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  void _modifyItemQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _deleteCartItem(index);
      return;
    }

    setState(() {
      _cartItems[index] = models.CartItem(
        productId: _cartItems[index].productId,
        productName: _cartItems[index].productName,
        productImage: _cartItems[index].productImage,
        price: _cartItems[index].price,
        quantity: newQuantity,
        variant: _cartItems[index].variant,
      );
    });
  }

  void _deleteCartItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });

    SnackbarUtils.showWarning(
      context,
      title: 'Item Removed',
      message: 'Item has been removed from your cart',
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: _executeCartClear,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _executeCartClear() {
    Navigator.pop(context);
    setState(() {
      _cartItems.clear();
    });
    SnackbarUtils.showWarning(
      context,
      title: 'Cart Cleared',
      message: 'All items have been removed from your cart',
    );
  }

  Future<void> _navigateToPayment() async {
    final currentUser = _userService.currentUser;

    if (currentUser == null) {
      SnackbarUtils.showError(
        context,
        title: 'Login Required',
        message: 'Please log in to continue',
      );
      return;
    }

    if (currentUser.addresses.isEmpty) {
      _promptAddressRequired();
      return;
    }

    final selectedAddress = _getDefaultOrFirstAddress(currentUser);
    final cartSummary = _calculateCartSummary();

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            cartItems: _cartItems,
            shippingAddress: selectedAddress,
            totalAmount: cartSummary['total']!,
            cartSummary: cartSummary,
          ),
        ),
      );
    }
  }

  models.Address _getDefaultOrFirstAddress(models.User user) {
    return user.addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => user.addresses.first,
    );
  }

  void _promptAddressRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Address Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Please add a shipping address before placing an order.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: _navigateToAddressManagement,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddressManagement() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressManagementScreen()),
    );
  }
}

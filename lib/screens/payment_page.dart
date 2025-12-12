import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/checkout_service.dart';
import '../services/user_service.dart';
import '../services/cart_service.dart';
import '../models/user.dart' as models;
import '../localization/app_localizations.dart';
import '../utils/snackbar_utils.dart';
import 'order_details_screen.dart';

enum PaymentMethodType { cash, creditCard, digitalWallet }

class PaymentPage extends StatefulWidget {
  final List<models.CartItem> cartItems;
  final models.Address shippingAddress;
  final double totalAmount;
  final Map<String, double> cartSummary;
  final PaymentMethodType? selectedPaymentMethod;

  const PaymentPage({
    super.key,
    required this.cartItems,
    required this.shippingAddress,
    required this.totalAmount,
    required this.cartSummary,
    this.selectedPaymentMethod,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CheckoutService _checkoutService = CheckoutService();
  final UserService _userService = UserService();
  final CartService _cartService = CartService();

  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.creditCard;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String walletNumber = '';
  final TextEditingController _walletController = TextEditingController();
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedPaymentMethod != null) {
      _selectedPaymentMethod = widget.selectedPaymentMethod!;
    }
  }

  @override
  void dispose() {
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPaymentMethodSelector(),
              const SizedBox(height: 20),
              if (_selectedPaymentMethod == PaymentMethodType.creditCard) ...[
                _buildCreditCardWidget(),
                _buildCreditCardForm(),
              ] else if (_selectedPaymentMethod ==
                  PaymentMethodType.digitalWallet) ...[
                _buildWalletInput(),
              ],
              _buildOrderSummary(),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
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
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppLocalizations.of(context).payment,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodOption(
            PaymentMethodType.creditCard,
            Icons.credit_card,
            'Credit/Debit Card',
            'Pay with card',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodOption(
            PaymentMethodType.digitalWallet,
            Icons.account_balance_wallet,
            'Digital Wallet',
            'Pay with wallet',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodOption(
            PaymentMethodType.cash,
            Icons.money,
            'Cash on Delivery',
            'Pay when delivered',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    PaymentMethodType method,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == method;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB).withOpacity(0.1)
                : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        )
                      : null,
                  color: isSelected ? null : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Digital Wallet Number',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _walletController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter wallet number',
                    prefixIcon: const Icon(Icons.account_balance_wallet),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      walletNumber = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              _buildWalletLogo('images/Orange_Egypt-Logo.wine.png'),
              const SizedBox(width: 8),
              _buildWalletLogo('images/voadafon logo.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletLogo(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.account_balance_wallet, size: 24);
          },
        ),
      ),
    );
  }

  Widget _buildCreditCardWidget() {
    final cardType = _getCardTypeFromNumber(cardNumber);
    return Container(
      margin: const EdgeInsets.all(20),
      child: CreditCardWidget(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        showBackView: isCvvFocused,
        obscureCardNumber: true,
        obscureCardCvv: true,
        isHolderNameVisible: true,
        cardBgColor: const Color(0xFF2563EB),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        cardType: cardType,
        animationDuration: const Duration(milliseconds: 500),
        onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
      ),
    );
  }

  CardType _getCardTypeFromNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.isEmpty) return CardType.visa;

    if (cleaned.startsWith('4')) {
      return CardType.visa;
    } else if (cleaned.startsWith('5')) {
      return CardType.mastercard;
    } else if (cleaned.startsWith('34') || cleaned.startsWith('37')) {
      return CardType.americanExpress;
    } else if (cleaned.startsWith('6')) {
      return CardType.discover;
    }

    return CardType.visa;
  }

  Widget _buildCreditCardForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardBrandIcons(),
          const SizedBox(height: 16),
          CreditCardForm(
            formKey: _formKey,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            onCreditCardModelChange: (CreditCardModel creditCardModel) {
              setState(() {
                cardNumber = creditCardModel.cardNumber;
                expiryDate = creditCardModel.expiryDate;
                cardHolderName = creditCardModel.cardHolderName;
                cvvCode = creditCardModel.cvvCode;
                isCvvFocused = creditCardModel.isCvvFocused;
              });
            },
            obscureCvv: true,
            obscureNumber: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandIcons() {
    final detectedBrand = _detectCardBrand(cardNumber);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accepted Cards',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCardIcon(
              icon: FontAwesomeIcons.ccVisa,
              brand: 'Visa',
              isActive: detectedBrand == 'Visa' || cardNumber.isEmpty,
              color: const Color(0xFF1434CB),
            ),
            const SizedBox(width: 12),
            _buildCardIcon(
              icon: FontAwesomeIcons.ccMastercard,
              brand: 'Mastercard',
              isActive: detectedBrand == 'Mastercard' || cardNumber.isEmpty,
              color: const Color(0xFFEB001B),
            ),
            const SizedBox(width: 12),
            _buildCardIcon(
              icon: FontAwesomeIcons.ccAmex,
              brand: 'Amex',
              isActive: detectedBrand == 'Amex' || cardNumber.isEmpty,
              color: const Color(0xFF006FCF),
            ),
            const SizedBox(width: 12),
            _buildCardIcon(
              icon: FontAwesomeIcons.creditCard,
              brand: 'Other',
              isActive: detectedBrand == 'Other' || cardNumber.isEmpty,
              color: Colors.grey[600]!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardIcon({
    required IconData icon,
    required String brand,
    required bool isActive,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? color : Colors.grey[300]!,
          width: isActive ? 2 : 1,
        ),
      ),
      child: FaIcon(icon, color: isActive ? color : Colors.grey[400], size: 24),
    );
  }

  String _detectCardBrand(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.isEmpty) return '';

    // Visa starts with 4
    if (cleaned.startsWith('4')) {
      return 'Visa';
    }
    // Mastercard starts with 5
    if (cleaned.startsWith('5')) {
      return 'Mastercard';
    }
    // Amex starts with 34 or 37
    if (cleaned.startsWith('34') || cleaned.startsWith('37')) {
      return 'Amex';
    }

    return 'Other';
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).orderSummary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            AppLocalizations.of(context).subtotal,
            widget.cartSummary['subtotal']!,
          ),
          _buildSummaryRow(
            AppLocalizations.of(context).shipping,
            widget.cartSummary['shipping']!,
            isFree: true,
          ),
          _buildSummaryRow(
            AppLocalizations.of(context).taxPercent,
            widget.cartSummary['tax']!,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildSummaryRow(
            AppLocalizations.of(context).total,
            widget.totalAmount,
            isTotal: true,
          ),
        ],
      ),
    );
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isProcessingPayment ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isProcessingPayment
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${AppLocalizations.of(context).payNow} \$${widget.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == PaymentMethodType.creditCard) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    } else if (_selectedPaymentMethod == PaymentMethodType.digitalWallet) {
      if (walletNumber.isEmpty) {
        SnackbarUtils.showError(
          context,
          title: 'Validation Error',
          message: 'Please enter your wallet number',
        );
        return;
      }
    }

    setState(() => _isProcessingPayment = true);

    try {
      PaymentMethod paymentMethod;
      switch (_selectedPaymentMethod) {
        case PaymentMethodType.creditCard:
          paymentMethod = PaymentMethod.creditCard;
          break;
        case PaymentMethodType.digitalWallet:
          paymentMethod = PaymentMethod.googlePay; // Using googlePay as wallet
          break;
        case PaymentMethodType.cash:
          paymentMethod =
              PaymentMethod.bankTransfer; // Using bankTransfer as cash
          break;
      }

      final orderNumber = await _checkoutService.processCheckout(
        items: widget.cartItems,
        shippingAddress: widget.shippingAddress,
        paymentMethod: paymentMethod,
        notes: _getPaymentNotes(),
      );

      if (orderNumber != null) {
        // Clear cart
        _cartService.clearCart();

        if (mounted) {
          SnackbarUtils.showSuccess(
            context,
            title: 'Order Placed Successfully!',
            message: 'Order #$orderNumber has been placed',
          );

          final order = _userService.getOrderByNumber(orderNumber);
          if (order != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(orderId: order.id),
              ),
            );
          } else {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        }
      } else {
        if (mounted) {
          SnackbarUtils.showError(
            context,
            title: 'Payment Failed',
            message: 'Failed to process payment. Please try again.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, title: 'Error', message: 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  String _getPaymentNotes() {
    switch (_selectedPaymentMethod) {
      case PaymentMethodType.creditCard:
        return cardNumber.isNotEmpty && cardNumber.length >= 4
            ? 'Payment via credit card ending in ${cardNumber.substring(cardNumber.length - 4)}'
            : 'Payment via credit card';
      case PaymentMethodType.digitalWallet:
        return 'Payment via digital wallet: ${walletNumber.isNotEmpty ? walletNumber : "N/A"}';
      case PaymentMethodType.cash:
        return 'Payment via cash on delivery';
    }
  }
}

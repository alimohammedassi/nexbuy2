import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String categoryName;
  final String productName;
  final double price;
  final String currency;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteChanged;
  final VoidCallback? onAddToCart;
  final String? shortDescription;
  final double? rating;
  final int? reviewCount;
  final double? discountPercentage;
  final bool isAvailable;
  final bool isFavorite;
  final Color? cardColor;
  final Color? primaryColor;
  final double? borderRadius;
  final double? aspectRatio;
  final bool showStock;
  final int? stockCount;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.categoryName,
    required this.productName,
    required this.price,
    this.currency = '\$',
    this.onTap,
    this.onFavoriteChanged,
    this.onAddToCart,
    this.shortDescription,
    this.rating,
    this.reviewCount,
    this.discountPercentage,
    this.isAvailable = true,
    this.isFavorite = false,
    this.cardColor,
    this.primaryColor,
    this.borderRadius,
    this.aspectRatio = 0.75,
    this.showStock = false,
    this.stockCount,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isFavorite = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() {
        _isFavorite = widget.isFavorite;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    widget.onTap?.call();
  }

  void _toggleFavorite() {
    if (!mounted) return;
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteChanged?.call(_isFavorite);
  }

  double get _discountedPrice {
    if (widget.discountPercentage != null && widget.discountPercentage! > 0) {
      return widget.price * (1 - widget.discountPercentage! / 100);
    }
    return widget.price;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final cardBgColor = widget.cardColor ?? theme.cardColor;
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    final borderRadiusValue =
        widget.borderRadius ?? (isSmallScreen ? 12.0 : 16.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final imageHeight = cardWidth * (widget.aspectRatio ?? 0.75);
        final fontSize = isSmallScreen ? 14.0 : 16.0;
        final smallFontSize = isSmallScreen ? 10.0 : 11.0;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: widget.isAvailable ? _handleTap : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.06 * _elevationAnimation.value / 4,
                        ),
                        blurRadius: 16 * _elevationAnimation.value / 4,
                        offset: Offset(0, 4 * _elevationAnimation.value / 4),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.03 * _elevationAnimation.value / 4,
                        ),
                        blurRadius: 8 * _elevationAnimation.value / 4,
                        offset: Offset(0, 2 * _elevationAnimation.value / 4),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section
                      _buildImageSection(
                        imageHeight,
                        borderRadiusValue,
                        isSmallScreen,
                      ),
                      // Product details
                      Expanded(
                        child: _buildDetailsSection(
                          theme,
                          primaryColor,
                          fontSize,
                          smallFontSize,
                          isSmallScreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageSection(
    double imageHeight,
    double borderRadiusValue,
    bool isSmallScreen,
  ) {
    return SizedBox(
      height: imageHeight,
      child: Stack(
        children: [
          // Product image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusValue),
                topRight: Radius.circular(borderRadiusValue),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(),
                  // Overlay gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.03),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Out of stock overlay
                  if (!widget.isAvailable)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'OUT OF STOCK',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[600],
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Top badges and buttons
          Positioned(
            top: isSmallScreen ? 8 : 10,
            left: isSmallScreen ? 8 : 10,
            right: isSmallScreen ? 8 : 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Discount badge
                if (widget.discountPercentage != null &&
                    widget.discountPercentage! > 0)
                  _buildDiscountBadge(isSmallScreen),
                const Spacer(),
                // Favorite button
                _buildFavoriteButton(isSmallScreen),
              ],
            ),
          ),
          // Stock indicator
          if (widget.showStock &&
              widget.stockCount != null &&
              widget.isAvailable &&
              widget.stockCount! < 10)
            Positioned(
              bottom: isSmallScreen ? 8 : 10,
              left: isSmallScreen ? 8 : 10,
              child: _buildStockIndicator(isSmallScreen),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final isNetworkImage =
        widget.imageUrl.startsWith('http') ||
        widget.imageUrl.startsWith('https');

    return isNetworkImage
        ? Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildImagePlaceholder();
            },
            errorBuilder: (context, error, stackTrace) =>
                _buildImagePlaceholder(),
          )
        : Image.asset(
            widget.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildImagePlaceholder(),
          );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[100]!, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(Icons.image_outlined, color: Colors.grey[300], size: 48),
      ),
    );
  }

  Widget _buildDiscountBadge(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 10,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '-${widget.discountPercentage!.toInt()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallScreen ? 10 : 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(bool isSmallScreen) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(_isFavorite),
            color: _isFavorite ? Colors.red[400] : Colors.grey[600],
            size: isSmallScreen ? 18 : 20,
          ),
        ),
      ),
    );
  }

  Widget _buildStockIndicator(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.orange[700],
            size: isSmallScreen ? 12 : 14,
          ),
          SizedBox(width: isSmallScreen ? 3 : 4),
          Text(
            'Only ${widget.stockCount} left',
            style: TextStyle(
              fontSize: isSmallScreen ? 9 : 10,
              fontWeight: FontWeight.w600,
              color: Colors.orange[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(
    ThemeData theme,
    Color primaryColor,
    double fontSize,
    double smallFontSize,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category badge
                _buildCategoryBadge(smallFontSize),
                SizedBox(height: isSmallScreen ? 6 : 8),
                // Product name
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Short description
                if (widget.shortDescription != null) ...[
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  Text(
                    widget.shortDescription!,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                // Rating
                if (widget.rating != null) ...[
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  _buildRating(isSmallScreen),
                ],
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          // Price and cart button
          _buildPriceSection(theme, primaryColor, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        widget.categoryName.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildRating(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 5 : 6,
        vertical: isSmallScreen ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.amber[700],
            size: isSmallScreen ? 13 : 15,
          ),
          SizedBox(width: isSmallScreen ? 3 : 4),
          Text(
            widget.rating!.toStringAsFixed(1),
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: Colors.amber[900],
            ),
          ),
          if (widget.reviewCount != null) ...[
            SizedBox(width: isSmallScreen ? 2 : 3),
            Text(
              '(${widget.reviewCount})',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSection(
    ThemeData theme,
    Color primaryColor,
    bool isSmallScreen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Price
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.discountPercentage != null &&
                  widget.discountPercentage! > 0)
                Text(
                  '${widget.currency}${widget.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.grey[400],
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 2,
                  ),
                ),
              Text(
                '${widget.currency}${_discountedPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // Add to cart button
        if (widget.isAvailable)
          GestureDetector(
            onTap: widget.onAddToCart,
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: isSmallScreen ? 18 : 20,
              ),
            ),
          ),
      ],
    );
  }
}

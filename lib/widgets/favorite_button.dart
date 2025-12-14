import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../utils/snackbar_utils.dart';

class FavoriteButton extends StatefulWidget {
  final String productId;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.size = 24,
    this.activeColor = Colors.red,
    this.inactiveColor = const Color(0xFF64748B),
    this.backgroundColor = Colors.white,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoriteService _favoriteService = FavoriteService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _favoriteService.favoriteStream.listen((_) {
      if (mounted) {
        _checkFavoriteStatus();
      }
    });
  }

  void _checkFavoriteStatus() {
    final newStatus = _favoriteService.isFavorite(widget.productId);
    if (newStatus != _isFavorite) {
      setState(() {
        _isFavorite = newStatus;
      });
    }
  }

  void _toggleFavorite() {
    if (_isFavorite) {
      _favoriteService.removeFromFavorites(widget.productId);
      SnackbarUtils.showRemovedFromFavorites(context);
    } else {
      _favoriteService.addToFavorites(widget.productId);
      SnackbarUtils.showAddedToFavorites(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
          size: widget.size,
          color: _isFavorite ? widget.activeColor : widget.inactiveColor,
        ),
      ),
    );
  }
}

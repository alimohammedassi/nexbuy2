import 'dart:ui' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_navbar/liquid_navbar.dart';
import '../widgets/app_logo.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../services/firestore_product_service.dart';
import '../screens/profile_screen.dart';
import '../screens/laptop_details_screen.dart';
import '../services/gemini_service.dart';
import '../services/cart_service.dart';
import '../services/favorite_service.dart';
import '../localization/app_localizations.dart';
import 'category_screen.dart';
import 'favorites_screen.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import 'address_management_screen.dart';
import '../models/user.dart';
import '../screens/cart_screen.dart';
import '../screens/search_screen.dart';
import '../utils/snackbar_utils.dart';
import '../services/google_maps_service.dart';

class DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0;

    const double spacing = 20.0;

    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _tabIndex = 1; // 0 = Search, 1 = Home, 2 = Profile (default to Home)
  AnimationController? _animationController;
  final CartService _cartService = CartService();
  final FavoriteService _favoriteService = FavoriteService();
  int _cartItemCount = 0;
  int _favoriteCount = 0;
  List<Product> _apiProducts = [];
  bool _isLoadingProducts = false;
  bool _isSettingLocation = false;
  final FirestoreProductService _productService = FirestoreProductService();
  final PageController _heroPageController = PageController();
  int _heroPageIndex = 0;
  late final AnimationController _cartBumpController;
  late final Animation<double> _cartBump;
  final List<String> _heroImages = const [
    'images/iPhone_17_Pro_cosmic_orange_finish_partial_back_ex.jpg',
    'images/iPhone_Air_back_exterior_Space_Black_color_top_rou.jpg',
    'images/eg-jun25-laptop-acc-push.png',
  ];
  final List<String> _heroTitles = const [
    'PRO PERFORMANCE',
    'AIR. LIGHT. FAST.',
    'POWERFUL SETUPS',
  ];
  final List<String> _heroSubtitles = const [
    'Next‑gen speed for creators and gamers',
    'Ultra‑thin design with all‑day battery life',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _cartBumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _cartBump = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_cartBumpController);

    // Initialize ProductProvider with database data
    ProductProvider.initialize().then((_) {
      if (mounted) {
        setState(() {
          // Trigger rebuild to show fetched products
        });
      }
    });

    // Initialize Gemini service
    GeminiService.initialize();

    // Listen to cart changes
    _cartService.cartStream.listen((cartItems) {
      if (mounted) {
        setState(() {
          _cartItemCount = _cartService.itemCount;
        });
      }
    });

    // Listen to favorite changes
    _favoriteService.favoriteStream.listen((favoriteIds) {
      if (mounted) {
        setState(() {
          _favoriteCount = _favoriteService.favoriteCount;
        });
      }
    });

    // Initialize cart count
    _cartItemCount = _cartService.itemCount;
    _favoriteCount = _favoriteService.favoriteCount;

    // Fetch products from Supabase
    _fetchProductsFromSupabase();

    // Listen to real-time product updates
    _listenToProductUpdates();

    // Load user data from Supabase
    _loadUserData();

    // Listen to user updates safely
    UserService().addListener(_onUserUpdate);
  }

  void _onUserUpdate() {
    if (!mounted) return;
    // Schedule the update to the next frame to avoid "setState during build" errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final userService = UserService();

    if (authService.isLoggedIn && authService.currentUser != null) {
      await userService.setCurrentUserFromSupabase(authService.currentUser!);
      if (mounted) {
        setState(() {}); // Refresh UI to show user name
      }
    }
  }

  Future<void> _setLocationFromGps() async {
    if (_isSettingLocation) return;
    final authService = AuthService();
    final userService = UserService();

    if (!authService.isLoggedIn || authService.currentUser == null) {
      SnackbarUtils.showError(
        context,
        title: 'Login required',
        message: 'Please log in to set your location.',
      );
      return;
    }

    setState(() => _isSettingLocation = true);
    try {
      final position = await GoogleMapsService.getCurrentLocation();
      if (position == null) {
        SnackbarUtils.showError(
          context,
          title: 'Location unavailable',
          message: 'Location permission denied or unavailable.',
        );
        return;
      }

      final latLng = GoogleMapsService.positionToLatLng(position);
      final addressText =
          await GoogleMapsService.getAddressFromCoordinates(latLng) ??
          'Current location (${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)})';

      final address = Address(
        id: '',
        title: 'Current location',
        fullAddress: addressText,
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        city: 'Unknown',
        state: 'Unknown',
        zipCode: '00000',
        country: 'Egypt',
        isDefault: true,
      );

      final saved = await userService.addAddress(address);
      if (!saved) {
        SnackbarUtils.showError(
          context,
          title: 'Could not save address',
          message: 'Please try again.',
        );
        return;
      }

      await userService.setCurrentUserFromSupabase(authService.currentUser!);
      if (mounted) {
        setState(() {});
      }
      SnackbarUtils.showSuccess(
        context,
        title: 'Location saved',
        message: 'Your address was added as default.',
      );
    } catch (e) {
      SnackbarUtils.showError(
        context,
        title: 'Error',
        message: 'Something went wrong while saving location.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSettingLocation = false);
      }
    }
  }

  void _showLocationSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text('Use current location'),
                onTap: () async {
                  Navigator.pop(context);
                  await _setLocationFromGps();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Manage addresses'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddressManagementScreen(),
                    ),
                  ).then((_) {
                    if (mounted) setState(() {});
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _listenToProductUpdates() {
    _productService.getProductsStream().listen((products) {
      if (mounted) {
        setState(() {
          _apiProducts = products;
        });
      }
    });
  }

  Future<void> _fetchProductsFromSupabase() async {
    if (!mounted) return;
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final products = await _productService.getAllProducts();

      print('✅ Supabase Success: Fetched ${products.length} products');
      for (var product in products) {
        print('📱 Product: ${product.name} - ${product.price}');
      }

      if (mounted) {
        setState(() {
          _apiProducts = products;
        });
      }
    } catch (e) {
      print('❌ Error fetching products from Supabase: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _cartBumpController.dispose();
    _heroPageController.dispose();
    UserService().removeListener(_onUserUpdate);
    super.dispose();
  }

  void _confirmAddedToCart() {
    _cartBumpController
        .forward(from: 0)
        .then((_) => _cartBumpController.reverse());
    if (!mounted) return;
    SnackbarUtils.showAddedToCart(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF2F4F7)),
      child: BottomNavScaffold(
        // Pages to show
        pages: [
          const SearchScreen(),
          _buildHomeTabContent(),
          ProfileScreen(
            onProfileUpdated: () {
              setState(() {});
            },
          ),
        ],

        // Navbar icons (must be List<Widget>)
        icons: const [
          Icon(Icons.search_rounded),
          Icon(Icons.home_filled),
          Icon(Icons.person_2_rounded),
        ],

        // Labels
        labels: [
          'Search',
          AppLocalizations.of(context).home,
          AppLocalizations.of(context).profile,
        ],

        // Customization
        navbarHeight: 70,
        indicatorWidth: 70,
        bottomPadding: 16,
        selectedColor: const Color(0xFF2563EB),
        unselectedColor: const Color.fromARGB(255, 0, 0, 0),
        horizontalPadding: 16,
      ),
    );
  }

  // BACKUP: Old Glassmorphic Tab Bar (kept for reference)
  // To restore the old navigation bar, uncomment the code below and replace _buildCurvedNavigationBar

  Widget _buildGlassmorphicTabBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.25),
                const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGlassTabItem(
                  icon: Icons.home_rounded,
                  label: AppLocalizations.of(context).home,
                  index: 0,
                  isSelected: _tabIndex == 0,
                ),

                _buildGlassTabItem(
                  icon: Icons.person_rounded,
                  label: AppLocalizations.of(context).profile,
                  index: 2,
                  isSelected: _tabIndex == 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTabItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _tabIndex = index);
          _animationController?.forward(from: 0);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2563EB).withValues(alpha: 0.8),
                      const Color(0xFF1D4ED8).withValues(alpha: 0.9),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[700],
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTabContent() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _fetchProductsFromSupabase,
        color: const Color(0xFF2563EB),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildPromoBanner(),
              const SizedBox(height: 17),
              _buildServiceCategories(),
              const SizedBox(height: 24),
              _buildPopularSection(),
              const SizedBox(height: 24),
              _buildPhonesSection(),
              const SizedBox(height: 28),
              const SizedBox(height: 100), // Space for tab bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Get user from UserService (already loaded in initState)
    final userService = UserService();

    final user = userService.currentUser;
    final String greetingName = user?.name.isNotEmpty == true
        ? user!.name
        : 'Guest';

    Address? defaultAddress;
    if (user != null && user.addresses.isNotEmpty) {
      try {
        defaultAddress = user.addresses.firstWhere((a) => a.isDefault);
      } catch (_) {
        defaultAddress = user.addresses.first;
      }
    }

    final String locationLabel = defaultAddress != null
        ? (defaultAddress.fullAddress.isNotEmpty
              ? defaultAddress.fullAddress
              : (defaultAddress.city.isNotEmpty
                    ? defaultAddress.city
                    : defaultAddress.title))
        : AppLocalizations.of(context).setLocation;

    String _greeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return AppLocalizations.of(context).goodMorning;
      if (hour < 17) return AppLocalizations.of(context).goodAfternoon;
      return AppLocalizations.of(context).goodEvening;
    }

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      margin: EdgeInsets.only(
        left: isArabic ? 0 : 0,
        top: 16,
        right: isArabic ? 0 : 0,
        bottom: 0,
      ),
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.7),
            const Color(0xFF667EEA).withOpacity(0.15),
            Colors.white.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 45,
            offset: const Offset(0, 28),
            spreadRadius: -12,
          ),
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.22),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 18,
            offset: const Offset(-6, -6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Glossy effect overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),

                // Floating orbs for glassy effect
                Positioned(
                  top: -50,
                  right: 20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF667EEA).withOpacity(0.2),
                          const Color(0xFF667EEA).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color.fromARGB(
                            255,
                            18,
                            63,
                            211,
                          ).withOpacity(0.15),
                          const Color.fromARGB(
                            255,
                            18,
                            63,
                            211,
                          ).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Profile & Action Icons
                      Row(
                        children: [
                          // Profile Avatar with Glass Effect
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF667EEA).withOpacity(0.6),
                                  const Color.fromARGB(
                                    255,
                                    18,
                                    63,
                                    211,
                                  ).withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF667EEA,
                                  ).withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.9),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: ClipOval(
                                child: (user?.profileImage?.isNotEmpty ?? false)
                                    ? Image.network(
                                        user!.profileImage!,
                                        fit: BoxFit.cover,
                                        width: 56,
                                        height: 56,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.blue.shade100,
                                                      Colors.purple.shade100,
                                                    ],
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.person_outline_rounded,
                                                  color: Colors.grey.shade600,
                                                  size: 30,
                                                ),
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        'images/profile_avatar.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.blue.shade100,
                                                      Colors.purple.shade100,
                                                    ],
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  color: Colors.grey.shade600,
                                                  size: 30,
                                                ),
                                              );
                                            },
                                      ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Action Icons with Glass Effect
                          Row(
                            children: [
                              _buildGlassIcon(
                                icon: Icons.notifications_outlined,
                                onTap: () {},
                              ),
                              const SizedBox(width: 10),

                              // Favorite Icon with Badge
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _buildGlassIcon(
                                    icon: Icons.favorite_outline,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FavoritesScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  if (_favoriteCount > 0)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFEF4444),
                                              Color(0xFFDC2626),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFEF4444,
                                              ).withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _favoriteCount > 99
                                                ? '99+'
                                                : '$_favoriteCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 10),

                              // Cart Icon with Badge
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ScaleTransition(
                                    scale: _cartBump,
                                    child: _buildGlassIcon(
                                      icon: Icons.shopping_bag_outlined,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (_cartItemCount > 0)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 36, 111, 216),
                                              Color.fromARGB(255, 18, 63, 211),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                255,
                                                36,
                                                111,
                                                216,
                                              ).withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _cartItemCount > 99
                                                ? '99+'
                                                : '$_cartItemCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        'Hi, $greetingName',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Welcome Message
                      Text(
                        _greeting(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),

                      const Spacer(),

                      // Smaller Location Button with Glass Effect
                      GestureDetector(
                        onTap: _showLocationSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.8),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF667EEA,
                                ).withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isSettingLocation
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF667EEA),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF667EEA),
                                            Color.fromARGB(255, 18, 63, 211),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        locationLabel,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: Color(0xFF667EEA),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Glass Icon Widget
  Widget _buildGlassIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF667EEA)),
      ),
    );
  }
  // Enhanced Action Icon Widget (assuming this exists in your code)

  // removed unused _buildCartButton

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _heroPageController,
        onPageChanged: (i) => setState(() => _heroPageIndex = i),
        itemCount: _heroImages.length,
        itemBuilder: (context, index) {
          final img = _heroImages[index];
          return AnimatedBuilder(
            animation: _heroPageController,
            builder: (context, child) {
              double value = 1.0;
              if (_heroPageController.position.haveDimensions) {
                value = (_heroPageController.page ?? 0) - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) * 200,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Image.asset(
                      img,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient Overlay with enhanced colors
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2563EB).withOpacity(0.4),
                            const Color(0xFF1D4ED8).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  AppLocalizations.of(context).fastDeals,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title
                          Text(
                            _heroTitles[index % _heroTitles.length],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Subtitle
                          Text(
                            _heroSubtitles[index % _heroSubtitles.length],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              shadows: const [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),

                          // CTA Button
                        ],
                      ),
                    ),
                    // Page Indicator Overlay
                    Positioned(
                      bottom: 10,
                      left: 150,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_heroImages.length, (i) {
                          final active = i == _heroPageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: active
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCategories() {
    final categories = CategoryProvider.getFeaturedCategories();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).categories,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.8,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${categories.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 180, // Increased from 160 to 180 to accommodate Arabic text
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final c = categories[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 100)),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value.clamp(0.0, 1.0),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(categoryName: c.name),
                      ),
                    );
                  },
                  child: Container(
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Add this to prevent overflow
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 14), // Reduced from 16 to 14
                        Stack(
                          children: [
                            const PulsingCircle(),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF2563EB,
                                  ).withOpacity(0.2),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2563EB,
                                    ).withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  c.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF2563EB),
                                            Color(0xFF3B82F6),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.category_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Reduced from 12 to 10
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            AppLocalizations.of(context).getCategoryName(c.id),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize:
                                  12, // Reduced from 13 to 12 for better fit
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                              letterSpacing: -0.3,
                              height: 1.15, // Reduced from 1.2 to 1.15
                            ),
                          ),
                        ),
                        const SizedBox(height: 6), // Reduced from 8 to 6
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Explore',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                size: 12,
                                color: Color(0xFF2563EB),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // Reduced from 12 to 10
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    final items = _apiProducts.isNotEmpty
        ? _apiProducts
        : ProductProvider.featuredLaptops;

    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final cardWidth =
        (screenWidth - 32 - (12 * (crossAxisCount - 1))) / crossAxisCount;
    final cardHeight = cardWidth * 1.45; // Adjust ratio for better proportions

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).popularProducts,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.8,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${items.length > 8 ? 8 : items.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemCount: items.length > 8 ? 8 : items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            final heroTag = 'popular_product_${product.id}_$index';
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200 + (index * 50)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LaptopDetailsScreen(
                        laptopId: product.id,
                        product: product,
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section with fixed height
                      Stack(
                        children: [
                          Container(
                            height: cardHeight * 0.45, // 45% of card height
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFF8FAFC),
                                  const Color(0xFFEFF6FF),
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Hero(
                                tag: heroTag,
                                child: product.imagePath.startsWith('http')
                                    ? Image.network(
                                        product.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(
                                                        0xFF2563EB,
                                                      ).withOpacity(0.1),
                                                      const Color(
                                                        0xFF3B82F6,
                                                      ).withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.laptop_mac,
                                                  color: Color(0xFF2563EB),
                                                  size: 40,
                                                ),
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        product.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(
                                                        0xFF2563EB,
                                                      ).withOpacity(0.1),
                                                      const Color(
                                                        0xFF3B82F6,
                                                      ).withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.laptop_mac,
                                                  color: Color(0xFF2563EB),
                                                  size: 40,
                                                ),
                                              );
                                            },
                                      ),
                              ),
                            ),
                          ),
                          // Delivery badge
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_shipping,
                                    size: 12,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Fast',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Favorite button
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Content section with flexible height
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name - Fixed 2 lines
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                  height: 1.3,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Brand and rating row
                              Row(
                                children: [
                                  if (product.brand.isNotEmpty) ...[
                                    Flexible(
                                      child: Text(
                                        product.brand,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFF59E0B),
                                          size: 12,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          product.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFB45309),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Specs - only if space available
                              if (product.specifications.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _buildCompactSpecRow(product.specifications),
                              ],
                              const Spacer(),
                              // Price and add to cart
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Color(0xFF2563EB),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _cartService.addToCart(
                                        productId: product.id,
                                        productName: product.name,
                                        productImage: product.imagePath,
                                        price: product.price,
                                      );
                                      _confirmAddedToCart();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2563EB),
                                            Color(0xFF3B82F6),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF2563EB,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Compact spec row to prevent overflow
  Widget _buildCompactSpecRow(Map<String, String> specs) {
    if (specs.isEmpty) return const SizedBox.shrink();

    final firstSpec = specs.entries.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${firstSpec.key}: ${firstSpec.value}',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2563EB),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSpecRow(Map<String, String> specs) {
    // Priority order: RAM, Storage, Screen Size, Processor
    final priorityKeys = [
      'RAM',
      'ram',
      'memory',
      'Storage',
      'storage',
      'Screen',
      'screen',
      'Processor',
      'processor',
      'CPU',
      'cpu',
    ];
    String? firstSpec;
    String? secondSpec;

    // Find first two available specs
    for (final key in priorityKeys) {
      if (specs.containsKey(key) && specs[key]!.isNotEmpty) {
        if (firstSpec == null) {
          firstSpec = specs[key];
        } else if (secondSpec == null) {
          secondSpec = specs[key];
          break;
        }
      }
    }

    // If no priority keys found, take first two from map
    if (firstSpec == null && specs.isNotEmpty) {
      final firstEntry = specs.entries.first;
      firstSpec = firstEntry.value;
    }
    if (secondSpec == null && specs.length > 1) {
      final secondEntry = specs.entries.elementAt(1);
      secondSpec = secondEntry.value;
    }

    final availableSpecs = <String>[];
    if (firstSpec != null) availableSpecs.add(firstSpec);
    if (secondSpec != null) availableSpecs.add(secondSpec);

    if (availableSpecs.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: availableSpecs
          .take(2)
          .map((spec) => _buildSpecChip(spec))
          .toList(),
    );
  }

  Widget _buildPhonesSection() {
    final phones = ProductProvider.featuredPhones;

    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final cardWidth =
        (screenWidth - 32 - (12 * (crossAxisCount - 1))) / crossAxisCount;
    final cardHeight = cardWidth * 1.45; // Adjust ratio for better proportions

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).smartphones,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.8,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${phones.length > 8 ? 8 : phones.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemCount: phones.length > 8 ? 8 : phones.length,
          itemBuilder: (context, index) {
            final product = phones[index];
            final heroTag = 'featured_product_${product.id}_$index';
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200 + (index * 50)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LaptopDetailsScreen(
                        laptopId: product.id,
                        product: product,
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section with fixed height
                      Stack(
                        children: [
                          Container(
                            height: cardHeight * 0.45, // 45% of card height
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFF8FAFC),
                                  const Color(0xFFEFF6FF),
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Hero(
                                tag: heroTag,
                                child: product.imagePath.startsWith('http')
                                    ? Image.network(
                                        product.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(
                                                        0xFF2563EB,
                                                      ).withOpacity(0.1),
                                                      const Color(
                                                        0xFF3B82F6,
                                                      ).withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.phone_android,
                                                  color: Color(0xFF2563EB),
                                                  size: 40,
                                                ),
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        product.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(
                                                        0xFF2563EB,
                                                      ).withOpacity(0.1),
                                                      const Color(
                                                        0xFF3B82F6,
                                                      ).withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.phone_android,
                                                  color: Color(0xFF2563EB),
                                                  size: 40,
                                                ),
                                              );
                                            },
                                      ),
                              ),
                            ),
                          ),
                          // Delivery badge
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_shipping,
                                    size: 12,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Fast',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Favorite button
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Content section with flexible height
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name - Fixed 2 lines
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                  height: 1.3,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Brand and rating row
                              Row(
                                children: [
                                  if (product.brand.isNotEmpty) ...[
                                    Flexible(
                                      child: Text(
                                        product.brand,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFF59E0B),
                                          size: 12,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          product.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFB45309),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Specs - only if space available
                              if (product.specifications.isNotEmpty) ...[
                                const SizedBox(height: 1),
                                _buildCompactSpecRow(product.specifications),
                              ],
                              const Spacer(),
                              // Price and add to cart
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Color(0xFF2563EB),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _cartService.addToCart(
                                        productId: product.id,
                                        productName: product.name,
                                        productImage: product.imagePath,
                                        price: product.price,
                                      );
                                      _confirmAddedToCart();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2563EB),
                                            Color(0xFF3B82F6),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF2563EB,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpecChip(String spec) {
    if (spec.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Text(
        spec,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Color(0xFF2563EB),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context).searchLaptopsPhones,
                style: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF2563EB),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final featuredLaptops = ProductProvider.featuredLaptops;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).featuredProducts,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context).seeAll,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredLaptops.length,
            itemBuilder: (context, index) {
              final laptop = featuredLaptops[index];
              return _buildLaptopCard(laptop);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLaptopCard(Product laptop) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaptopDetailsScreen(laptopId: laptop.id),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Laptop Image
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Laptop image
                  Center(
                    child: Container(
                      width: 110,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          laptop.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child: const Icon(
                                Icons.laptop_mac_rounded,
                                size: 40,
                                color: Color(0xFF2563EB),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: StreamBuilder<Set<String>>(
                      stream: _favoriteService.favoriteStream,
                      initialData: _favoriteService.favoriteIds,
                      builder: (context, snapshot) {
                        final isFavorite = _favoriteService.isFavorite(
                          laptop.id,
                        );
                        return GestureDetector(
                          onTap: () {
                            _favoriteService.toggleFavorite(laptop.id);
                            if (isFavorite) {
                              SnackbarUtils.showRemovedFromFavorites(context);
                            } else {
                              SnackbarUtils.showAddedToFavorites(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey[400],
                              size: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Laptop Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          laptop.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          laptop.brand,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFF2563EB),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              laptop.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${laptop.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _cartService.addToCart(
                              productId: laptop.id,
                              productName: laptop.name,
                              productImage: laptop.imagePath,
                              price: laptop.price,
                            );
                            _confirmAddedToCart();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const AppLogoLarge(useAnimatedLogo: true),
            const SizedBox(height: 20),
            const Text(
              'Settings Tab',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'This is the Settings tab with modern glassmorphic design.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showVerifiedIcon(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'images/Verified icon.gif',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.check_circle,
                      color: Color(0xFF2563EB),
                      size: 60,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    // Auto-dismiss after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF1F2937), size: 22),
        ),
      ),
    );
  }
}

class PulsingCircle extends StatefulWidget {
  const PulsingCircle({super.key});

  @override
  State<PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(
                  0xFF2563EB,
                ).withOpacity(0.1 + (_animation.value * 0.05)),
                const Color(
                  0xFF3B82F6,
                ).withOpacity(0.05 + (_animation.value * 0.03)),
              ],
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

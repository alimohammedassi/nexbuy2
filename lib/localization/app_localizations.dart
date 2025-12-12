import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // English and Arabic translations
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'NexBuy',
      'welcome': 'Welcome',
      'get_started': 'Get Started',
      'to_continue': 'to continue your journey',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'remember_me': 'Remember me',
      'dont_have_account': 'Don\'t have an account?',
      'already_have_account': 'Already have an account?',
      'create_account': 'Create Account',
      'sign_in': 'Sign In',
      'continue_with_google': 'Continue with Google',
      'continue_with_apple': 'Continue with Apple',
      'terms_and_conditions': 'Terms of Service',
      'privacy_policy': 'Privacy Policy',
      'agree_to_terms': 'I agree to the',
      'and': 'and',
      'enter_email': 'Please enter your email',
      'enter_valid_email': 'Please enter a valid email address',
      'enter_password': 'Please enter a password',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_dont_match': 'Passwords do not match',
      'enter_full_name': 'Please enter your full name',
      'agree_terms': 'Please agree to the terms and conditions',
      'account_created': 'Account created successfully!',
      'login_successful': 'Login successful!',
      'google_signin_demo': 'Google Sign-In not available in demo mode',
      'or': 'OR',
      'choose_language': 'Choose your preferred language',
      'english': 'English',
      'arabic': 'العربية',
      'new_text': 'NEW',
      'recent_orders': 'Recent Laptop Orders',
      'ai_chat': 'AI Chat',
      'home': 'Home',
      'profile': 'Profile',
      'featured_products': 'Featured Products',
      'categories': 'Categories',
      'premium': 'Premium',
      'points': 'Points',
      'orders': 'Orders',
      'rating': 'Rating',
      'edit_profile': 'Edit Profile',
      'addresses': 'Addresses',
      'cart': 'Cart',
      'settings': 'Settings',
      'location_not_available': 'Location not available',
      'saved_addresses': 'Saved Addresses',
      'add_address': 'Add Address',
      'default_text': 'Default',
      'edit': 'Edit',
      'set_as_default': 'Set as Default',
      'delete': 'Delete',
      'add_address_dialog': 'Add a new address to your account',
      'cancel': 'Cancel',
      'add': 'Add',
      'address_name': 'Address Name',
      'address': 'Address',
      'fill_all_fields': 'Please fill all fields',
      'save': 'Save',
      'using_current_location': 'Using current location',
      'enter_address_name': 'Please enter address name',
      'forgot_password': 'Forgot Password',
      'forgot_password_description':
          'Enter your email address and we\'ll send you a link to reset your password.',
      'reset_password': 'Reset Password',
      'remember_password': 'Remember your password?',
      'back_to_login': 'Back to Login',
      'reset_password_sent': 'Password reset link sent to your email!',
      'promoTitle': 'Special Promo',
      'promoSubtitle': 'Get the best deals!',
      'shopNow': 'Shop Now',
      'searchHint': 'Search for products...',
      'shopping_cart': 'Shopping Cart',
      'clear': 'Clear',
      'your_cart_is_empty': 'Your Cart is Empty',
      'start_adding_items':
          'Start adding items to your cart\nand make them yours',
      'start_shopping': 'Start Shopping',
      'item': 'item',
      'items': 'items',
      'proceed_to_checkout': 'Proceed to Checkout',
      'slide_to_checkout': 'Slide to Checkout',
      'subtotal': 'Subtotal',
      'shipping': 'Shipping',
      'tax': 'Tax',
      'tax_percent': 'Tax (8%)',
      'total': 'Total',
      'free': 'Free',
      'popular_products': 'Popular Products',
      'smartphones': 'Smartphones',
      'see_all': 'See All',
      'see_more': 'See More',
      'good_morning': 'Good morning',
      'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening',
      'set_location': 'Set location',
      'added_to_cart': 'Added to cart',
      'view_cart': 'View Cart',
      'delivery_time': '30 min',
      'fast_deals': 'Fast deals, quicker delivery.',
      'search_laptops_phones': 'Search laptops, phones...',
      'laptop_not_found': 'Laptop Not Found',
      'laptop_not_found_desc': 'Laptop not found',
      'in_stock': 'In Stock',
      'quick_actions': 'Quick Actions',
      'recent_orders_section': 'Recent Orders',
      'view_all': 'View All',
      'order_number': 'Order #',
      'order_history': 'Order History',
      'notifications': 'Notifications',
      'manage_preferences': 'Manage your preferences',
      'privacy_security': 'Privacy & Security',
      'password_data_settings': 'Password and data settings',
      'payment_methods': 'Payment Methods',
      'manage_cards_wallets': 'Manage cards and wallets',
      'help_center': 'Help Center',
      'about': 'About',
      'version': 'Version 1.0.0',
      'sign_out': 'Sign Out',
      'logout_from_account': 'Logout from your account',
      'reward': 'Reward',
      'customer': 'Customer',
      'specifications': 'Specifications',
      'features': 'Features',
      'add_to_cart': 'Add to Cart',
      'price': 'Price',
      'description': 'Description',
      'ram': 'RAM',
      'storage': 'Storage',
      'screen': 'Screen',
      'processor': 'Processor',
      'cpu': 'CPU',
      'memory': 'Memory',
      'city': 'City',
      'street': 'Street',
      'building': 'Building',
      'apartment': 'Apartment',
      'postal_code': 'Postal Code',
      'country': 'Country',
      'current_location': 'Current Location',
      'use_current_location': 'Use Current Location',
      'enter_manually': 'Enter Manually',
      'payment': 'Payment',
      'card_number': 'Card Number',
      'card_holder_name': 'Card Holder Name',
      'expiry_date': 'Expiry Date',
      'pay_now': 'Pay Now',
      'order_summary': 'Order Summary',
      'category_laptops': 'Laptops',
      'category_phones': 'Phones',
      'category_macbooks': 'MacBooks',
      'category_desktops': 'Desktops',
      'category_accessories': 'Accessories',
      'category_monitors': 'Monitors',
      'upgrade_your': 'Upgrade Your',
      'tech': 'Tech',
      'life': 'Life',
      'splash_subtitle':
          'Discover curated collections and timeless pieces\ncrafted exclusively for you.',
      'swipe_to_continue': 'Swipe to continue',
    },
    'ar': {
      'app_name': 'نيكس باي',
      'welcome': 'مرحباً',
      'get_started': 'ابدأ الآن',
      'to_continue': 'لمتابعة رحلتك',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'remember_me': 'تذكرني',
      'dont_have_account': 'ليس لديك حساب؟',
      'already_have_account': 'لديك حساب بالفعل؟',
      'create_account': 'إنشاء حساب',
      'sign_in': 'تسجيل الدخول',
      'continue_with_google': 'المتابعة مع جوجل',
      'continue_with_apple': 'المتابعة مع آبل',
      'terms_and_conditions': 'شروط الخدمة',
      'privacy_policy': 'سياسة الخصوصية',
      'agree_to_terms': 'أوافق على',
      'and': 'و',
      'enter_email': 'يرجى إدخال بريدك الإلكتروني',
      'enter_valid_email': 'يرجى إدخال عنوان بريد إلكتروني صحيح',
      'enter_password': 'يرجى إدخال كلمة المرور',
      'password_too_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'passwords_dont_match': 'كلمات المرور غير متطابقة',
      'enter_full_name': 'يرجى إدخال اسمك الكامل',
      'agree_terms': 'يرجى الموافقة على الشروط والأحكام',
      'account_created': 'تم إنشاء الحساب بنجاح!',
      'login_successful': 'تم تسجيل الدخول بنجاح!',
      'google_signin_demo': 'تسجيل الدخول مع جوجل غير متاح في الوضع التجريبي',
      'or': 'أو',
      'choose_language': 'اختر لغتك المفضلة',
      'english': 'English',
      'arabic': 'العربية',
      'new_text': 'جديد',
      'recent_orders': 'طلبات اللابتوب الأخيرة',
      'ai_chat': 'الدردشة الذكية',
      'home': 'الرئيسية',
      'profile': 'الملف الشخصي',
      'featured_products': 'المنتجات المميزة',
      'categories': 'الفئات',
      'premium': 'مميز',
      'points': 'النقاط',
      'orders': 'الطلبات',
      'rating': 'التقييم',
      'edit_profile': 'تعديل الملف الشخصي',
      'addresses': 'العناوين',
      'cart': 'السلة',
      'settings': 'الإعدادات',
      'location_not_available': 'الموقع غير متاح',
      'saved_addresses': 'العناوين المحفوظة',
      'add_address': 'إضافة عنوان',
      'default_text': 'افتراضي',
      'edit': 'تعديل',
      'set_as_default': 'تعيين كافتراضي',
      'delete': 'حذف',
      'add_address_dialog': 'إضافة عنوان جديد إلى حسابك',
      'cancel': 'إلغاء',
      'add': 'إضافة',
      'address_name': 'اسم العنوان',
      'address': 'العنوان',
      'fill_all_fields': 'يرجى ملء جميع الحقول',
      'save': 'حفظ',
      'using_current_location': 'استخدام الموقع الحالي',
      'enter_address_name': 'يرجى إدخال اسم العنوان',
      'forgot_password': 'نسيت كلمة المرور',
      'forgot_password_description':
          'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'remember_password': 'تتذكر كلمة المرور؟',
      'back_to_login': 'العودة لتسجيل الدخول',
      'reset_password_sent':
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني!',
      'promoTitle': 'عرض خاص',
      'promoSubtitle': 'احصل على أفضل العروض!',
      'shopNow': 'تسوق الآن',
      'searchHint': 'ابحث عن منتجات...',
      'shopping_cart': 'سلة التسوق',
      'clear': 'مسح',
      'your_cart_is_empty': 'سلة التسوق فارغة',
      'start_adding_items': 'ابدأ بإضافة المنتجات إلى السلة\nواجعلها ملكك',
      'start_shopping': 'ابدأ التسوق',
      'item': 'عنصر',
      'items': 'عناصر',
      'proceed_to_checkout': 'المتابعة للدفع',
      'slide_to_checkout': 'اسحب للدفع',
      'subtotal': 'المجموع الفرعي',
      'shipping': 'الشحن',
      'tax': 'الضريبة',
      'tax_percent': 'الضريبة (8%)',
      'total': 'المجموع',
      'free': 'مجاني',
      'popular_products': 'المنتجات الشائعة',
      'smartphones': 'الهواتف الذكية',
      'see_all': 'عرض الكل',
      'see_more': 'عرض المزيد',
      'good_morning': 'صباح الخير',
      'good_afternoon': 'مساء الخير',
      'good_evening': 'مساء الخير',
      'set_location': 'تعيين الموقع',
      'added_to_cart': 'تمت الإضافة للسلة',
      'view_cart': 'عرض السلة',
      'delivery_time': '30 دقيقة',
      'fast_deals': 'صفقات سريعة، توصيل أسرع.',
      'search_laptops_phones': 'ابحث عن أجهزة كمبيوتر، هواتف...',
      'laptop_not_found': 'الجهاز غير موجود',
      'laptop_not_found_desc': 'الجهاز غير موجود',
      'in_stock': 'متوفر',
      'quick_actions': 'الإجراءات السريعة',
      'recent_orders_section': 'الطلبات الأخيرة',
      'view_all': 'عرض الكل',
      'order_number': 'طلب #',
      'order_history': 'سجل الطلبات',
      'notifications': 'الإشعارات',
      'manage_preferences': 'إدارة تفضيلاتك',
      'privacy_security': 'الخصوصية والأمان',
      'password_data_settings': 'إعدادات كلمة المرور والبيانات',
      'payment_methods': 'طرق الدفع',
      'manage_cards_wallets': 'إدارة البطاقات والمحافظ',
      'help_center': 'مركز المساعدة',
      'about': 'حول',
      'version': 'الإصدار 1.0.0',
      'sign_out': 'تسجيل الخروج',
      'logout_from_account': 'تسجيل الخروج من حسابك',
      'reward': 'مكافأة',
      'customer': 'عميل',
      'specifications': 'المواصفات',
      'features': 'المميزات',
      'add_to_cart': 'أضف إلى السلة',
      'price': 'السعر',
      'description': 'الوصف',
      'ram': 'الذاكرة العشوائية',
      'storage': 'التخزين',
      'screen': 'الشاشة',
      'processor': 'المعالج',
      'cpu': 'المعالج',
      'memory': 'الذاكرة',
      'city': 'المدينة',
      'street': 'الشارع',
      'building': 'المبنى',
      'apartment': 'الشقة',
      'postal_code': 'الرمز البريدي',
      'country': 'البلد',
      'current_location': 'الموقع الحالي',
      'use_current_location': 'استخدام الموقع الحالي',
      'enter_manually': 'إدخال يدوي',
      'payment': 'الدفع',
      'card_number': 'رقم البطاقة',
      'card_holder_name': 'اسم صاحب البطاقة',
      'expiry_date': 'تاريخ انتهاء الصلاحية',
      'pay_now': 'ادفع الآن',
      'order_summary': 'ملخص الطلب',
      'category_laptops': 'أجهزة الكمبيوتر المحمولة',
      'category_phones': 'الهواتف',
      'category_macbooks': 'ماك بوك',
      'category_desktops': 'أجهزة الكمبيوتر المكتبية',
      'category_accessories': 'الملحقات',
      'category_monitors': 'الشاشات',
      'upgrade_your': 'طور',
      'tech': 'تقنيتك',
      'life': 'حياتك',
      'splash_subtitle':
          'اكتشف مجموعات مختارة بعناية وقطع خالدة\nمصممة حصرياً لك.',
      'swipe_to_continue': 'اسحب للمتابعة',
    },
  };

  String get appName =>
      _localizedValues[locale.languageCode]?['app_name'] ??
      _localizedValues['en']!['app_name']!;
  String get welcome =>
      _localizedValues[locale.languageCode]?['welcome'] ??
      _localizedValues['en']!['welcome']!;
  String get getStarted =>
      _localizedValues[locale.languageCode]?['get_started'] ??
      _localizedValues['en']!['get_started']!;
  String get toContinue =>
      _localizedValues[locale.languageCode]?['to_continue'] ??
      _localizedValues['en']!['to_continue']!;
  String get login =>
      _localizedValues[locale.languageCode]?['login'] ??
      _localizedValues['en']!['login']!;
  String get signup =>
      _localizedValues[locale.languageCode]?['signup'] ??
      _localizedValues['en']!['signup']!;
  String get email =>
      _localizedValues[locale.languageCode]?['email'] ??
      _localizedValues['en']!['email']!;
  String get password =>
      _localizedValues[locale.languageCode]?['password'] ??
      _localizedValues['en']!['password']!;
  String get confirmPassword =>
      _localizedValues[locale.languageCode]?['confirm_password'] ??
      _localizedValues['en']!['confirm_password']!;
  String get fullName =>
      _localizedValues[locale.languageCode]?['full_name'] ??
      _localizedValues['en']!['full_name']!;
  String get forgotPassword =>
      _localizedValues[locale.languageCode]?['forgot_password'] ??
      _localizedValues['en']!['forgot_password']!;
  String get rememberMe =>
      _localizedValues[locale.languageCode]?['remember_me'] ??
      _localizedValues['en']!['remember_me']!;
  String get dontHaveAccount =>
      _localizedValues[locale.languageCode]?['dont_have_account'] ??
      _localizedValues['en']!['dont_have_account']!;
  String get alreadyHaveAccount =>
      _localizedValues[locale.languageCode]?['already_have_account'] ??
      _localizedValues['en']!['already_have_account']!;
  String get createAccount =>
      _localizedValues[locale.languageCode]?['create_account'] ??
      _localizedValues['en']!['create_account']!;
  String get signIn =>
      _localizedValues[locale.languageCode]?['sign_in'] ??
      _localizedValues['en']!['sign_in']!;
  String get continueWithGoogle =>
      _localizedValues[locale.languageCode]?['continue_with_google'] ??
      _localizedValues['en']!['continue_with_google']!;
  String get continueWithApple =>
      _localizedValues[locale.languageCode]?['continue_with_apple'] ??
      _localizedValues['en']!['continue_with_apple']!;
  String get termsAndConditions =>
      _localizedValues[locale.languageCode]?['terms_and_conditions'] ??
      _localizedValues['en']!['terms_and_conditions']!;
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]?['privacy_policy'] ??
      _localizedValues['en']!['privacy_policy']!;
  String get agreeToTerms =>
      _localizedValues[locale.languageCode]?['agree_to_terms'] ??
      _localizedValues['en']!['agree_to_terms']!;
  String get and =>
      _localizedValues[locale.languageCode]?['and'] ??
      _localizedValues['en']!['and']!;
  String get enterEmail =>
      _localizedValues[locale.languageCode]?['enter_email'] ??
      _localizedValues['en']!['enter_email']!;
  String get enterValidEmail =>
      _localizedValues[locale.languageCode]?['enter_valid_email'] ??
      _localizedValues['en']!['enter_valid_email']!;
  String get enterPassword =>
      _localizedValues[locale.languageCode]?['enter_password'] ??
      _localizedValues['en']!['enter_password']!;
  String get passwordTooShort =>
      _localizedValues[locale.languageCode]?['password_too_short'] ??
      _localizedValues['en']!['password_too_short']!;
  String get passwordsDontMatch =>
      _localizedValues[locale.languageCode]?['passwords_dont_match'] ??
      _localizedValues['en']!['passwords_dont_match']!;
  String get enterFullName =>
      _localizedValues[locale.languageCode]?['enter_full_name'] ??
      _localizedValues['en']!['enter_full_name']!;
  String get agreeTerms =>
      _localizedValues[locale.languageCode]?['agree_terms'] ??
      _localizedValues['en']!['agree_terms']!;
  String get accountCreated =>
      _localizedValues[locale.languageCode]?['account_created'] ??
      _localizedValues['en']!['account_created']!;
  String get loginSuccessful =>
      _localizedValues[locale.languageCode]?['login_successful'] ??
      _localizedValues['en']!['login_successful']!;
  String get googleSigninDemo =>
      _localizedValues[locale.languageCode]?['google_signin_demo'] ??
      _localizedValues['en']!['google_signin_demo']!;
  String get or =>
      _localizedValues[locale.languageCode]?['or'] ??
      _localizedValues['en']!['or']!;
  String get chooseLanguage =>
      _localizedValues[locale.languageCode]?['choose_language'] ??
      _localizedValues['en']!['choose_language']!;
  String get english =>
      _localizedValues[locale.languageCode]?['english'] ??
      _localizedValues['en']!['english']!;
  String get arabic =>
      _localizedValues[locale.languageCode]?['arabic'] ??
      _localizedValues['en']!['arabic']!;
  String get newText =>
      _localizedValues[locale.languageCode]?['new_text'] ??
      _localizedValues['en']!['new_text']!;
  String get recentOrders =>
      _localizedValues[locale.languageCode]?['recent_orders'] ??
      _localizedValues['en']!['recent_orders']!;
  String get aiChat =>
      _localizedValues[locale.languageCode]?['ai_chat'] ??
      _localizedValues['en']!['ai_chat']!;
  String get home =>
      _localizedValues[locale.languageCode]?['home'] ??
      _localizedValues['en']!['home']!;
  String get profile =>
      _localizedValues[locale.languageCode]?['profile'] ??
      _localizedValues['en']!['profile']!;
  String get featuredProducts =>
      _localizedValues[locale.languageCode]?['featured_products'] ??
      _localizedValues['en']!['featured_products']!;
  String get categories =>
      _localizedValues[locale.languageCode]?['categories'] ??
      _localizedValues['en']!['categories']!;
  String get premium =>
      _localizedValues[locale.languageCode]?['premium'] ??
      _localizedValues['en']!['premium']!;
  String get points =>
      _localizedValues[locale.languageCode]?['points'] ??
      _localizedValues['en']!['points']!;
  String get orders =>
      _localizedValues[locale.languageCode]?['orders'] ??
      _localizedValues['en']!['orders']!;
  String get rating =>
      _localizedValues[locale.languageCode]?['rating'] ??
      _localizedValues['en']!['rating']!;
  String get editProfile =>
      _localizedValues[locale.languageCode]?['edit_profile'] ??
      _localizedValues['en']!['edit_profile']!;
  String get addresses =>
      _localizedValues[locale.languageCode]?['addresses'] ??
      _localizedValues['en']!['addresses']!;
  String get cart =>
      _localizedValues[locale.languageCode]?['cart'] ??
      _localizedValues['en']!['cart']!;
  String get settings =>
      _localizedValues[locale.languageCode]?['settings'] ??
      _localizedValues['en']!['settings']!;
  String get locationNotAvailable =>
      _localizedValues[locale.languageCode]?['location_not_available'] ??
      _localizedValues['en']!['location_not_available']!;
  String get savedAddresses =>
      _localizedValues[locale.languageCode]?['saved_addresses'] ??
      _localizedValues['en']!['saved_addresses']!;
  String get addAddress =>
      _localizedValues[locale.languageCode]?['add_address'] ??
      _localizedValues['en']!['add_address']!;
  String get defaultText =>
      _localizedValues[locale.languageCode]?['default_text'] ??
      _localizedValues['en']!['default_text']!;
  String get edit =>
      _localizedValues[locale.languageCode]?['edit'] ??
      _localizedValues['en']!['edit']!;
  String get setAsDefault =>
      _localizedValues[locale.languageCode]?['set_as_default'] ??
      _localizedValues['en']!['set_as_default']!;
  String get delete =>
      _localizedValues[locale.languageCode]?['delete'] ??
      _localizedValues['en']!['delete']!;
  String get addAddressDialog =>
      _localizedValues[locale.languageCode]?['add_address_dialog'] ??
      _localizedValues['en']!['add_address_dialog']!;
  String get cancel =>
      _localizedValues[locale.languageCode]?['cancel'] ??
      _localizedValues['en']!['cancel']!;
  String get add =>
      _localizedValues[locale.languageCode]?['add'] ??
      _localizedValues['en']!['add']!;
  String get addressName =>
      _localizedValues[locale.languageCode]?['address_name'] ??
      _localizedValues['en']!['address_name']!;
  String get address =>
      _localizedValues[locale.languageCode]?['address'] ??
      _localizedValues['en']!['address']!;
  String get fillAllFields =>
      _localizedValues[locale.languageCode]?['fill_all_fields'] ??
      _localizedValues['en']!['fill_all_fields']!;
  String get save =>
      _localizedValues[locale.languageCode]?['save'] ??
      _localizedValues['en']!['save']!;
  String get usingCurrentLocation =>
      _localizedValues[locale.languageCode]?['using_current_location'] ??
      _localizedValues['en']!['using_current_location']!;
  String get enterAddressName =>
      _localizedValues[locale.languageCode]?['enter_address_name'] ??
      _localizedValues['en']!['enter_address_name']!;
  String get forgotPasswordDescription =>
      _localizedValues[locale.languageCode]?['forgot_password_description'] ??
      _localizedValues['en']!['forgot_password_description']!;
  String get resetPassword =>
      _localizedValues[locale.languageCode]?['reset_password'] ??
      _localizedValues['en']!['reset_password']!;
  String get rememberPassword =>
      _localizedValues[locale.languageCode]?['remember_password'] ??
      _localizedValues['en']!['remember_password']!;
  String get backToLogin =>
      _localizedValues[locale.languageCode]?['back_to_login'] ??
      _localizedValues['en']!['back_to_login']!;
  String get resetPasswordSent =>
      _localizedValues[locale.languageCode]?['reset_password_sent'] ??
      _localizedValues['en']!['reset_password_sent']!;
  String get searchHint =>
      _localizedValues[locale.languageCode]?['searchHint'] ??
      _localizedValues['en']!['searchHint']!;
  String get promoTitle =>
      _localizedValues[locale.languageCode]?['promoTitle'] ??
      _localizedValues['en']!['promoTitle']!;
  String get promoSubtitle =>
      _localizedValues[locale.languageCode]?['promoSubtitle'] ??
      _localizedValues['en']!['promoSubtitle']!;
  String get shopNow =>
      _localizedValues[locale.languageCode]?['shopNow'] ??
      _localizedValues['en']!['shopNow']!;
  String get shoppingCart =>
      _localizedValues[locale.languageCode]?['shopping_cart'] ??
      _localizedValues['en']!['shopping_cart']!;
  String get clear =>
      _localizedValues[locale.languageCode]?['clear'] ??
      _localizedValues['en']!['clear']!;
  String get yourCartIsEmpty =>
      _localizedValues[locale.languageCode]?['your_cart_is_empty'] ??
      _localizedValues['en']!['your_cart_is_empty']!;
  String get startAddingItems =>
      _localizedValues[locale.languageCode]?['start_adding_items'] ??
      _localizedValues['en']!['start_adding_items']!;
  String get startShopping =>
      _localizedValues[locale.languageCode]?['start_shopping'] ??
      _localizedValues['en']!['start_shopping']!;
  String get item =>
      _localizedValues[locale.languageCode]?['item'] ??
      _localizedValues['en']!['item']!;
  String get items =>
      _localizedValues[locale.languageCode]?['items'] ??
      _localizedValues['en']!['items']!;
  String get proceedToCheckout =>
      _localizedValues[locale.languageCode]?['proceed_to_checkout'] ??
      _localizedValues['en']!['proceed_to_checkout']!;
  String get slideToCheckout =>
      _localizedValues[locale.languageCode]?['slide_to_checkout'] ??
      _localizedValues['en']!['slide_to_checkout']!;
  String get subtotal =>
      _localizedValues[locale.languageCode]?['subtotal'] ??
      _localizedValues['en']!['subtotal']!;
  String get shipping =>
      _localizedValues[locale.languageCode]?['shipping'] ??
      _localizedValues['en']!['shipping']!;
  String get tax =>
      _localizedValues[locale.languageCode]?['tax'] ??
      _localizedValues['en']!['tax']!;
  String get taxPercent =>
      _localizedValues[locale.languageCode]?['tax_percent'] ??
      _localizedValues['en']!['tax_percent']!;
  String get total =>
      _localizedValues[locale.languageCode]?['total'] ??
      _localizedValues['en']!['total']!;
  String get free =>
      _localizedValues[locale.languageCode]?['free'] ??
      _localizedValues['en']!['free']!;
  String get popularProducts =>
      _localizedValues[locale.languageCode]?['popular_products'] ??
      _localizedValues['en']!['popular_products']!;
  String get smartphones =>
      _localizedValues[locale.languageCode]?['smartphones'] ??
      _localizedValues['en']!['smartphones']!;
  String get seeAll =>
      _localizedValues[locale.languageCode]?['see_all'] ??
      _localizedValues['en']!['see_all']!;
  String get seeMore =>
      _localizedValues[locale.languageCode]?['see_more'] ??
      _localizedValues['en']!['see_more']!;
  String get goodMorning =>
      _localizedValues[locale.languageCode]?['good_morning'] ??
      _localizedValues['en']!['good_morning']!;
  String get goodAfternoon =>
      _localizedValues[locale.languageCode]?['good_afternoon'] ??
      _localizedValues['en']!['good_afternoon']!;
  String get goodEvening =>
      _localizedValues[locale.languageCode]?['good_evening'] ??
      _localizedValues['en']!['good_evening']!;
  String get setLocation =>
      _localizedValues[locale.languageCode]?['set_location'] ??
      _localizedValues['en']!['set_location']!;
  String get addedToCart =>
      _localizedValues[locale.languageCode]?['added_to_cart'] ??
      _localizedValues['en']!['added_to_cart']!;
  String get viewCart =>
      _localizedValues[locale.languageCode]?['view_cart'] ??
      _localizedValues['en']!['view_cart']!;
  String get deliveryTime =>
      _localizedValues[locale.languageCode]?['delivery_time'] ??
      _localizedValues['en']!['delivery_time']!;
  String get fastDeals =>
      _localizedValues[locale.languageCode]?['fast_deals'] ??
      _localizedValues['en']!['fast_deals']!;
  String get searchLaptopsPhones =>
      _localizedValues[locale.languageCode]?['search_laptops_phones'] ??
      _localizedValues['en']!['search_laptops_phones']!;
  String get laptopNotFound =>
      _localizedValues[locale.languageCode]?['laptop_not_found'] ??
      _localizedValues['en']!['laptop_not_found']!;
  String get laptopNotFoundDesc =>
      _localizedValues[locale.languageCode]?['laptop_not_found_desc'] ??
      _localizedValues['en']!['laptop_not_found_desc']!;
  String get inStock =>
      _localizedValues[locale.languageCode]?['in_stock'] ??
      _localizedValues['en']!['in_stock']!;
  String get quickActions =>
      _localizedValues[locale.languageCode]?['quick_actions'] ??
      _localizedValues['en']!['quick_actions']!;
  String get recentOrdersSection =>
      _localizedValues[locale.languageCode]?['recent_orders_section'] ??
      _localizedValues['en']!['recent_orders_section']!;
  String get viewAll =>
      _localizedValues[locale.languageCode]?['view_all'] ??
      _localizedValues['en']!['view_all']!;
  String get orderNumber =>
      _localizedValues[locale.languageCode]?['order_number'] ??
      _localizedValues['en']!['order_number']!;
  String get orderHistory =>
      _localizedValues[locale.languageCode]?['order_history'] ??
      _localizedValues['en']!['order_history']!;
  String get notifications =>
      _localizedValues[locale.languageCode]?['notifications'] ??
      _localizedValues['en']!['notifications']!;
  String get managePreferences =>
      _localizedValues[locale.languageCode]?['manage_preferences'] ??
      _localizedValues['en']!['manage_preferences']!;
  String get privacySecurity =>
      _localizedValues[locale.languageCode]?['privacy_security'] ??
      _localizedValues['en']!['privacy_security']!;
  String get passwordDataSettings =>
      _localizedValues[locale.languageCode]?['password_data_settings'] ??
      _localizedValues['en']!['password_data_settings']!;
  String get paymentMethods =>
      _localizedValues[locale.languageCode]?['payment_methods'] ??
      _localizedValues['en']!['payment_methods']!;
  String get manageCardsWallets =>
      _localizedValues[locale.languageCode]?['manage_cards_wallets'] ??
      _localizedValues['en']!['manage_cards_wallets']!;
  String get helpCenter =>
      _localizedValues[locale.languageCode]?['help_center'] ??
      _localizedValues['en']!['help_center']!;
  String get about =>
      _localizedValues[locale.languageCode]?['about'] ??
      _localizedValues['en']!['about']!;
  String get version =>
      _localizedValues[locale.languageCode]?['version'] ??
      _localizedValues['en']!['version']!;
  String get signOut =>
      _localizedValues[locale.languageCode]?['sign_out'] ??
      _localizedValues['en']!['sign_out']!;
  String get logoutFromAccount =>
      _localizedValues[locale.languageCode]?['logout_from_account'] ??
      _localizedValues['en']!['logout_from_account']!;
  String get reward =>
      _localizedValues[locale.languageCode]?['reward'] ??
      _localizedValues['en']!['reward']!;
  String get customer =>
      _localizedValues[locale.languageCode]?['customer'] ??
      _localizedValues['en']!['customer']!;
  String get specifications =>
      _localizedValues[locale.languageCode]?['specifications'] ??
      _localizedValues['en']!['specifications']!;
  String get features =>
      _localizedValues[locale.languageCode]?['features'] ??
      _localizedValues['en']!['features']!;
  String get addToCart =>
      _localizedValues[locale.languageCode]?['add_to_cart'] ??
      _localizedValues['en']!['add_to_cart']!;
  String get price =>
      _localizedValues[locale.languageCode]?['price'] ??
      _localizedValues['en']!['price']!;
  String get description =>
      _localizedValues[locale.languageCode]?['description'] ??
      _localizedValues['en']!['description']!;
  String get ram =>
      _localizedValues[locale.languageCode]?['ram'] ??
      _localizedValues['en']!['ram']!;
  String get storage =>
      _localizedValues[locale.languageCode]?['storage'] ??
      _localizedValues['en']!['storage']!;
  String get screen =>
      _localizedValues[locale.languageCode]?['screen'] ??
      _localizedValues['en']!['screen']!;
  String get processor =>
      _localizedValues[locale.languageCode]?['processor'] ??
      _localizedValues['en']!['processor']!;
  String get cpu =>
      _localizedValues[locale.languageCode]?['cpu'] ??
      _localizedValues['en']!['cpu']!;
  String get memory =>
      _localizedValues[locale.languageCode]?['memory'] ??
      _localizedValues['en']!['memory']!;
  String get city =>
      _localizedValues[locale.languageCode]?['city'] ??
      _localizedValues['en']!['city']!;
  String get street =>
      _localizedValues[locale.languageCode]?['street'] ??
      _localizedValues['en']!['street']!;
  String get building =>
      _localizedValues[locale.languageCode]?['building'] ??
      _localizedValues['en']!['building']!;
  String get apartment =>
      _localizedValues[locale.languageCode]?['apartment'] ??
      _localizedValues['en']!['apartment']!;
  String get postalCode =>
      _localizedValues[locale.languageCode]?['postal_code'] ??
      _localizedValues['en']!['postal_code']!;
  String get country =>
      _localizedValues[locale.languageCode]?['country'] ??
      _localizedValues['en']!['country']!;
  String get currentLocation =>
      _localizedValues[locale.languageCode]?['current_location'] ??
      _localizedValues['en']!['current_location']!;
  String get useCurrentLocation =>
      _localizedValues[locale.languageCode]?['use_current_location'] ??
      _localizedValues['en']!['use_current_location']!;
  String get enterManually =>
      _localizedValues[locale.languageCode]?['enter_manually'] ??
      _localizedValues['en']!['enter_manually']!;
  String get payment =>
      _localizedValues[locale.languageCode]?['payment'] ??
      _localizedValues['en']!['payment']!;
  String get cardNumber =>
      _localizedValues[locale.languageCode]?['card_number'] ??
      _localizedValues['en']!['card_number']!;
  String get cardHolderName =>
      _localizedValues[locale.languageCode]?['card_holder_name'] ??
      _localizedValues['en']!['card_holder_name']!;
  String get expiryDate =>
      _localizedValues[locale.languageCode]?['expiry_date'] ??
      _localizedValues['en']!['expiry_date']!;
  String get payNow =>
      _localizedValues[locale.languageCode]?['pay_now'] ??
      _localizedValues['en']!['pay_now']!;
  String get orderSummary =>
      _localizedValues[locale.languageCode]?['order_summary'] ??
      _localizedValues['en']!['order_summary']!;
  String get categoryLaptops =>
      _localizedValues[locale.languageCode]?['category_laptops'] ??
      _localizedValues['en']!['category_laptops']!;
  String get categoryPhones =>
      _localizedValues[locale.languageCode]?['category_phones'] ??
      _localizedValues['en']!['category_phones']!;
  String get categoryMacbooks =>
      _localizedValues[locale.languageCode]?['category_macbooks'] ??
      _localizedValues['en']!['category_macbooks']!;
  String get categoryDesktops =>
      _localizedValues[locale.languageCode]?['category_desktops'] ??
      _localizedValues['en']!['category_desktops']!;
  String get categoryAccessories =>
      _localizedValues[locale.languageCode]?['category_accessories'] ??
      _localizedValues['en']!['category_accessories']!;
  String get categoryMonitors =>
      _localizedValues[locale.languageCode]?['category_monitors'] ??
      _localizedValues['en']!['category_monitors']!;
  String get upgradeYour =>
      _localizedValues[locale.languageCode]?['upgrade_your'] ??
      _localizedValues['en']!['upgrade_your']!;
  String get tech =>
      _localizedValues[locale.languageCode]?['tech'] ??
      _localizedValues['en']!['tech']!;
  String get life =>
      _localizedValues[locale.languageCode]?['life'] ??
      _localizedValues['en']!['life']!;
  String get splashSubtitle =>
      _localizedValues[locale.languageCode]?['splash_subtitle'] ??
      _localizedValues['en']!['splash_subtitle']!;
  String get swipeToContinue =>
      _localizedValues[locale.languageCode]?['swipe_to_continue'] ??
      _localizedValues['en']!['swipe_to_continue']!;

  // Helper method to get localized category name by ID
  String getCategoryName(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'laptops':
        return categoryLaptops;
      case 'phones':
        return categoryPhones;
      case 'macbooks':
        return categoryMacbooks;
      case 'desktops':
        return categoryDesktops;
      case 'accessories':
        return categoryAccessories;
      case 'monitors':
        return categoryMonitors;
      default:
        return categoryId; // Return original if not found
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

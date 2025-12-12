# NexBuy - Modern Shopping App

A modern Flutter shopping app with AI Assistant integration, built with clean architecture and beautiful UI design.

## 🎨 Features

### UI Design
- **Modern & Minimal Design**: Clean interface with bright orange (#FF6A00) primary color
- **Responsive Layout**: Optimized for different screen sizes
- **Beautiful Cards**: Rounded corners, shadows, and smooth animations
- **Custom Components**: Reusable widgets for consistent design

### Core Features
- **Home Screen**: Greeting, search bar, promotional banner, categories, and product grid
- **Product Categories**: Smartphones, Laptops, Headphones, Watches with filtering
- **Product Grid**: Two-column layout with product cards showing images, prices, ratings
- **Favorites System**: Add/remove products from favorites
- **Shopping Cart**: Add products to cart functionality
- **Search**: Real-time product search with filtering
- **User Profile**: Personal information, stats, and settings

### AI Assistant Integration
- **Floating Action Button**: Easy access to AI chat
- **Natural Language Processing**: Ask questions like "Show me cheap gaming laptops"
- **Smart Recommendations**: AI-powered product suggestions
- **OpenAI Integration**: Ready for GPT-4o-mini API integration
- **Mock Responses**: Demo mode with realistic AI responses

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── product.dart
│   └── category.dart
├── providers/                # State management
│   ├── product_provider.dart
│   └── ai_provider.dart
├── screens/                  # UI screens
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── favorites_screen.dart
│   └── profile_screen.dart
└── widgets/                  # Reusable components
    ├── banner_card.dart
    ├── category_chip.dart
    ├── product_card.dart
    └── ai_chat_modal.dart
```

### State Management
- **Provider Pattern**: Clean separation of business logic
- **ProductProvider**: Manages products, categories, favorites, cart
- **AIProvider**: Handles AI chat functionality and OpenAI integration

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nexbuy
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### OpenAI Integration (Optional)

To enable real AI responses:

1. **Get OpenAI API Key**
   - Visit [OpenAI Platform](https://platform.openai.com/)
   - Create an account and generate an API key

2. **Configure the API Key**
   - Open `lib/providers/ai_provider.dart`
   - Replace the empty `_apiKey` with your actual API key:
   ```dart
   String _apiKey = 'your-openai-api-key-here';
   ```

3. **Test the Integration**
   - The app will use real OpenAI responses instead of mock responses
   - Make sure you have sufficient API credits

## 📱 Screenshots

### Home Screen
- Modern greeting with user name
- Search bar with filter functionality
- Promotional banner with gradient design
- Category chips with horizontal scrolling
- Product grid with beautiful cards

### AI Assistant
- Floating action button for easy access
- Chat interface with message bubbles
- Real-time typing indicators
- Smart product recommendations

### Navigation
- Bottom navigation with 4 tabs
- Home, Search, Favorites, Profile
- Active tab highlighting

## 🛠️ Customization

### Colors
- Primary Color: `#FF6A00` (Bright Orange)
- Background: White
- Accent Colors: Grey variants

### Fonts
- Primary: Roboto (Material Design)
- Clean and readable typography

### Components
- All widgets are reusable
- Easy to modify and extend
- Consistent design patterns

## 🔮 Future Enhancements

### Planned Features
- **Firebase Integration**: Authentication and real-time data
- **Payment Processing**: Stripe/PayPal integration
- **Push Notifications**: Order updates and promotions
- **Offline Support**: Local data caching
- **Advanced Search**: Filters, sorting, and recommendations
- **User Reviews**: Product ratings and comments
- **Wishlist**: Save products for later
- **Order Tracking**: Real-time order status

### Technical Improvements
- **State Management**: Migration to Riverpod/Bloc
- **Testing**: Unit and widget tests
- **Performance**: Image optimization and lazy loading
- **Accessibility**: Screen reader support
- **Internationalization**: Multi-language support

## 📦 Dependencies

- `flutter`: SDK
- `provider`: State management
- `http`: API requests
- `font_awesome_flutter`: Icons
- `cupertino_icons`: iOS-style icons

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenAI for AI capabilities
- Unsplash for beautiful product images
- Material Design for UI guidelines

---

**Built with ❤️ using Flutter**
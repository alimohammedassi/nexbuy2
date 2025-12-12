# 🛍️ NexBuy - Next Generation Shopping App

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)
![Gemini AI](https://img.shields.io/badge/AI-Gemini-8E75B2?logo=google)
![Provider](https://img.shields.io/badge/State-Provider-blue)
![License](https://img.shields.io/badge/License-MIT-green)

**NexBuy** is a state-of-the-art Flutter e-commerce application designed to provide a premium shopping experience to users and a powerful management interface to admins. Built with a "Mobile First" approach, it leverages the power of **Supabase** for a robust backend and **Google Gemini** for an intelligent shopping assistant.

---

## ✨ Key Features

### 👤 For Users

- **Modern UI/UX**: Sleek design featuring glassmorphism, smooth animations, and a vibrant color palette (#FF6A00).
- **Smart Product Discovery**:
  - Dynamic Product Grid with realtime availability.
  - Advanced Search & Filtering (Categories, Price, Specs).
  - **AI Shopping Assistant**: Chat with our Gemini-powered bot for personalized recommendations and product inquiries.
- **Seamless Shopping Experience**:
  - **Favorites System**: Synced across devices via Supabase.
  - **Cart Management**: Intuitive cart with total calculation and stock validation.
  - **Secure Checkout**: Integrated flow (UI ready for payment gateways).
- **User Profiles**: Manage personal details, order history (coming soon), and preferences.
- **Localization**: Bilingual support (English & Arabic) ready architecture.

### 🛡️ For Admins

- **Admin Dashboard**: comprehensive overview of analytics and inventory.
- **Product Management**: CRUD operations for products, including image uploads to Supabase Storage.
- **Category Management**: Manage product categories dynamically.
- **Stock Control**: realtime updates on inventory levels.

---

## 🏗️ Technical Architecture

NexBuy is built with clean architecture principles to ensure scalability and maintainability.

### 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK 3.8.1+)
- **Language**: [Dart](https://dart.dev/)
- **Backend as a Service**: [Supabase](https://supabase.com/)
  - **Authentication**: Secure email/password login & Google Auth.
  - **Database**: PostgreSQL for relational data (Products, Users, Cart, etc.).
  - **Storage**: Bucket storage for product images and assets.
- **Artificial Intelligence**: [Google Gemini](https://deepmind.google/technologies/gemini/) (via `google_generative_ai`)
- **State Management**: `provider` pattern.
- **UI Components**: `glassmorphism`, `carousel_slider`, `flutter_svg`, `shimmer`.

### 📂 Project Structure

```
lib/
├── config/             # Configuration (Supabase keys, Theme)
├── models/             # Data models (Product, Category, User, CartItem)
├── providers/          # State providers (Cart, Favorites, User)
├── screens/            # UI Screens (Home, Details, Cart, Admin)
├── services/           # Backend services (Supabase, Gemini, Auth)
├── widgets/            # Reusable UI components (ProductCard, Shimmer)
└── main.dart           # App Entry point
```

---

## 📚 Documentation & Guides

We have detailed documentation for every aspect of the project:

- **Setup Guides**:
  - [🛠️ Database Setup](./DATABASE_SETUP.md) - **Start Here**
  - [🔑 Admin Setup](./ADMIN_SETUP.md)
  - [🔥 Firebase/Auth Setup](./FIREBASE_SETUP.md)
- **Operational Guides**:
  - [➕ How to Add Products](./HOW_TO_ADD_PRODUCTS.md)
  - [📊 Access Admin Dashboard](./HOW_TO_ACCESS_ADMIN_DASHBOARD.md)
- **Troubleshooting**:
  - [🐛 Exceptions & Fixes](./EXCEPTIONS_FIXED_SUMMARY.md)
  - [🔒 RLS Policies Fix](./FIX_RLS_ERROR.md)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed and added to PATH.
- VS Code or Android Studio.
- A Supabase project (Free tier works great).
- A Google Cloud project for Gemini API key.

### Installation

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/yourusername/nexbuy.git
    cd nexbuy
    ```

2.  **Install Dependencies**

    ```bash
    flutter pub get
    ```

3.  **Configuration**

    - Open `lib/config/supabase_config.dart` and populate your Supabase URL and Anon Key.
      ```dart
      class SupabaseConfig {
        static const String url = 'YOUR_SUPABASE_URL';
        static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
      }
      ```
    - _Note: Ensure you have run the SQL scripts found in the root directory to set up your Supabase tables._

4.  **Database Migration**

    - Run `supabase_migration.sql` in your Supabase SQL Editor to create tables.
    - Run `insert_categories_data.sql` to seed initial data.

5.  **Run the App**
    ```bash
    flutter run
    ```

---

## 🎨 Design System

NexBuy uses a custom design system centered around:

- **Primary Color**: `Color(0xFFFF6A00)` (Vibrant Orange)
- **Typography**: `Poppins` for headings, `Cairo` for Arabic support.
- **Components**: Custom `ProductCard`, `GlassContainer`, and animated `SplashScreens`.

---

## 🛣️ Roadmap

- [x] Core Shopping Features
- [x] Supabase Authentication & Database
- [x] Gemini AI Chat Integration
- [x] Admin Dashboard
- [ ] Payment Gateway Integration (Stripe)
- [ ] Push Notifications
- [ ] Order Tracking System
- [ ] PWA Support

---

## 🤝 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Built with ❤️ by the NexBuy Team**

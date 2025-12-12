# LiquidTabBar Widget

A beautiful tab bar widget with liquid/glass morphism effects that matches the style of your liquid navbar.

## Features

✨ **Liquid Animation**: Smooth animated indicator that flows between tabs  
🎨 **Glass Morphism**: Backdrop blur effect for a modern look  
🔵 **Customizable Colors**: Match your app's theme  
📛 **Badge Support**: Show notification badges on tabs  
⚡ **Smooth Transitions**: Animated icon sizes and colors

## Installation

The widget is already created in your project at:

```
lib/widgets/liquid_tab_bar.dart
```

## Basic Usage

```dart
import 'package:flutter/material.dart';
import '../widgets/liquid_tab_bar.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _currentIndex = 0;

  final List<LiquidTabBarItem> _tabs = const [
    LiquidTabBarItem(
      label: 'Home',
      icon: Icons.home_rounded,
    ),
    LiquidTabBarItem(
      label: 'Search',
      icon: Icons.search_rounded,
    ),
    LiquidTabBarItem(
      label: 'Profile',
      icon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: LiquidTabBar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
```

## Advanced Customization

```dart
LiquidTabBar(
  items: _tabs,
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),

  // Customize colors
  selectedColor: const Color(0xFF2563EB),
  unselectedColor: Colors.grey,
  backgroundColor: Colors.white,

  // Customize sizes
  height: 70,
  indicatorHeight: 3,
)
```

## Adding Badges

```dart
LiquidTabBarItem(
  label: 'Notifications',
  icon: Icons.notifications_rounded,
  badge: '5', // Shows a red badge with "5"
)
```

## Parameters

### LiquidTabBar

| Parameter         | Type                     | Default             | Description                     |
| ----------------- | ------------------------ | ------------------- | ------------------------------- |
| `items`           | `List<LiquidTabBarItem>` | Required            | List of tab items               |
| `currentIndex`    | `int`                    | Required            | Currently selected tab index    |
| `onTap`           | `ValueChanged<int>`      | Required            | Callback when tab is tapped     |
| `selectedColor`   | `Color`                  | `Color(0xFF2563EB)` | Color for selected tab          |
| `unselectedColor` | `Color`                  | `Colors.grey`       | Color for unselected tabs       |
| `backgroundColor` | `Color`                  | `Colors.white`      | Background color of the tab bar |
| `height`          | `double`                 | `70`                | Height of the tab bar           |
| `indicatorHeight` | `double`                 | `3`                 | Height of the liquid indicator  |

### LiquidTabBarItem

| Parameter | Type       | Required | Description                            |
| --------- | ---------- | -------- | -------------------------------------- |
| `label`   | `String`   | Yes      | Text label for the tab                 |
| `icon`    | `IconData` | Yes      | Icon for the tab                       |
| `badge`   | `String?`  | No       | Optional badge text (e.g., "5", "NEW") |

## Example

Check out the complete example at:

```
lib/examples/liquid_tab_bar_example.dart
```

To run the example:

```dart
// In your main.dart or any screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const LiquidTabBarExample(),
  ),
);
```

## Comparison with CustomTabBar

| Feature        | CustomTabBar | LiquidTabBar          |
| -------------- | ------------ | --------------------- |
| Animation      | ❌ Static    | ✅ Liquid flow        |
| Glass Effect   | ❌ No        | ✅ Backdrop blur      |
| Indicator      | ❌ None      | ✅ Animated liquid    |
| Icon Animation | ❌ No        | ✅ Size & color       |
| Badge Styling  | ✅ Basic     | ✅ Gradient with glow |

## Tips

1. **Match Your Theme**: Use the same `selectedColor` as your liquid navbar for consistency
2. **Keep Labels Short**: 1-2 words work best for readability
3. **Use Rounded Icons**: Icons ending in `_rounded` look better with the liquid effect
4. **Limit Tabs**: 3-5 tabs work best for mobile screens

## Migration from CustomTabBar

Replace:

```dart
CustomTabBar(
  items: [
    CustomTabBarItem(label: 'Home', icon: Icons.home),
  ],
  currentIndex: _index,
  onTap: (i) => setState(() => _index = i),
)
```

With:

```dart
LiquidTabBar(
  items: [
    LiquidTabBarItem(label: 'Home', icon: Icons.home_rounded),
  ],
  currentIndex: _index,
  onTap: (i) => setState(() => _index = i),
)
```

## Troubleshooting

**Issue**: Tab bar appears behind content  
**Solution**: Make sure you're using it in `bottomNavigationBar` property of Scaffold, not in the body

**Issue**: Indicator doesn't animate  
**Solution**: Ensure you're calling `setState` when updating `currentIndex`

**Issue**: Blur effect not visible  
**Solution**: Make sure `backgroundColor` has some opacity (e.g., `Colors.white.withOpacity(0.95)`)

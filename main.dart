
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CampusApp());
}

const Color background = Color(0xFFFFF9F3);
const Color wine = Color(0xFF713D52);
const Color peach = Color(0xFFF4D9C9);
const Color ink = Color(0xFF302630);

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: wine),
      ),
      home: const FoodHome(),
    );
  }
}

class FoodHome extends StatefulWidget {
  const FoodHome({super.key});

  @override
  State<FoodHome> createState() => _FoodHomeState();
}

class _FoodHomeState extends State<FoodHome> {
  String selectedCategory = '';
  int currentTab = 0;

  final Map<String, int> cart = {};

  String? orderToken;
  DateTime? orderTime;
  bool orderPickedUp = false;

  final List<Map<String, String>> categories = [
    {
      'name': 'Desserts',
      'subtitle': 'Something sweet',
      'image': 'photo-1578985545062-69928b1d9587',
    },
    {
      'name': 'Lunch',
      'subtitle': 'Meals worth a break',
      'image': 'photo-1547592180-85f173990554',
    },
    {
      'name': 'Snacks',
      'subtitle': 'Little bites',
      'image': 'photo-1573080496219-bb080dd4f877',
    },
    {
      'name': 'Breakfast',
      'subtitle': 'Fresh starts',
      'image': 'photo-1533089860892-a7c6f0a88666',
    },
    {
      'name': 'Beverages',
      'subtitle': 'Sip something nice',
      'image': 'photo-1544145945-f90425340c7e',
    },
  ];

  final Map<String, List<Map<String, String>>> items = {
    'Desserts': [
      {'name': 'Chocolate Cake', 'price': '₹90', 'image': 'photo-1578985545062-69928b1d9587'},
      {'name': 'Strawberry Cheesecake', 'price': '₹110', 'image': 'photo-1533134242443-d4fd215305ad'},
      {'name': 'Chocolate Brownie', 'price': '₹70', 'image': 'photo-1606313564200-e75d5e30476c'},
      {'name': 'Ice Cream', 'price': '₹60', 'image': 'photo-1560008581-09826d1de69e',},
    ],
    'Lunch': [
      {'name': 'Veg Thali', 'price': '₹120', 'image': 'photo-1547592180-85f173990554'},
      {'name': 'Paneer Rice Bowl', 'price': '₹110', 'image': 'photo-1512058564366-18510be2db19'},
      {'name': 'Veg Biryani', 'price': '₹100', 'image': 'photo-1563379091339-03246963d96c'},
      {'name': 'Noodles', 'price': '₹90', 'image': 'photo-1585032226651-759b368d7246'},
    ],
    'Snacks': [
      {'name': 'French Fries', 'price': '₹60', 'image': 'photo-1573080496219-bb080dd4f877'},
      {'name': 'Veg Sandwich', 'price': '₹70', 'image': 'photo-1528735602780-2552fd46c7af'},
      {'name': 'Samosa', 'price': '₹25', 'image': 'photo-1601050690597-df0568f70950'},
      {'name': 'Burger', 'price': '₹85', 'image': 'photo-1568901346375-23c9450c58cd'},
    ],
    'Breakfast': [
      {'name': 'Pancakes', 'price': '₹80', 'image': 'photo-1528207776546-365bb710ee93'},
      {'name': 'Masala Dosa', 'price': '₹65', 'image': 'photo-1589301760014-d929f3979dbc'},
      {'name': 'Idli & Sambar', 'price': '₹50', 'image': 'photo-1589301760014-d929f3979dbc'},
      {'name': 'Toast & Eggs', 'price': '₹75', 'image': 'photo-1525351484163-7529414344d8'},
    ],
    'Beverages': [
      {'name': 'Iced Coffee', 'price': '₹80', 'image': 'photo-1461023058943-07fcbe16d735'},
      {'name': 'Fresh Juice', 'price': '₹60', 'image': 'photo-1600271886742-f049cd451bba'},
      {'name': 'Milkshake', 'price': '₹90', 'image': 'photo-1572490122747-3968b75cc699'},
      {'name': 'Lemon Cooler', 'price': '₹50', 'image': 'photo-1513558161293-cdaf765edfd4'},
    ],
  };

  int get cartCount =>
      cart.values.fold(0, (total, quantity) => total + quantity);

  double get cartTotal {
    double total = 0;

    for (final entry in cart.entries) {
      for (final group in items.values) {
        for (final item in group) {
          if (item['name'] == entry.key) {
            total +=
                double.parse(item['price']!.replaceAll('₹', '')) *
                entry.value;
          }
        }
      }
    }

    return total;
  }

  String photo(String id) =>
      'https://images.unsplash.com/$id?auto=format&fit=crop&w=800&q=85';

  String generateToken() {
    final random = Random.secure();
    final number = random.nextInt(900000) + 100000;
    return 'CB-$number';
  }

  void addItem(String name) {
    setState(() {
      cart[name] = (cart[name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to your cart'),
        duration: const Duration(milliseconds: 900),
        backgroundColor: wine,
      ),
    );
  }

  void removeItem(String name) {
    setState(() {
      if ((cart[name] ?? 0) > 1) {
        cart[name] = cart[name]! - 1;
      } else {
        cart.remove(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(),
            Expanded(
              child: selectedCategory.isEmpty
                  ? homePage()
                  : itemPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: wine,
        unselectedItemColor: Colors.grey,
        currentIndex: currentTab,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          setState(() {
            currentTab = index;
            selectedCategory = '';
          });

          if (index == 2) {
            showCart();
          } else if (index == 3) {
            showOrderTracking();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'My Order',
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: wine,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CAMPUS BITES',
                style: TextStyle(
                  color: wine,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 15,
                ),
              ),
              Text(
                'THE CAMPUS FOOD CLUB',
                style: TextStyle(
                  color: Colors.brown.shade400,
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: showOrderTracking,
            tooltip: 'My order',
            icon: const Icon(
              Icons.confirmation_number_outlined,
              color: wine,
              size: 27,
            ),
          ),
          GestureDetector(
            onTap: showCart,
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: wine,
                    size: 24,
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: -7,
                      top: -7,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: wine,
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: wine,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A LITTLE BREAK.\nA BETTER BITE.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Good food, right around your campus.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: peach,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: wine, size: 17),
                      SizedBox(width: 6),
                      Text(
                        'PRE-ORDER & PICK UP',
                        style: TextStyle(
                          color: wine,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          const Text(
            'Find your favourite',
            style: TextStyle(
              color: ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'A menu for every kind of break.',
            style: TextStyle(
              color: Colors.brown.shade400,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 15,
              childAspectRatio: 0.91,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category['name']!;
                    currentTab = 1;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      foodImage(category['image']!),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.78),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 10,
                        bottom: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              category['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        right: 12,
                        top: 12,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_outward,
                            color: wine,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget foodImage(String id) {
    return Image.network(
      photo(id),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: peach,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: wine,
            strokeWidth: 2,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: peach,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: wine,
            size: 38,
          ),
        );
      },
    );
  }

  Widget itemPage() {
    final selectedItems = items[selectedCategory] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = '';
                    currentTab = 0;
                  });
                },
                icon: const Icon(Icons.arrow_back, color: wine),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCategory,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: ink,
                    ),
                  ),
                  const Text(
                    'Choose something delicious',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: selectedItems.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 15,
              childAspectRatio: 0.69,
            ),
            itemBuilder: (context, index) {
              final item = selectedItems[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 9,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: foodImage(item['image']!),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['price']!,
                                style: const TextStyle(
                                  color: wine,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => addItem(item['name']!),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: wine,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, updateSheet) {
            final entries = cart.entries.toList();

            return Padding(
              padding: const EdgeInsets.fromLTRB(22, 15, 22, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your cart',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (entries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Your cart is waiting for something tasty!',
                        ),
                      ),
                    ),
                  ...entries.map(
                    (entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(entry.key),
                      subtitle: Text('Quantity: ${entry.value}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              removeItem(entry.key);
                              updateSheet(() {});
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: wine,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              addItem(entry.key);
                              updateSheet(() {});
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: wine,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '₹${cartTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: wine,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wine,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: entries.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context);
                              showCheckout();
                            },
                      child: const Text('Place my order'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showCheckout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: background,
          title: const Text('Confirm your order'),
          content: Text(
            'Your total is ₹${cartTotal.toStringAsFixed(0)}.\n\n'
            'Would you like to confirm your order?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Go back'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: wine,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  orderToken = generateToken();
                  orderTime = DateTime.now();
                  orderPickedUp = false;
                  cart.clear();
                });

                Navigator.pop(dialogContext);
                showOrderTracking();
              },
              child: const Text('Confirm order'),
            ),
          ],
        );
      },
    );
  }

  void showOrderTracking() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, updateSheet) {
            if (orderToken == null) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 45),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long, color: wine, size: 48),
                    SizedBox(height: 14),
                    Text(
                      'No active order yet',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: ink,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your order token and collection details will appear here after checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 15, 24, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your order',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Unique order token
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: wine,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'YOUR COLLECTION TOKEN',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          orderToken!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Show this token at the canteen counter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  if (!orderPickedUp) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: peach,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: wine,
                            size: 35,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Approximately 30 minutes',
                            style: TextStyle(
                              color: wine,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Your order is being prepared. Please collect it from the canteen counter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ink,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Once you have collected your food, confirm below.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wine,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () {
                          setState(() {
                            orderPickedUp = true;
                          });
                          updateSheet(() {});
                        },
                        child: const Text(
                          "I've picked up my order",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F0E4),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF38764B),
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Enjoy your meal!',
                            style: TextStyle(
                              color: Color(0xFF285B3B),
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Thank you for ordering with Campus Bites. Have a wonderful day!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF456B50),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wine,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

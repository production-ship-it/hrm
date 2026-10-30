import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KioskScreen extends StatefulWidget {
  const KioskScreen({super.key});

  @override
  State<KioskScreen> createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _mainTabController;
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _userNameController =
  TextEditingController(text: "Muhammad Arham Farooqui");
  final TextEditingController _orderSearchController = TextEditingController();

  String _selectedCategory = "All";

  // Catalog Data
  final List<Map<String, dynamic>> _kioskItems = [
    {
      "id": "1",
      "name": "Cold Espresso Brew",
      "category": "Drinks",
      "price": 3.50,
      "imageIcon": Icons.local_cafe_rounded,
      "color": const Color(0xFF795548),
      "inStock": true,
      "quantity": 0,
    },
    {
      "id": "2",
      "name": "Sparkling Energy Drink",
      "category": "Drinks",
      "price": 2.50,
      "imageIcon": Icons.local_drink_rounded,
      "color": const Color(0xFF2979FF),
      "inStock": true,
      "quantity": 0,
    },
    {
      "id": "3",
      "name": "Green Tea Latte",
      "category": "Drinks",
      "price": 3.00,
      "imageIcon": Icons.emoji_food_beverage_rounded,
      "color": const Color(0xFF4CAF50),
      "inStock": true,
      "quantity": 0,
    },
    {
      "id": "4",
      "name": "Roasted Almond Mix",
      "category": "Snacks",
      "price": 2.00,
      "imageIcon": Icons.grain_rounded,
      "color": const Color(0xFFFF9800),
      "inStock": true,
      "quantity": 0,
    },
    {
      "id": "5",
      "name": "Dark Chocolate Bar",
      "category": "Snacks",
      "price": 1.80,
      "imageIcon": Icons.cookie_rounded,
      "color": const Color(0xFF8D6E63),
      "inStock": true,
      "quantity": 0,
    },
    {
      "id": "6",
      "name": "Baked Potato Chips",
      "category": "Snacks",
      "price": 1.50,
      "imageIcon": Icons.fastfood_rounded,
      "color": const Color(0xFFFFC107),
      "inStock": true,
      "quantity": 0,
    },
  ];

  // Global Orders History Across All Users
  final List<Map<String, dynamic>> _allOrdersHistory = [
    {
      "orderId": "#ORD-8942",
      "userName": "Muhammad Arham Farooqui",
      "floor": "Floor 3, Bay 4-B",
      "date": "27 Oct 2026, 02:45 PM",
      "totalAmount": 6.00,
      "status": "Delivered",
      "items": [
        {"name": "Cold Espresso Brew", "quantity": 1, "price": 3.50},
        {"name": "Sparkling Energy Drink", "quantity": 1, "price": 2.50},
      ]
    },
    {
      "orderId": "#ORD-8941",
      "userName": "Minham Khanzada",
      "floor": "Floor 2, Engineering Wing",
      "date": "27 Oct 2026, 01:15 PM",
      "totalAmount": 4.80,
      "status": "In Transit",
      "items": [
        {"name": "Green Tea Latte", "quantity": 1, "price": 3.00},
        {"name": "Dark Chocolate Bar", "quantity": 1, "price": 1.80},
      ]
    },
    {
      "orderId": "#ORD-8939",
      "userName": "Arsalan Alvi",
      "floor": "Floor 1, Creative Studio",
      "date": "26 Oct 2026, 04:20 PM",
      "totalAmount": 3.50,
      "status": "Delivered",
      "items": [
        {"name": "Baked Potato Chips", "quantity": 1, "price": 1.50},
        {"name": "Roasted Almond Mix", "quantity": 1, "price": 2.00},
      ]
    },
    {
      "orderId": "#ORD-8935",
      "userName": "Dua Irfan",
      "floor": "Floor 4, Marketing Desk 12",
      "date": "25 Oct 2026, 11:30 AM",
      "totalAmount": 5.00,
      "status": "Delivered",
      "items": [
        {"name": "Green Tea Latte", "quantity": 1, "price": 3.00},
        {"name": "Roasted Almond Mix", "quantity": 1, "price": 2.00},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _mainTabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _floorController.dispose();
    _userNameController.dispose();
    _orderSearchController.dispose();
    super.dispose();
  }

  // Filter Catalog
  List<Map<String, dynamic>> _getFilteredItems() {
    if (_selectedCategory == "All") return _kioskItems;
    return _kioskItems
        .where((item) => item["category"] == _selectedCategory)
        .toList();
  }

  // Filter Orders History
  List<Map<String, dynamic>> _getFilteredOrders() {
    final query = _orderSearchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allOrdersHistory;

    return _allOrdersHistory.where((order) {
      final userName = order["userName"].toString().toLowerCase();
      final floor = order["floor"].toString().toLowerCase();
      final orderId = order["orderId"].toString().toLowerCase();
      return userName.contains(query) ||
          floor.contains(query) ||
          orderId.contains(query);
    }).toList();
  }

  // Total Calculation
  double get _totalPrice {
    return _kioskItems.fold(
        0.0, (sum, item) => sum + (item["price"] * (item["quantity"] as int)));
  }

  int get _totalItemsCount {
    return _kioskItems.fold(
        0, (sum, item) => sum + (item["quantity"] as int));
  }

  void _updateQuantity(String id, int delta) {
    setState(() {
      final item = _kioskItems.firstWhere((element) => element["id"] == id);
      int newQty = (item["quantity"] as int) + delta;
      if (newQty >= 0) {
        item["quantity"] = newQty;
      }
    });
  }

  // Submit Order Modal
  void _placeOrder(bool isDark) {
    if (_totalItemsCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least 1 item to place an order."),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    if (_floorController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please provide your floor/desk description."),
          backgroundColor: Color(0xFFFFC107),
        ),
      );
      return;
    }

    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

    final orderedItems = _kioskItems
        .where((item) => (item["quantity"] as int) > 0)
        .map((item) => {
      "name": item["name"],
      "quantity": item["quantity"],
      "price": item["price"],
    })
        .toList();

    final orderId =
        "#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

    // Register into All Users Order History
    setState(() {
      _allOrdersHistory.insert(0, {
        "orderId": orderId,
        "userName": _userNameController.text,
        "floor": _floorController.text.trim(),
        "date": "27 Oct 2026, Just now",
        "totalAmount": _totalPrice,
        "status": "In Transit",
        "items": orderedItems,
      });
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 28.r,
                      backgroundColor: const Color(0xFF00E676).withAlpha(25),
                      child: Icon(Icons.check_circle_rounded,
                          color: const Color(0xFF00E676), size: 36.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: Text(
                      "Kiosk Order Dispatched!",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Text(
                      orderId,
                      style: TextStyle(color: mutedColor, fontSize: 11.sp),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Divider(
                      color: isDark
                          ? Colors.white.withAlpha(15)
                          : Colors.black.withAlpha(15)),
                  SizedBox(height: 10.h),

                  // Delivery Metadata
                  _buildReceiptTile("Requested By", _userNameController.text,
                      Icons.person_outline_rounded, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildReceiptTile(
                      "Delivery Floor / Desk",
                      _floorController.text,
                      Icons.location_on_outlined,
                      textColor,
                      mutedColor,
                      inputBg),

                  SizedBox(height: 12.h),
                  Text("Summary Items",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),

                  ...orderedItems.map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item["quantity"]}x ${item["name"]}",
                          style:
                          TextStyle(color: textColor, fontSize: 12.sp),
                        ),
                        Text(
                          "\$${((item["price"] as double) * (item["quantity"] as int)).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),

                  SizedBox(height: 12.h),
                  Divider(
                      color: isDark
                          ? Colors.white.withAlpha(15)
                          : Colors.black.withAlpha(15)),
                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold)),
                      Text("\$${_totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: const Color(0xFF2979FF),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 42.h,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          for (var item in _kioskItems) {
                            item["quantity"] = 0;
                          }
                          _floorController.clear();
                        });
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text("Done",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Show Order Details Modal from History
  void _showOrderDetailsModal(
      Map<String, dynamic> order, bool isDark) {
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);
    final items = order["items"] as List;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ${order["orderId"]}",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            order["date"],
                            style: TextStyle(color: mutedColor, fontSize: 11.sp),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: mutedColor),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Divider(
                      color: isDark
                          ? Colors.white.withAlpha(15)
                          : Colors.black.withAlpha(15)),
                  SizedBox(height: 10.h),

                  _buildReceiptTile("Requested By", order["userName"],
                      Icons.person_outline_rounded, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildReceiptTile("Delivery Floor / Desk", order["floor"],
                      Icons.location_on_outlined, textColor, mutedColor, inputBg),

                  SizedBox(height: 12.h),
                  Text("Items Ordered",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),

                  ...items.map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item["quantity"]}x ${item["name"]}",
                          style:
                          TextStyle(color: textColor, fontSize: 12.sp),
                        ),
                        Text(
                          "\$${((item["price"] as double) * (item["quantity"] as int)).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),

                  SizedBox(height: 12.h),
                  Divider(
                      color: isDark
                          ? Colors.white.withAlpha(15)
                          : Colors.black.withAlpha(15)),
                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold)),
                      Text("\$${(order["totalAmount"] as double).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: const Color(0xFF2979FF),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text("Close",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptTile(String label, String value, IconData icon,
      Color textColor, Color mutedColor, Color bg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        children: [
          Icon(icon, color: mutedColor, size: 16.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: mutedColor, fontSize: 10.sp)),
                SizedBox(height: 2.h),
                Text(value,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor =
    isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

    final filteredItems = _getFilteredItems();
    final filteredOrders = _getFilteredOrders();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Title & Auto-Fetched User Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Office Pantry Kiosk",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12.r,
                          backgroundColor: const Color(0xFF2979FF),
                          child: Icon(Icons.person,
                              color: Colors.white, size: 12.r),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _userNameController.text.split(" ").first,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6.h),
              Text(
                "Order fresh snacks & beverages to your desk",
                style: TextStyle(color: mutedColor, fontSize: 11.sp),
              ),

              SizedBox(height: 14.h),

              // 2. Top View Switcher Tabs (Pantry Kiosk vs Orders History)
              Container(
                height: 40.h,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderColor),
                ),
                child: TabBar(
                  controller: _mainTabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    color: const Color(0xFF2979FF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: mutedColor,
                  labelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    const Tab(text: "Pantry Kiosk"),
                    Tab(text: "Orders History (${_allOrdersHistory.length})"),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              // 3. Tab Views Engine
              Expanded(
                child: IndexedStack(
                  index: _mainTabController.index,
                  children: [
                    // TAB 1: PANTRY KIOSK CATALOG
                    Column(
                      children: [
                        // Delivery Location Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      color: const Color(0xFF2979FF),
                                      size: 16.r),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Delivery Location / Floor Description *",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                controller: _floorController,
                                style: TextStyle(
                                    color: textColor, fontSize: 13.sp),
                                decoration: InputDecoration(
                                  hintText:
                                  "e.g. Floor 3, Bay 4-B, Executive Wing...",
                                  hintStyle: TextStyle(
                                      color: mutedColor, fontSize: 12.sp),
                                  filled: true,
                                  fillColor: inputBg,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 10.h),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Category Filter Tags
                        Row(
                          children: ["All", "Drinks", "Snacks"].map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2979FF)
                                      : cardColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2979FF)
                                        : borderColor,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color:
                                    isSelected ? Colors.white : textColor,
                                    fontSize: 12.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 12.h),

                        // Grid View Catalog
                        Expanded(
                          child: GridView.builder(
                            itemCount: filteredItems.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 12.h,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final qty = item["quantity"] as int;

                              return Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: qty > 0
                                        ? const Color(0xFF2979FF)
                                        : borderColor,
                                    width: qty > 0 ? 1.5 : 1.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 18.r,
                                          backgroundColor: (item["color"]
                                          as Color)
                                              .withAlpha(25),
                                          child: Icon(item["imageIcon"],
                                              color: item["color"], size: 18.r),
                                        ),
                                        Text(
                                          "\$${(item["price"] as double).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: const Color(0xFF2979FF),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      item["name"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      item["category"],
                                      style: TextStyle(
                                          color: mutedColor, fontSize: 10.sp),
                                    ),
                                    SizedBox(height: 10.h),

                                    // Quantity Selector Row
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              _updateQuantity(item["id"], -1),
                                          child: Container(
                                            padding: EdgeInsets.all(4.r),
                                            decoration: BoxDecoration(
                                              color: inputBg,
                                              borderRadius:
                                              BorderRadius.circular(6.r),
                                            ),
                                            child: Icon(Icons.remove,
                                                color: textColor, size: 16.r),
                                          ),
                                        ),
                                        Text(
                                          "$qty",
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () =>
                                              _updateQuantity(item["id"], 1),
                                          child: Container(
                                            padding: EdgeInsets.all(4.r),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2979FF),
                                              borderRadius:
                                              BorderRadius.circular(6.r),
                                            ),
                                            child: Icon(Icons.add,
                                                color: Colors.white, size: 16.r),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // Bottom Tray Bar
                        Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$_totalItemsCount Items Selected",
                                    style: TextStyle(
                                        color: mutedColor, fontSize: 11.sp),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "\$${_totalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _placeOrder(isDark),
                                icon: Icon(Icons.shopping_bag_outlined,
                                    size: 16.r),
                                label: Text(
                                  "Dispatch Order",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2979FF),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // TAB 2: ALL USERS ORDERS HISTORY WITH DATE
                    Column(
                      children: [
                        // Search Bar
                        Container(
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: mutedColor, size: 18.r),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: _orderSearchController,
                                  onChanged: (val) => setState(() {}),
                                  style: TextStyle(
                                      color: textColor, fontSize: 13.sp),
                                  decoration: InputDecoration(
                                    hintText:
                                    "Search orders by user, floor, or ID...",
                                    hintStyle: TextStyle(
                                        color: mutedColor, fontSize: 12.sp),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 8.h),
                                  ),
                                ),
                              ),
                              if (_orderSearchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _orderSearchController.clear();
                                    setState(() {});
                                  },
                                  child: Icon(Icons.clear,
                                      color: mutedColor, size: 16.r),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Orders List
                        Expanded(
                          child: filteredOrders.isEmpty
                              ? Center(
                            child: Text(
                              "No order history found",
                              style: TextStyle(
                                  color: mutedColor, fontSize: 12.sp),
                            ),
                          )
                              : ListView.builder(
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = filteredOrders[index];
                              final isDelivered =
                                  order["status"] == "Delivered";

                              return InkWell(
                                onTap: () =>
                                    _showOrderDetailsModal(order, isDark),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius:
                                    BorderRadius.circular(12.r),
                                    border:
                                    Border.all(color: borderColor),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Header Row: User Avatar, Name & Status
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 14.r,
                                                  backgroundColor:
                                                  const Color(
                                                      0xFF1E2838),
                                                  child: Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    color: const Color(
                                                        0xFF2979FF),
                                                    size: 16.r,
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        order["userName"],
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                          textColor,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        order["floor"],
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                          mutedColor,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Status Badge
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 3.h),
                                            decoration: BoxDecoration(
                                              color: isDelivered
                                                  ? const Color(0xFF00E676)
                                                  .withAlpha(25)
                                                  : const Color(0xFFFF9800)
                                                  .withAlpha(25),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.r),
                                              border: Border.all(
                                                color: isDelivered
                                                    ? const Color(
                                                    0xFF00E676)
                                                    : const Color(
                                                    0xFFFF9800),
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Text(
                                              order["status"],
                                              style: TextStyle(
                                                color: isDelivered
                                                    ? const Color(
                                                    0xFF00E676)
                                                    : const Color(
                                                    0xFFFF9800),
                                                fontSize: 10.sp,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10.h),

                                      // Order ID, Date & Total
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                order["orderId"],
                                                style: TextStyle(
                                                  color: const Color(
                                                      0xFF2979FF),
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                "• ${order["date"]}",
                                                style: TextStyle(
                                                    color: mutedColor,
                                                    fontSize: 10.sp),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "\$${(order["totalAmount"] as double).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
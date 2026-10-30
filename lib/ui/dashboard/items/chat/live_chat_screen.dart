import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_screen.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Employee Directory Data
  final List<Map<String, dynamic>> _employees = [
    {
      "name": "Abdul Basit",
      "role": "PHP Developer",
      "time": "1 month ago",
      "avatarText": "A",
      "isOnline": true,
    },
    {
      "name": "Adrain Myron Joshwa M",
      "role": "Associate Vice President",
      "time": "",
      "avatarText": "A",
      "isOnline": true,
    },
    {
      "name": "Ahmer Javed",
      "role": "Senior Sales Executive",
      "time": "never",
      "avatarText": "A",
      "isOnline": true,
    },
    {
      "name": "Ancil Fernandes",
      "role": "Project Manager",
      "time": "1 month ago",
      "avatarText": "A",
      "isOnline": true,
    },
    {
      "name": "Anshara Shaikh",
      "role": "UI/UX Designer",
      "time": "1 week ago",
      "avatarText": "A",
      "isOnline": false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E2026) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble,
                      color: const Color(0xFF2979FF),
                      size: 22.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Employee Directory",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // Search Input Box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: mutedColor, size: 18.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: textColor, fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: "Search employees...",
                          hintStyle: TextStyle(color: mutedColor, fontSize: 13.sp),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // LISTVIEW.BUILDER: Employee Directory List
              Expanded(
                child: ListView.builder(
                  itemCount: _employees.length,
                  itemBuilder: (context, index) {
                    final emp = _employees[index];

                    return Card(
                      color: cardColor,
                      elevation: 0,
                      margin: EdgeInsets.only(bottom: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 22.r,
                              backgroundColor: const Color(0xFF2979FF),
                              child: Text(
                                emp["avatarText"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (emp["isOnline"])
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 11.r,
                                  height: 11.r,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E676),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: cardColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                emp["name"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (emp["time"].isNotEmpty)
                              Text(
                                emp["time"],
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11.sp,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          emp["role"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: mutedColor,
                          size: 20.r,
                        ),
                        onTap: () {
                          // NAVIGATE TO FULL CHAT SCREEN FOR SELECTED USER
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                employee: emp,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

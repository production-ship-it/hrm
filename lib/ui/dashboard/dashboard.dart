import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrms/ui/dashboard/items/attendance/overall_data_screen.dart';
import 'package:hrms/ui/dashboard/items/attendance/request_screen.dart';
import 'package:hrms/ui/dashboard/items/kiosk_screen.dart';
import 'package:hrms/ui/dashboard/items/payroll_screen.dart';
import '../../common/common.dart';
import 'items/attendance/attendance_screen.dart';
import 'items/dialer_screen.dart';
import 'items/leads_screen.dart';
import 'items/chat/live_chat_screen.dart';
import 'items/manage_teams_screen.dart';
import 'items/manage_users_screen.dart';
import 'items/notes_screen.dart';
import 'items/overview_screen.dart';
import 'items/profile_screen.dart';
import 'items/taskboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // Navigation Trackers (Parent index & Sub-item index)
  int _selectedIndex = 0;
  int? _selectedSubIndex;

  bool _isDrawerOpen = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _radiusAnimation;

  // Navigation Items mapped to their destination Screens (including Sub-items)
  late final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.dashboard_rounded,
      label: "Dashboard",
      screen: const OverviewScreen(),
    ),
    _NavItem(
      icon: Icons.chat,
      label: "Live Chat",
      screen: const LiveChatScreen(),
    ),
    _NavItem(
      icon: Icons.manage_accounts,
      label: "Manage Users",
      screen: const ManageUsersScreen(),
    ),
    _NavItem(
      icon: Icons.group,
      label: "Manage Teams",
      screen: const ManageTeamsScreen(),
    ),
    _NavItem(
      icon: Icons.leaderboard_sharp,
      label: "Leads",
      screen: const LeadsScreen(),
    ),
    _NavItem(
      icon: Icons.notes,
      label: "Notes",
      screen: const NotesScreen(),
    ),
    _NavItem(
      icon: Icons.call,
      label: "Dialer",
      screen: const DialerScreen(),
    ),
    _NavItem(
      icon: Icons.task,
      label: "TaskBoard",
      screen: const TaskboardScreen(),
    ),
    _NavItem(
      icon: Icons.calendar_month,
      label: "Attendance",
      subItems: [
        const _NavSubItem(
          label: "Attendance Log",
          icon: Icons.edit_calendar,
          screen: AttendanceScreen(),
        ),
        const _NavSubItem(
          label: "Requests",
          icon: Icons.request_page_outlined,
          screen: RequestScreen(),
        ),
        const _NavSubItem(
          label: "Overall Attendance",
          icon: Icons.assessment_outlined,
          screen: OverallDataScreen(),
        ),
      ],
    ),
    _NavItem(
      icon: Icons.payment_rounded,
      label: "Payroll & Loans",
      screen: const PayrollScreen(),
    ),
    _NavItem(
      icon: Icons.local_drink,
      label: "Kiosk",
      screen: const KioskScreen(),
    ),
    _NavItem(
      icon: Icons.person,
      label: "Profile",
      screen: const ProfileScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 230.w).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _radiusAnimation = Tween<double>(begin: 0.0, end: 24.r).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      if (_isDrawerOpen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  // Get active screen title for AppBar
  String _getActiveTitle() {
    final parent = _navItems[_selectedIndex];
    if (parent.subItems != null && _selectedSubIndex != null) {
      return "${parent.label} • ${parent.subItems![_selectedSubIndex!].label}";
    }
    return parent.label;
  }

  // Get active screen Widget to render in Body
  Widget _getActiveScreen() {
    final parent = _navItems[_selectedIndex];
    if (parent.subItems != null && _selectedSubIndex != null) {
      return parent.subItems![_selectedSubIndex!].screen;
    }
    return parent.screen ?? const OverviewScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      body: Stack(
        children: [
          // 1. Background Side Navigation Drawer
          _buildSideMenu(),

          // 2. Animated Main Screen Host
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_slideAnimation.value, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_radiusAnimation.value),
                    child: child,
                  ),
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                if (_isDrawerOpen) _toggleDrawer();
              },
              child: AbsorbPointer(
                absorbing: _isDrawerOpen,
                child: Scaffold(
                  backgroundColor: primaryDark,
                  appBar: AppBar(
                    backgroundColor: cardDark,
                    elevation: 0,
                    title: Text(
                      _getActiveTitle(),
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: IconButton(
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _animationController,
                        color: textWhite,
                      ),
                      onPressed: _toggleDrawer,
                    ),
                  ),

                  // Displays active screen widget dynamically
                  body: _getActiveScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return SafeArea(
      child: SizedBox(
        width: 230.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: accentRed,
                    child: CircleAvatar(
                      radius: 22.r,
                      backgroundColor: cardDark,
                      backgroundImage: const AssetImage("assets/logo.webp"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alex Morgan",
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "HR Manager",
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: cardDark, height: 1),

            // Navigation List Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                itemCount: _navItems.length,
                itemBuilder: (context, index) {
                  final item = _navItems[index];
                  final isParentSelected = _selectedIndex == index;
                  final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;

                  if (hasSubItems) {
                    // Expandable Sub-Menu Tile (Attendance)
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isParentSelected
                                ? accentRed.withAlpha(20)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isParentSelected ? accentRed : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: isParentSelected,
                            tilePadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                            childrenPadding: EdgeInsets.only(left: 16.w, bottom: 6.h),
                            leading: Icon(
                              item.icon,
                              color: isParentSelected ? accentRed : textMuted,
                              size: 20.r,
                            ),
                            title: Text(
                              item.label,
                              style: TextStyle(
                                color: isParentSelected ? textWhite : textMuted,
                                fontSize: 13.sp,
                                fontWeight:
                                isParentSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            iconColor: isParentSelected ? accentRed : textMuted,
                            collapsedIconColor: textMuted,
                            children: item.subItems!.asMap().entries.map((entry) {
                              final subIndex = entry.key;
                              final subItem = entry.value;
                              final isSubSelected =
                                  isParentSelected && _selectedSubIndex == subIndex;

                              return Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSubSelected
                                        ? accentRed.withAlpha(35)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 0),
                                    leading: Icon(
                                      subItem.icon,
                                      color: isSubSelected ? accentRed : textMuted,
                                      size: 16.r,
                                    ),
                                    title: Text(
                                      subItem.label,
                                      style: TextStyle(
                                        color: isSubSelected ? textWhite : textMuted,
                                        fontSize: 12.sp,
                                        fontWeight: isSubSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                        _selectedSubIndex = subIndex;
                                      });
                                      _toggleDrawer();
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  }

                  // Standard Navigation Item
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isParentSelected
                            ? accentRed.withAlpha(35)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isParentSelected ? accentRed : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                        leading: Icon(
                          item.icon,
                          color: isParentSelected ? accentRed : textMuted,
                          size: 20.r,
                        ),
                        title: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isParentSelected ? textWhite : textMuted,
                            fontSize: 13.sp,
                            fontWeight:
                            isParentSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _selectedSubIndex = null;
                          });
                          _toggleDrawer();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Logout Button
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Container(
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.logout_rounded, color: accentRed),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      color: accentRed,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    _toggleDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Navigation Data Models
class _NavItem {
  final IconData icon;
  final String label;
  final Widget? screen;
  final List<_NavSubItem>? subItems;

  const _NavItem({
    required this.icon,
    required this.label,
    this.screen,
    this.subItems,
  });
}

class _NavSubItem {
  final String label;
  final IconData icon;
  final Widget screen;

  const _NavSubItem({
    required this.label,
    required this.icon,
    required this.screen,
  });
}

class _ScreenTemplate extends StatelessWidget {
  final String title;
  const _ScreenTemplate({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: textWhite,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/common.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  // Financial Overview State Variables
  double _totalTarget = 96420.0;
  double _paidAchievement = 18450.0;

  // Active Metrics
  int _activeTasksCount = 8;
  int _myAssignedTasksCount = 3;
  int _monthlyLeadsCount = 14;

  // Live Clock & Attendance State Variables
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();

  bool _isCheckedIn = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  @override
  void initState() {
    super.initState();
    // Start live clock timer updating every second
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  // Calculate Remaining Balance & Progress Percentage
  double get _remainingBalance =>
      (_totalTarget - _paidAchievement) < 0 ? 0.0 : (_totalTarget - _paidAchievement);

  double get _progressPercentage =>
      _totalTarget > 0 ? ((_paidAchievement / _totalTarget) * 100).clamp(0.0, 100.0) : 0.0;

  // Formatting Time Helpers
  String _formatLiveTime(DateTime dt) {
    int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    String minute = dt.minute.toString().padLeft(2, '0');
    String second = dt.second.toString().padLeft(2, '0');
    String period = dt.hour >= 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:$minute:$second $period";
  }

  String _formatShortTime(DateTime dt) {
    int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    String minute = dt.minute.toString().padLeft(2, '0');
    String period = dt.hour >= 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  String _formatDate(DateTime dt) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return "${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  String _getWorkedDuration() {
    if (_checkInTime == null) return "00h 00m";
    final endTime = _checkOutTime ?? _currentTime;
    final diff = endTime.difference(_checkInTime!);
    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    return "${hours}h ${minutes}m";
  }

  // Edit Financial Summary Modal
  void _showEditFinancialModal(bool isDark) {
    final targetController =
    TextEditingController(text: _totalTarget.toStringAsFixed(0));
    final paidController =
    TextEditingController(text: _paidAchievement.toStringAsFixed(0));
    final formKey = GlobalKey<FormState>();

    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Update Financial Targets",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: mutedTextColor),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildModalInput(
                      controller: targetController,
                      label: "Total Teams Target (\$) *",
                      hint: "96420",
                      textColor: textColor,
                      mutedTextColor: mutedTextColor,
                      inputBg: inputBg,
                    ),
                    SizedBox(height: 12.h),
                    _buildModalInput(
                      controller: paidController,
                      label: "Total Paid Achievement (\$) *",
                      hint: "18450",
                      textColor: textColor,
                      mutedTextColor: mutedTextColor,
                      inputBg: inputBg,
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _totalTarget =
                                  double.tryParse(targetController.text) ?? _totalTarget;
                              _paidAchievement =
                                  double.tryParse(paidController.text) ?? _paidAchievement;
                            });
                            Navigator.pop(dialogContext);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Update Summary",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Color textColor,
    required Color mutedTextColor,
    required Color inputBg,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: textColor, fontSize: 13.sp),
          validator: (val) => val == null || val.trim().isEmpty ? "Required" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: mutedTextColor, fontSize: 12.sp),
            filled: true,
            fillColor: inputBg,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final subCardColor = isDark ? const Color(0xFF25282B) : const Color(0xFFF1F5F9);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor = isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar (Welcome Message & Theme Selector)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Welcome, Super Admin",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "SUPERADMIN",
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF0284C7),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Superadmin@coretechdigitals.com",
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Theme Toggle Dropdown Switcher
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ThemeMode>(
                        value: ThemeController.themeModeNotifier.value,
                        dropdownColor: cardColor,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textColor,
                          size: 18.r,
                        ),
                        onChanged: (ThemeMode? newMode) {
                          if (newMode != null) {
                            ThemeController.toggleTheme(newMode == ThemeMode.dark);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dark_mode_rounded,
                                  color: const Color(0xFFFFB300),
                                  size: 16.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "Dark",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.light_mode_rounded,
                                  color: const Color(0xFFFF9800),
                                  size: 16.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "Light",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 2. LIVE REAL-TIME CLOCK & ATTENDANCE ACTION CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Live Clock & Date Display
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  color: const Color(0xFF2979FF),
                                  size: 18.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  _formatLiveTime(_currentTime),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _formatDate(_currentTime),
                              style: TextStyle(
                                color: mutedTextColor,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),

                        // Check In / Check Out Action Button
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (!_isCheckedIn && _checkOutTime == null) {
                                // Action: Check In
                                _isCheckedIn = true;
                                _checkInTime = DateTime.now();
                              } else if (_isCheckedIn) {
                                // Action: Check Out
                                _isCheckedIn = false;
                                _checkOutTime = DateTime.now();
                              }
                            });
                          },
                          icon: Icon(
                            _isCheckedIn
                                ? Icons.logout_rounded
                                : Icons.login_rounded,
                            size: 16.r,
                          ),
                          label: Text(
                            _checkOutTime != null
                                ? "Completed"
                                : (_isCheckedIn ? "Check Out" : "Check In"),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _checkOutTime != null
                                ? mutedTextColor
                                : (_isCheckedIn
                                ? const Color(0xFFFF5252)
                                : const Color(0xFF00E676)),
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

                    SizedBox(height: 12.h),
                    Divider(height: 1, thickness: 1, color: borderColor),
                    SizedBox(height: 12.h),

                    // Check-In, Check-Out & Worked Hours Logs Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTimeLogTile(
                          label: "Check In",
                          value: _checkInTime != null
                              ? _formatShortTime(_checkInTime!)
                              : "--:--",
                          textColor: textColor,
                          mutedTextColor: mutedTextColor,
                        ),
                        Container(
                            height: 24.h, width: 1.w, color: borderColor),
                        _buildTimeLogTile(
                          label: "Check Out",
                          value: _checkOutTime != null
                              ? _formatShortTime(_checkOutTime!)
                              : "--:--",
                          textColor: textColor,
                          mutedTextColor: mutedTextColor,
                        ),
                        Container(
                            height: 24.h, width: 1.w, color: borderColor),
                        _buildTimeLogTile(
                          label: "Worked Hours",
                          value: _getWorkedDuration(),
                          textColor: const Color(0xFF2979FF),
                          mutedTextColor: mutedTextColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 3. Summary Metric Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSummaryCard(
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      mutedTextColor: mutedTextColor,
                      icon: Icons.grid_view_rounded,
                      iconBgColor: isDark
                          ? const Color(0xFF0D3B3E)
                          : const Color(0xFFE0F7FA),
                      iconColor: const Color(0xFF00E5FF),
                      title: "Total Active Tasks",
                      value: "$_activeTasksCount",
                    ),
                    SizedBox(width: 12.w),
                    _buildSummaryCard(
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      mutedTextColor: mutedTextColor,
                      icon: Icons.person_pin_rounded,
                      iconBgColor: isDark
                          ? const Color(0xFF382F0B)
                          : const Color(0xFFFFF8E1),
                      iconColor: const Color(0xFFFFC107),
                      title: "My Assigned Tasks",
                      value: "$_myAssignedTasksCount",
                    ),
                    SizedBox(width: 12.w),
                    _buildSummaryCard(
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      mutedTextColor: mutedTextColor,
                      icon: Icons.work_outline_rounded,
                      iconBgColor: isDark
                          ? const Color(0xFF0D2545)
                          : const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF2979FF),
                      title: "Monthly Leads (Total)",
                      value: "$_monthlyLeadsCount",
                    ),
                    SizedBox(width: 12.w),
                    _buildSummaryCard(
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      mutedTextColor: mutedTextColor,
                      icon: Icons.account_balance_wallet_outlined,
                      iconBgColor: isDark
                          ? const Color(0xFF0C3822)
                          : const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF00E676),
                      title: "Monthly Achievement",
                      value: "\$${_paidAchievement.toStringAsFixed(0)}",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // 4. Financial Summary Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => _showEditFinancialModal(isDark),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF0D2847)
                                        : const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_rounded,
                                    color: const Color(0xFF00B0FF),
                                    size: 26.r,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Company All Teams Financial Summary",
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "Tap to edit targets & revenue overview",
                                        style: TextStyle(
                                          color: mutedTextColor,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.edit_note_rounded, color: mutedTextColor, size: 20.r),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Overall Progress Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1B4B)
                            : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFF6366F1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            color: const Color(0xFF6366F1),
                            size: 16.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Overall Progress: ${_progressPercentage.toStringAsFixed(1)}%",
                            style: TextStyle(
                              color: const Color(0xFF6366F1),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Target, Paid & Remaining Balance Cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double cardWidth = constraints.maxWidth > 600
                            ? (constraints.maxWidth - 24.w) / 3
                            : constraints.maxWidth;

                        return Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            _buildFinancialMetricCard(
                              width: cardWidth,
                              subCardColor: subCardColor,
                              textColor: textColor,
                              mutedTextColor: mutedTextColor,
                              icon: Icons.flag_rounded,
                              label: "ALL TEAMS TOTAL TARGET",
                              value: "\$${_totalTarget.toStringAsFixed(0)}",
                              valueColor: textColor,
                            ),
                            _buildFinancialMetricCard(
                              width: cardWidth,
                              subCardColor: subCardColor,
                              textColor: textColor,
                              mutedTextColor: mutedTextColor,
                              icon: Icons.check_circle_outline_rounded,
                              label: "TOTAL ACHIEVEMENT (PAID)",
                              value: "\$${_paidAchievement.toStringAsFixed(0)}",
                              valueColor: const Color(0xFF00E676),
                            ),
                            _buildFinancialMetricCard(
                              width: cardWidth,
                              subCardColor: subCardColor,
                              textColor: textColor,
                              mutedTextColor: mutedTextColor,
                              icon: Icons.warning_amber_rounded,
                              label: "TOTAL REMAINING BALANCE",
                              value: "\$${_remainingBalance.toStringAsFixed(0)}",
                              valueColor: const Color(0xFFFFB300),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall Goal Completion",
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${_progressPercentage.toStringAsFixed(1)}% Completed",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: _progressPercentage / 100,
                        minHeight: 8.h,
                        backgroundColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6366F1),
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
    );
  }

  // Time Log Tile Helper Widget
  Widget _buildTimeLogTile({
    required String label,
    required String value,
    required Color textColor,
    required Color mutedTextColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: mutedTextColor, fontSize: 10.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color mutedTextColor,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      width: 175.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialMetricCard({
    required double width,
    required Color subCardColor,
    required Color textColor,
    required Color mutedTextColor,
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: subCardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: mutedTextColor, size: 14.r),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
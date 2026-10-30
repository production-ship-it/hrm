import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverallDataScreen extends StatefulWidget {
  const OverallDataScreen({super.key});

  @override
  State<OverallDataScreen> createState() => _OverallDataScreenState();
}

class _OverallDataScreenState extends State<OverallDataScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  // Registered Users List
  final List<String> _usersList = [
    "Muhammad Arham Farooqui",
    "Minham Khanzada",
    "Arsalan Alvi",
    "Syed Muhammad Mubashir",
    "Fahad Bhutto",
    "Dua Irfan",
  ];

  late String _selectedUser;

  // Complete Attendance Dataset grouped by User
  final Map<String, List<Map<String, dynamic>>> _userAttendanceHistory = {
    "Muhammad Arham Farooqui": [
      {
        "date": "2026-10-23",
        "checkIn": "09:00 AM",
        "checkOut": "05:00 PM",
        "breakTime": "45 mins",
        "totalHours": "7h 15m",
        "status": "Present",
      },
      {
        "date": "2026-10-22",
        "checkIn": "09:25 AM",
        "checkOut": "05:30 PM",
        "breakTime": "30 mins",
        "totalHours": "7h 35m",
        "status": "Late",
      },
      {
        "date": "2026-10-21",
        "checkIn": "08:55 AM",
        "checkOut": "05:00 PM",
        "breakTime": "40 mins",
        "totalHours": "7h 25m",
        "status": "Present",
      },
      {
        "date": "2026-10-20",
        "checkIn": "-- : --",
        "checkOut": "-- : --",
        "breakTime": "0 mins",
        "totalHours": "0h 00m",
        "status": "Absent",
      },
      {
        "date": "2026-10-19",
        "checkIn": "09:00 AM",
        "checkOut": "01:00 PM",
        "breakTime": "15 mins",
        "totalHours": "3h 45m",
        "status": "Half-Day",
      },
    ],
    "Minham Khanzada": [
      {
        "date": "2026-10-23",
        "checkIn": "08:45 AM",
        "checkOut": "05:15 PM",
        "breakTime": "30 mins",
        "totalHours": "8h 00m",
        "status": "Present",
      },
      {
        "date": "2026-10-22",
        "checkIn": "08:50 AM",
        "checkOut": "05:00 PM",
        "breakTime": "45 mins",
        "totalHours": "7h 25m",
        "status": "Present",
      },
    ],
    "Arsalan Alvi": [
      {
        "date": "2026-10-23",
        "checkIn": "09:15 AM",
        "checkOut": "05:15 PM",
        "breakTime": "1 hour",
        "totalHours": "7h 00m",
        "status": "Late",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedUser = _usersList.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Pick Date Range
  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Filter Attendance Log by Selected User and Date Range
  List<Map<String, dynamic>> _getFilteredLogs() {
    final rawLogs = _userAttendanceHistory[_selectedUser] ?? [];

    return rawLogs.where((log) {
      if (_selectedDateRange != null) {
        final logDate = DateTime.parse(log["date"]);
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end.add(const Duration(days: 1));
        if (logDate.isBefore(start) || logDate.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }

  // Attendance Detail Popup Modal
  void _showLogDetailModal(Map<String, dynamic> log, bool isDark) {
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
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
                          _selectedUser,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Record Date: ${log["date"]}",
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
                Divider(color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15)),
                SizedBox(height: 12.h),

                _buildDetailTile("Status", log["status"], Icons.badge_outlined, textColor, mutedColor, inputBg),
                SizedBox(height: 8.h),
                _buildDetailTile("Check-In Time", log["checkIn"], Icons.login_rounded, textColor, mutedColor, inputBg),
                SizedBox(height: 8.h),
                _buildDetailTile("Check-Out Time", log["checkOut"], Icons.logout_rounded, textColor, mutedColor, inputBg),
                SizedBox(height: 8.h),
                _buildDetailTile("Break Duration", log["breakTime"], Icons.free_breakfast_outlined, textColor, mutedColor, inputBg),
                SizedBox(height: 8.h),
                _buildDetailTile("Total Worked Hours", log["totalHours"], Icons.access_time_rounded, textColor, mutedColor, inputBg),

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
                    child: Text("Close", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailTile(
      String label,
      String value,
      IconData icon,
      Color textColor,
      Color mutedColor,
      Color bg,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: mutedColor, size: 16.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: mutedColor, fontSize: 10.sp)),
                SizedBox(height: 2.h),
                Text(
                  value,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final tableHeaderBg = isDark ? const Color(0xFF111726) : const Color(0xFFF1F5F9);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor = isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);

    final filteredLogs = _getFilteredLogs();

    // Individual User Stats Calculations
    final presentDays = filteredLogs.where((l) => l["status"] == "Present").length;
    final lateDays = filteredLogs.where((l) => l["status"] == "Late").length;
    final absentDays = filteredLogs.where((l) => l["status"] == "Absent").length;
    final halfDays = filteredLogs.where((l) => l["status"] == "Half-Day").length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header Title
              Text(
                "Overall Attendance History",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16.h),

              // 1. Employee Dropdown & Search Bar Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedUser,
                          isExpanded: true,
                          dropdownColor: cardColor,
                          icon: Icon(Icons.arrow_drop_down, color: mutedColor),
                          items: _usersList.map((user) {
                            return DropdownMenuItem<String>(
                              value: user,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12.r,
                                    backgroundColor: const Color(0xFF2979FF),
                                    child: Icon(Icons.person, color: Colors.white, size: 12.r),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      user,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedUser = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Date Range Filter Button
                  InkWell(
                    onTap: () => _pickDateRange(context),
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: _selectedDateRange != null
                            ? const Color(0xFF2979FF)
                            : cardColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _selectedDateRange != null
                              ? const Color(0xFF2979FF)
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: _selectedDateRange != null
                                ? Colors.white
                                : mutedColor,
                            size: 16.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            _selectedDateRange == null
                                ? "Date Filter"
                                : "${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}",
                            style: TextStyle(
                              color: _selectedDateRange != null
                                  ? Colors.white
                                  : textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_selectedDateRange != null) ...[
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDateRange = null;
                                });
                              },
                              child: Icon(Icons.close, color: Colors.white, size: 14.r),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 2. Individual Employee Metrics Row Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMetricCard("Days Present", "$presentDays", Icons.check_circle_outline_rounded, const Color(0xFF00E676), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildMetricCard("Late Arrivals", "$lateDays", Icons.access_time_rounded, const Color(0xFFFFC107), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildMetricCard("Days Absent", "$absentDays", Icons.highlight_off_rounded, const Color(0xFFFF5252), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildMetricCard("Half Days", "$halfDays", Icons.timelapse_rounded, const Color(0xFF6366F1), cardColor, textColor, mutedColor, borderColor),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 3. Complete Attendance History Table
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      // Table Title Header
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Logs for $_selectedUser",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "${filteredLogs.length} Records Found",
                              style: TextStyle(color: mutedColor, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),

                      // Horizontal Scrollable Attendance Logs
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 700.w,
                            child: Column(
                              children: [
                                // Table Header Bar
                                Container(
                                  color: tableHeaderBg,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 12.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 120.w,
                                        child: _buildHeaderCell("DATE", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell("CHECK-IN", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell("CHECK-OUT", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell("BREAK", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell("TOTAL HOURS", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: _buildHeaderCell("STATUS", textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Attendance Rows List
                                Expanded(
                                  child: filteredLogs.isEmpty
                                      ? Center(
                                    child: Text(
                                      "No attendance records found for criteria",
                                      style: TextStyle(color: mutedColor, fontSize: 12.sp),
                                    ),
                                  )
                                      : ListView.separated(
                                    itemCount: filteredLogs.length,
                                    separatorBuilder: (context, index) => Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: borderColor,
                                    ),
                                    itemBuilder: (context, index) {
                                      final log = filteredLogs[index];
                                      final status = log["status"] as String;

                                      Color statusColor;
                                      switch (status) {
                                        case "Present":
                                          statusColor = const Color(0xFF00E676);
                                          break;
                                        case "Late":
                                          statusColor = const Color(0xFFFFC107);
                                          break;
                                        case "Absent":
                                          statusColor = const Color(0xFFFF5252);
                                          break;
                                        default:
                                          statusColor = const Color(0xFF6366F1);
                                      }

                                      return InkWell(
                                        onTap: () => _showLogDetailModal(log, isDark),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14.w, vertical: 12.h),
                                          child: Row(
                                            children: [
                                              // 1. Date
                                              SizedBox(
                                                width: 120.w,
                                                child: Text(
                                                  log["date"],
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              // 2. Check-In
                                              SizedBox(
                                                width: 110.w,
                                                child: Text(
                                                  log["checkIn"],
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),

                                              // 3. Check-Out
                                              SizedBox(
                                                width: 110.w,
                                                child: Text(
                                                  log["checkOut"],
                                                  style: TextStyle(
                                                    color: log["checkOut"] == "-- : --"
                                                        ? mutedColor
                                                        : textColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),

                                              // 4. Break Time
                                              SizedBox(
                                                width: 110.w,
                                                child: Text(
                                                  log["breakTime"],
                                                  style: TextStyle(
                                                    color: const Color(0xFFFF9800),
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),

                                              // 5. Total Hours
                                              SizedBox(
                                                width: 110.w,
                                                child: Text(
                                                  log["totalHours"],
                                                  style: TextStyle(
                                                    color: const Color(0xFF2979FF),
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              // 6. Status Badge
                                              SizedBox(
                                                width: 110.w,
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 3.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: statusColor.withAlpha(25),
                                                      borderRadius: BorderRadius.circular(10.r),
                                                      border: Border.all(
                                                          color: statusColor, width: 0.8),
                                                    ),
                                                    child: Text(
                                                      status,
                                                      style: TextStyle(
                                                        color: statusColor,
                                                        fontSize: 10.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                          ),
                        ),
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
  }

  // Metric Card Helper
  Widget _buildMetricCard(
      String title,
      String value,
      IconData icon,
      Color iconColor,
      Color cardColor,
      Color textColor,
      Color mutedColor,
      Color borderColor,
      ) {
    return Container(
      width: 135.w,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: mutedColor, fontSize: 10.sp),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(icon, color: iconColor, size: 16.r),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}
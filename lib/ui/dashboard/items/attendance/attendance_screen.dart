import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Attendance Records Dataset with Break Time added
  final List<Map<String, dynamic>> _attendanceList = [
    {
      "name": "Muhammad Arham Farooqui",
      "designation": "CMS Developer",
      "department": "Engineering",
      "isActive": true,
      "checkIn": "09:00 AM",
      "checkOut": "-- : --",
      "breakTime": "45 mins",
      "totalHours": "7h 15m",
    },
    {
      "name": "Minham Khanzada",
      "designation": "Fullstack Developer",
      "department": "Engineering",
      "isActive": true,
      "checkIn": "08:45 AM",
      "checkOut": "-- : --",
      "breakTime": "30 mins",
      "totalHours": "7h 30m",
    },
    {
      "name": "Arsalan Alvi",
      "designation": "Brand Designer",
      "department": "Creative",
      "isActive": false,
      "checkIn": "09:15 AM",
      "checkOut": "05:15 PM",
      "breakTime": "1 hour",
      "totalHours": "8h 00m",
    },
    {
      "name": "Syed Muhammad Mubashir",
      "designation": "CMS Developer",
      "department": "Engineering",
      "isActive": true,
      "checkIn": "09:05 AM",
      "checkOut": "-- : --",
      "breakTime": "45 mins",
      "totalHours": "7h 10m",
    },
    {
      "name": "Fahad Bhutto",
      "designation": "Performance Marketer",
      "department": "Marketing",
      "isActive": false,
      "checkIn": "-- : --",
      "checkOut": "-- : --",
      "breakTime": "0 mins",
      "totalHours": "0h 00m",
    },
    {
      "name": "Dua Irfan",
      "designation": "Senior Content Writer",
      "department": "Marketing",
      "isActive": true,
      "checkIn": "08:55 AM",
      "checkOut": "-- : --",
      "breakTime": "35 mins",
      "totalHours": "7h 20m",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Show Attendance Adjustment Modal Sheet
  void _showAdjustmentModal(
      BuildContext context,
      Map<String, dynamic> record,
      int index,
      bool isDark,
      ) {
    final checkInController =
    TextEditingController(text: record["checkIn"] == "-- : --" ? "" : record["checkIn"]);
    final checkOutController =
    TextEditingController(text: record["checkOut"] == "-- : --" ? "" : record["checkOut"]);
    final breakTimeController =
    TextEditingController(text: record["breakTime"]);
    final hoursController =
    TextEditingController(text: record["totalHours"]);
    final reasonController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20.h,
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Attendance Adjustment",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            record["name"],
                            style: TextStyle(color: mutedColor, fontSize: 12.sp),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: mutedColor),
                        onPressed: () => Navigator.pop(modalContext),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Check-In & Check-Out Time Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          controller: checkInController,
                          label: "Check-In Time",
                          hint: "09:00 AM",
                          icon: Icons.login_rounded,
                          textColor: textColor,
                          mutedColor: mutedColor,
                          inputBg: inputBg,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _buildModalTextField(
                          controller: checkOutController,
                          label: "Check-Out Time",
                          hint: "05:00 PM",
                          icon: Icons.logout_rounded,
                          textColor: textColor,
                          mutedColor: mutedColor,
                          inputBg: inputBg,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Break Time & Total Hours Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          controller: breakTimeController,
                          label: "Break Time",
                          hint: "e.g. 45 mins",
                          icon: Icons.free_breakfast_outlined,
                          textColor: textColor,
                          mutedColor: mutedColor,
                          inputBg: inputBg,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _buildModalTextField(
                          controller: hoursController,
                          label: "Adjust Total Hours",
                          hint: "e.g. 8h 00m",
                          icon: Icons.access_time_rounded,
                          textColor: textColor,
                          mutedColor: mutedColor,
                          inputBg: inputBg,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Adjustment Note / Reason
                  _buildModalTextField(
                    controller: reasonController,
                    label: "Reason for Adjustment",
                    hint: "e.g. Forgot to scan out / Machine error",
                    icon: Icons.note_alt_outlined,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    inputBg: inputBg,
                    maxLines: 2,
                  ),

                  SizedBox(height: 24.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            _attendanceList[index]["checkIn"] =
                            checkInController.text.trim().isEmpty
                                ? "-- : --"
                                : checkInController.text.trim();
                            _attendanceList[index]["checkOut"] =
                            checkOutController.text.trim().isEmpty
                                ? "-- : --"
                                : checkOutController.text.trim();
                            _attendanceList[index]["breakTime"] =
                                breakTimeController.text.trim();
                            _attendanceList[index]["totalHours"] =
                                hoursController.text.trim();
                          });
                          Navigator.pop(modalContext);
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
                        "Apply Adjustment",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color textColor,
    required Color mutedColor,
    required Color inputBg,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: textColor, fontSize: 13.sp),
          validator: (val) =>
          val == null || val.trim().isEmpty ? "Required field" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
            prefixIcon: Icon(icon, color: mutedColor, size: 18.r),
            filled: true,
            fillColor: inputBg,
            isDense: true,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final tableHeaderBg =
    isDark ? const Color(0xFF111726) : const Color(0xFFF1F5F9);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor =
    isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);

    final activeCount = _attendanceList.where((a) => a["isActive"]).length;
    final totalCount = _attendanceList.length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Date & Header Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Attendance Tracker",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Friday, 23 Oct 2026",
                        style: TextStyle(color: mutedColor, fontSize: 12.sp),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withAlpha(25),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFF00E676),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00E676),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "$activeCount/$totalCount Active",
                          style: TextStyle(
                            color: const Color(0xFF00E676),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Summary Stats Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard("Total Employees", "$totalCount", Icons.people_outline_rounded, const Color(0xFF2979FF), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildStatCard("Present Today", "$activeCount", Icons.check_circle_outline_rounded, const Color(0xFF00E676), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildStatCard("Absent / Off", "${totalCount - activeCount}", Icons.highlight_off_rounded, const Color(0xFFFF5252), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildStatCard("Late Arrival", "2 Users", Icons.access_time_rounded, const Color(0xFFFFC107), cardColor, textColor, mutedColor, borderColor),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Main Attendance List Panel
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      // Panel Header with Search
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          children: [
                            Text(
                              "Daily Attendance Log",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6.h,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 36.h,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E222A)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(
                                    color: textColor, fontSize: 12.sp),
                                decoration: InputDecoration(
                                  hintText: "Search employee...",
                                  hintStyle: TextStyle(
                                      color: mutedColor, fontSize: 12.sp),
                                  prefixIcon: Icon(Icons.search,
                                      color: mutedColor, size: 16.r),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.h),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Horizontal Scrollable Attendance Table
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 930.w, // Extended table width for Break Time column
                            child: Column(
                              children: [
                                // Table Header Bar
                                Container(
                                  color: tableHeaderBg,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 180.w,
                                        child: _buildHeaderCell(
                                            "EMPLOYEE", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell(
                                            "STATUS", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell(
                                            "CHECK-IN", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell(
                                            "CHECK-OUT", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell(
                                            "BREAK TIME", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: _buildHeaderCell(
                                            "TOTAL HOURS", textColor),
                                      ),
                                      SizedBox(
                                        width: 140.w,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: _buildHeaderCell(
                                              "ADJUSTMENT", textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Attendance Rows List
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: _attendanceList.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: borderColor,
                                        ),
                                    itemBuilder: (context, index) {
                                      final record = _attendanceList[index];
                                      final isActive = record["isActive"] as bool;

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            // 1. Employee Name & Department
                                            SizedBox(
                                              width: 180.w,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 14.r,
                                                    backgroundColor:
                                                    const Color(0xFF1E2838),
                                                    child: Icon(
                                                      Icons.person_outline_rounded,
                                                      color: const Color(0xFF2979FF),
                                                      size: 16.r,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          record["name"],
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${record["designation"]} • ${record["department"]}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: mutedColor,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // 2. Status Badge
                                            SizedBox(
                                              width: 110.w,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 3.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? const Color(0xFF00E676).withAlpha(25)
                                                        : const Color(0xFFFF5252).withAlpha(25),
                                                    borderRadius: BorderRadius.circular(12.r),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 6.r,
                                                        height: 6.r,
                                                        decoration: BoxDecoration(
                                                          color: isActive
                                                              ? const Color(0xFF00E676)
                                                              : const Color(0xFFFF5252),
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Text(
                                                        isActive ? "Active" : "Inactive",
                                                        style: TextStyle(
                                                          color: isActive
                                                              ? const Color(0xFF00E676)
                                                              : const Color(0xFFFF5252),
                                                          fontSize: 10.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // 3. Check-In Time
                                            SizedBox(
                                              width: 110.w,
                                              child: Text(
                                                record["checkIn"],
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            // 4. Check-Out Time
                                            SizedBox(
                                              width: 110.w,
                                              child: Text(
                                                record["checkOut"],
                                                style: TextStyle(
                                                  color: record["checkOut"] == "-- : --"
                                                      ? mutedColor
                                                      : textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            // 5. Break Time
                                            SizedBox(
                                              width: 110.w,
                                              child: Text(
                                                record["breakTime"],
                                                style: TextStyle(
                                                  color: const Color(0xFFFF9800),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            // 6. Total Hours
                                            SizedBox(
                                              width: 110.w,
                                              child: Text(
                                                record["totalHours"],
                                                style: TextStyle(
                                                  color: const Color(0xFF2979FF),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            // 7. Adjustment Action Button
                                            SizedBox(
                                              width: 140.w,
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: OutlinedButton.icon(
                                                  onPressed: () => _showAdjustmentModal(
                                                    context,
                                                    record,
                                                    index,
                                                    isDark,
                                                  ),
                                                  icon: Icon(
                                                    Icons.tune_rounded,
                                                    size: 13.r,
                                                    color: const Color(0xFF2979FF),
                                                  ),
                                                  label: Text(
                                                    "Adjust",
                                                    style: TextStyle(
                                                      color: const Color(0xFF2979FF),
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  style: OutlinedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 4.h,
                                                    ),
                                                    side: const BorderSide(
                                                      color: Color(0xFF2979FF),
                                                      width: 1,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6.r),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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

  // Summary Stat Card Helper
  Widget _buildStatCard(
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
              Text(
                title,
                style: TextStyle(color: mutedColor, fontSize: 10.sp),
              ),
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
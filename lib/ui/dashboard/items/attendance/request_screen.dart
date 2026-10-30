import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Attendance Requests Dataset
  final List<Map<String, dynamic>> _requestsList = [
    {
      "id": "1",
      "name": "Muhammad Arham Farooqui",
      "department": "Engineering",
      "requestType": "Check-In Adjustment",
      "requestDate": "23 Oct 2026",
      "reason": "Fingerprint scanner glitch on arrival at 09:00 AM.",
      "status": "Pending",
    },
    {
      "id": "2",
      "name": "Minham Khanzada",
      "department": "Engineering",
      "requestType": "Overtime Approval",
      "requestDate": "22 Oct 2026",
      "reason": "Extended work hours to release production build hotfix.",
      "status": "Approved",
    },
    {
      "id": "3",
      "name": "Arsalan Alvi",
      "department": "Creative",
      "requestType": "Half-Day Leave",
      "requestDate": "21 Oct 2026",
      "reason": "Personal medical appointment in the afternoon.",
      "status": "Rejected",
    },
    {
      "id": "4",
      "name": "Dua Irfan",
      "department": "Marketing",
      "requestType": "Check-Out Adjustment",
      "requestDate": "20 Oct 2026",
      "reason": "Forgot to scan out due to late client strategy meeting.",
      "status": "Pending",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter requests based on Active Tab & Search Query
  List<Map<String, dynamic>> _getFilteredRequests() {
    final query = _searchController.text.trim().toLowerCase();

    return _requestsList.where((item) {
      // 1. Tab Status Filtering
      if (_tabController.index == 1 && item["status"] != "Pending") return false;
      if (_tabController.index == 2 && item["status"] != "Approved") return false;
      if (_tabController.index == 3 && item["status"] != "Rejected") return false;

      // 2. Search Query Filtering (Name or Department)
      if (query.isNotEmpty) {
        final name = item["name"].toString().toLowerCase();
        final dept = item["department"].toString().toLowerCase();
        if (!name.contains(query) && !dept.contains(query)) return false;
      }

      return true;
    }).toList();
  }

  // Show Modal to Submit New Request
  void _showNewRequestModal(BuildContext context, bool isDark) {
    final nameController = TextEditingController();
    final deptController = TextEditingController();
    final dateController = TextEditingController();
    final reasonController = TextEditingController();

    String selectedType = "Check-In Adjustment";
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
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                          Text(
                            "New Attendance Request",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, color: mutedColor),
                            onPressed: () => Navigator.pop(modalContext),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Requester Name
                      _buildModalTextField(
                        controller: nameController,
                        label: "Employee Name",
                        hint: "e.g. Alex Morgan",
                        icon: Icons.person_outline_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Department & Request Type Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalTextField(
                              controller: deptController,
                              label: "Department",
                              hint: "e.g. Engineering",
                              icon: Icons.business_outlined,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Request Type",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedType,
                                      isExpanded: true,
                                      dropdownColor: cardColor,
                                      icon: Icon(Icons.arrow_drop_down, color: mutedColor),
                                      items: [
                                        "Check-In Adjustment",
                                        "Check-Out Adjustment",
                                        "Overtime Approval",
                                        "Half-Day Leave",
                                      ]
                                          .map((t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(
                                          t,
                                          style: TextStyle(color: textColor, fontSize: 11.sp),
                                        ),
                                      ))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setModalState(() => selectedType = val);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Requested Date
                      _buildModalTextField(
                        controller: dateController,
                        label: "Requested Date",
                        hint: "e.g. 26 Oct 2026",
                        icon: Icons.calendar_today_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Reason
                      _buildModalTextField(
                        controller: reasonController,
                        label: "Reason / Justification",
                        hint: "Provide details for this request...",
                        icon: Icons.notes_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                        maxLines: 2,
                      ),

                      SizedBox(height: 24.h),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _requestsList.insert(0, {
                                  "id": DateTime.now().millisecondsSinceEpoch.toString(),
                                  "name": nameController.text.trim(),
                                  "department": deptController.text.trim(),
                                  "requestType": selectedType,
                                  "requestDate": dateController.text.trim(),
                                  "reason": reasonController.text.trim(),
                                  "status": "Pending",
                                });
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
                            "Submit Request",
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
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor = isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

    // Counts Calculation
    final totalCount = _requestsList.length;
    final pendingCount = _requestsList.where((r) => r["status"] == "Pending").length;
    final approvedCount = _requestsList.where((r) => r["status"] == "Approved").length;
    final rejectedCount = _requestsList.where((r) => r["status"] == "Rejected").length;

    final filteredRequests = _getFilteredRequests();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title Header & "+ New Request" Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Attendance Requests",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showNewRequestModal(context, isDark),
                    icon: Icon(Icons.add_circle_outline_rounded, size: 16.r),
                    label: Text(
                      "New Request",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      foregroundColor: Colors.white,
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 1. Metric Stat Summary Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard("Total Requests", "$totalCount", Icons.folder_open_rounded, const Color(0xFF2979FF), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildStatCard("Pending", "$pendingCount", Icons.hourglass_empty_rounded, const Color(0xFFFFC107), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildStatCard("Approved", "$approvedCount", Icons.check_circle_outline_rounded, const Color(0xFF00E676), cardColor, textColor, mutedColor, borderColor),
                    SizedBox(width: 10.w),
                    _buildStatCard("Rejected", "$rejectedCount", Icons.cancel_outlined, const Color(0xFFFF5252), cardColor, textColor, mutedColor, borderColor),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 2. Search Field
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
                        controller: _searchController,
                        onChanged: (val) => setState(() {}),
                        style: TextStyle(color: textColor, fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: "Search requester name or department...",
                          hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        child: Icon(Icons.clear, color: mutedColor, size: 16.r),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 3. Category Tabs (All / Pending / Approved / Rejected)
              Container(
                height: 42.h,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderColor),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  indicator: BoxDecoration(
                    color: const Color(0xFF2979FF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: mutedColor,
                  labelStyle: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: "All ($totalCount)"),
                    Tab(text: "Pending ($pendingCount)"),
                    Tab(text: "Approved ($approvedCount)"),
                    Tab(text: "Rejected ($rejectedCount)"),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // 4. Requests List View
              Expanded(
                child: filteredRequests.isEmpty
                    ? Center(
                  child: Text(
                    "No attendance requests found",
                    style: TextStyle(color: mutedColor, fontSize: 13.sp),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final req = filteredRequests[index];
                    final status = req["status"] as String;

                    Color statusColor;
                    switch (status) {
                      case "Approved":
                        statusColor = const Color(0xFF00E676);
                        break;
                      case "Rejected":
                        statusColor = const Color(0xFFFF5252);
                        break;
                      default:
                        statusColor = const Color(0xFFFFC107);
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1: Requester Avatar, Name, Dept & Status Badge
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16.r,
                                        backgroundColor:
                                        const Color(0xFF1E2838),
                                        child: Icon(
                                          Icons.person_outline_rounded,
                                          color: const Color(0xFF2979FF),
                                          size: 18.r,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              req["name"],
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${req["department"]} Department",
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

                                // Status Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withAlpha(25),
                                    borderRadius:
                                    BorderRadius.circular(12.r),
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
                              ],
                            ),

                            SizedBox(height: 10.h),

                            // Request Type Tag & Requested Date
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius:
                                    BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    req["requestType"],
                                    style: TextStyle(
                                      color: const Color(0xFF2979FF),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded,
                                        color: mutedColor, size: 12.r),
                                    SizedBox(width: 4.w),
                                    Text(
                                      req["requestDate"],
                                      style: TextStyle(
                                        color: mutedColor,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 8.h),

                            // Reason Snippet
                            Text(
                              req["reason"],
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12.sp,
                              ),
                            ),

                            // Quick Action Buttons for Pending Items
                            if (status == "Pending") ...[
                              SizedBox(height: 10.h),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: isDark
                                    ? Colors.white.withAlpha(10)
                                    : Colors.black.withAlpha(10),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        req["status"] = "Rejected";
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 4.h),
                                      side: const BorderSide(
                                          color: Color(0xFFFF5252)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(6.r),
                                      ),
                                    ),
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(
                                        color: const Color(0xFFFF5252),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        req["status"] = "Approved";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF00E676),
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 4.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(6.r),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Approve",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
    );
  }

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
}
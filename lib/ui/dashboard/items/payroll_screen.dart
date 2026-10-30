import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _selectedMonth = "October 2026";

  // 1. Employee Salary Structure Dataset
  final List<Map<String, dynamic>> _salaryStructures = [
    {
      "name": "Muhammad Arham Farooqui",
      "designation": "CMS Developer",
      "department": "Engineering",
      "baseSalary": 5500.0,
      "allowances": 800.0,
      "deductions": 300.0,
      "netSalary": 6000.0,
      "paymentStatus": "Paid",
    },
    {
      "name": "Minham Khanzada",
      "designation": "Fullstack Developer",
      "department": "Engineering",
      "baseSalary": 6200.0,
      "allowances": 1000.0,
      "deductions": 400.0,
      "netSalary": 6800.0,
      "paymentStatus": "Paid",
    },
    {
      "name": "Arsalan Alvi",
      "designation": "Brand Designer",
      "department": "Creative",
      "baseSalary": 4800.0,
      "allowances": 600.0,
      "deductions": 200.0,
      "netSalary": 5200.0,
      "paymentStatus": "Pending",
    },
    {
      "name": "Dua Irfan",
      "designation": "Senior Content Writer",
      "department": "Marketing",
      "baseSalary": 4500.0,
      "allowances": 500.0,
      "deductions": 200.0,
      "netSalary": 4800.0,
      "paymentStatus": "Pending",
    },
  ];

  // 2. Comprehensive Monthly History with Every Employee's Data
  final List<Map<String, dynamic>> _monthlyHistory = [
    {
      "month": "October 2026",
      "totalDisbursed": "\$22,800",
      "disbursementDate": "28 Oct 2026",
      "status": "Processing",
      "employees": [
        {
          "name": "Muhammad Arham Farooqui",
          "designation": "CMS Developer",
          "baseSalary": "\$5,500",
          "allowances": "+\$800",
          "deductions": "-\$300",
          "netSalary": "\$6,000",
          "status": "Paid",
        },
        {
          "name": "Minham Khanzada",
          "designation": "Fullstack Developer",
          "baseSalary": "\$6,200",
          "allowances": "+\$1,000",
          "deductions": "-\$400",
          "netSalary": "\$6,800",
          "status": "Paid",
        },
        {
          "name": "Arsalan Alvi",
          "designation": "Brand Designer",
          "baseSalary": "\$4,800",
          "allowances": "+\$600",
          "deductions": "-\$200",
          "netSalary": "\$5,200",
          "status": "Pending",
        },
        {
          "name": "Dua Irfan",
          "designation": "Senior Content Writer",
          "baseSalary": "\$4,500",
          "allowances": "+\$500",
          "deductions": "-\$200",
          "netSalary": "\$4,800",
          "status": "Pending",
        },
      ],
    },
    {
      "month": "September 2026",
      "totalDisbursed": "\$21,500",
      "disbursementDate": "30 Sep 2026",
      "status": "Completed",
      "employees": [
        {
          "name": "Muhammad Arham Farooqui",
          "designation": "CMS Developer",
          "baseSalary": "\$5,500",
          "allowances": "+\$500",
          "deductions": "-\$200",
          "netSalary": "\$5,800",
          "status": "Paid",
        },
        {
          "name": "Minham Khanzada",
          "designation": "Fullstack Developer",
          "baseSalary": "\$6,200",
          "allowances": "+\$800",
          "deductions": "-\$300",
          "netSalary": "\$6,700",
          "status": "Paid",
        },
        {
          "name": "Arsalan Alvi",
          "designation": "Brand Designer",
          "baseSalary": "\$4,800",
          "allowances": "+\$400",
          "deductions": "-\$200",
          "netSalary": "\$5,000",
          "status": "Paid",
        },
        {
          "name": "Dua Irfan",
          "designation": "Senior Content Writer",
          "baseSalary": "\$4,500",
          "allowances": "+\$300",
          "deductions": "-\$800",
          "netSalary": "\$4,000",
          "status": "Paid",
        },
      ],
    },
    {
      "month": "August 2026",
      "totalDisbursed": "\$20,800",
      "disbursementDate": "31 Aug 2026",
      "status": "Completed",
      "employees": [
        {
          "name": "Muhammad Arham Farooqui",
          "designation": "CMS Developer",
          "baseSalary": "\$5,500",
          "allowances": "+\$400",
          "deductions": "-\$200",
          "netSalary": "\$5,700",
          "status": "Paid",
        },
        {
          "name": "Minham Khanzada",
          "designation": "Fullstack Developer",
          "baseSalary": "\$6,200",
          "allowances": "+\$700",
          "deductions": "-\$300",
          "netSalary": "\$6,600",
          "status": "Paid",
        },
      ],
    },
  ];

  // 3. Payroll Requests Dataset
  final List<Map<String, dynamic>> _payrollRequests = [
    {
      "id": "1",
      "name": "Syed Muhammad Mubashir",
      "department": "Engineering",
      "type": "Advance Salary",
      "amount": "\$1,200",
      "requestDate": "24 Oct 2026",
      "reason": "Emergency medical expenses for family member.",
      "status": "Pending",
    },
    {
      "id": "2",
      "name": "Fahad Bhutto",
      "department": "Marketing",
      "type": "Performance Bonus",
      "amount": "\$500",
      "requestDate": "22 Oct 2026",
      "reason": "Exceeded quarterly PPC ad conversion targets.",
      "status": "Approved",
    },
    {
      "id": "3",
      "name": "Arsalan Alvi",
      "department": "Creative",
      "type": "Expense Reimbursement",
      "amount": "\$250",
      "requestDate": "19 Oct 2026",
      "reason": "Purchased stock photography license assets.",
      "status": "Rejected",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Show Payslip Modal Dialog
  void _showPayslipModal(Map<String, dynamic> item, bool isDark) {
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
                            "Official Payslip",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Period: $_selectedMonth",
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

                  _buildDetailTile("Employee", item["name"], Icons.person_outline_rounded, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Department / Role", "${item["department"]} • ${item["designation"]}", Icons.badge_outlined, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Base Pay", "\$${item["baseSalary"]}", Icons.payments_outlined, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Total Allowances", "+\$${item["allowances"]}", Icons.add_circle_outline, textColor, const Color(0xFF00E676), inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Total Deductions", "-\$${item["deductions"]}", Icons.remove_circle_outline, textColor, const Color(0xFFFF5252), inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Net Disbursed Pay", "\$${item["netSalary"]}", Icons.account_balance_wallet_outlined, const Color(0xFF2979FF), mutedColor, inputBg),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Downloading Payslip PDF...")),
                            );
                          },
                          icon: Icon(Icons.download_rounded, size: 16.r, color: const Color(0xFF2979FF)),
                          label: Text("Download PDF", style: TextStyle(color: const Color(0xFF2979FF), fontSize: 12.sp)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2979FF)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

    // Dynamic Calculations
    double totalPayroll = _salaryStructures.fold(0, (sum, item) => sum + (item["netSalary"] as double));
    double paidTotal = _salaryStructures
        .where((item) => item["paymentStatus"] == "Paid")
        .fold(0, (sum, item) => sum + (item["netSalary"] as double));
    double pendingTotal = totalPayroll - paidTotal;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Title Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payroll Management",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Salary structure & payouts for $_selectedMonth",
                    style: TextStyle(color: mutedColor, fontSize: 12.sp),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 2. Summary Metric Cards Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard(
                      "Total Payroll",
                      "\$${totalPayroll.toStringAsFixed(0)}",
                      Icons.account_balance_wallet_outlined,
                      const Color(0xFF2979FF),
                      cardColor,
                      textColor,
                      mutedColor,
                      borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildStatCard(
                      "Disbursed Paid",
                      "\$${paidTotal.toStringAsFixed(0)}",
                      Icons.check_circle_outline_rounded,
                      const Color(0xFF00E676),
                      cardColor,
                      textColor,
                      mutedColor,
                      borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildStatCard(
                      "Pending Payouts",
                      "\$${pendingTotal.toStringAsFixed(0)}",
                      Icons.hourglass_empty_rounded,
                      const Color(0xFFFFC107),
                      cardColor,
                      textColor,
                      mutedColor,
                      borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildStatCard(
                      "Total Staff",
                      "${_salaryStructures.length} Users",
                      Icons.people_outline_rounded,
                      const Color(0xFF6366F1),
                      cardColor,
                      textColor,
                      mutedColor,
                      borderColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 3. Section Category Tabs
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
                    Tab(text: "Salaries (${_salaryStructures.length})"),
                    Tab(text: "Monthly History (${_monthlyHistory.length})"),
                    Tab(text: "Requests (${_payrollRequests.length})"),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // 4. Tab Views Content
              Expanded(
                child: IndexedStack(
                  index: _tabController.index,
                  children: [
                    // Tab 1: Current Salary Structure DataTable
                    _buildSalaryStructureTable(cardColor, tableHeaderBg, textColor, mutedColor, borderColor, isDark),

                    // Tab 2: Monthly History with Every Employee's Salary Data
                    _buildMonthlyHistoryWithEmployees(cardColor, textColor, mutedColor, borderColor, inputBg, isDark),

                    // Tab 3: Payroll Requests
                    _buildPayrollRequestsList(cardColor, textColor, mutedColor, borderColor, inputBg, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // View 1: Salary Structure Table (DataTable Fix)
  Widget _buildSalaryStructureTable(
      Color cardColor,
      Color tableHeaderBg,
      Color textColor,
      Color mutedColor,
      Color borderColor,
      bool isDark,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(tableHeaderBg),
              horizontalMargin: 16.w,
              columnSpacing: 24.w,
              dataRowMinHeight: 52.h,
              dataRowMaxHeight: 56.h,
              columns: [
                DataColumn(label: _buildHeaderCell("EMPLOYEE", textColor)),
                DataColumn(label: _buildHeaderCell("BASE PAY", textColor)),
                DataColumn(label: _buildHeaderCell("ALLOWANCES", textColor)),
                DataColumn(label: _buildHeaderCell("DEDUCTIONS", textColor)),
                DataColumn(label: _buildHeaderCell("NET SALARY", textColor)),
                DataColumn(label: _buildHeaderCell("STATUS", textColor)),
                DataColumn(label: _buildHeaderCell("ACTION", textColor)),
              ],
              rows: _salaryStructures.map((item) {
                final isPaid = item["paymentStatus"] == "Paid";

                return DataRow(
                  cells: [
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["name"],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${item["designation"]} • ${item["department"]}",
                            style: TextStyle(color: mutedColor, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        "\$${item["baseSalary"]}",
                        style: TextStyle(color: textColor, fontSize: 12.sp),
                      ),
                    ),
                    DataCell(
                      Text(
                        "+\$${item["allowances"]}",
                        style: TextStyle(
                          color: const Color(0xFF00E676),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        "-\$${item["deductions"]}",
                        style: TextStyle(
                          color: const Color(0xFFFF5252),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        "\$${item["netSalary"]}",
                        style: TextStyle(
                          color: const Color(0xFF2979FF),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isPaid
                              ? const Color(0xFF00E676).withAlpha(25)
                              : const Color(0xFFFFC107).withAlpha(25),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          item["paymentStatus"],
                          style: TextStyle(
                            color: isPaid
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFFC107),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(
                          Icons.receipt_long_rounded,
                          color: const Color(0xFF2979FF),
                          size: 18.r,
                        ),
                        onPressed: () => _showPayslipModal(item, isDark),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // View 2: Monthly History with Every Employee's Salary Data (Expandable Month Cards)
  Widget _buildMonthlyHistoryWithEmployees(
      Color cardColor,
      Color textColor,
      Color mutedColor,
      Color borderColor,
      Color inputBg,
      bool isDark,
      ) {
    return ListView.builder(
      itemCount: _monthlyHistory.length,
      itemBuilder: (context, index) {
        final monthData = _monthlyHistory[index];
        final List employees = monthData["employees"] as List;
        final isCompleted = monthData["status"] == "Completed";

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              childrenPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              leading: CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFF2979FF).withAlpha(25),
                child: Icon(Icons.calendar_month_rounded, color: const Color(0xFF2979FF), size: 18.r),
              ),
              title: Text(
                monthData["month"],
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Disbursed on ${monthData["disbursementDate"]} • ${employees.length} Staff Records",
                style: TextStyle(color: mutedColor, fontSize: 11.sp),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    monthData["totalDisbursed"],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF00E676).withAlpha(25)
                          : const Color(0xFFFF9800).withAlpha(25),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      monthData["status"],
                      style: TextStyle(
                        color: isCompleted
                            ? const Color(0xFF00E676)
                            : const Color(0xFFFF9800),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Divider(height: 1, thickness: 1, color: borderColor),
                SizedBox(height: 10.h),
                // Every Employee's Individual Salary Breakdown Row
                ...employees.map((emp) {
                  final isEmpPaid = emp["status"] == "Paid";

                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Employee Info
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emp["name"],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                emp["designation"],
                                style: TextStyle(color: mutedColor, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),

                        // Financial Breakdown Pills
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text("Base", style: TextStyle(color: mutedColor, fontSize: 9.sp)),
                                  Text(emp["baseSalary"], style: TextStyle(color: textColor, fontSize: 11.sp, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Allow.", style: TextStyle(color: mutedColor, fontSize: 9.sp)),
                                  Text(emp["allowances"], style: TextStyle(color: const Color(0xFF00E676), fontSize: 11.sp, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Deduct.", style: TextStyle(color: mutedColor, fontSize: 9.sp)),
                                  Text(emp["deductions"], style: TextStyle(color: const Color(0xFFFF5252), fontSize: 11.sp, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Net Salary & Badge
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                emp["netSalary"],
                                style: TextStyle(
                                  color: const Color(0xFF2979FF),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                emp["status"],
                                style: TextStyle(
                                  color: isEmpPaid
                                      ? const Color(0xFF00E676)
                                      : const Color(0xFFFFC107),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // View 3: Payroll Requests List
  Widget _buildPayrollRequestsList(
      Color cardColor,
      Color textColor,
      Color mutedColor,
      Color borderColor,
      Color inputBg,
      bool isDark,
      ) {
    return ListView.builder(
      itemCount: _payrollRequests.length,
      itemBuilder: (context, index) {
        final req = _payrollRequests[index];
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: const Color(0xFF1E2838),
                        child: Icon(Icons.person_outline_rounded, color: const Color(0xFF2979FF), size: 16.r),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(req["name"], style: TextStyle(color: textColor, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                          Text(req["department"], style: TextStyle(color: mutedColor, fontSize: 10.sp)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: statusColor, width: 0.8),
                    ),
                    child: Text(status, style: TextStyle(color: statusColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(6.r)),
                    child: Text("${req["type"]} (${req["amount"]})", style: TextStyle(color: const Color(0xFF2979FF), fontSize: 11.sp, fontWeight: FontWeight.bold)),
                  ),
                  Text(req["requestDate"], style: TextStyle(color: mutedColor, fontSize: 11.sp)),
                ],
              ),
              SizedBox(height: 8.h),
              Text(req["reason"], style: TextStyle(color: textColor, fontSize: 12.sp)),

              // Approval Action Buttons for Pending Requests
              if (status == "Pending") ...[
                SizedBox(height: 10.h),
                Divider(height: 1, thickness: 1, color: borderColor),
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
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        side: const BorderSide(color: Color(0xFFFF5252)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                      ),
                      child: Text("Reject", style: TextStyle(color: const Color(0xFFFF5252), fontSize: 11.sp, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          req["status"] = "Approved";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                        elevation: 0,
                      ),
                      child: Text("Approve", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // Helpers
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
      width: 140.w,
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
              Icon(icon, color: iconColor, size: 16.r),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 15.sp,
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
}
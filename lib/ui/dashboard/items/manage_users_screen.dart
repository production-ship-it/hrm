import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Registered Users Data with Joining Date, Birthday, and Salary
  final List<Map<String, String>> _users = [
    {
      "name": "Muhammad Arham Farooqui",
      "email": "Arham@coretechdigitals.com",
      "phone": "03323488318",
      "role": "Production Staff",
      "designation": "CMS Developer",
      "joiningDate": "15 Jan 2022",
      "birthday": "10 Aug 1996",
      "salary": "\$1,500",
    },
    {
      "name": "Minham Khanzada",
      "email": "Minhamkhanzada@coretechdigitals.com",
      "phone": "03332625333",
      "role": "Production Staff",
      "designation": "Fullstack Developer",
      "joiningDate": "01 Mar 2021",
      "birthday": "22 Dec 1994",
      "salary": "\$2,200",
    },
    {
      "name": "Arsalan Alvi",
      "email": "Arsalanalvi@coretechdigitals.com",
      "phone": "03333313778",
      "role": "Production Staff",
      "designation": "Brand Designer",
      "joiningDate": "10 Jun 2022",
      "birthday": "05 Apr 1998",
      "salary": "\$1,200",
    },
    {
      "name": "Syed Muhammad Mubashir",
      "email": "Muhammadmubashir@coretechdigitals.com",
      "phone": "03174727668",
      "role": "Production Staff",
      "designation": "CMS Developer",
      "joiningDate": "18 Jul 2023",
      "birthday": "14 Nov 1997",
      "salary": "\$1,400",
    },
    {
      "name": "Fahad Bhutto",
      "email": "Fahadbhutto@coretechdigitals.com",
      "phone": "0308-2560166",
      "role": "Production Staff",
      "designation": "Performance Marketer",
      "joiningDate": "05 Oct 2021",
      "birthday": "30 Jan 1995",
      "salary": "\$1,800",
    },
    {
      "name": "Dua Irfan",
      "email": "Duairfan@coretechdigitals.com",
      "phone": "03323947430",
      "role": "Production Staff",
      "designation": "Senior Content Writer",
      "joiningDate": "12 Feb 2020",
      "birthday": "19 May 1993",
      "salary": "\$1,600",
    },
    {
      "name": "Shayan Ahmed",
      "email": "Shayanahmed@coretechdigitals.com",
      "phone": "0300-2633937",
      "role": "Sales Executive",
      "designation": "Manager Sales",
      "joiningDate": "01 Jan 2019",
      "birthday": "08 Sep 1991",
      "salary": "\$3,000",
    },
    {
      "name": "Muqtadir Wasi",
      "email": "Muqtadirwasi@coretechdigitals.com",
      "phone": "03312861523",
      "role": "Production Staff",
      "designation": "Senior SEO Specialist",
      "joiningDate": "20 Nov 2021",
      "birthday": "25 Feb 1994",
      "salary": "\$1,700",
    },
    {
      "name": "Zaid Bin Rafi",
      "email": "Zaid@coretechdigitals.com",
      "phone": "0332 3837549",
      "role": "Production Staff",
      "designation": "Flutter Developer",
      "joiningDate": "10 Aug 2022",
      "birthday": "11 Jul 1999",
      "salary": "\$2,000",
    },
    {
      "name": "Zaryab Shaikh",
      "email": "Zaryabshaikh@coretechdigitals.com",
      "phone": "0336 1136445",
      "role": "Production Staff",
      "designation": "Social Media Executive",
      "joiningDate": "01 Apr 2023",
      "birthday": "03 Oct 2000",
      "salary": "\$1,100",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Show User Detail Popup Modal
  void _showUserDetailModal(BuildContext context, Map<String, String> user, bool isDark) {
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final badgeBg = isDark ? const Color(0xFF1E232A) : const Color(0xFFE2E8F0);
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
                    // Modal Header with Avatar & Name
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: const Color(0xFF1E2838),
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: const Color(0xFF2979FF),
                            size: 26.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user["name"] ?? "",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                user["designation"] ?? "",
                                style: TextStyle(
                                  color: const Color(0xFF2979FF),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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

                    // Detail Fields
                    _buildDetailTile(
                      icon: Icons.email_outlined,
                      label: "Email Address",
                      value: user["email"] ?? "N/A",
                      textColor: textColor,
                      mutedColor: mutedColor,
                      bg: inputBg,
                    ),
                    SizedBox(height: 8.h),
                    _buildDetailTile(
                      icon: Icons.phone_outlined,
                      label: "Phone Number",
                      value: user["phone"] ?? "N/A",
                      textColor: textColor,
                      mutedColor: mutedColor,
                      bg: inputBg,
                    ),
                    SizedBox(height: 8.h),
                    _buildDetailTile(
                      icon: Icons.calendar_today_outlined,
                      label: "Joining Date",
                      value: user["joiningDate"] ?? "N/A",
                      textColor: textColor,
                      mutedColor: mutedColor,
                      bg: inputBg,
                    ),
                    SizedBox(height: 8.h),
                    _buildDetailTile(
                      icon: Icons.cake_outlined,
                      label: "Birthday",
                      value: user["birthday"] ?? "N/A",
                      textColor: textColor,
                      mutedColor: mutedColor,
                      bg: inputBg,
                    ),
                    SizedBox(height: 8.h),
                    _buildDetailTile(
                      icon: Icons.attach_money_rounded,
                      label: "Salary",
                      value: user["salary"] ?? "N/A",
                      textColor: const Color(0xFF00E676),
                      mutedColor: mutedColor,
                      bg: inputBg,
                    ),
                    SizedBox(height: 8.h),

                    // Role Row
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.security_outlined, color: mutedColor, size: 18.r),
                              SizedBox(width: 10.w),
                              Text(
                                "User Role",
                                style: TextStyle(color: mutedColor, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              user["role"] ?? "N/A",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Close Button
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
                        child: Text(
                          "Close",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
        },
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color mutedColor,
    required Color bg,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: mutedColor, size: 18.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: mutedColor, fontSize: 10.sp),
                ),
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

  // Show "Add New User" Modal Bottom Sheet
  void _showAddUserModal(BuildContext context, bool isDark) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final designationController = TextEditingController();
    final joiningDateController = TextEditingController();
    final birthdayController = TextEditingController();
    final salaryController = TextEditingController();
    String selectedRole = "Production Staff";

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
                            "Add New System User",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, color: mutedColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildModalTextField(
                        controller: nameController,
                        label: "Full Name",
                        hint: "Enter user full name",
                        icon: Icons.person_outline_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),
                      _buildModalTextField(
                        controller: emailController,
                        label: "Email Address",
                        hint: "e.g. user@coretechdigitals.com",
                        icon: Icons.email_outlined,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 12.h),
                      _buildModalTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        hint: "e.g. 03323488318",
                        icon: Icons.phone_outlined,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 12.h),

                      // Role Dropdown Field
                      Text(
                        "Role",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRole,
                            isExpanded: true,
                            dropdownColor: cardColor,
                            icon: Icon(Icons.arrow_drop_down, color: mutedColor),
                            items: [
                              "Production Staff",
                              "Sales Executive",
                              "Admin",
                              "Manager"
                            ]
                                .map(
                                  (role) => DropdownMenuItem(
                                value: role,
                                child: Text(
                                  role,
                                  style: TextStyle(
                                      color: textColor, fontSize: 13.sp),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedRole = val);
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildModalTextField(
                        controller: designationController,
                        label: "Designation",
                        hint: "e.g. CMS Developer",
                        icon: Icons.badge_outlined,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),
                      _buildModalTextField(
                        controller: joiningDateController,
                        label: "Joining Date",
                        hint: "e.g. 15 Jan 2023",
                        icon: Icons.calendar_today_outlined,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),
                      _buildModalTextField(
                        controller: birthdayController,
                        label: "Birthday",
                        hint: "e.g. 10 Aug 1996",
                        icon: Icons.cake_outlined,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),
                      _buildModalTextField(
                        controller: salaryController,
                        label: "Salary",
                        hint: "e.g. \$1,500",
                        icon: Icons.attach_money_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _users.insert(0, {
                                  "name": nameController.text.trim(),
                                  "email": emailController.text.trim(),
                                  "phone": phoneController.text.trim(),
                                  "role": selectedRole,
                                  "designation": designationController.text.trim(),
                                  "joiningDate": joiningDateController.text.trim(),
                                  "birthday": birthdayController.text.trim(),
                                  "salary": salaryController.text.trim(),
                                });
                              });
                              Navigator.pop(context);
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
                            "Save User",
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
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          style: TextStyle(color: textColor, fontSize: 13.sp),
          validator: (val) =>
          val == null || val.trim().isEmpty ? "Required field" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: mutedColor, fontSize: 13.sp),
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
    final borderColor =
    isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);
    final designationBg = isDark ? const Color(0xFF1E2838) : const Color(0xFFE0F2FE);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Title Header & "+ Add New User" Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "System Users",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddUserModal(context, isDark),
                    icon: Icon(Icons.person_add_alt_1_rounded, size: 16.r),
                    label: Text(
                      "Add New User",
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

              // 2. Main Registered Users Container Panel
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      // Header & Search Bar Row
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Registered Users",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 160.w,
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
                                  hintText: "Search...",
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

                      Divider(height: 1, thickness: 1, color: borderColor),

                      // 3. User List
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          itemCount: _users.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: borderColor,
                          ),
                          itemBuilder: (context, index) {
                            final user = _users[index];

                            return InkWell(
                              onTap: () =>
                                  _showUserDetailModal(context, user, isDark),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // User Avatar Circle
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: const Color(0xFF1E2838),
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        color: const Color(0xFF2979FF),
                                        size: 20.r,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),

                                    // Details Stack: Name -> Email -> Designation
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // 1. User Name
                                          Text(
                                            user["name"]!,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),

                                          // 2. User Email
                                          Text(
                                            user["email"]!,
                                            style: TextStyle(
                                              color: mutedColor,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),

                                          // 3. Designation Badge / Subtext
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 3.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: designationBg,
                                              borderRadius:
                                              BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              user["designation"]!,
                                              style: TextStyle(
                                                color: const Color(0xFF2979FF),
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Chevron Arrow Indicator
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: mutedColor,
                                      size: 20.r,
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
            ],
          ),
        ),
      ),
    );
  }
}
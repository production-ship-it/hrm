import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageTeamsScreen extends StatefulWidget {
  const ManageTeamsScreen({super.key});

  @override
  State<ManageTeamsScreen> createState() => _ManageTeamsScreenState();
}

class _ManageTeamsScreenState extends State<ManageTeamsScreen> {
  // Registered System Users Pool
  final List<String> _availableUsers = [
    "Muhammad Arham Farooqui",
    "Minham Khanzada",
    "Arsalan Alvi",
    "Syed Muhammad Mubashir",
    "Fahad Bhutto",
    "Dua Irfan",
    "Shayan Ahmed",
    "Muqtadir Wasi",
    "Zaid Bin Rafi",
    "Zaryab Shaikh",
  ];

  // Teams Data with Member Names List
  final List<Map<String, dynamic>> _teams = [
    {
      "name": "TEAM WAQAS",
      "target": "0 Units",
      "members": ["Muhammad Arham Farooqui", "Minham Khanzada", "Arsalan Alvi"],
    },
    {
      "name": "TEAM MAXINTA",
      "target": "0 Units",
      "members": ["Syed Muhammad Mubashir", "Fahad Bhutto", "Dua Irfan"],
    },
    {
      "name": "TEAM ISSAC",
      "target": "0 Units",
      "members": ["Shayan Ahmed", "Muqtadir Wasi", "Zaid Bin Rafi", "Zaryab Shaikh"],
    },
    {
      "name": "TEAM KEVIN",
      "target": "0 Units",
      "members": ["Muhammad Arham Farooqui", "Syed Muhammad Mubashir", "Fahad Bhutto", "Dua Irfan"],
    },
    {
      "name": "TEAM ZAHEER",
      "target": "0 Units",
      "members": ["Arsalan Alvi", "Minham Khanzada", "Zaid Bin Rafi"],
    },
    {
      "name": "TEAM JOSHWA",
      "target": "5000 Units",
      "members": ["Shayan Ahmed", "Muqtadir Wasi", "Zaryab Shaikh"],
    },
  ];

  // Show "Create/Edit Team" Modal Bottom Sheet with Multi-Select User Picker
  void _showTeamModal(
      BuildContext context,
      bool isDark, {
        Map<String, dynamic>? existingTeam,
        int? editIndex,
      }) {
    final nameController =
    TextEditingController(text: existingTeam?["name"] ?? "");
    final targetController =
    TextEditingController(text: existingTeam?["target"] ?? "");

    // Selected Users List state
    final List<String> selectedUserNames = existingTeam != null
        ? List<String>.from(existingTeam["members"])
        : [];

    final formKey = GlobalKey<FormState>();

    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);
    final selectedChipBg = isDark ? const Color(0xFF1E2838) : const Color(0xFFE0F2FE);

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
                      // Title & Close Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            editIndex != null ? "Edit Team" : "Create New Team",
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

                      // Team Name
                      _buildModalTextField(
                        controller: nameController,
                        label: "Team Name",
                        hint: "e.g. TEAM ALPHA",
                        icon: Icons.groups_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Total Target
                      _buildModalTextField(
                        controller: targetController,
                        label: "Total Target",
                        hint: "e.g. 5000 Units",
                        icon: Icons.track_changes_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 16.h),

                      // Select Team Members Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Team Members",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${selectedUserNames.length} Selected",
                            style: TextStyle(
                              color: const Color(0xFF2979FF),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Multi-Select Users Checklist Box
                      Container(
                        height: 180.h,
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          itemCount: _availableUsers.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
                          ),
                          itemBuilder: (context, index) {
                            final userName = _availableUsers[index];
                            final isSelected = selectedUserNames.contains(userName);

                            return CheckboxListTile(
                              dense: true,
                              activeColor: const Color(0xFF2979FF),
                              checkColor: Colors.white,
                              value: isSelected,
                              title: Text(
                                userName,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13.sp,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              onChanged: (checked) {
                                setModalState(() {
                                  if (checked == true) {
                                    selectedUserNames.add(userName);
                                  } else {
                                    selectedUserNames.remove(userName);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Selected User Badges Wrap Preview
                      if (selectedUserNames.isNotEmpty) ...[
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: selectedUserNames.map((user) {
                            return Chip(
                              backgroundColor: selectedChipBg,
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                              avatar: Icon(
                                Icons.person_outline_rounded,
                                color: const Color(0xFF2979FF),
                                size: 14.r,
                              ),
                              label: Text(
                                user,
                                style: TextStyle(
                                  color: const Color(0xFF2979FF),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              deleteIcon: Icon(
                                Icons.close_rounded,
                                color: const Color(0xFF2979FF),
                                size: 14.r,
                              ),
                              onDeleted: () {
                                setModalState(() {
                                  selectedUserNames.remove(user);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Save/Update Button
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (selectedUserNames.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select at least one team member"),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                final teamData = {
                                  "name": nameController.text.trim(),
                                  "target": targetController.text.trim().endsWith("Units")
                                      ? targetController.text.trim()
                                      : "${targetController.text.trim()} Units",
                                  "members": selectedUserNames,
                                };

                                if (editIndex != null) {
                                  _teams[editIndex] = teamData;
                                } else {
                                  _teams.add(teamData);
                                }
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
                            editIndex != null ? "Update Team" : "Create Team",
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
    final tableHeaderBg =
    isDark ? const Color(0xFF111726) : const Color(0xFFF1F5F9);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor =
    isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);
    final targetBg = isDark ? const Color(0xFF0A2B20) : const Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Header & "+ Create New Team" Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Teams Management",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showTeamModal(context, isDark),
                    icon: Icon(Icons.add_circle_outline_rounded, size: 16.r),
                    label: Text(
                      "Create New Team",
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

              // Main Teams Panel
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      // Scrollable Table Container
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 650.w,
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
                                        width: 200.w,
                                        child: _buildHeaderCell("TEAM NAME", textColor),
                                      ),
                                      SizedBox(
                                        width: 150.w,
                                        child: _buildHeaderCell("TOTAL TARGET", textColor),
                                      ),
                                      SizedBox(
                                        width: 150.w,
                                        child: _buildHeaderCell("MEMBERS COUNT", textColor),
                                      ),
                                      SizedBox(
                                        width: 110.w,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: _buildHeaderCell("ACTIONS", textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Table Row List View
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: _teams.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: borderColor,
                                        ),
                                    itemBuilder: (context, index) {
                                      final team = _teams[index];
                                      final List<String> memberList =
                                      List<String>.from(team["members"] ?? []);

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            // 1. Team Name with Icon
                                            SizedBox(
                                              width: 200.w,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 14.r,
                                                    backgroundColor:
                                                    const Color(0xFF1E2838),
                                                    child: Icon(
                                                      Icons.account_tree_outlined,
                                                      color: const Color(0xFF2979FF),
                                                      size: 15.r,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Expanded(
                                                    child: Text(
                                                      team["name"]!,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // 2. Total Target Badge
                                            SizedBox(
                                              width: 150.w,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: targetBg,
                                                    borderRadius:
                                                    BorderRadius.circular(12.r),
                                                  ),
                                                  child: Text(
                                                    team["target"]!,
                                                    style: TextStyle(
                                                      color: const Color(0xFF00E676),
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // 3. Dynamic Members Count
                                            SizedBox(
                                              width: 150.w,
                                              child: Text(
                                                "${memberList.length} Users",
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),

                                            // 4. Actions (Edit & Delete)
                                            SizedBox(
                                              width: 110.w,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit_note_rounded,
                                                      color: mutedColor,
                                                      size: 20.r,
                                                    ),
                                                    onPressed: () => _showTeamModal(
                                                      context,
                                                      isDark,
                                                      existingTeam: team,
                                                      editIndex: index,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_outline_rounded,
                                                      color: const Color(0xFFFF5252),
                                                      size: 18.r,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _teams.removeAt(index);
                                                      });
                                                    },
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
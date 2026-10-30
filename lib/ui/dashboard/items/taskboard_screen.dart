import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskboardScreen extends StatefulWidget {
  const TaskboardScreen({super.key});

  @override
  State<TaskboardScreen> createState() => _TaskboardScreenState();
}

class _TaskboardScreenState extends State<TaskboardScreen> {
  // Sample Tasks Dataset
  final List<Map<String, dynamic>> _tasks = [
    {
      "id": "1",
      "title": "Redesign Landing Page Hero",
      "description": "Revamp the header section with modern high-converting CTAs and 3D graphics.",
      "domain": "Website",
      "status": "To Do",
      "deadline": "28 Oct 2026",
      "assignedBy": "Super Admin",
      "assignedTo": "Arsalan Alvi",
      "imageUrl": "https://picsum.photos/seed/design/400/200",
    },
    {
      "title": "Fix Auth Token Refresh Bug",
      "description": "Address rare token expiration edge cases on Flutter mobile app background resume.",
      "domain": "App Dev",
      "status": "In Progress",
      "deadline": "25 Oct 2026",
      "assignedBy": "Minham Khanzada",
      "assignedTo": "Zaid Bin Rafi",
      "imageUrl": null,
    },
    {
      "id": "3",
      "title": "Publish October Newsletter eBook",
      "description": "Complete PDF formatting, proofreading, and cover artwork placement.",
      "domain": "eBook",
      "status": "Completed",
      "deadline": "20 Oct 2026",
      "assignedBy": "Dua Irfan",
      "assignedTo": "Muhammad Arham",
      "imageUrl": "https://picsum.photos/seed/ebook/400/200",
    },
    {
      "id": "4",
      "title": "Setup SMM Ad Campaigns",
      "description": "Prepare targeted audience sets and visual creatives for Facebook & IG campaigns.",
      "domain": "Marketing",
      "status": "To Do",
      "deadline": "30 Oct 2026",
      "assignedBy": "Shayan Ahmed",
      "assignedTo": "Zaryab Shaikh",
      "imageUrl": null,
    },
  ];

  // Show Task Details Modal
  void _showTaskDetailModal(Map<String, dynamic> task, bool isDark) {
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
                  // Title & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task["title"],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: mutedColor),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Domain & Status Badges
                  Row(
                    children: [
                      _buildChip(task["domain"], const Color(0xFF2979FF), isDark),
                      SizedBox(width: 8.w),
                      _buildChip(
                        task["status"],
                        _getStatusColor(task["status"]),
                        isDark,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),
                  Divider(color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15)),
                  SizedBox(height: 12.h),

                  // Media Image Attachment (if present)
                  if (task["imageUrl"] != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        task["imageUrl"],
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100.h,
                          color: inputBg,
                          child: Center(
                            child: Icon(Icons.broken_image_outlined, color: mutedColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],

                  // Description
                  Text(
                    "Description",
                    style: TextStyle(color: mutedColor, fontSize: 11.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    task["description"],
                    style: TextStyle(color: textColor, fontSize: 13.sp),
                  ),
                  SizedBox(height: 14.h),

                  // Metadata Tile Fields
                  _buildDetailTile("Deadline", task["deadline"], Icons.calendar_today_rounded, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Assigned By", task["assignedBy"], Icons.person_outline_rounded, textColor, mutedColor, inputBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Assigned To", task["assignedTo"], Icons.assignment_ind_outlined, textColor, mutedColor, inputBg),

                  SizedBox(height: 20.h),

                  // Move Task Action Section
                  Text(
                    "Move Task To Stage",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Row(
                    children: ["To Do", "In Progress", "Completed"].map((stage) {
                      final isCurrent = task["status"] == stage;
                      return Expanded(
                        child: GestureDetector(
                          onTap: isCurrent
                              ? null
                              : () {
                            setState(() {
                              task["status"] = stage;
                            });
                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: stage != "Completed" ? 6.w : 0),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? _getStatusColor(stage)
                                  : inputBg,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                stage,
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : textColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // "+ Add Task" Modal Bottom Sheet
  void _showAddTaskModal(BuildContext context, bool isDark) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final assignedByController = TextEditingController();
    final assignedToController = TextEditingController();
    final imageController = TextEditingController();

    String selectedDomain = "Website";
    String selectedStatus = "To Do";
    String selectedDeadline = "28 Oct 2026";

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
                            "Create New Task",
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

                      // Task Title
                      _buildModalTextField(
                        controller: titleController,
                        label: "Task Title",
                        hint: "e.g. Design Dashboard Wireframes",
                        icon: Icons.title_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Description
                      _buildModalTextField(
                        controller: descController,
                        label: "Description",
                        hint: "Enter task requirements...",
                        icon: Icons.notes_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                        maxLines: 2,
                      ),
                      SizedBox(height: 12.h),

                      // Domain & Status Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownTile(
                              label: "Domain",
                              value: selectedDomain,
                              items: ["Website", "App Dev", "eBook", "Marketing", "Design"],
                              onChanged: (val) {
                                if (val != null) setModalState(() => selectedDomain = val);
                              },
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                              cardColor: cardColor,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildDropdownTile(
                              label: "Initial Stage",
                              value: selectedStatus,
                              items: ["To Do", "In Progress", "Completed"],
                              onChanged: (val) {
                                if (val != null) setModalState(() => selectedStatus = val);
                              },
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                              cardColor: cardColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Assigned By & Assigned To
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalTextField(
                              controller: assignedByController,
                              label: "Assigned By",
                              hint: "Manager Name",
                              icon: Icons.person_outline_rounded,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildModalTextField(
                              controller: assignedToController,
                              label: "Assigned To",
                              hint: "Assignee Name",
                              icon: Icons.assignment_ind_outlined,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Optional Media Image URL
                      _buildModalTextField(
                        controller: imageController,
                        label: "Media Image URL (Optional)",
                        hint: "https://example.com/image.png",
                        icon: Icons.image_outlined,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                        isOptional: true,
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
                                _tasks.insert(0, {
                                  "id": DateTime.now().millisecondsSinceEpoch.toString(),
                                  "title": titleController.text.trim(),
                                  "description": descController.text.trim(),
                                  "domain": selectedDomain,
                                  "status": selectedStatus,
                                  "deadline": selectedDeadline,
                                  "assignedBy": assignedByController.text.trim(),
                                  "assignedTo": assignedToController.text.trim(),
                                  "imageUrl": imageController.text.trim().isNotEmpty
                                      ? imageController.text.trim()
                                      : null,
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
                            "Save Task",
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor = isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header & "+ Add Task" Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Taskboard",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddTaskModal(context, isDark),
                    icon: Icon(Icons.add_task_rounded, size: 16.r),
                    label: Text(
                      "Add Task",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 3-Stage Kanban Horizontal Steps Columns
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKanbanColumn("To Do", const Color(0xFFFF9800), cardColor, textColor, mutedColor, borderColor, isDark),
                      SizedBox(width: 12.w),
                      _buildKanbanColumn("In Progress", const Color(0xFF2979FF), cardColor, textColor, mutedColor, borderColor, isDark),
                      SizedBox(width: 12.w),
                      _buildKanbanColumn("Completed", const Color(0xFF00E676), cardColor, textColor, mutedColor, borderColor, isDark),
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

  // Kanban Column Widget
  Widget _buildKanbanColumn(
      String stageTitle,
      Color stageColor,
      Color cardColor,
      Color textColor,
      Color mutedColor,
      Color borderColor,
      bool isDark,
      ) {
    final columnTasks = _tasks.where((t) => t["status"] == stageTitle).toList();

    return Container(
      width: 260.w,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13151A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          // Column Header Bar
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: stageColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      stageTitle,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E222A) : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    "${columnTasks.length}",
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

          Divider(height: 1, thickness: 1, color: borderColor),

          // ListView Task Cards
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.w),
              itemCount: columnTasks.length,
              itemBuilder: (context, index) {
                final task = columnTasks[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () => _showTaskDetailModal(task, isDark),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Task Domain Badge & Quick Move Menu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildChip(task["domain"], const Color(0xFF2979FF), isDark),

                              // Quick Move Popup Menu
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert_rounded, color: mutedColor, size: 16.r),
                                color: cardColor,
                                onSelected: (newStage) {
                                  setState(() {
                                    task["status"] = newStage;
                                  });
                                },
                                itemBuilder: (context) => [
                                  if (stageTitle != "To Do")
                                    PopupMenuItem(value: "To Do", child: Text("Move to To Do", style: TextStyle(color: textColor, fontSize: 12.sp))),
                                  if (stageTitle != "In Progress")
                                    PopupMenuItem(value: "In Progress", child: Text("Move to In Progress", style: TextStyle(color: textColor, fontSize: 12.sp))),
                                  if (stageTitle != "Completed")
                                    PopupMenuItem(value: "Completed", child: Text("Move to Completed", style: TextStyle(color: textColor, fontSize: 12.sp))),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          // Title
                          Text(
                            task["title"],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Description Short Snippet
                          Text(
                            task["description"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 11.sp,
                            ),
                          ),

                          // Media Attachment Thumbnail Indicator
                          if (task["imageUrl"] != null) ...[
                            SizedBox(height: 8.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: Image.network(
                                task["imageUrl"],
                                height: 80.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],

                          SizedBox(height: 10.h),
                          Divider(height: 1, thickness: 1, color: borderColor),
                          SizedBox(height: 8.h),

                          // Assigned To & Deadline Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.assignment_ind_outlined, color: mutedColor, size: 13.r),
                                  SizedBox(width: 4.w),
                                  Text(
                                    task["assignedTo"],
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                task["deadline"],
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 10.sp,
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
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  Color _getStatusColor(String status) {
    switch (status) {
      case "In Progress":
        return const Color(0xFF2979FF);
      case "Completed":
        return const Color(0xFF00E676);
      default:
        return const Color(0xFFFF9800);
    }
  }

  Widget _buildChip(String label, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
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

  Widget _buildDropdownTile({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required Color textColor,
    required Color mutedColor,
    required Color inputBg,
    required Color cardColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontSize: 12.sp, fontWeight: FontWeight.w600),
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
              value: value,
              isExpanded: true,
              dropdownColor: cardColor,
              icon: Icon(Icons.arrow_drop_down, color: mutedColor),
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: TextStyle(color: textColor, fontSize: 13.sp)),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
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
    bool isOptional = false,
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
          maxLines: maxLines,
          style: TextStyle(color: textColor, fontSize: 13.sp),
          validator: (val) {
            if (isOptional) return null;
            return val == null || val.trim().isEmpty ? "Required field" : null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
            prefixIcon: Icon(icon, color: mutedColor, size: 18.r),
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
}
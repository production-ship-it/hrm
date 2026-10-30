import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryFilter = "All";

  final List<String> _categories = [
    "All",
    "Work",
    "Personal",
    "Ideas",
    "Meeting"
  ];

  // Notes Local Dataset
  final List<Map<String, dynamic>> _notesList = [
    {
      "id": "1",
      "title": "Quarterly HR Strategy & Payroll Review",
      "content":
      "Review team performance targets, prepare Q4 salary structures, and schedule 1-on-1 feedback sessions.",
      "category": "Work",
      "date": "27 Oct 2026",
      "isPinned": true,
    },
    {
      "id": "2",
      "title": "Flutter UI Performance Checklist",
      "content":
      "1. Optimize ListView with proper itemExtent.\n2. Wrap horizontal scrolling tables with DataTable.\n3. Avoid heavy computations inside build().",
      "category": "Ideas",
      "date": "25 Oct 2026",
      "isPinned": true,
    },
    {
      "id": "3",
      "title": "Client Onboarding Sync",
      "content":
      "Discussed project scope with CoreTech leadership. Follow up on contract signature by Friday.",
      "category": "Meeting",
      "date": "20 Oct 2026",
      "isPinned": false,
    },
    {
      "id": "4",
      "title": "Personal Goals for November",
      "content":
      "Complete Flutter ScreenUtil architecture updates and read 2 technical books.",
      "category": "Personal",
      "date": "18 Oct 2026",
      "isPinned": false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter Notes by Search Query & Category
  List<Map<String, dynamic>> _getFilteredNotes() {
    final query = _searchController.text.trim().toLowerCase();

    return _notesList.where((note) {
      final matchesSearch = note["title"].toString().toLowerCase().contains(query) ||
          note["content"].toString().toLowerCase().contains(query);
      final matchesCategory = _selectedCategoryFilter == "All" ||
          note["category"] == _selectedCategoryFilter;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Open Create or Edit Note Modal
  void _openNoteEditorModal({Map<String, dynamic>? noteToEdit, required bool isDark}) {
    final isEditing = noteToEdit != null;

    final titleController = TextEditingController(text: isEditing ? noteToEdit["title"] : "");
    final contentController = TextEditingController(text: isEditing ? noteToEdit["content"] : "");
    String selectedCategory = isEditing ? noteToEdit["category"] : "Work";

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
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing ? "Edit Note" : "Create New Note",
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

                      // Title Field
                      Text(
                        "Title",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      TextFormField(
                        controller: titleController,
                        style: TextStyle(color: textColor, fontSize: 13.sp),
                        validator: (val) =>
                        val == null || val.trim().isEmpty ? "Title is required" : null,
                        decoration: InputDecoration(
                          hintText: "Enter note title...",
                          hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
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

                      SizedBox(height: 14.h),

                      // Category Selector
                      Text(
                        "Category Tag",
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
                            value: selectedCategory,
                            isExpanded: true,
                            dropdownColor: cardColor,
                            icon: Icon(Icons.arrow_drop_down, color: mutedColor),
                            items: ["Work", "Personal", "Ideas", "Meeting"]
                                .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat,
                                  style:
                                  TextStyle(color: textColor, fontSize: 13.sp)),
                            ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedCategory = val);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 14.h),

                      // Content Field
                      Text(
                        "Note Content",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      TextFormField(
                        controller: contentController,
                        maxLines: 5,
                        style: TextStyle(color: textColor, fontSize: 13.sp),
                        validator: (val) =>
                        val == null || val.trim().isEmpty ? "Content cannot be empty" : null,
                        decoration: InputDecoration(
                          hintText: "Write your details here...",
                          hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
                          filled: true,
                          fillColor: inputBg,
                          contentPadding: EdgeInsets.all(12.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                if (isEditing) {
                                  noteToEdit["title"] = titleController.text.trim();
                                  noteToEdit["content"] = contentController.text.trim();
                                  noteToEdit["category"] = selectedCategory;
                                } else {
                                  _notesList.insert(0, {
                                    "id": DateTime.now().millisecondsSinceEpoch.toString(),
                                    "title": titleController.text.trim(),
                                    "content": contentController.text.trim(),
                                    "category": selectedCategory,
                                    "date": "Today",
                                    "isPinned": false,
                                  });
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
                            isEditing ? "Update Note" : "Save Note",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
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

  // Delete Note Confirmation Modal
  void _deleteNote(String id) {
    setState(() {
      _notesList.removeWhere((item) => item["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Note deleted successfully"),
        backgroundColor: Color(0xFFFF5252),
      ),
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

    final filteredNotes = _getFilteredNotes();

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditorModal(isDark: isDark),
        backgroundColor: const Color(0xFF2979FF),
        icon: Icon(Icons.add_rounded, color: Colors.white, size: 20.r),
        label: Text("New Note", style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Notes",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "${filteredNotes.length} notes available",
                        style: TextStyle(color: mutedColor, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 2. Search Field Bar
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: textColor, fontSize: 13.sp),
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Search notes by keyword...",
                    hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
                    prefixIcon: Icon(Icons.search_rounded, color: mutedColor, size: 18.r),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear_rounded, color: mutedColor, size: 16.r),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // 3. Category Filter Tags Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategoryFilter == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryFilter = cat;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2979FF) : cardColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2979FF) : borderColor,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textColor,
                            fontSize: 11.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 16.h),

              // 4. Notes ListView / Grid
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sticky_note_2_outlined, color: mutedColor, size: 48.r),
                      SizedBox(height: 10.h),
                      Text(
                        "No notes found",
                        style: TextStyle(color: textColor, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Create a new note to keep track of ideas",
                        style: TextStyle(color: mutedColor, fontSize: 11.sp),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    final isPinned = note["isPinned"] == true;

                    Color categoryColor;
                    switch (note["category"]) {
                      case "Work":
                        categoryColor = const Color(0xFF2979FF);
                        break;
                      case "Ideas":
                        categoryColor = const Color(0xFF00E676);
                        break;
                      case "Meeting":
                        categoryColor = const Color(0xFFFF9800);
                        break;
                      default:
                        categoryColor = const Color(0xFF6366F1);
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Option Menu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    if (isPinned) ...[
                                      Icon(Icons.push_pin_rounded,
                                          color: const Color(0xFFFFC107), size: 14.r),
                                      SizedBox(width: 6.w),
                                    ],
                                    Expanded(
                                      child: Text(
                                        note["title"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Popup Menu Actions
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert_rounded, color: mutedColor, size: 18.r),
                                color: cardColor,
                                onSelected: (val) {
                                  if (val == "edit") {
                                    _openNoteEditorModal(noteToEdit: note, isDark: isDark);
                                  } else if (val == "pin") {
                                    setState(() {
                                      note["isPinned"] = !isPinned;
                                    });
                                  } else if (val == "delete") {
                                    _deleteNote(note["id"]);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: "pin",
                                    child: Row(
                                      children: [
                                        Icon(Icons.push_pin_outlined, color: textColor, size: 16.r),
                                        SizedBox(width: 8.w),
                                        Text(isPinned ? "Unpin" : "Pin Note", style: TextStyle(color: textColor, fontSize: 12.sp)),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined, color: textColor, size: 16.r),
                                        SizedBox(width: 8.w),
                                        Text("Edit Note", style: TextStyle(color: textColor, fontSize: 12.sp)),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline_rounded, color: const Color(0xFFFF5252), size: 16.r),
                                        SizedBox(width: 8.w),
                                        Text("Delete", style: TextStyle(color: const Color(0xFFFF5252), fontSize: 12.sp)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          // Note Content Preview
                          Text(
                            note["content"],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: mutedColor, fontSize: 12.sp, height: 1.4),
                          ),

                          SizedBox(height: 12.h),

                          // Category Tag & Date Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: categoryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  note["category"],
                                  style: TextStyle(
                                    color: categoryColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                note["date"],
                                style: TextStyle(color: mutedColor, fontSize: 10.sp),
                              ),
                            ],
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
    );
  }
}
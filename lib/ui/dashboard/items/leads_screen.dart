import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  // Raw Sample Leads Dataset
  final List<Map<String, dynamic>> _allLeads = [
    {
      "name": "Sarah Jenkins",
      "email": "sarah.j@techcorp.com",
      "phone": "+1 202-555-0143",
      "domain": "Website",
      "source": "PPC",
      "service": "Web Development",
      "brand": "CoreTech Digitals",
      "type": "Front",
      "date": "2026-10-20",
    },
    {
      "name": "David Miller",
      "email": "dmiller@logix.io",
      "phone": "+1 202-555-0188",
      "domain": "eBook",
      "source": "SMM",
      "service": "Content Writing",
      "brand": "Design Prodigy",
      "type": "Upsell",
      "date": "2026-10-18",
    },
    {
      "name": "Elena Rostova",
      "email": "elena@vanguard.org",
      "phone": "+1 202-555-0192",
      "domain": "Design",
      "source": "PPC",
      "service": "UI/UX Branding",
      "brand": "CoreTech Digitals",
      "type": "Front",
      "date": "2026-10-15",
    },
    {
      "name": "Michael Brown",
      "email": "mbrown@apexgroup.com",
      "phone": "+1 202-555-0111",
      "domain": "Website",
      "source": "SMM",
      "service": "Fullstack Application",
      "brand": "Apex Agency",
      "type": "Upsell",
      "date": "2026-10-12",
    },
    {
      "name": "Amanda Vance",
      "email": "a.vance@innovate.co",
      "phone": "+1 202-555-0165",
      "domain": "eBook",
      "source": "Organic",
      "service": "eBook Publishing",
      "brand": "Design Prodigy",
      "type": "Front",
      "date": "2026-10-10",
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
    _searchController.dispose();
    super.dispose();
  }

  // Pick Date Range for Filtering
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

  // Filter Leads based on Active Tab, Search Query, and Date Filter
  List<Map<String, dynamic>> _getFilteredLeads() {
    final query = _searchController.text.trim().toLowerCase();

    return _allLeads.where((lead) {
      if (_tabController.index == 1 && lead["type"] != "Front") return false;
      if (_tabController.index == 2 && lead["type"] != "Upsell") return false;

      if (query.isNotEmpty) {
        final name = lead["name"].toString().toLowerCase();
        if (!name.contains(query)) return false;
      }

      if (_selectedDateRange != null) {
        final leadDate = DateTime.parse(lead["date"]);
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end.add(const Duration(days: 1));
        if (leadDate.isBefore(start) || leadDate.isAfter(end)) return false;
      }

      return true;
    }).toList();
  }

  // Modal Sheet to Add New Lead
  void _showAddLeadModal(BuildContext context, bool isDark) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final serviceController = TextEditingController();
    final brandController = TextEditingController();

    String selectedDomain = "Website";
    String selectedSource = "PPC";
    String selectedType = "Front";

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
                            "Add New Lead",
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

                      // Lead Name
                      _buildModalTextField(
                        controller: nameController,
                        label: "Lead Name",
                        hint: "Enter client name",
                        icon: Icons.person_outline_rounded,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Email & Phone Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalTextField(
                              controller: emailController,
                              label: "Email",
                              hint: "client@mail.com",
                              icon: Icons.email_outlined,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildModalTextField(
                              controller: phoneController,
                              label: "Phone",
                              hint: "+1 202-555-0100",
                              icon: Icons.phone_outlined,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Domain & Source Dropdowns Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownTile(
                              label: "Domain",
                              value: selectedDomain,
                              items: ["Website", "eBook", "Design"],
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
                              label: "Source",
                              value: selectedSource,
                              items: ["PPC", "SMM", "Organic", "Direct"],
                              onChanged: (val) {
                                if (val != null) setModalState(() => selectedSource = val);
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

                      // Service & Brand
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalTextField(
                              controller: serviceController,
                              label: "Service",
                              hint: "e.g. Web Dev",
                              icon: Icons.design_services_outlined,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildModalTextField(
                              controller: brandController,
                              label: "Brand",
                              hint: "e.g. CoreTech",
                              icon: Icons.business_outlined,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              inputBg: inputBg,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Lead Type (Front vs Upsell Toggle)
                      Text(
                        "Lead Type",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: ["Front", "Upsell"].map((type) {
                          final isSelected = selectedType == type;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() => selectedType = type);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(right: type == "Front" ? 8.w : 0),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2979FF)
                                      : inputBg,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : textColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 24.h),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final now = DateTime.now();
                              final dateStr =
                                  "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                              setState(() {
                                _allLeads.insert(0, {
                                  "name": nameController.text.trim(),
                                  "email": emailController.text.trim(),
                                  "phone": phoneController.text.trim(),
                                  "domain": selectedDomain,
                                  "source": selectedSource,
                                  "service": serviceController.text.trim(),
                                  "brand": brandController.text.trim(),
                                  "type": selectedType,
                                  "date": dateStr,
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
                            "Save Lead",
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
              value: value,
              isExpanded: true,
              dropdownColor: cardColor,
              icon: Icon(Icons.arrow_drop_down, color: mutedColor),
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: textColor, fontSize: 13.sp),
                ),
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

  // Detail Modal Popup
  void _showLeadDetailModal(Map<String, dynamic> lead, bool isDark) {
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final tileBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

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
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: const Color(0xFF2979FF),
                            child: Icon(Icons.person, color: Colors.white, size: 20.r),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead["name"],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${lead["domain"]} • ${lead["brand"]}",
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
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

                  _buildDetailTile("Email", lead["email"], Icons.email_outlined, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Phone", lead["phone"], Icons.phone_outlined, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Domain", lead["domain"], Icons.domain_rounded, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Source", lead["source"], Icons.campaign_outlined, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Service", lead["service"], Icons.design_services_outlined, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Brand", lead["brand"], Icons.business_outlined, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Lead Type", lead["type"], Icons.badge_outlined, textColor, mutedColor, tileBg),
                  SizedBox(height: 8.h),
                  _buildDetailTile("Created Date", lead["date"], Icons.calendar_today_outlined, textColor, mutedColor, tileBg),

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
                      child: Text(
                        "Close",
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
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
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final borderColor = isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15);
    final inputBg = isDark ? const Color(0xFF1E222A) : const Color(0xFFF1F5F9);

    final totalLeadsCount = _allLeads.length;
    final frontLeadsCount = _allLeads.where((l) => l["type"] == "Front").length;
    final upsellLeadsCount = _allLeads.where((l) => l["type"] == "Upsell").length;

    final filteredLeads = _getFilteredLeads();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header Title & Add Lead Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Leads Overview",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddLeadModal(context, isDark),
                    icon: Icon(Icons.add_circle_outline_rounded, size: 16.r),
                    label: Text(
                      "Add Lead",
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

              // 1. Top Metrics Horizontal Row Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMetricCard(
                      title: "Total Target",
                      value: "\$50,000",
                      icon: Icons.track_changes_rounded,
                      iconColor: const Color(0xFF2979FF),
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildMetricCard(
                      title: "Achieved Target",
                      value: "\$18,450",
                      icon: Icons.price_check_rounded,
                      iconColor: const Color(0xFF00E676),
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildMetricCard(
                      title: "Total Leads",
                      value: "$totalLeadsCount",
                      icon: Icons.leaderboard_rounded,
                      iconColor: const Color(0xFFFFC107),
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildMetricCard(
                      title: "Front Leads",
                      value: "$frontLeadsCount",
                      icon: Icons.flag_rounded,
                      iconColor: const Color(0xFF00E5FF),
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                    SizedBox(width: 10.w),
                    _buildMetricCard(
                      title: "Upsell Leads",
                      value: "$upsellLeadsCount",
                      icon: Icons.trending_up_rounded,
                      iconColor: const Color(0xFF6366F1),
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 2. Search & Date Filter Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                                hintText: "Search lead by name...",
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
                  ),
                  SizedBox(width: 10.w),

                  // Date Filter Button
                  InkWell(
                    onTap: () => _pickDateRange(context),
                    child: Container(
                      height: 40.h,
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

              // 3. Category Tabs (Fixed Spacing & Padding)
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: "All Leads ($totalLeadsCount)"),
                    Tab(text: "Front ($frontLeadsCount)"),
                    Tab(text: "Upsell ($upsellLeadsCount)"),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // 4. Render Leads List
              Expanded(
                child: filteredLeads.isEmpty
                    ? Center(
                  child: Text(
                    "No leads found matching criteria",
                    style: TextStyle(color: mutedColor, fontSize: 13.sp),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredLeads.length,
                  itemBuilder: (context, index) {
                    final lead = filteredLeads[index];
                    final isFront = lead["type"] == "Front";

                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () => _showLeadDetailModal(lead, isDark),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          lead["name"],
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: inputBg,
                                            borderRadius:
                                            BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            lead["domain"],
                                            style: TextStyle(
                                              color: const Color(0xFF2979FF),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFront
                                          ? const Color(0xFF00E5FF)
                                          .withAlpha(30)
                                          : const Color(0xFF6366F1)
                                          .withAlpha(30),
                                      borderRadius:
                                      BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: isFront
                                            ? const Color(0xFF00E5FF)
                                            : const Color(0xFF6366F1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      lead["type"],
                                      style: TextStyle(
                                        color: isFront
                                            ? const Color(0xFF00E5FF)
                                            : const Color(0xFF818CF8),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,
                                      color: mutedColor, size: 13.r),
                                  SizedBox(width: 4.w),
                                  Text(
                                    lead["email"],
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Icon(Icons.phone_outlined,
                                      color: mutedColor, size: 13.r),
                                  SizedBox(width: 4.w),
                                  Text(
                                    lead["phone"],
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: isDark
                                    ? Colors.white.withAlpha(10)
                                    : Colors.black.withAlpha(10),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Source: ${lead["source"]} • ${lead["service"]}",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Brand: ${lead["brand"]}",
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 11.sp,
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
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
    required Color borderColor,
  }) {
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
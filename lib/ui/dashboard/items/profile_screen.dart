import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _obscureCurrentPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  // Profile Form Controllers
  late TextEditingController _nameController;
  late TextEditingController _designationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Password Controllers
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  String _profileImageUrl = "https://picsum.photos/seed/user_avatar/300/300";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "Alex Morgan");
    _designationController = TextEditingController(text: "HR Manager");
    _emailController = TextEditingController(text: "alex.morgan@company.com");
    _phoneController = TextEditingController(text: "+1 202-555-0199");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Handle change password check if any field is filled
      if (_newPassController.text.isNotEmpty) {
        if (_currentPassController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter current password to change password")),
          );
          return;
        }
        if (_newPassController.text != _confirmPassController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New passwords do not match")),
          );
          return;
        }
      }

      setState(() {
        _isEditing = false;
      });

      _currentPassController.clear();
      _newPassController.clear();
      _confirmPassController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Color(0xFF00E676),
        ),
      );
    }
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

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Title & Edit/Save Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile Settings",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_isEditing) {
                          _saveProfile();
                        } else {
                          _toggleEditMode();
                        }
                      },
                      icon: Icon(
                        _isEditing ? Icons.check_rounded : Icons.edit_rounded,
                        size: 16.r,
                      ),
                      label: Text(
                        _isEditing ? "Save Changes" : "Edit Profile",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEditing
                            ? const Color(0xFF00E676)
                            : const Color(0xFF2979FF),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // 2. Profile Picture & Quick Info Header Card
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
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 45.r,
                            backgroundColor: const Color(0xFF2979FF),
                            child: CircleAvatar(
                              radius: 42.r,
                              backgroundImage: NetworkImage(_profileImageUrl),
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Image upload picker triggered"),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: const Color(0xFF2979FF),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 14.r,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        _nameController.text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _designationController.text,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // 3. Personal Information Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personal Details",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Full Name
                      _buildProfileField(
                        controller: _nameController,
                        label: "Full Name",
                        icon: Icons.person_outline_rounded,
                        isEditable: _isEditing,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Designation
                      _buildProfileField(
                        controller: _designationController,
                        label: "Designation / Role",
                        icon: Icons.badge_outlined,
                        isEditable: _isEditing,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Email Address
                      _buildProfileField(
                        controller: _emailController,
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        isEditable: _isEditing,
                        keyboardType: TextInputType.emailAddress,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Phone Number
                      _buildProfileField(
                        controller: _phoneController,
                        label: "Phone Number",
                        icon: Icons.phone_outlined,
                        isEditable: _isEditing,
                        keyboardType: TextInputType.phone,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // 4. Change Password Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              color: const Color(0xFF2979FF), size: 18.r),
                          SizedBox(width: 8.w),
                          Text(
                            "Security & Password",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      // Current Password
                      _buildPasswordField(
                        controller: _currentPassController,
                        label: "Current Password",
                        obscureText: _obscureCurrentPass,
                        isEditable: _isEditing,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureCurrentPass = !_obscureCurrentPass;
                          });
                        },
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // New Password
                      _buildPasswordField(
                        controller: _newPassController,
                        label: "New Password",
                        obscureText: _obscureNewPass,
                        isEditable: _isEditing,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureNewPass = !_obscureNewPass;
                          });
                        },
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                      SizedBox(height: 12.h),

                      // Confirm New Password
                      _buildPasswordField(
                        controller: _confirmPassController,
                        label: "Confirm New Password",
                        obscureText: _obscureConfirmPass,
                        isEditable: _isEditing,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirmPass = !_obscureConfirmPass;
                          });
                        },
                        textColor: textColor,
                        mutedColor: mutedColor,
                        inputBg: inputBg,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Bottom Save Button (visible when editing)
                if (_isEditing)
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Update Profile Settings",
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
      ),
    );
  }

  // Helper Widget for Standard Text Fields
  Widget _buildProfileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isEditable,
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
            color: mutedColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: isEditable,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isEditable ? textColor : textColor.withAlpha(180),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
          validator: (val) =>
          val == null || val.trim().isEmpty ? "Required field" : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: mutedColor, size: 18.r),
            filled: true,
            fillColor: isEditable ? inputBg : inputBg.withAlpha(100),
            isDense: true,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widget for Password Fields
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required bool isEditable,
    required VoidCallback onToggleVisibility,
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
            color: mutedColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: isEditable,
          obscureText: obscureText,
          style: TextStyle(
            color: isEditable ? textColor : textColor.withAlpha(180),
            fontSize: 13.sp,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.key_outlined, color: mutedColor, size: 18.r),
            suffixIcon: isEditable
                ? IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: mutedColor,
                size: 18.r,
              ),
              onPressed: onToggleVisibility,
            )
                : null,
            hintText: "••••••••",
            hintStyle: TextStyle(color: mutedColor, fontSize: 12.sp),
            filled: true,
            fillColor: isEditable ? inputBg : inputBg.withAlpha(100),
            isDense: true,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
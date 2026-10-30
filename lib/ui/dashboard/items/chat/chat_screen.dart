import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> employee;

  const ChatDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Chat Messages Data List
  final List<Map<String, dynamic>> _chatMessages = [
    {"type": "call", "text": "Voice Call ended (00:00)", "isVoice": true},
    {"type": "call", "text": "Video Call ended (00:00)", "isVoice": false},
    {"type": "call", "text": "Video Call ended (00:00)", "isVoice": false},
    {"type": "call", "text": "Voice Call ended (00:00)", "isVoice": true},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF16181D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E2026) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 18.r),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFF2979FF),
              child: Text(
                widget.employee["avatarText"] ?? "A",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.employee["name"] ?? "",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.employee["role"] ?? "",
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          _buildHeaderButton(
            icon: Icons.call_outlined,
            label: "Audio Call",
            borderColor: const Color(0xFF00E676),
            textColor: const Color(0xFF00E676),
          ),
          SizedBox(width: 6.w),
          _buildHeaderButton(
            icon: Icons.videocam_outlined,
            label: "Video Call",
            borderColor: const Color(0xFF2979FF),
            textColor: Colors.white,
            bgColor: const Color(0xFF2979FF),
          ),
          SizedBox(width: 4.w),
          IconButton(
            icon: Icon(Icons.phone_android_rounded, color: mutedColor, size: 20.r),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: mutedColor, size: 20.r),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // LISTVIEW.BUILDER: Chat Messages
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  final msg = _chatMessages[index];
                  final isVoice = msg["isVoice"] ?? false;

                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isVoice ? Icons.phone_disabled_rounded : Icons.videocam_off_rounded,
                            color: const Color(0xFFFF5252),
                            size: 16.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            msg["text"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Message Input Box
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file_rounded, color: mutedColor),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: textColor, fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: mutedColor, fontSize: 13.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: const Color(0xFF2979FF),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 16.r,
                        ),
                        onPressed: () {
                          if (_messageController.text.trim().isNotEmpty) {
                            setState(() {
                              _chatMessages.add({
                                "type": "text",
                                "text": _messageController.text.trim(),
                                "isVoice": false,
                              });
                              _messageController.clear();
                            });
                          }
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
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required Color borderColor,
    required Color textColor,
    Color? bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12.r),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
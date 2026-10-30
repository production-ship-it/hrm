import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siprix_voip_sdk/accounts_model.dart';
import 'package:siprix_voip_sdk/calls_model.dart';
import 'package:siprix_voip_sdk/logs_model.dart';
import 'package:siprix_voip_sdk/network_model.dart';
import 'package:siprix_voip_sdk/siprix_voip_sdk.dart';

class DialerScreen extends StatefulWidget {
  const DialerScreen({super.key});

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _numberController = TextEditingController();

  // 3CX SIP Connection Controllers
  final AccountsModel _accountsModel = AccountsModel();
  late CallsModel _callsModel;
  late NetworkModel _networkModel; // Required for WebRTC local SDP network mapping

  bool _isConnected = false;

  // 3CX Credentials
  final String _pbxHost = "1478.3cx.cloud";
  final String _sipExtension = "45010";
  final String _sipPassword = "CRM3cxSecurePass!";
  final int _sipPort = 5060; // Standard SIP port for UDP

  int? _myAccountId;

  // Active & Incoming Call State Trackers
  CallModel? _activeCall;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isOnHold = false;

  // Call Logs Dataset
  final List<dynamic> _callLogs = [
    {
      "name": "Minham Khanzada",
      "extension": "45011",
      "type": "Incoming",
      "time": "Today, 02:15 PM",
      "duration": "04m 12s",
    },
    {
      "name": "Arsalan Alvi",
      "extension": "45012",
      "type": "Missed",
      "time": "Today, 11:40 AM",
      "duration": "00m 00s",
    },
    {
      "name": "Dua Irfan",
      "extension": "45013",
      "type": "Outgoing",
      "time": "Yesterday, 05:20 PM",
      "duration": "08m 45s",
    },
  ];

  // Extension Directory Dataset
  final List<dynamic> _directory = [
    {
      "name": "Minham Khanzada",
      "ext": "45011",
      "dept": "Engineering",
      "status": "Available"
    },
    {
      "name": "Arsalan Alvi",
      "ext": "45012",
      "dept": "Creative",
      "status": "Busy"
    },
    {
      "name": "Dua Irfan",
      "ext": "45013",
      "dept": "Marketing",
      "status": "Available"
    },
    {
      "name": "Fahad Bhutto",
      "ext": "45014",
      "dept": "Sales",
      "status": "Away"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize Network Model alongside Accounts and Calls
    _networkModel = NetworkModel();
    _callsModel = CallsModel(_accountsModel);
    _callsModel.addListener(_onCallStateChanged);
    _init3CXStack();
  }

  // 1. Initialize PJSIP Stack
  Future<void> _init3CXStack() async {
    try {
      InitData initData = InitData();
      initData.logLevelFile = LogLevel.info;
      await SiprixVoipSdk().initialize(initData);
      await _connectTo3CX();
    } catch (e) {
      debugPrint("3CX SDK Init Error: $e");
    }
  }

  // 2. Connect / Register 3CX SIP Extension
  Future<void> _connectTo3CX() async {
    try {
      final existingAccounts = List.from(_accountsModel.accounts);
      for (var acc in existingAccounts) {
        await _accountsModel.deleteAccount(acc);
      }

      AccountModel acc = AccountModel();
      acc.sipServer = _pbxHost;
      acc.sipExtension = _sipExtension;
      acc.sipPassword = _sipPassword;
      acc.port = _sipPort;
      acc.expireTime = 300;
      acc.transport = SipTransport.udp;

      await _accountsModel.addAccount(acc);

      if (mounted) {
        setState(() {
          _myAccountId = acc.myAccId;
          _isConnected = true;
        });
      }

      debugPrint("3CX Account Registered Successfully with ID: $_myAccountId");
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnected = false;
          _myAccountId = null;
        });
      }
      debugPrint("3CX Connection Failed: $e");
    }
  }

  // Listen to incoming or outgoing call state changes
  void _onCallStateChanged() {
    if (!mounted) return;
    setState(() {
      if (_callsModel.isNotEmpty) {
        _activeCall = _callsModel.first;
      } else {
        _activeCall = null;
        _isMuted = false;
        _isOnHold = false;
        _isSpeakerOn = false;
      }
    });
  }

  // 3. Initiate Real SIP Call
  void _makeCall([String? target]) {
    final destinationNumber = target ?? _numberController.text.trim();

    if (destinationNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter an extension or phone number"),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    final accountId = _myAccountId ?? _accountsModel.selAccountId;

    if (accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("3CX Extension is not registered"),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    CallDestination destination = CallDestination(
      destinationNumber,
      accountId,
      false, // Audio only
    );

    _callsModel.invite(destination).catchError((err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("3CX Call Error: $err")),
        );
      }
    });
  }

  // 4. Call Handling Controls (Accept, Reject, End)
  void _acceptCall() {
    if (_activeCall != null && _activeCall!.isIncoming) {
      _activeCall!.accept();
    }
  }

  void _rejectCall() {
    if (_activeCall != null && _activeCall!.isIncoming) {
      _activeCall!.reject();
    }
  }

  void _endCall() {
    if (_activeCall != null) {
      _activeCall!.bye();
    }
  }

  // 5. Mute & Hold Controls
  void _toggleMute() {
    if (_activeCall != null) {
      setState(() {
        _isMuted = !_isMuted;
        _activeCall!.muteMic(_isMuted);
      });
    }
  }

  void _toggleHold() {
    if (_activeCall != null) {
      setState(() {
        _isOnHold = !_isOnHold;
        _activeCall!.hold();
      });
    }
  }

  void _onKeypadTap(String value) {
    setState(() {
      _numberController.text += value;
    });
    if (_activeCall != null) {
      _activeCall!.sendDtmf(value);
    }
  }

  void _onBackspace() {
    if (_numberController.text.isNotEmpty) {
      setState(() {
        _numberController.text = _numberController.text
            .substring(0, _numberController.text.length - 1);
      });
    }
  }

  @override
  void dispose() {
    _callsModel.removeListener(_onCallStateChanged);
    _tabController.dispose();
    _numberController.dispose();
    super.dispose();
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
        child: _activeCall != null
            ? _buildActiveCallScreen(cardColor, textColor, mutedColor)
            : Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "3CX Softphone",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "PBX System Extension Dialing",
                        style: TextStyle(color: mutedColor, fontSize: 11.sp),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _connectTo3CX,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: _isConnected
                            ? const Color(0xFF00E676).withAlpha(20)
                            : const Color(0xFFFF5252).withAlpha(20),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: _isConnected
                              ? const Color(0xFF00E676)
                              : const Color(0xFFFF5252),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 4.r,
                            backgroundColor: _isConnected
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFF5252),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            _isConnected ? "Ext $_sipExtension" : "Offline",
                            style: TextStyle(
                              color: _isConnected
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFFFF5252),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Container(
                height: 40.h,
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
                  tabs: const [
                    Tab(text: "Keypad"),
                    Tab(text: "Recent Calls"),
                    Tab(text: "Extensions"),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Expanded(
                child: IndexedStack(
                  index: _tabController.index,
                  children: [
                    _buildKeypadView(textColor, mutedColor, inputBg),
                    _buildCallLogsView(cardColor, textColor, mutedColor, borderColor),
                    _buildDirectoryView(cardColor, textColor, mutedColor, borderColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadView(Color textColor, Color mutedColor, Color inputBg) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['*', '0', '#']
    ];

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _numberController.text.isEmpty ? "Enter extension or number" : _numberController.text,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _numberController.text.isEmpty ? mutedColor : textColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              if (_numberController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.backspace_outlined, color: mutedColor, size: 20.r),
                  onPressed: _onBackspace,
                ),
            ],
          ),
        ),

        const Spacer(),

        Column(
          children: keys.map((row) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((key) {
                  return InkWell(
                    onTap: () => _onKeypadTap(key),
                    borderRadius: BorderRadius.circular(36.r),
                    child: Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        color: inputBg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          key,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 16.h),

        GestureDetector(
          onTap: () => _makeCall(),
          child: Container(
            width: 68.r,
            height: 68.r,
            decoration: const BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.call_rounded, color: Colors.black, size: 30.r),
          ),
        ),

        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildCallLogsView(
      Color cardColor, Color textColor, Color mutedColor, Color borderColor) {
    return ListView.builder(
      itemCount: _callLogs.length,
      itemBuilder: (context, index) {
        final log = _callLogs[index];
        final isMissed = log["type"] == "Missed";

        IconData icon;
        Color iconColor;

        if (log["type"] == "Incoming") {
          icon = Icons.call_received_rounded;
          iconColor = const Color(0xFF00E676);
        } else if (log["type"] == "Outgoing") {
          icon = Icons.call_made_rounded;
          iconColor = const Color(0xFF2979FF);
        } else {
          icon = Icons.call_missed_rounded;
          iconColor = const Color(0xFFFF5252);
        }

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: iconColor.withAlpha(25),
                child: Icon(icon, color: iconColor, size: 18.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log["name"] ?? "",
                      style: TextStyle(
                        color: isMissed ? const Color(0xFFFF5252) : textColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Ext: ${log["extension"]} • ${log["time"]}",
                      style: TextStyle(color: mutedColor, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.call, color: const Color(0xFF00E676), size: 18.r),
                onPressed: () => _makeCall(log["extension"]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDirectoryView(
      Color cardColor, Color textColor, Color mutedColor, Color borderColor) {
    return ListView.builder(
      itemCount: _directory.length,
      itemBuilder: (context, index) {
        final emp = _directory[index];
        final status = emp["status"] as String;

        Color statusColor;
        switch (status) {
          case "Available":
            statusColor = const Color(0xFF00E676);
            break;
          case "Busy":
            statusColor = const Color(0xFFFF5252);
            break;
          default:
            statusColor = const Color(0xFFFF9800);
        }

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFF2979FF).withAlpha(25),
                child: Icon(Icons.person_outline_rounded,
                    color: const Color(0xFF2979FF), size: 18.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emp["name"] ?? "",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Ext: ${emp["ext"]} • ${emp["dept"]}",
                      style: TextStyle(color: mutedColor, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10.r),
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
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(Icons.call, color: const Color(0xFF00E676), size: 18.r),
                onPressed: () => _makeCall(emp["ext"]),
              ),
            ],
          ),
        );
      },
    );
  }

  // Active / Incoming Call UI Screen
  Widget _buildActiveCallScreen(
      Color cardColor, Color textColor, Color mutedColor) {
    final isIncoming = _activeCall?.isIncoming ?? false;
    final remoteNumber = _activeCall?.remoteExt ??
        (_numberController.text.isNotEmpty ? _numberController.text : "Unknown Extension");
    final callStateText = isIncoming
        ? "Incoming 3CX Call..."
        : (_isOnHold ? "Call on Hold" : "Connected (3CX SIP)");

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          CircleAvatar(
            radius: 44.r,
            backgroundColor: const Color(0xFF2979FF).withAlpha(25),
            child: Icon(Icons.person_rounded,
                color: const Color(0xFF2979FF), size: 48.r),
          ),
          SizedBox(height: 16.h),
          Text(
            remoteNumber,
            style: TextStyle(
              color: textColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            callStateText,
            style: TextStyle(
              color: isIncoming
                  ? const Color(0xFF2979FF)
                  : (_isOnHold ? const Color(0xFFFF9800) : const Color(0xFF00E676)),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          if (isIncoming) ...[
            // Accept / Reject UI for Incoming Call
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _rejectCall,
                  child: CircleAvatar(
                    radius: 34.r,
                    backgroundColor: const Color(0xFFFF5252),
                    child: Icon(Icons.call_end_rounded, color: Colors.white, size: 28.r),
                  ),
                ),
                GestureDetector(
                  onTap: _acceptCall,
                  child: CircleAvatar(
                    radius: 34.r,
                    backgroundColor: const Color(0xFF00E676),
                    child: Icon(Icons.call_rounded, color: Colors.black, size: 28.r),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Active Call Audio Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallControlButton(
                  icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  label: "Mute",
                  isActive: _isMuted,
                  onTap: _toggleMute,
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                _buildCallControlButton(
                  icon: _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                  label: "Speaker",
                  isActive: _isSpeakerOn,
                  onTap: () {
                    setState(() {
                      _isSpeakerOn = !_isSpeakerOn;
                    });
                  },
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                _buildCallControlButton(
                  icon: Icons.pause_rounded,
                  label: "Hold",
                  isActive: _isOnHold,
                  onTap: _toggleHold,
                  cardColor: cardColor,
                  textColor: textColor,
                ),
              ],
            ),

            SizedBox(height: 32.h),

            GestureDetector(
              onTap: _endCall,
              child: Container(
                width: 68.r,
                height: 68.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5252),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.call_end_rounded, color: Colors.white, size: 30.r),
              ),
            ),
          ],

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCallControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF2979FF) : cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : textColor,
              size: 22.r,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(color: textColor, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
import 'dart:async';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/otp/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/otp_controller.dart';
 // pastikan path ini benar

class OtpView extends StatefulWidget {
  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final int otpLength = 6;
  final int totalTimeInSeconds = 300;
  final OtpController otpControllerGetx = Get.put(OtpController());

  List<FocusNode> focusNodes = [];
  List<TextEditingController> otpFieldControllers = [];

  Timer? _timer;
  int _secondsRemaining = 300;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    otpFieldControllers = List.generate(otpLength, (_) => TextEditingController());
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    focusNodes.forEach((node) => node.dispose());
    otpFieldControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _secondsRemaining = totalTimeInSeconds;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < otpLength - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    setState(() {});
  }

  String getOtp() {
    return otpFieldControllers.map((c) => c.text).join();
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Verifikasi OTP',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Lottie.asset('assets/lottie/otp1.json', height: 200),
              SizedBox(height: 24),
              Text('Masukkan Kode OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Kode OTP dikirim ke Email Anda', style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(otpLength, (index) {
                  bool isFocused = focusNodes[index].hasFocus;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: MediaQuery.of(context).size.width / 9,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isFocused ? Colors.brown : Colors.grey.shade300,
                        width: isFocused ? 2 : 1.5,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: TextField(
                        controller: otpFieldControllers[index],
                        focusNode: focusNodes[index],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => _onOtpChanged(value, index),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24),
              Text(
                _canResend
                    ? 'Tidak menerima kode?'
                    : 'Kirim ulang kode dalam ${formatTime(_secondsRemaining)}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              TextButton(
                onPressed: _canResend
                    ? () {
                        // TODO: Implement resend OTP di backend
                        startTimer();
                      }
                    : null,
                child: Text(
                  'Kirim Ulang OTP',
                  style: TextStyle(
                    color: _canResend ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Obx(() => otpControllerGetx.isLoading.value
                  ? CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () {
                        final otp = getOtp();
                        if (otp.length < otpLength) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Silakan lengkapi OTP terlebih dahulu.')),
                          );
                          return;
                        }
                        otpControllerGetx.otpController.text = otp;
                        otpControllerGetx.verifyOtp();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.brown],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Verifikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

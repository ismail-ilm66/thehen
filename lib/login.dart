// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:wordpress/web_view.dart';
// // import 'colors.dart';
// //
// // class LoginScreen extends StatefulWidget {
// //   @override
// //   _LoginScreenState createState() => _LoginScreenState();
// // }
// //
// // class _LoginScreenState extends State<LoginScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   bool _obscurePassword = true;
// //
// //   void _showSnackbar(String message, Color backgroundColor) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(
// //           message,
// //           style: TextStyle(color: ColorPalette.whiteColor),
// //         ),
// //         backgroundColor: backgroundColor,
// //         behavior: SnackBarBehavior.floating,
// //         margin: EdgeInsets.all(16.0),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       ),
// //     );
// //   }
// //
// //   void _validateAndLogin() {
// //     if (_formKey.currentState!.validate()) {
// //       _showSnackbar("Login successful!", ColorPalette.greenColor);
// //       Get.to(() => InAppWebViewFileUploadPage());
// //     } else {
// //       _showSnackbar("Login Failed", ColorPalette.redColor);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: ColorPalette.primaryColor,
// //       body: Center(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   "Welcome Back!",
// //                   style: TextStyle(
// //                     fontSize: 28,
// //                     fontWeight: FontWeight.w700,
// //                     color: ColorPalette.blackColor,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 Text(
// //                   "Login to your account",
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     color: ColorPalette.blackColor.withOpacity(0.7),
// //                   ),
// //                 ),
// //                 SizedBox(height: 40),
// //                 TextFormField(
// //                   controller: _emailController,
// //                   decoration: InputDecoration(
// //                     hintText: "Email / Username",
// //                     prefixIcon: Icon(Icons.email_outlined,
// //                         color: ColorPalette.blackColor),
// //                     filled: true,
// //                     fillColor: ColorPalette.whiteColor,
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(16),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                     contentPadding:
// //                         EdgeInsets.symmetric(vertical: 18, horizontal: 16),
// //                     hintStyle: TextStyle(
// //                         color: ColorPalette.blackColor.withOpacity(0.5)),
// //                   ),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return "Please enter your email/username.";
// //                     }
// //                     bool isEmail = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(value);
// //
// //                     bool isUsername = RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value);
// //
// //                     if (!isEmail && !isUsername) {
// //                       return "Enter a valid email or username.";
// //                     }
// //
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextFormField(
// //                   controller: _passwordController,
// //                   obscureText: _obscurePassword,
// //                   decoration: InputDecoration(
// //                     hintText: "Password",
// //                     prefixIcon: Icon(Icons.lock_outline,
// //                         color: ColorPalette.blackColor),
// //                     suffixIcon: IconButton(
// //                       icon: Icon(
// //                         _obscurePassword
// //                             ? Icons.visibility_off
// //                             : Icons.visibility,
// //                         color: ColorPalette.blackColor,
// //                       ),
// //                       onPressed: () {
// //                         setState(() {
// //                           _obscurePassword = !_obscurePassword;
// //                         });
// //                       },
// //                     ),
// //                     filled: true,
// //                     fillColor: ColorPalette.whiteColor,
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(16),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                     contentPadding:
// //                         EdgeInsets.symmetric(vertical: 18, horizontal: 16),
// //                     hintStyle: TextStyle(
// //                         color: ColorPalette.blackColor.withOpacity(0.5)),
// //                   ),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return "Please enter your password.";
// //                     }
// //                     if (value.length < 6) {
// //                       return "Password must be at least 6 characters long.";
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 30),
// //                 ElevatedButton(
// //                   onPressed: _validateAndLogin,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: ColorPalette.blackColor,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     padding:
// //                         EdgeInsets.symmetric(vertical: 16, horizontal: 120),
// //                     elevation: 6,
// //                   ),
// //                   child: Text(
// //                     "Login",
// //                     style: TextStyle(
// //                       color: ColorPalette.whiteColor,
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:wordpress/web_view.dart';
// import 'admin_dashboard.dart';
// import 'colors.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _obscurePassword = true;
//
//   void _showSnackbar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(color: ColorPalette.whiteColor),
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(16.0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
//
//   Future<void> _saveTokenToFirestore(String username) async {
//     try {
//       // Get the FCM token
//       String? fcmToken = await FirebaseMessaging.instance.getToken();
//       print("The FCM token is: $fcmToken");
//       if (fcmToken == null) {
//         throw Exception("Unable to fetch FCM token");
//       }
//
//       // Check if the username already exists in Firestore
//       DocumentReference userDoc = _firestore.collection('users').doc(username);
//
//       userDoc.get().then((docSnapshot) {
//         if (docSnapshot.exists) {
//           // Update the FCM token if the user exists
//           userDoc.update({'fcm_token': fcmToken}).then((_) {
//             _showSnackbar("FCM token updated successfully!", ColorPalette.greenColor);
//           }).catchError((error) {
//             _showSnackbar("Error updating FCM token: $error", ColorPalette.redColor);
//           });
//         } else {
//           // Create a new document if the username doesn't exist
//           userDoc.set({
//             'username': username,
//             'fcm_token': fcmToken,
//           }).then((_) {
//             _showSnackbar("User created and token saved!", ColorPalette.greenColor);
//           }).catchError((error) {
//             _showSnackbar("Error saving user: $error", ColorPalette.redColor);
//           });
//         }
//       });
//     } catch (e) {
//       _showSnackbar("Error: $e", ColorPalette.redColor);
//     }
//   }
//
//   void _validateAndLogin() {
//     if (_formKey.currentState!.validate()) {
//
//       String username = _emailController.text.trim();
//       String password = _passwordController.text.trim();
//
//       if(username == "admin" && password == "admin1@") {
//         _showSnackbar("Login successful!", ColorPalette.greenColor);
//         //_saveTokenToFirestore(username);
//         Get.to(() => DashboardScreen());
//       }
//       else
//         {
//           _saveTokenToFirestore(username);
//           Get.to(() => InAppWebViewFileUploadPage());
//         }
//
//     } else {
//       _showSnackbar("Login Failed", ColorPalette.redColor);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorPalette.primaryColor,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Welcome Back!",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     color: ColorPalette.blackColor,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Login to your account",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: ColorPalette.blackColor.withOpacity(0.7),
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     hintText: "Email / Username",
//                     prefixIcon: Icon(Icons.email_outlined,
//                         color: ColorPalette.blackColor),
//                     filled: true,
//                     fillColor: ColorPalette.whiteColor,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding:
//                     EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//                     hintStyle: TextStyle(
//                         color: ColorPalette.blackColor.withOpacity(0.5)),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter your email/username.";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     hintText: "Password",
//                     prefixIcon: Icon(Icons.lock_outline,
//                         color: ColorPalette.blackColor),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: ColorPalette.blackColor,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                     filled: true,
//                     fillColor: ColorPalette.whiteColor,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding:
//                     EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//                     hintStyle: TextStyle(
//                         color: ColorPalette.blackColor.withOpacity(0.5)),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter your password.";
//                     }
//                     if (value.length < 6) {
//                       return "Password must be at least 6 characters long.";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _validateAndLogin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorPalette.blackColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     padding:
//                     EdgeInsets.symmetric(vertical: 16, horizontal: 120),
//                     elevation: 6,
//                   ),
//                   child: Text(
//                     "Login",
//                     style: TextStyle(
//                       color: ColorPalette.whiteColor,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

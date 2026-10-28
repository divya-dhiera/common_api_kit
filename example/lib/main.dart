import 'package:common_api_kit/common_api_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controller.dart';
import 'home_screen.dart';

String baseUrl = "https://your_domain/api";
CommonController commonController = Get.put(CommonController());
GetStorage box = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  APIProvider.init(baseUrl: baseUrl);

  ApiService.appName = 'Common Api Demo';

  ApiService.getAuthToken = () {
    final token = box.read('auth_token');
    if (kDebugMode) {
      print("token ======>$token");
    }
    return token ?? '';
  };

  ApiService.onUnauthorized = () {
    box.remove('auth_token');
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        title: const Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Email",
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                  size: 25,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: pass,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              obscureText: passwordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                  size: 25,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  child: Icon(
                    passwordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black,
                  ).paddingAll(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                commonController.callLoginApi(
                  {"email": email.text, "password": pass.text},
                  () {
                    Get.snackbar('Success', 'Login Success');

                    Map<String, dynamic> params = {"per_page": 20, "page": 1};
                    commonController.getAllProductApi(params, () {
                      Get.to(() => const HomeScreen());
                    });
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.withValues(alpha: 0.7),
                ),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

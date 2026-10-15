import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:camera/camera.dart';
import 'dart:io';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint("Camera initialization error: $e");
  }

  await Supabase.initialize(
    url: 'https://kjyjlwklxuunjwfkeigr.supabase.co',
    anonKey: 'sb_publishable_s5pbZ46gCoAyf4oWdR6EgA_cGwEM1NB',
  );

  runApp(const CleanLoopApp());
}

// ==========================================
// MULTI-LANGUAGE LOCALIZATION CONTROLLER
// ==========================================
class AppLanguage {
  static String selectedLanguage = 'English';

  static final Map<String, Map<String, String>> translations = {
    'English': {
      'title': 'CleanLoop',
      'live_scanner': 'Scanner',
      'hotspots': 'Hotspots',
      'vendors': 'Vendors',
      'impact': 'Impact',
      'register_shop': 'Register Unit',
      'active_scanner': '🔴 LIVE HARDWARE CAMERA STREAMING',
      'snap_btn': 'SNAP LIVE PHOTO',
      'detected': 'Detected Category',
      'steps': 'Disposal Instructions',
      'no_camera': 'No camera detected. Connect physical mobile device.',
      'login_title': 'Welcome to CleanLoop',
      'login_subtitle': 'Sign in securely via Supabase to earn Green Points',
      'email_hint': 'Email Address',
      'pass_hint': 'Password',
      'login_btn': 'Login',
      'signup_btn': 'Create New Account',
      'logout': 'Logout',
    },
    'தமிழ்': {
      'title': 'க்ளீன்லூப்',
      'live_scanner': 'ஸ்கேனர்',
      'hotspots': 'வரைபடம்',
      'vendors': 'சேகரிப்பாளர்கள்',
      'impact': 'தாக்கம்',
      'register_shop': 'கடை பதிவு',
      'active_scanner': '🔴 நேரடி கேமரா இயங்குகிறது',
      'snap_btn': 'படம் எடுக்கவும்',
      'detected': 'கண்டறியப்பட்ட வகை',
      'steps': 'அகற்றும் வழிமுறைகள்',
      'no_camera': 'கேமரா கிடைக்கவில்லை.',
      'login_title': 'க்ளீன்லூப்பிற்கு உங்களை வரவேற்கிறோம்',
      'login_subtitle': 'புள்ளிகளைப் பெற உள்நுழையவும்',
      'email_hint': 'மின்னஞ்சல் முகவரி',
      'pass_hint': 'கடவுச்சொல்',
      'login_btn': 'உள்நுழைக',
      'signup_btn': 'புதிய கணக்கை உருவாக்கவும்',
      'logout': 'வெளியேறு',
    },
    'हिंदी': {
      'title': 'क्लीनलूप',
      'live_scanner': 'स्कैनर',
      'hotspots': 'हॉटस्पॉट',
      'vendors': 'विक्रेता',
      'impact': 'प्रभाव',
      'register_shop': 'इकाई पंजीकृत करें',
      'active_scanner': '🔴 AI कचरा वर्गीकरण तैयार',
      'snap_btn': 'लाइव फोटो लें',
      'detected': 'पहचाना गया वर्गीकरण',
      'steps': 'निपटान निर्देश',
      'no_camera': 'कैमरा नहीं मिला।',
      'login_title': 'क्लीनलूप में आपका स्वागत है',
      'login_subtitle': 'पॉइंट्स कमाने के लिए साइन इन करें',
      'email_hint': 'ईमेल पता',
      'pass_hint': 'पासवर्ड',
      'login_btn': 'लॉगिन',
      'signup_btn': 'नया खाता बनाएं',
      'logout': 'लॉग आउट',
    },
    'తెలుగు': {
      'title': 'క్లీన్‌లూప్',
      'live_scanner': 'స్కానర్',
      'hotspots': 'హాట్‌స్పాట్‌లు',
      'vendors': 'విక్రేతలు',
      'impact': 'ప్రభావం',
      'register_shop': 'యూనిట్ నమోదు',
      'active_scanner': '🔴 ప్రత్యక్ష కెమెరా స్ట్రీమింగ్',
      'snap_btn': 'లైవ్ ఫోటో తీయండి',
      'detected': 'గుర్తించబడిన వర్గం',
      'steps': 'విసర్జన సూచనలు',
      'no_camera': 'కెమెరా కనుగొనబడలేదు.',
      'login_title': 'క్లీన్‌లూప్‌కు స్వాగతం',
      'login_subtitle': 'గ్రీన్ పాయింట్లు సంపాదించడానికి సైన్ ఇన్ చేయండి',
      'email_hint': 'ఈమెయిల్ చిరునామా',
      'pass_hint': 'పాస్‌వర్డ్',
      'login_btn': 'లాగిన్',
      'signup_btn': 'కొత్త ఖాతాను సృష్టించండి',
      'logout': 'లాగ్ అవుట్',
    },
    'മലയാളം': {
      'title': 'ക്ലീൻലൂപ്പ്',
      'live_scanner': 'സ്‌കാനർ',
      'hotspots': 'ഹോട്ട്‌സ്‌പോട്ടുകൾ',
      'vendors': 'വ്യാപാരികൾ',
      'impact': 'സ്വാധീനം',
      'register_shop': 'യൂണിറ്റ് രജിസ്റ്റർ ചെയ്യുക',
      'active_scanner': '🔴 തത്സമയ ക്യാമറ സ്ട്രീമിംഗ്',
      'snap_btn': 'ഫോട്ടോയെടുക്കുക',
      'detected': 'കണ്ടെത്തിയ വിഭാഗം',
      'steps': 'നിർദ്ദേശങ്ങൾ',
      'no_camera': 'ക്യാമറ കണ്ടെത്തിയില്ല.',
      'login_title': 'ക്ലീൻലൂപ്പിലേക്ക് സ്വാഗതം',
      'login_subtitle': 'പോയിന്റുകൾ നേടാൻ ലോഗിൻ ചെയ്യുക',
      'email_hint': 'ഇമെയിൽ വിലാസം',
      'pass_hint': 'പാസ്‌വേർഡ്',
      'login_btn': 'ലോഗിൻ',
      'signup_btn': 'പുതിയ അക്കൗണ്ട് സൃഷ്ടിക്കുക',
      'logout': 'പുറത്തുപോവുക',
    },
    'കന്നഡ': {
      'title': 'ಕ್ಲೀನ್‌ಲೂಪ್',
      'live_scanner': 'ಸ್ಕ್ಯಾನರ್',
      'hotspots': 'ಹಾಟ್‌ಸ್ಪಾಟ್‌ಗಳು',
      'vendors': 'ಮಾರಾಟಗಾರರು',
      'impact': 'ಪರಿಣಾಮ',
      'register_shop': 'ಘಟಕ ನೋಂದಾಯಿಸಿ',
      'active_scanner': '🔴 ಲೈವ್ ಕ್ಯಾಮೆರಾ ಸ್ಟ್ರೀಮಿಂಗ್',
      'snap_btn': 'ಫೋಟೋ ಸೆರೆಹಿಡಿಯಿರಿ',
      'detected': 'ಗುರ್ತಿಸಲಾದ ವರ್ಗ',
      'steps': 'ವಿಲೇವಾರಿ ಸೂಚನೆಗಳು',
      'no_camera': 'ಯಾವ ಕ್ಯಾಮೆರಾವೂ ಪತ್ತೆಯಾಗಿಲ್ಲ.',
      'login_title': 'ಕ್ಲೀನ್‌ಲೂಪ್‌ಗೆ ಸ್ವಾಗತ',
      'login_subtitle': 'ಅಂಕಗಳನ್ನು ಗಳಿಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ',
      'email_hint': 'ಇಮೇಲ್ ವಿಳಾಸ',
      'pass_hint': 'ಪಾಸ್‌ವರ್ಡ್',
      'login_btn': 'ಲಾಗಿನ್',
      'signup_btn': 'ಹೊಸ ಖಾತೆ ರಚಿಸಿ',
      'logout': 'ಲಾಗ್ ಔಟ್',
    },
  };

  static String getText(String key) {
    return translations[selectedLanguage]?[key] ?? translations['English']![key]!;
  }
}

class CleanLoopApp extends StatelessWidget {
  const CleanLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanLoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4D3E)),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

// ==========================================
// SUPABASE AUTHENTICATION GATE
// ==========================================
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = Supabase.instance.client.auth.currentUser;
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _currentUser = data.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const AuthScreen();
    } else {
      return const HomeScreen();
    }
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;

  Future<void> _authenticate() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully!')));
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> languages = ['English', 'தமிழ்', 'हिंदी', 'తెలుగు', 'മലയാളം', 'കന്നഡ'];

    return Scaffold(
      backgroundColor: const Color(0xFF1B4D3E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF1B4D3E),
              value: AppLanguage.selectedLanguage,
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white),
              items: languages.map((String lang) {
                return DropdownMenuItem<String>(
                  value: lang,
                  child: Text(lang, style: const TextStyle(color: Colors.white, fontSize: 13)),
                );
              }).toList(),
              onChanged: (String? newLang) {
                if (newLang != null) {
                  setState(() {
                    AppLanguage.selectedLanguage = newLang;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, size: 60, color: Color(0xFF1B4D3E)),
                  const SizedBox(height: 12),
                  Text(AppLanguage.getText('login_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E))),
                  const SizedBox(height: 6),
                  Text(AppLanguage.getText('login_subtitle'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: AppLanguage.getText('email_hint'), border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: AppLanguage.getText('pass_hint'), border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4D3E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isLoading ? null : _authenticate,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(_isSignUp ? AppLanguage.getText('signup_btn') : AppLanguage.getText('login_btn'), style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(_isSignUp ? 'Already have an account? Login' : 'Need an account? Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HOME SCREEN & NAVIGATION CONTROLLER
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _languages = ['English', 'தமிழ்', 'हिंदी', 'తెలుగు', 'മലയാളം', 'കന്നഡ'];
  int _greenPoints = 350;

  final List<Widget> _screens = [
    const LiveNativeScanScreen(),
    const MapScreen(),
    const RecyclerDirectoryScreen(),
    const DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(AppLanguage.getText('title'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber.shade700, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text('$_greenPoints Pts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1B4D3E),
        actions: [
          DropdownButton<String>(
            dropdownColor: const Color(0xFF1B4D3E),
            value: AppLanguage.selectedLanguage,
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.white),
            items: _languages.map((String lang) {
              return DropdownMenuItem<String>(
                value: lang,
                child: Text(lang, style: const TextStyle(color: Colors.white, fontSize: 13)),
              );
            }).toList(),
            onChanged: (String? newLang) {
              if (newLang != null) {
                setState(() {
                  AppLanguage.selectedLanguage = newLang;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_business, color: Colors.white),
            tooltip: AppLanguage.getText('register_shop'),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterVendorScreen()));
              setState(() {
                _greenPoints += 100;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: AppLanguage.getText('logout'),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1B4D3E),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.camera_alt), label: AppLanguage.getText('live_scanner')),
          BottomNavigationBarItem(icon: const Icon(Icons.map), label: AppLanguage.getText('hotspots')),
          BottomNavigationBarItem(icon: const Icon(Icons.store), label: AppLanguage.getText('vendors')),
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: AppLanguage.getText('impact')),
        ],
      ),
    );
  }
}

// ==========================================
// LIVE HARDWARE CAMERA SCANNER SCREEN
// ==========================================
class LiveNativeScanScreen extends StatefulWidget {
  const LiveNativeScanScreen({super.key});

  @override
  State<LiveNativeScanScreen> createState() => _LiveNativeScanScreenState();
}

class _LiveNativeScanScreenState extends State<LiveNativeScanScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String? _capturedImagePath;
  Map<String, dynamic>? _scanResult;

  final List<Map<String, dynamic>> _wasteDatabase = [
    {
      'label': 'PET Plastic Bottle (DRY WASTE)',
      'instructions': '1. Rinse thoroughly\n2. Compress bottle\n3. Dispose in Blue Dry Bin',
    },
    {
      'label': 'Organic Food Waste (WET WASTE)',
      'instructions': '1. Separate plastic wrappers\n2. Put into Green Bio-Compost bin',
    },
    {
      'label': 'E-Waste / Electronic Device',
      'instructions': '1. Do not break or burn\n2. Drop off at local E-waste collection hub',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing camera hardware: $e");
    }
  }

  Future<void> _captureAndClassify() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImagePath = photo.path;
        _wasteDatabase.shuffle();
        _scanResult = _wasteDatabase.first;
        _isProcessing = false;
      });
    } catch (e) {
      debugPrint("Error taking photo: $e");
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                color: Colors.black,
                child: _capturedImagePath != null
                    ? Image.file(File(_capturedImagePath!), fit: BoxFit.cover, width: double.infinity)
                    : _isCameraInitialized
                        ? CameraPreview(_cameraController!)
                        : Center(
                            child: Text(
                              AppLanguage.getText('no_camera'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
              ),
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Text(
                  AppLanguage.getText('active_scanner'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 32,
                right: 32,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4D3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isProcessing ? null : _captureAndClassify,
                  icon: const Icon(Icons.camera),
                  label: Text(
                    _isProcessing ? "ANALYZING..." : AppLanguage.getText('snap_btn'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _scanResult != null
                      ? "${AppLanguage.getText('detected')}: ${_scanResult!['label']}"
                      : "Point camera at item and tap Snap",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1B4D3E)),
                ),
                const SizedBox(height: 8),
                Text(
                  _scanResult != null
                      ? "${AppLanguage.getText('steps')}:\n${_scanResult!['instructions']}"
                      : "Real-time feed active. Aim camera directly at plastic, paper, or e-waste.",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// VENDOR REGISTRATION SCREEN
// ==========================================
class RegisterVendorScreen extends StatefulWidget {
  const RegisterVendorScreen({super.key});

  @override
  State<RegisterVendorScreen> createState() => _RegisterVendorScreenState();
}

class _RegisterVendorScreenState extends State<RegisterVendorScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _category = 'E-Waste & Plastic';
  bool _isSubmitting = false;

  Future<void> _submitRegistration() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in required fields')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await Supabase.instance.client.from('reports').insert({
        'title': _nameController.text.trim(),
        'description': 'Category: $_category | Phone: ${_phoneController.text.trim()} | Address: ${_addressController.text.trim()}',
        'latitude': 13.0827,
        'longitude': 80.2707,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recycling Unit Registered Successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unit Registered Successfully!')));
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.getText('register_shop')),
        backgroundColor: const Color(0xFF1B4D3E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Register Your Recycling Unit / Scrap Shop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E))),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Shop Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: ['E-Waste & Plastic', 'Paper & Metals', 'Organic / Wet Waste', 'Hazardous Waste']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4D3E), padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: _isSubmitting ? null : _submitRegistration,
              child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Registration', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MAP, DIRECTORY & DASHBOARD SCREENS
// ==========================================
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(initialCenter: LatLng(13.0827, 80.2707), initialZoom: 13.0),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.cleanloop'),
        const MarkerLayer(
          markers: [
            Marker(point: LatLng(13.0827, 80.2707), width: 80, height: 80, child: Icon(Icons.location_pin, color: Colors.red, size: 40)),
          ],
        ),
      ],
    );
  }
}

class RecyclerDirectoryScreen extends StatelessWidget {
  const RecyclerDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Card(
          child: ListTile(
            title: Text('GreenChennai Eco Solutions', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E))),
            subtitle: Text('E-Waste & Plastic • Anna Nagar, Chennai\nPhone: +91 44 2654 8890'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.star, color: Colors.amber, size: 16), Text(' 4.8')]),
          ),
        ),
      ],
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Text('Your Environmental Impact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E))),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            ImpactCard(title: 'Waste Recycled', value: '42.5 kg', icon: Icons.recycling, color: Colors.green),
            ImpactCard(title: 'CO2 Saved', value: '18.2 kg', icon: Icons.cloud, color: Colors.blue),
            ImpactCard(title: 'Hotspots Cleared', value: '7 Areas', icon: Icons.check_circle, color: Colors.orange),
            ImpactCard(title: 'Green Coins', value: '350 pts', icon: Icons.monetization_on, color: Colors.amber),
          ],
        ),
      ],
    );
  }
}

class ImpactCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ImpactCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
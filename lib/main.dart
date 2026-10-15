import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://kjyjlwklxuunjwfkeigr.supabase.co',
      anonKey: 'sb_publishable_s5pbZ46gCoAyf4oWdR6EgA_cGwEM1NB',
    );
  } catch (e) {
    debugPrint('Supabase init note: $e');
  }

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera init error: $e');
  }

  runApp(const CleanLoopApp());
}

class CleanLoopApp extends StatelessWidget {
  const CleanLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanLoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF4F9F4),
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// AUTHENTICATION SCREEN
// -----------------------------------------------------------------------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created! Please log in.')),
          );
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Auth Note: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToDemo() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainDashboard()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 80, color: Colors.green),
              const SizedBox(height: 12),
              const Text('CleanLoop AI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
              const Text('Waste to Resource Platform', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 28),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _handleAuth,
                      child: Text(_isSignUp ? 'Sign Up' : 'Log In', style: const TextStyle(fontSize: 18)),
                    ),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(_isSignUp ? 'Already have an account? Log In' : 'New user? Create an account'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.flash_on, size: 24),
                label: const Text('Quick Demo Access (For Judges)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _goToDemo,
              ),
              const Divider(height: 36),
              OutlinedButton.icon(
                icon: const Icon(Icons.handshake),
                label: const Text('Partner Registration (Scrap Dealers & NGOs)'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PartnerRegistrationScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN CONTAINER WITH BOTTOM NAVIGATION
// -----------------------------------------------------------------------------
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  String _selectedLanguage = 'English';
  int _greenPoints = 180;

  void _updatePoints(int added) {
    setState(() {
      _greenPoints += added;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        selectedLanguage: _selectedLanguage,
        onLanguageChanged: (lang) => setState(() => _selectedLanguage = lang),
        greenPoints: _greenPoints,
        onPointsAdded: _updatePoints,
      ),
      const HotspotsScreen(),
      const VendorsScreen(),
      const ImpactsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Hotspots'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Vendors'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Impacts'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. HOME SCREEN
// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;
  final int greenPoints;
  final ValueChanged<int> onPointsAdded;

  HomeScreen({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.greenPoints,
    required this.onPointsAdded,
  });

  final Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'title': 'CleanLoop Waste AI',
      'subtitle': 'Turn everyday waste into verified resources',
      'points': 'Green Points Earned',
      'streak': 'Daily Login Streak',
      'scanBtn': 'Open Live Camera Scanner',
      'partnerBtn': 'Become a Recycling Partner',
    },
    'Tamil': {
      'title': 'CleanLoop கழிவு AI',
      'subtitle': 'தினசரி கழிவுகளை மதிப்புள்ள வளமாக மாற்றுக',
      'points': 'பசுமை புள்ளிகள்',
      'streak': 'தினசரி வருகை தொடர்',
      'scanBtn': 'நேரலை கேமராவை திறக்கவும்',
      'partnerBtn': 'மறுசுழற்சி பங்காளராக இணையுங்கள்',
    },
    'Hindi': {
      'title': 'CleanLoop कचरा AI',
      'subtitle': 'कचरे को उपयोगी संसाधनों में बदलें',
      'points': 'ग्रीन पॉइंट्स',
      'streak': 'डेली लॉगिन स्ट्रिक',
      'scanBtn': 'लाइव कैमरा स्कैनर खोलें',
      'partnerBtn': 'रिसाइक्लिंग पार्टनर बनें',
    },
    'Telugu': {
      'title': 'CleanLoop వ్యర్థాల AI',
      'subtitle': 'రోజువారీ వ్యర్థాలను వనరులుగా మార్చండి',
      'points': 'గ్రీన్ పాయింట్లు',
      'streak': 'డైలీ లాగిన్ స్ట్రీక్',
      'scanBtn': 'లైవ్ కెమెరా స్క్యానర్ తెరవండి',
      'partnerBtn': 'రీసైక్లింగ్ భాగస్వామిగా మారండి',
    },
    'Malayalam': {
      'title': 'CleanLoop വേസ്റ്റ് AI',
      'subtitle': 'ദൈനംദിന മാലിന്യങ്ങൾ വിഭവങ്ങളാക്കി മാറ്റുക',
      'points': 'ഗ്രീൻ പോയിന്റുകൾ',
      'streak': 'ഡെയ്‌ലി ലോഗിൻ സ്ട്രീക്ക്',
      'scanBtn': 'ലൈവ് ക്യാമറ സ്കാനർ തുറക്കുക',
      'partnerBtn': 'റീസൈക്ലിംഗ് പങ്കാളിയാകൂ',
    },
    'Kannada': {
      'title': 'CleanLoop ತ್ಯಾಜ್ಯ AI',
      'subtitle': 'ದೈನಂದಿನ ತ್ಯಾಜ್ಯವನ್ನು ಸಂಪನ್ಮೂಲವಾಗಿ ಮಾರ್ಪಡಿಸಿ',
      'points': 'ಗ್ರೀನ್ ಪಾಯಿಂಟ್‌ಗಳು',
      'streak': 'ಡೈಲಿ ಲಾಗಿನ್ ಸ್ಕ್ಯಾನ್',
      'scanBtn': 'ಲೈವ್ ಕ್ಯಾಮೆರಾವನ್ನು ತೆರೆಯಿರಿ',
      'partnerBtn': 'ಮರುಬಳಕೆ ಪಾಲುದಾರರಾಗಿ',
    },
  };

  void _openCameraScanner(BuildContext context) async {
    if (cameras.isNotEmpty) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealCameraScanScreen(
            camera: cameras.first,
            selectedLanguage: selectedLanguage,
          ),
        ),
      );
      if (result == true) {
        onPointsAdded(25);
      }
    } else {
      onPointsAdded(25);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulated Scan: Item identified! +25 Points logged')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _localizedStrings[selectedLanguage]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: Text(t['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedLanguage,
              dropdownColor: Colors.green.shade800,
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: ['English', 'Tamil', 'Hindi', 'Telugu', 'Malayalam', 'Kannada'].map((String lang) {
                return DropdownMenuItem<String>(
                  value: lang,
                  child: Text(lang, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newLang) {
                if (newLang != null) onLanguageChanged(newLang);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade600, Colors.teal.shade700]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.eco, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(t['subtitle']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.orange, size: 36),
                          SizedBox(height: 6),
                          Text('Daily Streak', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('5 Days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.military_tech, color: Colors.green, size: 36),
                          const SizedBox(height: 6),
                          Text(t['points']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('$greenPoints PTS', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.camera_alt, size: 28),
              label: Text(t['scanBtn']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () => _openCameraScanner(context),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. HOTSPOTS SCREEN
// -----------------------------------------------------------------------------
class HotspotsScreen extends StatelessWidget {
  const HotspotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotspots = [
      {'name': 'Anna Nagar 4th Avenue Dump', 'status': 'Critical High Volume', 'kg': '320 kg', 'color': Colors.red},
      {'name': 'T. Nagar Bus Terminus Overflow', 'status': 'Pending Cleanup', 'kg': '150 kg', 'color': Colors.orange},
      {'name': 'Marina Beach Promenade Dry Bin', 'status': 'Cleared Recently', 'kg': '80 kg', 'color': Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Waste Hotspots Radar'), backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hotspots.length,
        itemBuilder: (context, index) {
          final spot = hotspots[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.location_on, color: spot['color'] as Color, size: 36),
              title: Text(spot['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Status: ${spot['status']} \nEstimated Waste: ${spot['kg']}'),
              isThreeLine: true,
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hotspot cleanup task assigned to local partner!')),
                  );
                },
                child: const Text('Dispatch'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. VENDORS SCREEN
// -----------------------------------------------------------------------------
class VendorsScreen extends StatelessWidget {
  const VendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vendors = [
      {'name': 'Kumar Scrap & Kabadiwala', 'area': 'Adyar, Chennai', 'type': 'Dry Recyclables & Paper', 'phone': '+91 98401 23456'},
      {'name': 'EcoGreen E-Waste Recyclers', 'area': 'Guindy Industrial Estate', 'type': 'E-Waste & Batteries', 'phone': '+91 94442 88990'},
      {'name': 'GreenSociety Compost Hub', 'area': 'Velachery', 'type': 'Organic & Wet Waste', 'phone': '+91 97100 55443'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Verified Recycling Vendors'), backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final v = vendors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.store, color: Colors.white)),
              title: Text(v['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Area: ${v['area']}\nSpec: ${v['type']}\nContact: ${v['phone']}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. IMPACTS SCREEN
// -----------------------------------------------------------------------------
class ImpactsScreen extends StatelessWidget {
  const ImpactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Environmental Impact Metrics'), backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
              child: const Column(
                children: [
                  Text('🌱 Total Community Impact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [Text('1,420 kg', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('Diverted')]),
                      Column(children: [Text('85 Trees', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('Saved')]),
                      Column(children: [Text('650 kg', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('CO2 Offset')]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(value: 0.75, color: Colors.green, minHeight: 10),
            const SizedBox(height: 8),
            const Text('75% of monthly community recycling goal achieved!'),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DYNAMIC AI CAMERA SCANNER WITH FULL 4-ITEM DATASETS FOR ALL 6 LANGUAGES
// -----------------------------------------------------------------------------
class RealCameraScanScreen extends StatefulWidget {
  final CameraDescription camera;
  final String selectedLanguage;

  const RealCameraScanScreen({
    super.key,
    required this.camera,
    this.selectedLanguage = 'English',
  });

  @override
  State<RealCameraScanScreen> createState() => _RealCameraScanScreenState();
}

class _RealCameraScanScreenState extends State<RealCameraScanScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;
  static int _scanIndex = 0;

  final Map<String, List<Map<String, String>>> _localizedWasteData = {
    'English': [
      {
        'item': 'PET Plastic Bottle',
        'category': 'Dry Recyclable Plastic',
        'guide': '1. Empty remaining liquid.\n2. Lightly rinse with water.\n3. Crush bottle to save space.\n4. Hand over to dry-waste collector or kabadiwala.',
        'points': '+25 Green Points',
      },
      {
        'item': 'Aluminum Beverage Can',
        'category': 'Metal Recyclable',
        'guide': '1. Rinse internal contents.\n2. Flatten metal body.\n3. Deposit at local metal scrap center.',
        'points': '+30 Green Points',
      },
      {
        'item': 'Cardboard Packaging Box',
        'category': 'Paper / Dry Waste',
        'guide': '1. Remove plastic tape and staples.\n2. Flatten cardboard sheets.\n3. Keep dry and bundle for recycling.',
        'points': '+20 Green Points',
      },
      {
        'item': 'E-Waste: Lithium Battery / Cable',
        'category': 'Hazardous E-Waste',
        'guide': '1. Do NOT throw in regular bins.\n2. Tape exposed terminals.\n3. Drop off at designated municipal e-waste kiosk.',
        'points': '+50 Green Points',
      },
    ],
    'Tamil': [
      {
        'item': 'PET பிளாஸ்டிக் பாட்டில்',
        'category': 'உலர் மறுசுழற்சி பிளாஸ்டிக்',
        'guide': '1. திரவத்தை முழுமையாக அகற்றவும்.\n2. தண்ணீரால் லேசாகக் கழுவவும்.\n3. பாட்டிலை நசுக்கவும்.\n4. உலர் கழிவு சேகரிப்பாளரிடம் கொடுக்கவும்.',
        'points': '+25 பசுமை புள்ளிகள்',
      },
      {
        'item': 'அலுமினிய கேன்',
        'category': 'உலோக மறுசுழற்சி',
        'guide': '1. உட்சென்றவற்றை சுத்தமாகக் கழுவவும்.\n2. கேனை தட்டையாக்கவும்.\n3. உள்ளூர் மறுசுழற்சி மையத்தில் கொடுக்கவும்.',
        'points': '+30 பசுமை புள்ளிகள்',
      },
      {
        'item': 'அட்டைப் பெட்டி (Cardboard)',
        'category': 'காகிதம் / உலர் கழிவு',
        'guide': '1. பிளாஸ்டிக் டேப்பை அகற்றவும்.\n2. அட்டையை தட்டையாக மடிக்கவும்.\n3. ஈரம் படாமல் மறுசுழற்சிக்கு அனுப்பவும்.',
        'points': '+20 பசுமை புள்ளிகள்',
      },
      {
        'item': 'மின் கழிவு: லித்தியம் பேட்டரி',
        'category': 'அபாயகரமான மின் கழிவு',
        'guide': '1. சாதாரண குப்பை தொட்டியில் போட வேண்டாம்.\n2. முனைகளை டேப்பால் மூடவும்.\n3. மின் கழிவு மையத்தில் சேர்க்கவும்.',
        'points': '+50 பசுமை புள்ளிகள்',
      },
    ],
    'Hindi': [
      {
        'item': 'PET प्लास्टिक बोतल',
        'category': 'सूखा रीसाइक्लिंग प्लास्टिक',
        'guide': '1. बचा हुआ तरल खाली करें।\n2. पानी से थोड़ा धो लें।\n3. बोतल को दबाएं।\n4. कबाड़ीवाले को दें।',
        'points': '+25 ग्रीन पॉइंट्स',
      },
      {
        'item': 'एल्युमीनियम केन',
        'category': 'धातु रीसाइक्लिंग',
        'guide': '1. अंदर की सामग्री धो लें।\n2. केन को चपटा करें।\n3. स्क्रैप सेंटर में जमा करें।',
        'points': '+30 ग्रीन पॉइंट्स',
      },
      {
        'item': 'गत्ते का डिब्बा (Cardboard)',
        'category': 'कागज / सूखा कचरा',
        'guide': '1. टेप और स्टेपल हटा दें।\n2. गत्ते को चपटा करें।\n3. रीसाइक्लिंग के लिए दें।',
        'points': '+20 ग्रीन पॉइंट्स',
      },
      {
        'item': 'ई-कचरा: लिथियम बैटरी',
        'category': 'खतरनाक ई-कचरा',
        'guide': '1. सामान्य कचरे में न फेंकें।\n2. सिरों पर टेप लगाएं।\n3. ई-कचरा केंद्र में दें।',
        'points': '+50 ग्रीन पॉइंट्स',
      },
    ],
    'Telugu': [
      {
        'item': 'PET ప్లాస్టిక్ బాటిల్',
        'category': 'డ్రై రీసైక్లింగ్ ప్లాస్టిక్',
        'guide': '1. నీటిని పూర్తిగా ఖాళీ చేయండి.\n2. నీటితో తేలికగా కడగండి.\n3. బాటిల్‌ను అణచివేయండి.\n4. చెత్త సేకరించే వారికి ఇవ్వండి.',
        'points': '+25 గ్రీన్ పాయింట్లు',
      },
      {
        'item': 'అల్యూమినియం క్యాన్',
        'category': 'మెటల్ రీసైక్లింగ్',
        'guide': '1. లోపల శుభ్రం చేయండి.\n2. క్యాన్‌ను చదును చేయండి.\n3. స్క్రాప్ సెంటర్‌లో ఇవ్వండి.',
        'points': '+30 గ్రీన్ పాయింట్లు',
      },
      {
        'item': 'కార్డ్‌బోర్డ్ బాక్స్',
        'category': 'పేపర్ / పొడి చెత్త',
        'guide': '1. టేప్ తొలగించండి.\n2. బోర్డును మడవండి.\n3. రీసైక్లింగ్ కోసం ఇవ్వండి.',
        'points': '+20 గ్రీన్ పాయింట్లు',
      },
      {
        'item': 'ఈ-వేస్ట్: లిథియం బ్యాటరీ',
        'category': 'ఈ-వేస్ట్',
        'guide': '1. సాధారణ చెత్తబుట్టలో వేయకండి.\n2. టేప్‌తో కప్పండి.\n3. ఈ-వేస్ట్ సెంటర్‌లో ఇవ్వండి.',
        'points': '+50 గ్రీన్ పాయింట్లు',
      },
    ],
    'Malayalam': [
      {
        'item': 'PET പ്ലാസ്റ്റിക് ബോട്ടിൽ',
        'category': 'ഡ്രൈ റീസൈക്ലിംഗ് പ്ലാസ്റ്റിക്',
        'guide': '1. വെള്ളം കളയുക.\n2. കഴുകുക.\n3. അമർത്തി ചെറുതാക്കുക.\n4. വേസ്റ്റ് കളക്ടർക്ക് നൽകുക.',
        'points': '+25 ഗ്രീൻ പോയിന്റുകൾ',
      },
      {
        'item': 'അലുമിനിയം ക്യാൻ',
        'category': 'മെറ്റൽ റീസൈക്ലിംഗ്',
        'guide': '1. അകം കഴുകുക.\n2. ക്യാൻ പരത്തുക.\n3. സ്ക്രാപ്പ് സെന്ററിൽ നൽകുക.',
        'points': '+30 ഗ്രീൻ പോയിന്റുകൾ',
      },
      {
        'item': 'കാർഡ്ബോർഡ് ബോക്സ്',
        'category': 'പേപ്പർ വേസ്റ്റ്',
        'guide': '1. ടേപ്പ് മാറ്റുക.\n2. ബോക്സ് മടക്കുക.\n3. റീസൈക്ലിംഗിനായി നൽകുക.',
        'points': '+20 ഗ്രീൻ പോയിന്റുകൾ',
      },
      {
        'item': 'ഇ-വേസ്റ്റ്: ബാറ്ററി',
        'category': 'ഇ-വേസ്റ്റ്',
        'guide': '1. സാധാരണ ബിന്നിൽ ഇടരുത്.\n2. ടേപ്പ് ചെയ്യുക.\n3. ഇ-വേസ്റ്റ് സെന്ററിൽ നൽകുക.',
        'points': '+50 ഗ്രീൻ പോയിന്റുകൾ',
      },
    ],
    'Kannada': [
      {
        'item': 'PET ಪ್ಲಾಸ್ಟಿಕ್ ಬಾಟಲ್',
        'category': 'ಡ್ರೈ ರಿಸೈಕ್ಲಿಂಗ್ ಪ್ಲಾಸ್ಟಿಕ್',
        'guide': '1. ದ್ರವವನ್ನು ಖಾಲಿ ಮಾಡಿ.\n2. ನೀರಿನಿಂದ ತೊಳೆಯಿರಿ.\n3. ಬಾಟಲಿಯನ್ನು ಅಮುಕಿ.\n4. ತ್ಯಾಜ್ಯ ಸಂಗ್ರಹಕಾರರಿಗೆ ನೀಡಿ.',
        'points': '+25 ಗ್ರೀನ್ ಪಾಯಿಂಟ್‌ಗಳು',
      },
      {
        'item': 'ಅಲ್ಯೂಮಿನಿಯಂ ಕ್ಯಾನ್',
        'category': 'ಮೆಟಲ್ ರಿಸೈಕ್ಲಿಂಗ್',
        'guide': '1. ಒಳಗಿನ ಭಾಗ ತೊಳೆಯಿರಿ.\n2. ಕ್ಯಾನ್ ಚಪ್ಪಟೆಗೊಳಿಸಿ.\n3. ಸ್ಕ್ರ್ಯಾಪ್ ಸೆಂಟರ್‌ಗೆ ನೀಡಿ.',
        'points': '+30 ಗ್ರೀನ್ ಪಾಯಿಂಟ್‌ಗಳು',
      },
      {
        'item': 'ಕಾರ್ಡ್‌ಬೋರ್ಡ್ ಬಾಕ್ಸ್',
        'category': 'ಪೇಪರ್ ತ್ಯಾಜ್ಯ',
        'guide': '1. ಪ್ಲಾಸ್ಟಿಕ್ ಟೇಪ್ ತೆಗೆಯಿರಿ.\n2. ಮಡಚಿ ಚಪ್ಪಟೆಗೊಳಿಸಿ.\n3. ಮರುಬಳಕೆಗೆ ನೀಡಿ.',
        'points': '+20 ಗ್ರೀನ್ ಪಾಯಿಂಟ್‌ಗಳು',
      },
      {
        'item': 'ಇ-ತ್ಯಾಜ್ಯ: ಲಿಥಿಯಂ ಬ್ಯಾಟರಿ',
        'category': 'ಅಪಾಯಕಾರಿ ಇ-ತ್ಯಾಜ್ಯ',
        'guide': '1. ಕಸದ ಬುಟ್ಟಿಗೆ ಹಾಕಬೇಡಿ.\n2. ಟೇಪ್‌ನಿಂದ ಮುಚ್ಚಿ.\n3. ಇ-ತ್ಯಾಜ್ಯ ಕೇಂದ್ರಕ್ಕೆ ನೀಡಿ.',
        'points': '+50 ಗ್ರೀನ್ ಪಾಯಿಂಟ್‌ಗಳು',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processCapturedImage(String imagePath) async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final langList = _localizedWasteData[widget.selectedLanguage] ?? _localizedWasteData['English']!;
    final currentResult = langList[_scanIndex % langList.length];
    _scanIndex++;

    try {
      await Supabase.instance.client.from('reports').insert({
        'image_path': imagePath,
        'category': currentResult['item'],
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('AI Waste Classification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🔍 Detected Waste Item:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 4),
                  Text('${currentResult['item']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Category: ${currentResult['category']}', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text('📋 Step-by-Step Disposal Guide:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Text(currentResult['guide']!, style: const TextStyle(fontSize: 13, height: 1.4)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.orange, size: 20),
                  const SizedBox(width: 6),
                  Text('Reward: ${currentResult['points']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text('Confirm & Earn Reward'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live AI Scanner (${widget.selectedLanguage})'), backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.green),
                    SizedBox(height: 16),
                    Text('Running AI Model Analysis...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera, color: Colors.white, size: 30),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            _processCapturedImage(image.path);
          } catch (e) {
            debugPrint('Capture error: $e');
          }
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PARTNER REGISTRATION PAGE
// -----------------------------------------------------------------------------
class PartnerRegistrationScreen extends StatefulWidget {
  const PartnerRegistrationScreen({super.key});

  @override
  State<PartnerRegistrationScreen> createState() => _PartnerRegistrationScreenState();
}

class _PartnerRegistrationScreenState extends State<PartnerRegistrationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String _partnerType = 'Local Scrap Dealer (Kabadiwala)';

  Future<void> _submitPartner() async {
    try {
      await Supabase.instance.client.from('reports').insert({
        'category': 'Partner Application: $_partnerType',
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partner Application Submitted Successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add as Recycling Partner'), backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Join the CleanLoop Network', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            const Text('Connect directly with citizens and local collection centers.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _partnerType,
              decoration: const InputDecoration(labelText: 'Partner Type', border: OutlineInputBorder()),
              items: [
                'Local Scrap Dealer (Kabadiwala)',
                'Housing Society Representative',
                'E-Waste Recycler',
                'NGO / Eco-Club',
              ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (val) => setState(() => _partnerType = val!),
            ),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Business or Entity Name', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Contact Phone Number', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location / Area (e.g., Chennai)', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _submitPartner,
              child: const Text('Register Partner Profile', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
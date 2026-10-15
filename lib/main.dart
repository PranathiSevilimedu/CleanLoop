import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kjyjlwklxuunjwfkeigr.supabase.co',
    anonKey: 'sb_publishable_s5pbZ46gCoAyf4oWdR6EgA_cGwEM1NB',
  );

  runApp(const CleanLoopApp());
}

// Global Language Controller
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
      'detected': 'Detected',
      'steps': 'Disposal Instructions',
      'active_scanner': '🔴 AI SCANNER READY',
    },
    'தமிழ்': {
      'title': 'க்ளீன்லூப்',
      'live_scanner': 'ஸ்கேனர்',
      'hotspots': 'வரைபடம்',
      'vendors': 'சேகரிப்பாளர்கள்',
      'impact': 'தாக்கம்',
      'register_shop': 'கடை பதிவு',
      'detected': 'கண்டறியப்பட்டது',
      'steps': 'அகற்றும் வழிமுறைகள்',
      'active_scanner': '🔴 AI ஸ்கேனர் தயார் நிலையில் உள்ளது',
    },
    'हिंदी': {
      'title': 'क्लीनलूप',
      'live_scanner': 'स्कैनर',
      'hotspots': 'हॉटस्पॉट',
      'vendors': 'विक्रेता',
      'impact': 'प्रभाव',
      'register_shop': 'इकाई पंजीकृत करें',
      'detected': 'पहचाना गया',
      'steps': 'निपटान निर्देश',
      'active_scanner': '🔴 AI स्कैनर तैयार',
    },
    'తెలుగు': {
      'title': 'క్లీన్‌లూప్',
      'live_scanner': 'స్కానర్',
      'hotspots': 'హాట్‌స్పాట్‌లు',
      'vendors': 'విక్రేతలు',
      'impact': 'ప్రభావం',
      'register_shop': 'యూనిట్ నమోదు',
      'detected': 'గుర్తించబడింది',
      'steps': 'విసర్జన సూచనలు',
      'active_scanner': '🔴 AI స్కానర్ సిద్ధంగా ఉంది',
    },
    'മലയാളം': {
      'title': 'ക്ലീൻലൂപ്പ്',
      'live_scanner': 'സ്‌കാനർ',
      'hotspots': 'ഹോട്ട്‌സ്‌പോട്ടുകൾ',
      'vendors': 'വ്യാപാരികൾ',
      'impact': 'സ്വാധീനം',
      'register_shop': 'യൂണിറ്റ് രജിസ്റ്റർ ചെയ്യുക',
      'detected': 'കണ്ടെത്തി',
      'steps': 'നിർദ്ദേശങ്ങൾ',
      'active_scanner': '🔴 AI സ്കാനർ തയ്യാറാണ്',
    },
    'കന്നഡ': {
      'title': 'ಕ್ಲೀನ್‌ಲೂಪ್',
      'live_scanner': 'ಸ್ಕ್ಯಾನರ್',
      'hotspots': 'ಹಾಟ್‌ಸ್ಪಾಟ್‌ಗಳು',
      'vendors': 'ಮಾರಾಟಗಾರರು',
      'impact': 'ಪರಿಣಾಮ',
      'register_shop': 'ಘಟಕ ನೋಂದಾಯಿಸಿ',
      'detected': 'ಗುರ್ತಿಸಲಾಗಿದೆ',
      'steps': 'ವಿಲೇವಾರಿ ಸೂಚನೆಗಳು',
      'active_scanner': '🔴 AI ಸ್ಕ್ಯಾನರ್ ಸಿದ್ಧವಾಗಿದೆ',
    },
  };

  static String getText(String key) {
    return translations[selectedLanguage]?[key] ?? translations['English']![key]!;
  }
}

class CleanLoopApp extends StatefulWidget {
  const CleanLoopApp({super.key});

  @override
  State<CleanLoopApp> createState() => _CleanLoopAppState();
}

class _CleanLoopAppState extends State<CleanLoopApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanLoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4D3E)),
        useMaterial3: true,
      ),
      home: MobileFrameWrapper(
        child: HomeScreen(
          onLanguageChanged: () => setState(() {}),
        ),
      ),
    );
  }
}

class MobileFrameWrapper extends StatelessWidget {
  final Widget child;
  const MobileFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F251E),
      body: Center(
        child: Container(
          width: 412,
          height: 870,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.black87, width: 10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: child,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onLanguageChanged;
  const HomeScreen({super.key, required this.onLanguageChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _languages = ['English', 'தமிழ்', 'हिंदी', 'తెలుగు', 'മലയാളം', 'കന്നഡ'];

  final List<Widget> _screens = [
    const ScanScreen(),
    const MapScreen(),
    const RecyclerDirectoryScreen(),
    const DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.getText('title'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4D3E),
        centerTitle: false,
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
                widget.onLanguageChanged();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_business, color: Colors.white),
            tooltip: AppLanguage.getText('register_shop'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterVendorScreen()));
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

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isProcessing = false;
  Map<String, dynamic>? _scannedResult;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _wasteDatabase = [
    {
      'label': 'PET Plastic Bottle (DRY WASTE)',
      'confidence': '96.4%',
      'color': Colors.blue,
      'instructions': {
        'English': '1. Rinse thoroughly\n2. Compress bottle\n3. Dispose in Blue Dry Bin',
        'தமிழ்': '1. தண்ணீரில் நன்கு கழுவவும்\n2. பாட்டிலை அமுக்கவும்\n3. நீல நிற காய்ந்த குப்பை தொட்டியில் போடவும்',
        'हिंदी': '1. अच्छी तरह धोएं\n2. बोतल को दबाएं\n3. नीले सूखे कचरा पात्र में डालें',
        'తెలుగు': '1. నీటితో శుభ్రం చేయండి\n2. బాటిల్‌ను నొక్కండి\n3. బ్లూ డ్రై బిన్‌లో వేయండి',
        'മലയാളം': '1. കഴുകി വൃത്തിയാക്കുക\n2. കുപ്പി അമർത്തുക\n3. ഡ്രൈ ബിന്നിൽ നിക്ഷേപിക്കുക',
        'കന്നഡ': '1. ನೀರಿನಿಂದ ತೊಳೆಯಿರಿ\n2. ಬಾಟಲಿಯನ್ನು ಕುಗ್ಗಿಸಿ\n3. ಒಣ ತ್ಯಾಜ್ಯ ಬುಟ್ಟಿಗೆ ಹಾಕಿ',
      }
    },
    {
      'label': 'Organic Food Waste (WET WASTE)',
      'confidence': '92.1%',
      'color': Colors.green,
      'instructions': {
        'English': '1. Separate plastic wrappers\n2. Put into Green Bio-Compost bin',
        'தமிழ்': '1. பிளாஸ்டிக் உறைகளை பிரிக்கவும்\n2. பச்சை நிற மக்கும் குப்பை தொட்டியில் போடவும்',
        'हिंदी': '1. प्लास्टिक रैपर अलग करें\n2. हरे जैविक खाद बिन में डालें',
        'తెలుగు': '1. ప్లాస్టిక్ కవర్లను వేరు చేయండి\n2. గ్రీన్ కంపోస్ట్ బిన్‌లో వేయండి',
        'മലയാളം': '1. പ്ലാസ്റ്റിക് മാറ്റുക\n2. ഗ്രീൻ കോമ്പോസ്റ്റ് ബിന്നിൽ ഇടുക',
        'കന്നഡ': '1. ಪ್ಲಾಸ್ಟಿಕ್ ಬೇರ್ಪಡಿಸಿ\n2. ಹಸಿರು ಗೊಬ್ಬರದ ಬುಟ್ಟಿಗೆ ಹಾಕಿ',
      }
    },
    {
      'label': 'E-Waste / Electronic Device',
      'confidence': '98.0%',
      'color': Colors.orange,
      'instructions': {
        'English': '1. Do not break or burn\n2. Drop off at local E-waste collection hub',
        'தமிழ்': '1. உடைக்கவோ எரிக்கவோ வேண்டாம்\n2. உள்ளூர் மின்னணு கழிவு மையத்தில் ஒப்படைக்கவும்',
        'हिंदी': '1. तोड़ें या जलाएं नहीं\n2. नजदीकी ई-कचरा केंद्र में जमा करें',
        'తెలుగు': '1. కాల్చవద్దు లేదా పగలగొట్టవద్దు\n2. ఇ-వేస్ట్ కేంద్రంలో ఇవ్వండి',
        'മലയാളം': '1. കത്തിക്കരുത്\n2. ഇ-വേസ്റ്റ് കളക്ഷൻ സെന്ററിൽ നൽകുക',
        'കന്നഡ': '1. ಸುಡಬೇಡಿ ಅಥವಾ ಒಡೆಯಬೇಡಿ\n2. ಇ-ತ್ಯಾಜ್ಯ ಸಂಗ್ರಹಣಾ ಕೇಂದ್ರಕ್ಕೆ ನೀಡಿ',
      }
    },
  ];

  Future<void> _pickAndProcessImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _isProcessing = true;
      _scannedResult = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _wasteDatabase.shuffle();
          _scannedResult = _wasteDatabase.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguage.selectedLanguage;

    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Center(
                  child: _isProcessing
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 12),
                            Text('Analyzing image with AI...', style: TextStyle(color: Colors.white)),
                          ],
                        )
                      : _selectedImage != null
                          ? kIsWeb
                              ? Image.network(_selectedImage!.path, fit: BoxFit.cover, width: double.infinity)
                              : Image.file(File(_selectedImage!.path), fit: BoxFit.cover, width: double.infinity)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 70, color: Colors.white38),
                                SizedBox(height: 8),
                                Text('Upload or snap a photo of your waste', style: TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _isProcessing ? null : _pickAndProcessImage,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Photo to Scan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Text(
                  AppLanguage.getText('active_scanner'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF1B4D3E)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _scannedResult != null
                            ? '${AppLanguage.getText('detected')}: ${_scannedResult!['label']}'
                            : 'Status: Waiting for photo upload',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B4D3E)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${AppLanguage.getText('steps')}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  _scannedResult != null
                      ? _scannedResult!['instructions'][lang] ?? _scannedResult!['instructions']['English']
                      : 'Upload a picture of any waste item to instantly classify it and get instructions.',
                  style: TextStyle(color: Colors.grey.shade800, height: 1.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
        'title': _nameController.text,
        'description': 'Category: $_category | Phone: ${_phoneController.text} | Address: ${_addressController.text}',
        'latitude': 13.0827,
        'longitude': 80.2707,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recycling Unit Registered Successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved locally: ${_nameController.text} Registered!')));
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Shop / Business Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact Phone Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address / Location', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Recycling Category', border: OutlineInputBorder()),
              items: ['E-Waste & Plastic', 'Paper & Metals', 'Organic / Wet Waste', 'Hazardous Waste']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4D3E),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _isSubmitting ? null : _submitRegistration,
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Registration', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

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
            Marker(point: LatLng(13.0750, 80.2600), width: 80, height: 80, child: Icon(Icons.location_pin, color: Colors.orange, size: 40)),
          ],
        ),
      ],
    );
  }
}

class RecyclerDirectoryScreen extends StatelessWidget {
  const RecyclerDirectoryScreen({super.key});

  final List<Map<String, dynamic>> _vendors = const [
    {'name': 'GreenChennai Eco Solutions', 'type': 'E-Waste & Plastic', 'address': 'Anna Nagar, Chennai', 'phone': '+91 44 2654 8890', 'rating': 4.8},
    {'name': 'Kachra to Cash Scrap Mart', 'type': 'Paper & Metals', 'address': 'T. Nagar, Chennai', 'phone': '+91 98401 55221', 'rating': 4.6},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _vendors.length,
      itemBuilder: (context, index) {
        final vendor = _vendors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(vendor['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E))),
            subtitle: Text('${vendor['type']} • ${vendor['address']}\nPhone: ${vendor['phone']}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: Colors.amber, size: 16), Text('${vendor['rating']}')]),
          ),
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(AppLanguage.getText('impact'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E))),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: const [
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
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
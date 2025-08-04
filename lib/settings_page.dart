import 'package:flutter/material.dart';
import 'music_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _musicVolume = 0.5;
  double _soundEffectVolume = 0.3;
  double _ambientSoundVolume = 1.0;
  String _selectedMenu = 'Audio';
  String _selectedLanguage = 'English';
  bool _hasChanges = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
        _soundEffectVolume = prefs.getDouble('soundEffectVolume') ?? 0.3;
        _ambientSoundVolume = prefs.getDouble('ambientSoundVolume') ?? 1.0;
        _selectedLanguage = prefs.getString('language') ?? 'English';
      });
    } catch (e) {
      print('Error loading settings: $e');
    }
  }
  
  Future<void> _saveAudioSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('musicVolume', _musicVolume);
      await prefs.setDouble('soundEffectVolume', _soundEffectVolume);
      await prefs.setDouble('ambientSoundVolume', _ambientSoundVolume);
      
      setState(() {
        _hasChanges = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio settings saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving audio settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save settings. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  Future<void> _saveLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', language);
      
      setState(() {
        _selectedLanguage = language;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $language'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving language setting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to change language. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MusicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Back button and title in same row
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero, // Remove padding to save space
                      constraints: const BoxConstraints(), // Remove constraints
                    ),
                    const Spacer(),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30, // Further reduced
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEF8B60),
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                
                const SizedBox(height: 10), // Reduced further
                
                // Main content
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menu section (left side)
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuButton('Audio', isSelected: _selectedMenu == 'Audio'),
                            const SizedBox(height: 10), // Further reduced
                            _buildMenuButton('Language', isSelected: _selectedMenu == 'Language'),
                            const SizedBox(height: 10), // Further reduced
                            _buildMenuButton('Control', isSelected: _selectedMenu == 'Control'),
                            const SizedBox(height: 10), // Further reduced
                            _buildMenuButton('General', isSelected: _selectedMenu == 'General'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 10), // Further reduced
                      
                      // Content section (right side) - with save button inside
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade800.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.7),
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(14), // Reduced padding
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Content
                              _buildSelectedContent(),
                              
                              // Save button INSIDE the container
                              if (_selectedMenu == 'Audio' && _hasChanges)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: ElevatedButton(
                                    onPressed: _saveAudioSettings,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF8B60),
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                      minimumSize: const Size(100, 32), // Smaller minimum size
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 14, // Further reduced
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton(String title, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMenu = title;
          if (_selectedMenu != 'Audio') {
            _hasChanges = false;
          }
        });
      },
      child: Container(
        height: 40, // Further reduced
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.deepPurple.shade800.withOpacity(0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFEF8B60) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFFEF8B60),
              fontSize: 15, // Further reduced
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAudioContent() {
    // Only show two sliders to prevent overflow
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSliderSetting('Music', _musicVolume, (value) {
          setState(() {
            _musicVolume = value;
            _hasChanges = true;
          });
        }),
        const SizedBox(height: 15), // Further reduced
        _buildSliderSetting('Sound Effect', _soundEffectVolume, (value) {
          setState(() {
            _soundEffectVolume = value;
            _hasChanges = true;
          });
        }),
        // Ambient sound removed entirely to prevent overflow
      ],
    );
  }
  
  Widget _buildLanguageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Language',
          style: TextStyle(
            color: Color(0xFFEF8B60),
            fontSize: 16, // Further reduced
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12), // Further reduced
        _buildLanguageOption('English', _selectedLanguage == 'English'),
        const SizedBox(height: 8), // Further reduced
        _buildLanguageOption('Indonesian', _selectedLanguage == 'Indonesian'),
      ],
    );
  }
  
  Widget _buildControlContent() {
    return const Center(
      child: Text(
        'Control settings will be implemented soon',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14, // Further reduced
        ),
      ),
    );
  }
  
  Widget _buildGeneralContent() {
    return const Center(
      child: Text(
        'General settings will be implemented soon',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14, // Further reduced
        ),
      ),
    );
  }
  
  Widget _buildSelectedContent() {
    switch (_selectedMenu) {
      case 'Audio':
        return _buildAudioContent();
      case 'Language':
        return _buildLanguageContent();
      case 'Control':
        return _buildControlContent();
      case 'General':
        return _buildGeneralContent();
      default:
        return _buildAudioContent();
    }
  }
  
  Widget _buildLanguageOption(String language, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (_selectedLanguage != language) {
          _saveLanguage(language);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Further reduced
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEF8B60).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFEF8B60) : Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                color: isSelected ? const Color(0xFFEF8B60) : Colors.white,
                fontSize: 14, // Further reduced
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFEF8B60),
                size: 16, // Further reduced
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSliderSetting(String title, double value, Function(double) onChanged) {
    final percentage = (value * 100).toInt();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFEF8B60),
                fontSize: 15, // Further reduced
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                color: Color(0xFFEF8B60),
                fontSize: 15, // Further reduced
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6), // Further reduced
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4, // Further reduced
            activeTrackColor: const Color(0xFFEF8B60),
            inactiveTrackColor: Colors.deepPurple.shade400.withOpacity(0.3),
            thumbColor: const Color(0xFFEF8B60),
            overlayColor: const Color(0xFFEF8B60).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8), // Further reduced
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14), // Further reduced
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../models/app_user.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();
  
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  
  final List<String> _interests = [];
  final List<String> _availableInterests = [
    'Music', 'Movies', 'Sports', 'Travel', 'Food', 'Art', 'Books',
    'Gaming', 'Fitness', 'Photography', 'Dancing', 'Cooking',
    'Fashion', 'Technology', 'Nature', 'Nightlife'
  ];
  
  String _lookingFor = 'friends';

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 photos allowed')),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_interests.contains(interest)) {
        _interests.remove(interest);
      } else if (_interests.length < 5) {
        _interests.add(interest);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 5 interests allowed')),
        );
      }
    });
  }

  Future<void> _completeSetup() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one photo')),
        );
        return;
      }

      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) return;

      // TODO: Upload images to Firebase Storage
      final List<String> imageUrls = [];

      final updatedUser = currentUser.copyWith(
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
        age: int.parse(_ageController.text),
        profileImages: imageUrls,
        preferences: currentUser.preferences.copyWith(
          interests: _interests,
          lookingFor: _lookingFor,
        ),
      );

      // TODO: Update user in Firestore
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photos Section
              Text(
                'Add Photos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._selectedImages.asMap().entries.map((entry) {
                      return Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(entry.value.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(entry.key),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    
                    if (_selectedImages.length < 6)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryColor,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Display Name
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Age
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 18 || age > 99) {
                    return 'Age must be between 18 and 99';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Bio
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Tell us about yourself...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Looking For
              Text(
                'Looking For',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['friends', 'dating', 'relationship', 'networking'].map((option) {
                  return FilterChip(
                    label: Text(option.split('').first.toUpperCase() + option.substring(1)),
                    selected: _lookingFor == option,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _lookingFor = option;
                        });
                      }
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.3),
                    checkmarkColor: AppTheme.primaryColor,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Interests
              Text(
                'Interests (Select up to 5)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.map((interest) {
                  return FilterChip(
                    label: Text(interest),
                    selected: _interests.contains(interest),
                    onSelected: (selected) => _toggleInterest(interest),
                    selectedColor: AppTheme.primaryColor.withOpacity(0.3),
                    checkmarkColor: AppTheme.primaryColor,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 48),
              
              // Complete Setup Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeSetup,
                  child: const Text('Complete Setup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
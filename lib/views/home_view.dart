import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/connectivity_service.dart';

import '../widgets/custom_input.dart';
import 'result_view.dart';
import 'loading_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _slideCountController =
      TextEditingController(text: '10');
  final TextEditingController _presentationForController =
      TextEditingController(text: 'student');

  String _selectedTemplateType = 'default'; // 'default' or 'editable'
  String _selectedTemplate = 'bullet-point1';
  String _selectedLanguage = 'en';
  String _selectedModel = 'gpt-3.5';

  final List<String> _editableTemplates = [
    'ed-bullet-point9',
    'ed-bullet-point7',
    'ed-bullet-point6',
    'ed-bullet-point5',
    'ed-bullet-point2',
    'ed-bullet-point4',
    'custom gold 1',
    'custom Dark 1',
    'custom sync 1',
    'custom sync 2',
    'custom sync 3',
    'custom sync 4',
    'custom sync 5',
    'custom sync 6',
    'custom-ed-7',
    'custom-ed-8',
    'custom-ed-9',
    'custom-ed-10',
    'custom-ed-11',
    'custom-ed-12',
    'pitchdeckorignal',
    'pitch-deck-2',
    'pitch-deck-3',
    'ed-bullet-point1',
  ];

  final List<String> _defaultTemplates = [
    'bullet-point1',
    'bullet-point2',
    'bullet-point4',
    'bullet-point5',
    'bullet-point6',
    'bullet-point7',
    'bullet-point8',
    'bullet-point9',
    'bullet-point10',
    'custom2',
    'custom3',
    'custom4',
    'custom5',
    'custom6',
    'custom7',
    'custom8',
    'custom9',
    'verticalBulletPoint1',
    'verticalCustom1',
  ];

  List<String> get _currentTemplates => _selectedTemplateType == 'editable'
      ? _editableTemplates
      : _defaultTemplates;

  bool _aiImages = false;
  bool _imageOnEachSlide = false;
  bool _googleImages = false;
  bool _googleText = false;

  Future<void> _showSelectionSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> options,
    required T selectedValue,
    required String Function(T) labelBuilder,
    String Function(T)? subtitleBuilder,
    required ValueChanged<T> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Ink(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        width: 28,
                        height: 28,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => Navigator.pop(context),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: options.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option == selectedValue;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            onSelected(option);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        labelBuilder(option),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : null,
                                        ),
                                      ),
                                      if (subtitleBuilder != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          subtitleBuilder(option),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Slide Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Ink(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      width: 28,
                      height: 28,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => Navigator.pop(context),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Template Type Selection
                const Text('Choose Template Type:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'default',
                          groupValue: _selectedTemplateType,
                          activeColor: Theme.of(context).primaryColor,
                          fillColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedTemplateType = value!;
                              _selectedTemplate = _defaultTemplates.first;
                            });
                            setState(() {
                              _selectedTemplateType = value!;
                              _selectedTemplate = _defaultTemplates.first;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedTemplateType = 'default';
                              _selectedTemplate = _defaultTemplates.first;
                            });
                            setState(() {
                              _selectedTemplateType = 'default';
                              _selectedTemplate = _defaultTemplates.first;
                            });
                          },
                          child: const Text('Default'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'editable',
                          groupValue: _selectedTemplateType,
                          activeColor: Theme.of(context).primaryColor,
                          fillColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedTemplateType = value!;
                              _selectedTemplate = _editableTemplates.first;
                            });
                            setState(() {
                              _selectedTemplateType = value!;
                              _selectedTemplate = _editableTemplates.first;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedTemplateType = 'editable';
                              _selectedTemplate = _editableTemplates.first;
                            });
                            setState(() {
                              _selectedTemplateType = 'editable';
                              _selectedTemplate = _editableTemplates.first;
                            });
                          },
                          child: const Text('Editable'),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                CustomInput(
                  label: 'Presentation For',
                  controller: _presentationForController,
                ),
                const SizedBox(height: 24),
                CustomInput(
                  label: 'Slide Count (1-50)',
                  controller: _slideCountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Language Selector
                _buildSelectionTile(
                  label: 'Language',
                  value: {
                        'en': 'English',
                        'es': 'Spanish',
                        'fr': 'French',
                        'de': 'German',
                        'it': 'Italian',
                      }[_selectedLanguage] ??
                      _selectedLanguage,
                  onTap: () {
                    _showSelectionSheet<String>(
                      context: context,
                      title: 'Select Language',
                      options: ['en', 'es', 'fr', 'de', 'it'],
                      selectedValue: _selectedLanguage,
                      labelBuilder: (val) =>
                          {
                            'en': 'English',
                            'es': 'Spanish',
                            'fr': 'French',
                            'de': 'German',
                            'it': 'Italian',
                          }[val] ??
                          val,
                      onSelected: (val) {
                        setModalState(() => _selectedLanguage = val);
                        setState(() => _selectedLanguage = val);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Template Selector
                _buildSelectionTile(
                  label: 'Template',
                  value: _selectedTemplate,
                  onTap: () {
                    _showSelectionSheet<String>(
                      context: context,
                      title: 'Select Template',
                      options: _currentTemplates,
                      selectedValue: _selectedTemplate,
                      labelBuilder: (val) => val,
                      onSelected: (val) {
                        setModalState(() => _selectedTemplate = val);
                        setState(() => _selectedTemplate = val);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Model Selector
                _buildSelectionTile(
                  label: 'AI Model',
                  value: _selectedModel == 'gpt-3.5' ? 'GPT-3.5' : 'GPT-4',
                  onTap: () {
                    _showSelectionSheet<String>(
                      context: context,
                      title: 'Select AI Model',
                      options: ['gpt-3.5', 'gpt-4'],
                      selectedValue: _selectedModel,
                      labelBuilder: (val) =>
                          val == 'gpt-3.5' ? 'GPT-3.5' : 'GPT-4',
                      subtitleBuilder: (val) => val == 'gpt-3.5'
                          ? 'Standard model, faster'
                          : 'Advanced model, more capable',
                      onSelected: (val) {
                        setModalState(() => _selectedModel = val);
                        setState(() => _selectedModel = val);
                      },
                    );
                  },
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showIntegrationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Integrations & Options',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    width: 28,
                    height: 28,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Navigator.pop(context),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Theme.of(context).primaryColor,
                title: const Text('AI Images'),
                value: _aiImages,
                onChanged: (val) {
                  setModalState(() => _aiImages = val);
                  setState(() => _aiImages = val);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Theme.of(context).primaryColor,
                title: const Text('Image on Each Slide'),
                value: _imageOnEachSlide,
                onChanged: (val) {
                  setModalState(() => _imageOnEachSlide = val);
                  setState(() => _imageOnEachSlide = val);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Theme.of(context).primaryColor,
                title: const Text('Google Images'),
                value: _googleImages,
                onChanged: (val) {
                  setModalState(() => _googleImages = val);
                  setState(() => _googleImages = val);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Theme.of(context).primaryColor,
                title: const Text('Google Text'),
                value: _googleText,
                onChanged: (val) {
                  setModalState(() => _googleText = val);
                  setState(() => _googleText = val);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MagicSlides',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authViewModel.signOut();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ??
                            user?.email.split('@').first ??
                            'User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.withValues(alpha: 0.1),
                  thickness: 1,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: Text(
                    'History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Centered Content
              Center(
                child: Text(
                  'How may I help you?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Top Right Logout (Removed as it's likely in drawer or not needed with AppBar actions, but user didn't explicitly ask to remove it, but AppBar usually handles actions. I'll keep it consistent with request: "in left side add app drawer". The logout was previously top right. I'll remove the floating logout button since we have an AppBar now, or move it to AppBar actions? The request didn't specify logout location, but standard is AppBar. I'll add it to AppBar actions to keep functionality.)

              // Bottom Search/Input Area
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _topicController,
                          decoration: const InputDecoration(
                            hintText: 'Ask anything...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 8,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  // Settings Button
                                  IconButton(
                                    icon: const Icon(Icons.tune),
                                    tooltip: 'Slide Settings',
                                    onPressed: () =>
                                        _showSettingsModal(context),
                                  ),
                                  // Integrations Button
                                  IconButton(
                                    icon: const Icon(Icons.grid_view),
                                    tooltip: 'Integrations',
                                    onPressed: () =>
                                        _showIntegrationsModal(context),
                                  ),
                                ],
                              ),
                            ),
                            // Generate Button
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _topicController,
                              builder: (context, value, child) {
                                final isEnabled = value.text.trim().length >= 3;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isEnabled
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  width: 28,
                                  height: 28, // Ensure it's a circle
                                  child: IconButton(
                                    padding: EdgeInsets
                                        .zero, // Remove default padding
                                    constraints:
                                        const BoxConstraints(), // Remove default constraints
                                    icon: Icon(
                                      Icons.send,
                                      color: isEnabled
                                          ? Colors.black
                                          : Colors.grey[500],
                                      size:
                                          14, // Slightly adjusted size for better visual centering
                                    ),
                                    onPressed: isEnabled
                                        ? () async {
                                            if (_topicController.text
                                                .trim()
                                                .isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please enter a topic')),
                                              );
                                              return;
                                            }

                                            final accessId = dotenv
                                                .env['MAGICSLIDES_ACCESS_ID'];
                                            if (accessId == null ||
                                                accessId.isEmpty ||
                                                accessId == 'YOUR_ACCESS_ID') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Access ID not configured. Please check .env file.')),
                                              );
                                              return;
                                            }

                                            // Check internet connectivity
                                            final connectivityService =
                                                ConnectivityService();
                                            final isConnected =
                                                await connectivityService
                                                    .isConnected();

                                            if (!isConnected) {
                                              if (mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .cardColor,
                                                    title: const Text(
                                                        'No Internet Connection'),
                                                    content: const Text(
                                                        'Please check your network settings and try again.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              return;
                                            }

                                            // Show Loading View
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoadingView()),
                                            );

                                            final success =
                                                await homeViewModel.generatePPT(
                                              topic: _topicController.text,
                                              email: user?.email ??
                                                  'test@example.com', // Fallback if null
                                              accessId: accessId,
                                              template: _selectedTemplate,
                                              slideCount: int.tryParse(
                                                      _slideCountController
                                                          .text) ??
                                                  10,
                                              language: _selectedLanguage,
                                              aiImages: _aiImages,
                                              imageForEachSlide:
                                                  _imageOnEachSlide, // Mapped to new param name
                                              googleImage:
                                                  _googleImages, // Mapped to new param name
                                              googleText: _googleText,
                                              model: _selectedModel,
                                              presentationFor:
                                                  _presentationForController
                                                      .text,
                                            );

                                            // Remove Loading View
                                            if (mounted) {
                                              Navigator.pop(context);
                                            }

                                            if (success && mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultView(
                                                    file: homeViewModel
                                                        .downloadedFile,
                                                    pptUrl:
                                                        homeViewModel.pptUrl,
                                                  ),
                                                ),
                                              );
                                            } else if (mounted) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .cardColor,
                                                  title: const Text('Error'),
                                                  content: Text(homeViewModel
                                                          .errorMessage ??
                                                      'Generation failed'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Okay',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

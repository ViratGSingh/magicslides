import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/storage_service.dart';

class ResultView extends StatefulWidget {
  final File? file;
  final String? pptUrl;

  const ResultView({Key? key, this.file, this.pptUrl}) : super(key: key);

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late final WebViewController? _controller;
  bool _isLoading = true;
  bool _isDownloading = false;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    if (widget.pptUrl != null && widget.pptUrl!.isNotEmpty) {
      _initializeWebView();
    }
  }

  void _initializeWebView() {
    // Use Google Docs viewer to display PPT
    final viewerUrl =
        'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.pptUrl!)}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
  }

  Future<void> _downloadPPT() async {
    if (widget.pptUrl == null || widget.pptUrl!.isEmpty) {
      _showErrorDialog('No presentation URL available');
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      final fileName =
          'presentation_${DateTime.now().millisecondsSinceEpoch}.pptx';

      // Download PPT to user's visible folder
      final String destinationPath =
          await _storageService.downloadToUserFolder(widget.pptUrl!, fileName);

      setState(() {
        _isDownloading = false;
      });

      _showSuccessDialog(destinationPath);
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      _showErrorDialog('Failed to download: $e');
    }
  }

  void _showSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
          size: 64,
        ),
        title: Text('Download Successful!',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Your presentation has been downloaded successfully.',
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            // const Text(
            //   'Saved to:',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            // ),
            // const SizedBox(height: 4),
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(4),
            //   ),
            //   child: Text(
            //     filePath,
            //     style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            //   ),
            // ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Presentation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon:
                Image.asset("assets/images/google_slides_logo.png", height: 32),
            tooltip: 'Open in Google Slides',
            onPressed: () async {
              // Open in Google Slides
              if (widget.pptUrl != null && widget.pptUrl!.isNotEmpty) {
                try {
                  // Google Slides viewer URL
                  final slidesUrl =
                      'https://docs.google.com/presentation/d/?url=${Uri.encodeComponent(widget.pptUrl!)}';

                  // Open in browser
                  final uri = Uri.parse(slidesUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open Google Slides'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error opening Google Slides: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (widget.pptUrl != null && widget.pptUrl!.isNotEmpty)
            WebViewWidget(controller: _controller!)
          else
            const Center(
              child: Text('No presentation available to display'),
            ),
          if (_isLoading && widget.pptUrl != null && widget.pptUrl!.isNotEmpty)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _isDownloading
                  ? Colors.grey.withOpacity(0.3)
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _isDownloading ? null : _downloadPPT,
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: _isDownloading
              ? Colors.grey[400]
              : Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: _isDownloading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 24,
                ),
        ),
      ),
    );
  }
}

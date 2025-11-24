import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

class ResultView extends StatelessWidget {
  final File? file;
  final String? pptUrl;

  const ResultView({Key? key, this.file, this.pptUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated PPT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (pptUrl != null && pptUrl!.isNotEmpty) {
                await Share.share(pptUrl!,
                    subject: 'My Generated Presentation');
              } else if (file != null) {
                await Share.shareXFiles([XFile(file!.path)],
                    text: 'Here is my generated presentation!');
              }
            },
          ),
        ],
      ),
      body: file != null
          ? SfPdfViewer.file(file!)
          : const Center(child: Text('Preview not available for this format.')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (pptUrl != null && pptUrl!.isNotEmpty) {
            // Share the link if PPT URL is available (preferred for PPTX)
            await Share.share(pptUrl!, subject: 'Download my Presentation');
          } else if (file != null) {
            await Share.shareXFiles([XFile(file!.path)],
                text: 'Here is my generated presentation!');
          }
        },
        icon: const Icon(Icons.download),
        label: const Text('Download / Share'),
      ),
    );
  }
}

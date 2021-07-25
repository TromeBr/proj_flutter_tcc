import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as fileExtension;
import 'package:proj_flutter_tcc/models/consts.dart';

class PDFViewer extends StatefulWidget {
  final File exam;

  const PDFViewer(
    this.exam,
  );

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PDFViewController PDFController;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final text = '${indexPage + 1} of $pages';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fileExtension.basenameWithoutExtension(widget.exam.path),
          style: TextStyle(
            color: Color(
              systemPrimaryColor,
            ),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: pages >= 2
            ? [
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Color(systemPrimaryColor),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 32),
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    PDFController.setPage(page);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 32),
                  onPressed: () {
                    final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                    PDFController.setPage(page);
                  },
                ),
              ]
            : null,
        iconTheme: IconThemeData(
          color: Color(systemPrimaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: PDFView(
        filePath: widget.exam.path,
        // autoSpacing: false,
        // swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages),
        onViewCreated: (controller) =>
            setState(() => this.PDFController = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage),
      ),
    );
  }
}

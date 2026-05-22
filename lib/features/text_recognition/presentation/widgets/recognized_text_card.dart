import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecognizedTextCard extends StatefulWidget {
  final String recognizedText;
  final List<String> lines;

  const RecognizedTextCard({
    super.key,
    required this.recognizedText,
    required this.lines,
  });

  @override
  State<RecognizedTextCard> createState() => _RecognizedTextCardState();
}

class _RecognizedTextCardState extends State<RecognizedTextCard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.recognizedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.copy_all, color: Colors.white),
            SizedBox(width: 8),
            Text('Text copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF7F00FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLines = widget.lines
        .where((line) => line.toLowerCase().contains(_searchQuery))
        .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2833),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFE100FF),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
            tabs: const [
              Tab(text: 'Full Text'),
              Tab(text: 'Lines & Search'),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFullTextView(context),
                _buildLinesView(filteredLines),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullTextView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.recognizedText.isNotEmpty
                      ? widget.recognizedText
                      : 'No text detected.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _copyToClipboard(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F00FF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.copy, color: Colors.white),
            label: const Text(
              'Copy Full Text',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinesView(List<String> filteredLines) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search lines...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredLines.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredLines.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.black.withValues(alpha: 0.15),
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            filteredLines[index],
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy, size: 16, color: Colors.white38),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: filteredLines[index]));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Line copied!'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFFE100FF),
                                  width: 150,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No matching lines found.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

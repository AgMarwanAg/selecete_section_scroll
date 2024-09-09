import 'package:flutter/material.dart';

class SectionScrollScreen extends StatefulWidget {
  const SectionScrollScreen({super.key});

  @override
  SectionScrollScreenState createState() => SectionScrollScreenState();
}

class SectionScrollScreenState extends State<SectionScrollScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  final Map<String, GlobalKey> _sections = {
    'Home': GlobalKey(),
    'Services': GlobalKey(),
    'About': GlobalKey(),
    'Contact': GlobalKey(),
    'Contact1': GlobalKey(),
    'Contact2': GlobalKey(),
    'Contact3': GlobalKey(),
    'Contact4': GlobalKey(),
  };

  double getOffset(GlobalKey key) {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dy;
  }

  void _onScroll() {
    for (int i = 0; i < _sections.values.length; i++) {
      final position = getOffset(_sections.values.elementAt(i));

      if (position < MediaQuery.of(context).size.height / 2 && position >= 0) {
        setState(() {
          _selectedIndex = i;
        });
        break;
      }
    }
  }

  void _scrollToSection(int index) {
    final offset = getOffset(_sections.values.elementAt(index));

    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section Scroll Example'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sections.keys.map((key) {
                  int index = _sections.keys.toList().indexOf(key);
                  return TextButton(
                    onPressed: () => _scrollToSection(index),
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                        color: _selectedIndex == index ? Colors.blue : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Section Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: _sections.keys.map((key) {
                  return Column(
                    children: [
                      Center(
                        key: _sections[key],
                        child: Text(
                          key,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(
                        height: 500,
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

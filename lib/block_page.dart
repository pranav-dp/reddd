import 'package:flutter/material.dart';

class BlockPage extends StatelessWidget {
  static const List<Map<String, dynamic>> devices = [
    {'name': 'Camera', 'icon': Icons.camera_alt},
    {'name': 'Alerts', 'icon': Icons.notifications},
    {'name': 'Insect Detection System', 'icon': Icons.bug_report},
    {'name': 'Internet', 'icon': Icons.wifi},
    {'name': 'Pesticide Sprayer', 'icon': Icons.spa},
  ];

  const BlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildSearchBar(),
                _buildTreeChips(),
                Expanded(
                  child: _buildDeviceList(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 8),
          Text(
            'Block A',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: Color(0xFF9BA4B4)),
          filled: true,
          fillColor: Color(0xFF16213E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTreeChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text('Tree A${index + 1}'),
              backgroundColor: Color(0xFF16213E),
              labelStyle: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return _buildDeviceItem(context, devices[index]);
      },
    );
  }

  Widget _buildDeviceItem(BuildContext context, Map<String, dynamic> device) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(device['icon'], color: Color(0xFFE94560)),
        title: Text(
          device['name'],
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xFF9BA4B4)),
        onTap: () {
          Navigator.pushNamed(context, '/devices');
        },
      ),
    );
  }
}


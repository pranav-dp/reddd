import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const List<Map<String, dynamic>> blocks = [
    {'name': 'A', 'icon': Icons.park},
    {'name': 'B', 'icon': Icons.forest},
    {'name': 'C', 'icon': Icons.nature},
    {'name': 'D', 'icon': Icons.landscape},
    {'name': 'E', 'icon': Icons.eco},
    {'name': 'F', 'icon': Icons.terrain},
  ];

  const HomePage({super.key});

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Premises',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9BA4B4),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      if (index == blocks.length) {
                        return _buildAddBlock();
                      }
                      return _buildBlockItem(context, blocks[index]);
                    },
                    itemCount: blocks.length + 1,
                  ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Welcome Rahul',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.settings, color: Color(0xFF9BA4B4)),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications, color: Color(0xFF9BA4B4)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlockItem(BuildContext context, Map<String, dynamic> block) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/blocks');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF16213E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              block['icon'],
              size: 48,
              color: Color(0xFFE94560),
            ),
            SizedBox(height: 8),
            Text(
              'Block ${block['name']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBlock() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 48,
            color: Color(0xFFE94560),
          ),
          SizedBox(height: 8),
          Text(
            'Add Block',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


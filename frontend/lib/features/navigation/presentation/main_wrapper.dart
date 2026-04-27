import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class MainWrapper extends StatefulWidget {
  final Widget child; 
  const MainWrapper({super.key, required this.child});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/timeline')) return 1;
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/timeline'); break;
      case 2: context.go('/profile'); break;
      case 3: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/upload'),
        backgroundColor: AppTheme.primaryColor,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppTheme.backgroundColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(context, icon: Icons.grid_view_rounded, index: 0),
              _buildNavIcon(context, icon: Icons.auto_graph_rounded, index: 1),
              
              const SizedBox(width: 30),
              
              _buildNavIcon(context, icon: Icons.person_outline_rounded, index: 2),
              _buildNavIcon(context, icon: Icons.settings_outlined, index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, {required IconData icon, required int index}) {
    final isSelected = _getSelectedIndex(context) == index;
    return IconButton(
      onPressed: () => _onItemTapped(index, context),
      icon: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
        size: 26,
      ),
    );
  }
}

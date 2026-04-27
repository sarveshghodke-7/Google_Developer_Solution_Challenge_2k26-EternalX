import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    final theme = Theme.of(context); 
    final String location = GoRouterState.of(context).uri.path;
    IconData fabIcon = Icons.add;
    String fabLabel = "";
    VoidCallback? fabAction;
    bool isExtended = false;
    if (location == '/medications') {
      fabIcon = Icons.medication_outlined;
      fabLabel = "Add Med";
      isExtended = true;
      fabAction = () => print("Open Med Sheet"); 
    } else if (location == '/visits') {
      fabIcon = Icons.calendar_month;
      fabLabel = "Book Visit";
      isExtended = true;
      fabAction = () => print("Book Visit");
    } else {
      fabIcon = Icons.add;
      fabAction = () => Future.microtask(() => context.push('/upload'));
    }
    return Scaffold(
      body: widget.child,
      floatingActionButton: isExtended 
      ? FloatingActionButton.extended(
          onPressed: fabAction,
          backgroundColor: theme.colorScheme.primary,
          icon: Icon(fabIcon, color: theme.colorScheme.onPrimary),
          label: Text(fabLabel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        )
      : FloatingActionButton(
          onPressed: fabAction,
          backgroundColor: theme.colorScheme.primary,
          shape: const CircleBorder(),
          child: Icon(fabIcon, color: Colors.white, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        // CRITICAL FIX: This uses white in Light Mode, and dark slate in Dark Mode!
        color: theme.colorScheme.surface, 
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(context, icon: Icons.grid_view_rounded, index: 0, theme: theme),
              _buildNavIcon(context, icon: Icons.auto_graph_rounded, index: 1, theme: theme),
              
              const SizedBox(width: 50),
              
              _buildNavIcon(context, icon: Icons.person_outline_rounded, index: 2, theme: theme),
              _buildNavIcon(context, icon: Icons.settings_outlined, index: 3, theme: theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, {required IconData icon, required int index, required ThemeData theme}) {
    final isSelected = _getSelectedIndex(context) == index;
    return IconButton(
      onPressed: () => _onItemTapped(index, context),
      icon: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5),
        size: 26,
      ),
    );
  }
}

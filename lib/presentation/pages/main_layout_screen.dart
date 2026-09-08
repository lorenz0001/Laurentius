import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../core/services/mock_data_service.dart';
import '../widgets/spotlight_search_bar_widget.dart';
import 'category_explorer_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// Schermata principale (Root Layout) di Brilliant-OS.
/// Radically simplified: elimina il vecchio AppBar affollato con pulsanti di debug ("Ricarica")
/// e icone modali nascoste, introducendo una barra di ricerca istantanea Spotlight omnipresente
/// con integrazione ⌘K, navigazione fluida tra Grafo ed Esplora e accesso rapido alle impostazioni.
class MainLayoutScreen extends StatefulWidget {
  final Isar? isar;

  const MainLayoutScreen({super.key, this.isar});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;
  bool _isSyncing = false;

  final GlobalKey<_GraphTabWrapperState> _graphWrapperKey =
      GlobalKey<_GraphTabWrapperState>();
  final GlobalKey<State<CategoryExplorerScreen>> _categoryKey = GlobalKey();

  Future<void> _handleRefresh() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      if (widget.isar != null) {
        await MockDataService.populateDatabase(widget.isar!);
      }
      _graphWrapperKey.currentState?.reload();
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Catalogo delle conoscenze sincronizzato con successo!'),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Logo & Titolo Brilliant OS
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Brilliant OS',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 12),

                // Barra di Ricerca Istantanea Omnipresente Spotlight
                Expanded(
                  child: SpotlightSearchBarWidget(
                    isar: widget.isar,
                  ),
                ),
                const SizedBox(width: 6),

                // Ingranaggio Impostazioni AI & DeepSeek
                IconButton(
                  tooltip: 'Impostazioni AI & DeepSeek',
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF475569),
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _GraphTabWrapper(key: _graphWrapperKey, isar: widget.isar),
          CategoryExplorerScreen(
            key: _categoryKey,
            isar: widget.isar,
            onRefreshRequested: _handleRefresh,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.hub_outlined),
              activeIcon: Icon(Icons.hub_rounded),
              label: 'Grafo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined),
              activeIcon: Icon(Icons.auto_stories_rounded),
              label: 'Esplora',
            ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper per isolare e permettere il refresh programmatico di GraphViewScreen
class _GraphTabWrapper extends StatefulWidget {
  final Isar? isar;

  const _GraphTabWrapper({super.key, this.isar});

  @override
  State<_GraphTabWrapper> createState() => _GraphTabWrapperState();
}

class _GraphTabWrapperState extends State<_GraphTabWrapper> {
  Key _graphKey = UniqueKey();

  void reload() {
    setState(() {
      _graphKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GraphViewScreen(
      key: _graphKey,
      isar: widget.isar,
      showAppBar: false,
    );
  }
}

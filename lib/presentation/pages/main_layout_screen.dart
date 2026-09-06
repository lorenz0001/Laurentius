import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../core/services/mock_data_service.dart';
import '../widgets/node_search_delegate.dart';
import 'category_explorer_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// Schermata principale (Root Layout) di Brilliant-OS.
/// Gestisce la navigazione tramite BottomNavigationBar in stile iOS tra
/// la vista a Grafo (GraphViewScreen) e la vista gerarchica a Categorie (CategoryExplorerScreen),
/// oltre ad ospitare la barra di ricerca globale e i controlli di sincronizzazione.
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

  void _openSearch() {
    showSearch(
      context: context,
      delegate: GlobalNodeSearchDelegate(isar: widget.isar),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.hub_rounded,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Brilliant OS',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    fontSize: 18,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  _currentIndex == 0
                      ? 'Mappa Conoscenze (DAG)'
                      : 'Libreria Categorie',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Pulsante Ricerca Globale
          IconButton(
            tooltip: 'Cerca per titolo, categoria o formula',
            icon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF0F172A),
              size: 22,
            ),
            onPressed: _openSearch,
          ),

          // Pulsante Ricarica catalogo
          IconButton(
            tooltip: 'Ricarica e sincronizza catalogo',
            onPressed: _isSyncing ? null : _handleRefresh,
            icon: _isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF2563EB),
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
          ),
          // Pulsante Impostazioni AI & DeepSeek
          IconButton(
            tooltip: 'Impostazioni AI & DeepSeek',
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF0F172A),
              size: 22,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
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

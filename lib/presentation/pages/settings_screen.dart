import 'package:flutter/material.dart';

import '../../core/services/app_settings_service.dart';

/// Schermata di configurazione delle impostazioni AI di Brilliant-OS.
/// Permette all'utente di inserire la propria chiave API DeepSeek,
/// selezionare il modello (es. deepseek-v4-flash), verificare la connessione
/// e regolare i parametri del tutor intelligente.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();

  bool _obscureApiKey = true;
  bool _isLoading = true;
  bool _isTesting = false;
  bool _isSaving = false;
  ConnectionTestResult? _testResult;

  final List<String> _suggestedModels = [
    'deepseek-v4-flash',
    'deepseek-chat',
    'deepseek-reasoner',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _modelController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final apiKey = await AppSettingsService.getApiKey() ?? '';
    final model = await AppSettingsService.getModel();
    final baseUrl = await AppSettingsService.getBaseUrl();

    if (mounted) {
      setState(() {
        _apiKeyController.text = apiKey;
        _modelController.text = model;
        _baseUrlController.text = baseUrl;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    final key = _apiKeyController.text.trim();
    final model = _modelController.text.trim().isEmpty
        ? AppSettingsService.defaultModel
        : _modelController.text.trim();
    final baseUrl = _baseUrlController.text.trim().isEmpty
        ? AppSettingsService.defaultBaseUrl
        : _baseUrlController.text.trim();

    await AppSettingsService.setApiKey(key);
    await AppSettingsService.setModel(model);
    await AppSettingsService.setBaseUrl(baseUrl);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Impostazioni DeepSeek salvate con successo!'),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _runConnectionTest() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      setState(() {
        _testResult = const ConnectionTestResult(
          isSuccess: false,
          message: 'Inserisci prima la tua chiave API DeepSeek nel campo soprastante.',
        );
      });
      return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final result = await AppSettingsService.testConnection(
      apiKey: key,
      model: _modelController.text.trim(),
      baseUrl: _baseUrlController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isTesting = false;
        _testResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Impostazioni AI & DeepSeek',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveSettings,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Salva',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF2563EB),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Header di configurazione
                  _buildHeaderCard(),
                  const SizedBox(height: 20),

                  // Sezione API Key
                  _buildApiKeySection(),
                  const SizedBox(height: 20),

                  // Sezione Modello & Endpoint
                  _buildModelAndEndpointSection(),
                  const SizedBox(height: 20),

                  // Sezione Test Connessione
                  _buildTestConnectionSection(),
                  const SizedBox(height: 20),

                  // Sezione Guida & Istruzioni
                  _buildGuideSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    final hasKey = _apiKeyController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: hasKey ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasKey ? const Color(0xFFBFDBFE) : const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasKey ? Icons.bolt_rounded : Icons.warning_amber_rounded,
              color: hasKey ? const Color(0xFF2563EB) : const Color(0xFFD97706),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasKey
                      ? 'Motore DeepSeek Attivo'
                      : 'Chiave API Non Configurata',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: hasKey
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasKey
                      ? 'Quiz matematici personalizzati, rielaborazione testi e assistente sbloccati.'
                      : 'Inserisci la tua chiave DeepSeek per abilitare la generazione di quiz rigorosi e l\'assistente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: hasKey
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeySection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.key_rounded, size: 18, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text(
                'DEEPSEEK API KEY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'La chiave viene salvata localmente sul tuo dispositivo e mai trasmessa a terzi.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'monospace',
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'sk-...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 1.5,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureApiKey
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureApiKey = !_obscureApiKey;
                  });
                },
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildModelAndEndpointSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                'MODELLO & ENDPOINT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Selezione rapida modello con Chip
          const Text(
            'Modelli Consigliati:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedModels.map((m) {
              final isSelected = _modelController.text.trim() == m;
              return ChoiceChip(
                label: Text(m),
                selected: isSelected,
                selectedColor: const Color(0xFFEFF6FF),
                backgroundColor: const Color(0xFFF8FAFC),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF475569),
                ),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _modelController.text = m;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Campo testo modello
          TextField(
            controller: _modelController,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Nome Modello',
              labelStyle: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Campo Base URL
          TextField(
            controller: _baseUrlController,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Base URL API',
              labelStyle: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestConnectionSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.network_check_rounded,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                'VERIFICA CONNETTIVITÀ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Invia una richiesta minima di test ai server DeepSeek per verificare la validità della chiave.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _isTesting ? null : _runConnectionTest,
            icon: _isTesting
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded, size: 16),
            label: Text(
              _isTesting ? 'Verifica in corso...' : 'Testa Chiave API',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              side: const BorderSide(color: Color(0xFFBFDBFE)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          if (_testResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _testResult!.isSuccess
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _testResult!.isSuccess
                      ? const Color(0xFFBBF7D0)
                      : const Color(0xFFFECACA),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _testResult!.isSuccess
                        ? Icons.check_circle_rounded
                        : Icons.error_outline_rounded,
                    color: _testResult!.isSuccess
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _testResult!.message,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _testResult!.isSuccess
                            ? const Color(0xFF15803D)
                            : const Color(0xFFB91C1C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuideSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Color(0xFF64748B),
              ),
              SizedBox(width: 8),
              Text(
                'COME OTTENERE LA CHIAVE API',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '1. Accedi alla console ufficiale su platform.deepseek.com\n'
            '2. Seleziona la sezione "API Keys" e clicca "Create new secret key"\n'
            '3. Copia la chiave generata e incollala nel campo soprastante\n'
            '4. Clicca su "Salva" per abilitare tutte le funzionalità AI avanzate.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.6,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

## 2026-09-07T23:40:52Z

You are the Spotlight Search & UI Architecture Explorer for Laurentius (Brilliant-OS).
Your working directory is: c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_3
You MUST read c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md before starting work (specifically the section ## 2026-09-07T23:39:08Z).
Also review:
- c:\Users\catte\Desktop\Laurentius\PROJECT_MAP.md
- c:\Users\catte\Desktop\Laurentius\.agents\skills\laurentius-dev\SKILL.md

Your objective:
Analyze the main screen UI and search architecture:
1. Review lib/presentation/pages/home_screen.dart, lib/presentation/pages/main_layout_screen.dart, and lib/presentation/pages/category_explorer_screen.dart. What buttons, nested menus, or UI clutter exist? How can the layout be radically simplified per Brilliant design language?
2. Review lib/presentation/widgets/node_search_delegate.dart, lib/data/repositories/node_repository.dart, and lib/data/catalog/curriculum_registry.dart. How does search currently work?
3. Design the omnipresent, top-level Instant Spotlight Search bar on the main screen:
   - Live predictive indexing as the user types (theorems, formulas, corollaries, definitions).
   - Displaying matching proof and corollary cards directly with highlight, category badge, and preview snippet.
   - Selecting a search result must jump directly to that topic focused on that exact theorem or corollary in <= 1 tap (passing target focus to NodeDetailScreen).
4. Detail the exact widget architecture, state management (Notifier/Provider/StatefulWidget), keyboard handling, and transitions.
5. Identify existing tests and recommend new widget/unit tests for Spotlight search and 1-tap navigation.

Write your architectural analysis, component design, interaction flows, and implementation plan to c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_3\handoff.md and update progress.md in your working directory.
When done, notify the caller with a concise summary and the path to your report.

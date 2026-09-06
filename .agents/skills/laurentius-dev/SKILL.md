---
name: laurentius-dev
description: >-
  Development guidelines, architectural standards, and workflow procedures for the Laurentius
  (Brilliant OS) offline-first interactive knowledge graph Flutter application. Use this skill
  when adding domain models, interacting with Isar database, managing mathematical proofs, or
  building presentation widgets.
---

# Laurentius Development Skill

This skill contains core architectural standards, operational directives, and best practices for developing the **Laurentius** application.

---

## 1. Project Architecture Guidelines

Follow Clean Architecture strictly separated across layers:

- **`lib/domain/`**:
  - Contains entities, pure business models, and repository interfaces.
  - No direct Flutter UI dependencies.
- **`lib/data/`**:
  - Implements repositories using the local Isar database and sync mechanisms.
  - Handles serialization, queries, and data persistence.
- **`lib/core/`**:
  - Reusable utilities, constants, theme tokens, and mock/seeding services.
- **`lib/presentation/`**:
  - UI screens, state management (e.g. Riverpod/Bloc), interactive canvas widgets, and graph visualization.

---

## 2. Isar Database Directives

When modifying or querying the local database:

1. **Schema & Models**:
   - Main entities use the `@collection` annotation.
   - Child components or nested data structures use `@embedded`.
   - Every collection must have an `Id id = Isar.autoIncrement;`.
   - Keep unique identifiers indexed with `@Index(unique: true, replace: true)`.
   - Relationships between knowledge nodes must use `IsarLinks<T>`.

2. **Code Generation**:
   - Always run code generation after modifying `@collection` or `@embedded` files:
     ```bash
     dart run build_runner build --delete-conflicting-outputs
     ```

3. **Transactions**:
   - All writes, updates, and relationship updates must be wrapped in `isar.writeTxn(...)`.
   - When updating links (`IsarLinks`), explicitly call `await node.prerequisites.save()` inside the transaction.

---

## 3. Mathematical & Proof Content Directives

1. **LaTeX Formatting**:
   - In Dart strings, always use raw strings (`r'...'`) or double backslashes (`\\`) for LaTeX escape sequences (e.g., `r'V = R \cdot I'` or `r'\frac{a}{b}'`).
2. **Proof Steps**:
   - Each `ProofStep` should contain an equation, a concise description, and an educational insight explaining the transformation or intuition.
3. **Interactive Parameters**:
   - Provide safe numeric bounds (`minValue`, `maxValue`, `defaultValue`, `stepSize`) for all interactive parameters to prevent division by zero or invalid calculations.

---

## 4. Quality & Verification Workflow

Before committing any changes:

1. **Static Analysis**:
   ```bash
   flutter analyze
   ```
2. **Automated Tests**:
   ```bash
   flutter test
   ```
3. **Git Hygiene**:
   - Keep commits atomic and prefixed according to Conventional Commits:
     - `feat:` for new features
     - `fix:` for bug fixes
     - `chore:` for tooling, dependencies, or mocks
     - `ci:` for CI/CD pipelines

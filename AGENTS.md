# AGENTS.md

## Workflow rules (user-mandated)

- Work one roadmap story at a time from `FLOATWISE_FUTURE_IMPLEMENTATION.md`. Follow handoff spec §42 rules: inspect the repo before changes, confirm file paths/types exist, no blind overwrites, keep the app runnable, show each file path touched, run format/analyze/tests after significant changes, write tests alongside new parser/ledger/verification logic, keep raw SMS separate from financial entries.
- After **every completed story**, output:
  1. A sample commit message for that story.
  2. `git add` / `commit` / `push` commands.
  3. A short "How to test in the app" direction describing how to verify the story's changes on a running device/emulator (with exact `flutter run`/`flutter test` steps when relevant).
- Real SMS samples: the synthetic fixtures under `test/fixtures/sms/{mtn,telecel,airteltigo}/` stand in until real anonymized samples are provided. Formats were researched online and are realistic; swap file contents when real samples arrive (tests read them automatically).
- Accounting defaults (approved, until changed): cashIn → verified/deposit (cash `+amount`, float `-amount`); cashOut → verified/withdrawal (cash `-amount`, float `+amount`); transfer/airtime/data/billPayment/fee/reversal/unknown → `needsReview`, no ledger event. Commission = 0 for now.
- Scope: offline-only. Supabase/secure-storage remain dormant. No `parsed_transactions` table (parse stage is in-memory).
- Do not add code comments unless asked.

## Verification commands

- `dart run build_runner build --delete-conflicting-outputs` (required after DAO/table changes to regenerate `.g.dart`).
- `dart format lib test`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- Clean up: all must pass before committing a story.

## Key implementation facts

- Drift `Migrator` in 2.34 uses `deleteTable(name)` (not `dropTable`). Schema version is 3; `from < 3` migrations drop+recreate `provider_transactions` and `ledger_events` (unreleased schema, data loss acceptable).
- Dart 3.12 private named params: `required this._x` is normalized at call sites to `x:`.
- Widget tests need `SharedPreferences.setMockInitialValues(...)` and `GoogleFonts.config.allowRuntimeFetching = false`.
- Posting flow: parse → `SmsParseResult.transactions` → `TransactionPostingService.postTransactions` auto-run after SMS import; ledger events only for verified txs inside an active session. Posting interface lives at `lib/features/transaction/application/transaction_posting_service.dart`; impl at `data/services/`.
- `mobile_money_provider_registry_provider.dart` is the shared registry provider used by both import and parse providers.
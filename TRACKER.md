# FloatWise — App Tracker

Living status table. Updated after each story.
Legend: `✅ Done` · `🔶 Partial` · `⬜ Not started` · `🚫 Deferred`

## Phase A — Foundation

| # | Item | Status |
|---|------|--------|
| A1 | Flutter project + theme + router + folder structure | ✅ |
| A2 | Design system | ✅ |
| A3 | Application shell | ✅ |
| A4 | Drift DB config + schema v3 + migrations | ✅ |

## Phase B — Setup & Navigation

| # | Item | Status | Notes |
|---|------|--------|-------|
| B1 | Setup Wizard (5 steps) | ✅ | Only reachable pre-setup (redirect) |
| B2 | Atomic setup persistence + open session | ✅ | |
| B3 | Router / redirect logic | ✅ | |
| B4 | Setup re-run / onboarding path from dashboard | ⬜ | No "restart setup" entry |

## Phase C — Business/Branch/Till/Session Domain

| # | Item | Status |
|---|------|--------|
| C1 | Business entity/repo/DAO | ✅ |
| C2 | Branch entity/repo/DAO | ✅ |
| C3 | Till entity/repo/DAO | ✅ |
| C4 | Daily Session entity/repo/DAO + one-open-per-till | ✅ |
| C5 | Multi-till switching | 🚫 Deferred (§31) |

## Phase D — SMS Subsystem

| # | Item | Status | Notes |
|---|------|--------|-------|
| D1 | SMS permission (manifest, runtime, denied, permanently-denied, settings, skip) | ✅ | FW-008.1 |
| D2 | Raw SMS import with date ranges | ✅ | FW-008.2 |
| D3 | Duplicate protection (sha256, unique key) | ✅ | |
| D4 | DeviceSmsReader (paged) | ✅ | |
| D5 | Provider registry (sender + message characteristics) | ✅ | MTN/Telecel/AirtelTigo |
| D6 | Parsers per provider | ✅ | |
| D7 | Parser fixtures (synthetic) + parser tests | ✅ | Swap real samples later |
| D8 | Raw SMS kept as audit source (not auto-posted) | ✅ | |
| D9 | Background/realtime SMS listener | 🚫 Deferred (§26) |

## Phase E — Transactions → Ledger

| # | Item | Status | Notes |
|---|------|--------|-------|
| E1 | Parse → post pipeline after import | ✅ | |
| E2 | Ledger events (cash/float deltas, append-only) | ✅ | commission=0 |
| E3 | Accounting defaults cashIn/cashOut | ✅ | |
| E4 | Manual verification / review workflow | ✅ | Story 1 (FW-010) |
| E5 | Manual transaction / adjustment entry | ⬜ | Story 3 |
| E6 | Needs-review exception queue / triage | ✅ | Via review screen |

## Phase F — Reconciliation & Close Day

| # | Item | Status | Notes |
|---|------|--------|-------|
| F1 | Reconciliation engine | ✅ | balanced/short/excess/unresolved |
| F2 | Close Day flow + discrepancy confirmation | ✅ | |
| F3 | Working Reconcile screen | ✅ | Story 2 (FW-011) |

## Phase G — Dashboard

| # | Item | Status | Notes |
|---|------|--------|-------|
| G1 | Dashboard connected to real data | ✅ | |
| G2 | Review deep-link from summary card | ✅ | Story 1 |

## Phase H — Hygiene / Tests / Docs

| # | Item | Status | Notes |
|---|------|--------|-------|
| H1 | Unit tests (parsers, posting, verification, close day, recon) | ✅ | |
| H2 | DAO/database + migration tests | ⬜ | Story 4 |
| H3 | SMS→parse→ledger→reconcile integration test | ⬜ | Story 4 |
| H4 | PROJECT_STATUS.md refresh (stale) | ⬜ | Story 4 |
| H5 | Branch/merge hygiene (16 commits ahead of main) | 🔶 | On feature branches; merge on request |

## Phase I — Deferred (spec §40 / MVP-first)

| # | Item | Status |
|---|------|--------|
| I1 | Reports / search / history (§29–30) | 🚫 |
| I2 | Missing-SMS detection (§22) | 🚫 |
| I3 | Multi-till switching (§31) | 🚫 |
| I4 | Auth / cloud sync (§32) | 🚫 |
| I5 | Security / privacy hardening (§33–34) | 🚫 |
| I6 | Play Store / SMS-policy review (§35) — release blocker | 🚫 |

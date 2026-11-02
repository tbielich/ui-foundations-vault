---
id: publication.merge-guardian-baseline-2026-11-02
title: Merge Guardian Baseline Audit (UIF-VLT #70)
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-11-02
updated: 2026-11-02
authority: supporting
summary: Evidence-backed baseline audit of merge enforcement, CI, and security controls across the five UI Foundations repositories, from a frozen 2026-11-02 API and source snapshot. Kiro analysis pending independent Codex verification.
consumers:
  - human
  - agent
  - codex
applies_to:
  - ui-foundations-vault
  - ui-foundations-runtime
  - ui-foundations-studio
  - ui-foundations-intelligence
  - ui-foundations-connectors
related:
  references:
    - governance.execution-authority
    - governance.verification-review
    - governance.precedence
    - specification.agent-execution-contract
    - workflow.operational.release-review
verification:
  status: unverified
  method: Kiro static analysis of a frozen local snapshot under .audit-input/. No live API calls, no mutation, no push.
  pending:
    - Independent Codex verification will be appended as a separate verification receipt before any draft PR.
  reviewed: null
  reviewers: []
assumptions:
  - The frozen snapshot in .audit-input is the available evidence corpus for this analysis; absence of an item from it cannot by itself prove general repository absence.
  - This document records Kiro analysis only. governance.verification-review is cited as the review contract, not as executed review evidence; no reviewer has yet reviewed this document.
  - Codex performs independent verification and appends its own receipt before any draft PR to tbielich.
---

# Merge Guardian Baseline Audit (UIF-VLT #70)

Codex-Nachtrag: Die anschließende unabhängige [Prüfquittung](merge-guardian-verification-2026-11-02.md) dokumentiert den akzeptierten Prüfumfang und die weiterhin offenen UNVERIFIED-Punkte. Der folgende Statusabschnitt beschreibt den Kiro-Handoff vor dieser Prüfung.

## Status and authority

Dies ist die Kiro-Analyse für den operativen Merge-Guardian-Baseline-Audit (UIF-VLT #70). Sie ist eine statische Auswertung eines eingefrorenen lokalen Snapshots und **noch nicht unabhängig von Codex verifiziert**. `governance.verification-review` ist hier als Review-Vertrag referenziert, nicht als bereits ausgeführte Review-Evidenz; es hat noch kein Reviewer dieses Dokument geprüft. Codex ergänzt anschließend eine eigenständige Verifikations-Quittung.

Alle Aussagen beruhen auf dem Snapshot unter `.audit-input/` mit Aufnahmezeitpunkt `2026-11-02T06:33:31Z` (`captured_utc` in `.audit-input/manifest.json`). Dieses Dokument trifft keine Implementierungs-, CI-, Protection-, Ruleset-, Security- oder Deployment-Änderungen und veröffentlicht nichts. Es testet insbesondere nicht durch einen Push auf `main`.

Der Snapshot enthält `compact.json` pro Repository (Settings, Protection, Rulesets, effektive Regeln, Workflows, Runs, Checks, Security-Endpunkte) sowie SHA-gepinnte Quelldateien unter `source/`. Der vollständige rekursive API-Tree je Repository liegt zusätzlich unter `.audit-input/<repo>/supplement.json` mit `data.truncated: false` vor; eine im Reader sichtbare Kürzung ist eine Darstellungsgrenze, keine API-Truncation. Jede Matrixzeile nennt Endpoint oder Quelldatei-Referenz als klickbaren Link.

## Evidenz-Provenienz und Aliase

Der lokale Snapshot `.audit-input/` ist nicht Teil des veröffentlichten PR. Für Nachprüfbarkeit gelten die folgenden definierten Aliase; die Codex-Quittung ergänzt eine unabhängige Prüfung der Hashes.

- Snapshot-Manifest: `.audit-input/manifest.json`, `captured_utc = 2026-11-02T06:33:31.458520+00:00`, mit SHA-256 je aufgenommener Datei (`sha256`-Map). Die Snapshot-Map führt Hashes der tatsächlich aufgenommenen Dateien; ein Hash deckt genau die aufgenommene Datei ab und sagt nichts über eine nicht aufgenommene Datei aus. Der Manifest-Hash wird von Codex in der eigenständigen Verifikations-Quittung festgehalten; Kiro erhebt hier keinen eigenen Hash-Nachweis.
- Repo-Basis-Links (SHA-gepinnter Head auf `main`), verwendet in den Evidenzzellen als klickbare Markdown-Links auf konkrete Pfade (siehe Reference-Definitionen am Dokumentende):
  - Vault@`a0c58d1`: [Repo-Baum][vault-tree] (privat/public Blob-Pfade z. B. [ci.yml][vault-ci])
  - Runtime@`aa153b7`: [Repo-Baum][runtime-tree] (z. B. [package.json][runtime-pkg], [ci.yml][runtime-ci])
  - Studio@`95cfb96`: [Repo-Baum][studio-tree] (privat; Blob-Links für Berechtigte)
  - Intelligence@`d14ee2f`: [Repo-Baum][intel-tree] (privat; z. B. [ci.yml][intel-ci])
  - Connectors@`e06faf2`: [Repo-Baum][conn-tree] (privat)
- API-Endpoint-Basis `https://api.github.com/repos/tbielich/<repo>/...`: vollständige Endpointpfade stehen pro Zeile als klickbare Links (keine `...`-Platzhalter); Action-Run-/Job-Links verweisen auf konkrete `https://github.com/tbielich/<repo>/actions/runs/<run>/job/<job>`-Pfade.

## Scope-Grenzen der Evidenz

- Eine Datei kann per SHA in der Snapshot-Map stehen, ohne dass ihr Inhalt unter `source/` materialisiert ist; der Hash deckt dann nur die aufgenommene Datei ab. Für die unabhängig nachgeladenen Artefakte (vollständiger rekursiver Tree je Repo, Runtime `.githooks/pre-commit`) liegen Inhalte vor und sind entsprechend nicht mehr UNVERIFIED.
- API-Semantik wird getrennt: `404 "Branch not protected"` ist eine **explizite** Aussage über einen ungeschützten Branch; `403 "Upgrade to GitHub Pro..."` ist ein **unzugänglicher** Endpoint und damit UNVERIFIED.
- Security-Endpunkte werden einzeln ausgewertet. Eine explizite `disabled`/`not enabled`-Antwort belegt, dass das **benannte GitHub-Feature** deaktiviert ist — nicht das Fehlen einer gleichwertigen anderweitigen Prüfung. `no analysis found` belegt lediglich, dass keine Analyse zurückkam (UNVERIFIED), nicht dass Code Scanning deaktiviert ist.
- Ein vorhandenes Workflow-File oder ein Gesamtzähler erfolgreicher Runs belegt keine erzwungene Merge-Prüfung. Durchsetzung am Merge muss über Protection plus Ruleset-Details plus effektive Regeln gestützt werden; Präsenz ist nicht gleich Nicht-Umgehbarkeit.
- Sichtbare Security-Settings (z. B. aktiviertes Secret Scanning) belegen eine aktive Funktion, aber **keine** unumgehbare Merge-Durchsetzung.

## Repository-Identität (eingefroren, Identitätsmetadaten)

Repo-Existenz, Default-Branch und Head-SHA sind Identitätsmetadaten, keine durchgesetzte Kontrolle. Sie stehen deshalb außerhalb der Kontrollmatrix.

| Repository | Sichtbarkeit | Default-Branch | Head-SHA (main) | Endpoint |
|---|---|---|---|---|
| ui-foundations-vault | public | main | `a0c58d1f97c1b08621d6d1103a7f734c5c89a70f` | `GET /repos/tbielich/ui-foundations-vault` |
| ui-foundations-runtime | public | main | `aa153b79668df7c3b655a96d9541171de1899580` | `GET /repos/tbielich/ui-foundations-runtime` |
| ui-foundations-studio | private | main | `95cfb968db86645049565175517ee4446fe1178d` | `GET /repos/tbielich/ui-foundations-studio` |
| ui-foundations-intelligence | private | main | `d14ee2f382c4e295cdfda7571963ac08b80c3452` | `GET /repos/tbielich/ui-foundations-intelligence` |
| ui-foundations-connectors | private | main | `e06faf24f5dccfcd3e08c7beefffb4f6871247b5` | `GET /repos/tbielich/ui-foundations-connectors` |

Alle fünf Repositories existieren, sind nicht archiviert, Default-Branch `main`. Beobachtung zum Read-Collector: das für die Aufnahme genutzte Token meldet auf allen fünf Repos `admin: true`. Das ist eine Eigenschaft des lesenden Collectors, nicht die Publikationsidentität; Publisher ist `uif-intelligence`.

## Kernbefunde

1. **Für kein Repository ist eine positive Approval-Zahl oder ein benannter Required Context am Merge konfiguriert.** Bei Runtime existiert `required_pull_request_reviews` (`require_code_owner_reviews: true`), aber `required_approving_review_count: 0` und `required_status_checks.contexts: []`. Das belegt, dass keine positive Approval-Zahl und kein benannter Required Context gebunden ist. Die effektive Direct-Push-/PR-Durchsetzung ist daraus **nicht** ableitbar und bleibt UNVERIFIED (kein Mutationstest durchgeführt); aus `required_approving_review_count: 0` folgt insbesondere nicht, dass Direct Push oder PR-Bypass erlaubt sind. Bekannt bleibt die Ruleset-`update`-Beschränkung: `main`-Updates sind für Nicht-Bypass-Akteure eingeschränkt. Bei Vault gilt dieselbe `update`-Beschränkung. Für die drei privaten Repos ist die effektive Merge-Durchsetzung über die API nicht einsehbar (403 Pro-Feature) und bleibt UNVERIFIED.
2. **Rulesets der öffentlichen Repos decken `creation`, `update`, `deletion`, `non_fast_forward` ab.** Die `update`-Regel (Restrict updates) beschränkt Branch-Updates auf Bypass-Akteure; sie ist nicht nur Force-Push-Integrität. Folge laut diesem Ruleset: Ein direkter Push auf `main` ist nur für den Bypass-Actor zulässig, Nicht-Bypass-Akteure können `main` nicht aktualisieren. Es fehlen `pull_request`- und `required_status_checks`-Regeltypen, d. h. die Rulesets verlangen weder PRs noch Approvals noch Status-Checks. Beide Rulesets haben einen Bypass-Actor (`actor_id 14805502`, `bypass_mode: always`) und `current_user_can_bypass: always`.
3. **`require_code_owner_reviews: true` bei Runtime ist konfiguriert, aber ohne derzeitige Codeowner-Zuordnung.** Der vollständige rekursive API-Tree (`data.truncated: false`) wurde für alle fünf Repos unabhängig geprüft; keiner der fünf Trees enthält eine `CODEOWNERS`-Datei. Für Runtime gilt somit: vollständiger rekursiver API-Tree `truncated:false`; keine `CODEOWNERS`-Datei vorhanden; `require_code_owner_reviews` ist konfiguriert, derzeit keine Codeowner-Zuordnung im Tree. Code-Owner-Review greift damit mangels Datei aktuell nicht; dies ist eine künftige CODEOWNERS-Entscheidung, keine fehlende Evidenz.
4. **Security-Features sind je Endpoint unterschiedlich.** Runtime: Secret Scanning plus Push Protection `enabled`; `dependabot_security_updates: disabled` (das sind Security-Updates, nicht Alerts); Dependabot-Alerts explizit `disabled` (403); Code Scanning `no analysis found` (UNVERIFIED, keine Analyse zurückgegeben). Vault: Secret Scanning explizit `disabled` (404), Dependabot-Alerts `disabled` (403), Code Scanning `no analysis found` (UNVERIFIED). Private Repos: `security_and_analysis: null`, Code Scanning `not enabled` (403), Secret Scanning `disabled` (404), Dependabot `disabled` (403).
5. **Runtime-Release-Evidence ist ein manuell ausgelöster, schreibgeschützter Dry-Run, kein Merge-Gate.** `release-readiness.yml` läuft per `workflow_dispatch`, `permissions: contents: read`, mit einem job-lokalen Fail-closed-Gate nach `continue-on-error`. Es ist kein Required Check auf `main`.
6. **Knip und jscpd sind in den aufgenommenen Command-Sets nicht nachweisbar.** Weder Runtime `ci:check` noch der fixe Command-Satz von `scripts/release-evidence.mjs` enthalten Knip oder jscpd. Status UNVERIFIED mangels Konfigurationsdatei im Snapshot.

## Branch-Protection und Rulesets im Detail

### ui-foundations-vault (public)

- `GET /repos/tbielich/ui-foundations-vault/branches/main/protection` -> `404 "Branch not protected"`. Explizit ungeschützter Branch, keine klassische Branch Protection.
- Ruleset `24978374` "UIF main — tbielich only", `enforcement: active`, Bedingung `refs/heads/main`, Regeln: `creation`, `update`, `deletion`, `non_fast_forward`. Bypass-Actor `14805502` (`always`), `current_user_can_bypass: always`. (`GET /repos/tbielich/ui-foundations-vault/rulesets/24978374`)
- Effektive Regeln auf `main` (`GET /repos/tbielich/ui-foundations-vault/rules/branches/main`): nur die vier obigen Typen. Kein `pull_request`-Regeltyp, kein `required_status_checks`-Regeltyp.
- Folge: Die `update`-Regel beschränkt Updates von `main` auf den Bypass-Actor; Nicht-Bypass-Akteure können `main` weder per Direct Push noch anderweitig aktualisieren. Für den Bypass-Actor ist Direct Push zulässig. Force-Push, Löschen und Non-Fast-Forward sind blockiert, für den Bypass-Actor umgehbar. Es ist kein PR- oder Status-Check-Zwang konfiguriert.

### ui-foundations-runtime (public)

- `GET /repos/tbielich/ui-foundations-runtime/branches/main/protection` -> `200`. `enforce_admins.enabled: true` (klassische Admin-Durchsetzung). `required_pull_request_reviews`: `require_code_owner_reviews: true`, `required_approving_review_count: 0`, `dismiss_stale_reviews: false`, `require_last_push_approval: false`. `required_status_checks`: `strict: true`, aber `contexts: []` und `checks: []`. `required_signatures.enabled: false`. `allow_force_pushes.enabled: false`, `allow_deletions.enabled: false`, `required_linear_history.enabled: false`, `required_conversation_resolution.enabled: false`, `lock_branch.enabled: false`.
- Ruleset `24978370` "UIF main — tbielich only", `active`, Regeln `creation`/`update`/`deletion`/`non_fast_forward`, Bypass-Actor `14805502` (`always`), `current_user_can_bypass: always`. (`GET /repos/tbielich/ui-foundations-runtime/rulesets/24978370`)
- Beobachtung: `required_approving_review_count: 0` bedeutet, dass keine positive Approval-Zahl erzwungen ist; `contexts: []` bedeutet, dass kein benannter Required Check gebunden ist. Die effektive Direct-Push-/PR-Durchsetzung ist daraus nicht ableitbar und bleibt UNVERIFIED (kein Mutationstest). `require_code_owner_reviews: true` ist konfiguriert; der vollständige rekursive API-Tree (`data.truncated: false`) enthält jedoch keine `CODEOWNERS`-Datei — Code-Owner-Review greift derzeit mangels Zuordnung nicht, es ist eine künftige CODEOWNERS-Entscheidung. ([Protection][runtime-protection], [Tree][runtime-tree])
- Klassische Protection ([Protection][runtime-protection]): `allow_force_pushes.enabled: false`, `allow_deletions.enabled: false`, `enforce_admins.enabled: true`. Diese Kontrollen sind in der inspizierten Konfiguration durchgesetzt (statisch inspiziert, nicht dynamisch getestet) und wirken unabhängig vom Ruleset. Der Ruleset-Bypass (`actor_id 14805502`) hebt **nur** die Ruleset-Integritätsregeln für diesen Actor aus und besiegt **nicht** die eigenständige klassische Protection. Force-Push und Löschen auf `main` sind damit auch für den Ruleset-Bypass-Actor durch die klassische Protection weiterhin blockiert.
- `.github/workflows/ci.yml` ist vorhanden und lesbar ([ci.yml][runtime-ci]): `on: push` und `pull_request` ohne Branch-/Path-Filter; Job `build` mit Matrix `node-version: [20, 22]`, `fail-fast: false`; Schritte `actions/checkout@v4`, `actions/setup-node@v4`, `npm ci`, `npx playwright install --with-deps chromium`, `npm run ci:check`. Kein `continue-on-error` in dieser CI.
- `.githooks/pre-commit` wurde am gepinnten SHA unabhängig nachgeladen (Inhalt unter `.audit-review/runtime-pre-commit.txt`): `set -e`, führt `npm run lint` dann `npm run test:unit` je mit `|| exit 1`. Das ist ein lokaler, umgehbarer Hook (configured-not-enforced), kein serverseitiges Merge-Gate.

### ui-foundations-studio / -intelligence / -connectors (private)

- Protection und Rulesets: `GET .../branches/main/protection`, `GET .../rulesets?includes_parents=true` und `GET .../rules/branches/main` -> `403 "Upgrade to GitHub Pro or make this repository public to enable this feature."`
- Diese Endpoints sind unzugänglich, nicht nachweislich abwesend. Effektive Merge-Durchsetzung dieser Repos ist UNVERIFIED. Der 403 unterscheidet sich ausdrücklich vom expliziten `404 "Branch not protected"` des Vault.
- Die Actions-API ist bei `intelligence` und `studio` einsehbar (Workflows, Runs, Checks), bei `connectors` leer (0 Workflows).

## Workflows und tatsächliche Ausführung

| Repository | Workflows (Anzahl) | Belegte Ausführung (Head-Commit Checks) |
|---|---|---|
| vault | 3 (CI, Publish, Copilot) | 1 Check `validate` = success auf `a0c58d1f` |
| runtime | 5 (CI, Pages, Publish npm, Release Readiness, Copilot) | 3 Checks auf `aa153b79`: `Collect release-readiness evidence`, `build (22)`, `build (20)` = success |
| studio | 1 (Studio prototype checks) | 0 Checks auf Head `95cfb968`; der aktuelle `main`-Tree enthält **kein** `.github/workflows`. Die Actions-Inventur (`studio-checks.yml`) und 9 historische Runs beziehen sich auf frühere Commits, nicht auf den aktuellen Tree. |
| intelligence | 6 (CI, Cloud pipeline, Repo sanity x2, Rotate token, Copilot) | 8 Checks auf `d14ee2f3`: `sanity / inspect` success, `sanity / persist` skipped, mehrere `rotate` success, `test` success |
| connectors | 0 | 0 Runs, 0 Checks |

`.../commits/<head>/status` liefert bei allen fünf `state: pending, total_count: 0`: keine Commit-Status-API-Einträge, nur Check-Runs.

## Fünf-Repository-Gap-Matrix

Status-Spalte strikt eines von: **enforced** (am Merge durchgesetzt), **configured-not-enforced** (vorhanden/geplant/job-lokal, aber kein belegtes Required-Merge-Gate), **absent** (explizit abwesend), **UNVERIFIED** (Evidenzlücke), **not applicable**. Das Feld "Enforcement" bezieht sich durchgehend auf den **Merge**; job-lokal erfolgreiche oder geplante Prüfungen sind `configured-not-enforced`, solange kein Required-Merge-Gate belegt ist. Job-lokales Fail-closed-Verhalten steht in den beobachteten Details. Priorität: P0 Sicherheit/Durchsetzbarkeit, P1 Code-Gesundheit, P2 Ergonomie. Eigentümervorschläge sind unbestätigt.

### Branch Protection (klassisch) — Merge-Durchsetzung

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner (unbestätigt) |
|---|---|---|---|---|---|---|---|
| vault | Branch Protection main | absent | [Protection][vault-protection] -> 404 "Branch not protected" | hoch | P0 | Durchsetzbares PR-/Check-Gate über Ruleset oder Protection etablieren (menschliche Freigabe) | ui-foundations |
| runtime | Branch Protection main | configured-not-enforced | [Protection][runtime-protection] 200; `required_approving_review_count: 0`, `required_status_checks.contexts: []`, `enforce_admins.enabled: true` (klassisch durchgesetzt) | hoch | P0 | Approvals >=1 und benannte Required Checks ergänzen; CODEOWNERS-Entscheidung | ui-foundations |
| studio | Branch Protection main | UNVERIFIED | [Protection][studio-protection] -> 403 Pro-Feature | mittel | P0 | Einsehbarkeit herstellen oder alternative Evidenz liefern | ui-foundations |
| intelligence | Branch Protection main | UNVERIFIED | [Protection][intel-protection] -> 403 Pro-Feature | mittel | P0 | dito | ui-foundations |
| connectors | Branch Protection main | UNVERIFIED | [Protection][conn-protection] -> 403 Pro-Feature | mittel | P0 | dito | ui-foundations |

### Rulesets (inkl. vererbt) und effektive Regeln — Merge-Durchsetzung

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner |
|---|---|---|---|---|---|---|---|
| vault | Ruleset main | configured-not-enforced | Ruleset `24978374` active; Regeln creation/update/deletion/non_fast_forward (`update` beschränkt Updates auf Bypass-Actor); kein PR-/Check-Regeltyp; Bypass `14805502` always ([Ruleset][vault-ruleset]) | hoch | P0 | PR- und Status-Check-Regeln ergänzen; Bypass einschränken | ui-foundations |
| runtime | Ruleset main | configured-not-enforced | Ruleset `24978370` active; gleiche vier Regeln (`update` beschränkt Updates auf Bypass-Actor); kein PR-/Check-Regeltyp; Bypass `14805502` always ([Ruleset][runtime-ruleset]) | hoch | P0 | dito | ui-foundations |
| studio | Ruleset main | UNVERIFIED | [Rulesets][studio-ruleset] + [Rules][studio-rules] -> 403 | mittel | P0 | Einsehbarkeit oder alternative Evidenz | ui-foundations |
| intelligence | Ruleset main | UNVERIFIED | [Rulesets][intel-ruleset] -> 403 | mittel | P0 | dito | ui-foundations |
| connectors | Ruleset main | UNVERIFIED | [Rulesets][conn-ruleset] -> 403 | mittel | P0 | dito | ui-foundations |

### Reviews / Required Checks / Direct Push / Force Push / Deletion / Signatures / Bypass — Merge-Durchsetzung

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner |
|---|---|---|---|---|---|---|---|
| vault | Required Reviews | absent | kein `pull_request`-Regeltyp ([Ruleset][vault-ruleset]); [Protection][vault-protection] 404 | hoch | P0 | >=1 Approval, Code-Owner-Review | ui-foundations |
| vault | Required Checks | absent | kein `required_status_checks`-Regeltyp ([Ruleset][vault-ruleset]); [Protection][vault-protection] 404 | hoch | P0 | Mindestens einen benannten Required Check verlangen | ui-foundations |
| vault | Direct Push / PR-Gate | configured-not-enforced | Ruleset-`update`-Regel beschränkt `main`-Updates auf den Bypass-Actor; Nicht-Bypass-Akteure können `main` nicht aktualisieren; kein PR-Regeltyp; Protection 404 (keine unabhängige klassische Protection); Bypass `14805502` always ([Ruleset][vault-ruleset], [Protection][vault-protection]) | hoch | P0 | PR-Pflicht ergänzen; Bypass reduzieren | ui-foundations |
| vault | Force Push / Non-FF | configured-not-enforced | Ruleset `non_fast_forward` blockiert; da keine unabhängige klassische Protection (404), für den Bypass-Actor umgehbar ([Ruleset][vault-ruleset]) | mittel | P1 | Bypass einschränken | ui-foundations |
| vault | Deletion | configured-not-enforced | Ruleset `deletion` blockiert; da keine unabhängige klassische Protection (404), für den Bypass-Actor umgehbar ([Ruleset][vault-ruleset]) | mittel | P1 | Bypass einschränken | ui-foundations |
| vault | Signatures | absent | kein Signatur-Regeltyp; Protection 404 ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-vault/branches/main/protection)) | niedrig | P2 | Optional Commit-Signaturen | ui-foundations |
| vault | Bypass-Actor | configured-not-enforced | Ruleset Bypass `14805502` always; `current_user_can_bypass: always` ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-vault/rulesets?includes_parents=true)) | hoch | P0 | Bypass reduzieren/entfernen | ui-foundations |
| runtime | Required Reviews | configured-not-enforced | [Protection][runtime-protection]: `require_code_owner_reviews: true`, `required_approving_review_count: 0`; vollständiger rekursiver [Tree][runtime-tree] `truncated:false`, keine `CODEOWNERS`-Datei vorhanden | hoch | P0 | Count auf >=1 anheben; CODEOWNERS-Entscheidung treffen und Datei anlegen | ui-foundations |
| runtime | Required Checks | configured-not-enforced | [Protection][runtime-protection]: `required_status_checks.strict: true`, `contexts: []`, `checks: []`; CI-Job `build` existiert ([ci.yml][runtime-ci]), aber nicht als Context gebunden | hoch | P0 | CI-Context (z. B. `build`/`ci:check`) als Required Check benennen | ui-foundations |
| runtime | Direct Push / PR-Durchsetzung | UNVERIFIED | effektive Direct-Push-/PR-Durchsetzung nicht aus Konfiguration ableitbar (kein Mutationstest); bekannt: Ruleset-`update`-Regel beschränkt `main`-Updates auf Bypass-Actor ([Ruleset][runtime-ruleset]) | hoch | P0 | PR-Pflicht faktisch binden; effektives Verhalten verifizieren | ui-foundations |
| runtime | Force Push / Non-FF | enforced | [Protection][runtime-protection]: `allow_force_pushes.enabled: false` (klassisch, unabhängig vom Ruleset-Bypass) plus Ruleset `non_fast_forward`; in inspizierter Konfiguration durchgesetzt (statisch, nicht dynamisch getestet) | niedrig | P2 | beibehalten | ui-foundations |
| runtime | Deletion | enforced | [Protection][runtime-protection]: `allow_deletions.enabled: false` (klassisch, unabhängig vom Ruleset-Bypass) plus Ruleset `deletion`; in inspizierter Konfiguration durchgesetzt (statisch, nicht dynamisch getestet) | niedrig | P2 | beibehalten | ui-foundations |
| runtime | Signatures | absent | `required_signatures.enabled: false` ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-runtime/branches/main/protection)) | niedrig | P2 | optional | ui-foundations |
| runtime | Admin-Enforcement / Bypass | enforced | [Protection][runtime-protection]: `enforce_admins.enabled: true` (klassisch, unabhängig, in inspizierter Konfiguration durchgesetzt); Ruleset-Bypass `14805502` always umgeht nur Ruleset-Integrität, nicht `enforce_admins` ([Ruleset][runtime-ruleset]) | mittel | P0 | Ruleset-Bypass konsistent zu enforce_admins reduzieren | ui-foundations |
| runtime | Stale Approval Dismissal | configured-not-enforced | `dismiss_stale_reviews: false` ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-runtime/branches/main/protection)) | mittel | P1 | aktivieren, sobald Approvals >=1 | ui-foundations |
| studio | Reviews/Checks/Push/Force/Deletion/Signatures/Bypass/Stale | UNVERIFIED | Protection + Rulesets 403 ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-studio/branches/main/protection)) | mittel | P0 | Einsehbarkeit oder alternative Evidenz | ui-foundations |
| intelligence | Reviews/Checks/Push/Force/Deletion/Signatures/Bypass/Stale | UNVERIFIED | 403 ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-intelligence/branches/main/protection)) | mittel | P0 | dito | ui-foundations |
| connectors | Reviews/Checks/Push/Force/Deletion/Signatures/Bypass/Stale | UNVERIFIED | 403 ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-connectors/branches/main/protection)) | mittel | P0 | dito | ui-foundations |

### Secret Scanning / Dependabot / Code Scanning (benannte GitHub-Features; keine Merge-Durchsetzung)

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner |
|---|---|---|---|---|---|---|---|
| vault | Secret Scanning | absent | `security_and_analysis.secret_scanning: disabled`; `GET /repos/tbielich/ui-foundations-vault/secret-scanning/alerts` -> 404 "Secret scanning is disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-vault/secret-scanning/alerts)) | mittel | P0 | aktivieren inkl. Push Protection | ui-foundations |
| vault | Dependabot Alerts | absent | `GET /repos/tbielich/ui-foundations-vault/dependabot/alerts` -> 403 "Dependabot alerts are disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-vault/dependabot/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| vault | Code Scanning | UNVERIFIED | `GET /repos/tbielich/ui-foundations-vault/code-scanning/alerts` -> 404 "no analysis found" (keine Analyse zurückgegeben; kein Beleg für aktiviert/deaktiviert) ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-vault/code-scanning/alerts)) | niedrig | P1 | Status klären; optional CodeQL | ui-foundations |
| runtime | Secret Scanning | configured-not-enforced | `secret_scanning: enabled`, `secret_scanning_push_protection: enabled`; `secret-scanning/alerts` 0 (redacted). Aktive Funktion, aber keine Merge-Durchsetzung ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-runtime/secret-scanning/alerts)) | niedrig | P1 | beibehalten | ui-foundations |
| runtime | Dependabot Alerts | absent | `GET /repos/tbielich/ui-foundations-runtime/dependabot/alerts` -> 403 "Dependabot alerts are disabled"; `dependabot_security_updates: disabled` (Security-Updates, nicht Alerts) ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-runtime/dependabot/alerts)) | mittel | P1 | Alerts aktivieren | ui-foundations |
| runtime | Code Scanning | UNVERIFIED | `GET /repos/tbielich/ui-foundations-runtime/code-scanning/alerts` -> 404 "no analysis found" (keine Analyse zurückgegeben) ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-runtime/code-scanning/alerts)) | niedrig | P1 | Status klären; optional CodeQL | ui-foundations |
| studio | Secret Scanning | absent | `security_and_analysis: null`; `GET /repos/tbielich/ui-foundations-studio/secret-scanning/alerts` -> 404 "disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-studio/secret-scanning/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| studio | Dependabot Alerts | absent | `GET /repos/tbielich/ui-foundations-studio/dependabot/alerts` -> 403 "disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-studio/dependabot/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| studio | Code Scanning | absent | `GET /repos/tbielich/ui-foundations-studio/code-scanning/alerts` -> 403 "Code scanning is not enabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-studio/code-scanning/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| intelligence | Secret Scanning | absent | `security_and_analysis: null`; `GET /repos/tbielich/ui-foundations-intelligence/secret-scanning/alerts` -> 404 "disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-intelligence/secret-scanning/alerts)) | hoch | P0 | Secret Scanning aktivieren (Repo rotiert Publikations-Token) | ui-foundations |
| intelligence | Dependabot Alerts | absent | `GET /repos/tbielich/ui-foundations-intelligence/dependabot/alerts` -> 403 "disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-intelligence/dependabot/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| intelligence | Code Scanning | absent | `GET /repos/tbielich/ui-foundations-intelligence/code-scanning/alerts` -> 403 "Code scanning is not enabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-intelligence/code-scanning/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| connectors | Secret Scanning | absent | `security_and_analysis: null`; `GET /repos/tbielich/ui-foundations-connectors/secret-scanning/alerts` -> 404 "disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-connectors/secret-scanning/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| connectors | Dependabot Alerts | absent | `GET /repos/tbielich/ui-foundations-connectors/dependabot/alerts` -> 403 "disabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-connectors/dependabot/alerts)) | mittel | P1 | aktivieren | ui-foundations |
| connectors | Code Scanning | absent | `GET /repos/tbielich/ui-foundations-connectors/code-scanning/alerts` -> 403 "Code scanning is not enabled" ([Quelle](https://api.github.com/repos/tbielich/ui-foundations-connectors/code-scanning/alerts)) | mittel | P1 | aktivieren | ui-foundations |

### Code-Health-Checks: Lint / Typecheck / Tests / A11y / Naming / Knip / jscpd — Merge-Durchsetzung

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner |
|---|---|---|---|---|---|---|---|
| vault | Repo-Basics / Projektions-Check | configured-not-enforced | [ci.yml][vault-ci] job `validate`: Schritte "Validate vault repository basics", "Validate project projections" (`ruby scripts/generate-project-projections.rb --check`). Check `validate` success ([validate run][vault-validate-run]); kein Required Context | mittel | P1 | als Required Check binden | ui-foundations |
| vault | Governance-Pack-Validierung | configured-not-enforced | [ci.yml][vault-ci] Schritt `ruby schemas/validate-governance-packs.rb` | mittel | P1 | als Required Check binden | ui-foundations |
| vault | Vault-Audit-Selbsttests | configured-not-enforced | [ci.yml][vault-ci] Schritt `ruby schemas/validate-vault-audits.rb --self-test-contract` + `--self-test-frontmatter`. Dies sind **Selbsttests** der Audit-Logik, kein vollständiges Repo-weites Frontmatter-/Link-/Taxonomie-Audit-Gate | mittel | P1 | Scope klarstellen; ggf. Full-Repo-Audit als Gate ergänzen | ui-foundations |
| vault | Figma-Export-Tests | configured-not-enforced | [ci.yml][vault-ci] Schritt `ruby scripts/test-figma-export.rb` (deterministische Stdlib-Tests) | niedrig | P2 | beibehalten | ui-foundations |
| vault | Naming (Full-Doc-Durchsetzung) | UNVERIFIED | [ci.yml][vault-ci] enthält keinen repo-weiten Dateinamens-/Naming-Durchsetzungsschritt; ob Naming über das gesamte Dokumentenset erzwungen wird, ist nicht belegt | niedrig | P2 | repo-weites Naming-Gate klären/ergänzen | ui-foundations |
| vault | Governance-Pack-Validierung (Naming-nah) | configured-not-enforced | [ci.yml][vault-ci] Schritt `ruby schemas/validate-governance-packs.rb`; validiert Governance-Pack-Struktur, kein Required Merge-Context | mittel | P1 | als Required Check binden | ui-foundations |
| vault | Lint / Typecheck / A11y / Knip / jscpd | not applicable | [ci.yml][vault-ci] enthält keine JS/TS-Schritte; Knip und jscpd sind JS/TS-basiert und greifen auf einem Markdown-/Ruby-Vault nicht | niedrig | P2 | nicht anwendbar, solange kein JS/TS-Code vorliegt | ui-foundations |
| runtime | Lint | configured-not-enforced | [package.json][runtime-pkg] `lint` -> `scripts/lint-js.mjs`; Teil von `ci:check` (via [ci.yml][runtime-ci] `npm run ci:check`); kein Required Context | mittel | P1 | als Required Check binden | ui-foundations |
| runtime | Tests (unit) | configured-not-enforced | [package.json][runtime-pkg] `test:unit` -> `node --test tests/*.test.mjs`; in `ci:check`; Check `build (20)`/`build (22)` success ([ci.yml][runtime-ci] Matrix `[20, 22]`, `fail-fast: false`), aber kein Required Context | mittel | P1 | als Required Check binden | ui-foundations |
| runtime | Tests (browser/a11y) | configured-not-enforced | `test:browser:only` (Playwright) in `ci:check` ([package.json][runtime-pkg], [ci.yml][runtime-ci] `npx playwright install --with-deps chromium`); zugelassen durch Vault-ADR [bounded-browser-verification][vault-adr-browser]. Vollständige WCAG-Konformität ist über CI allein nicht belegbar | mittel | P1 | a11y-Teil explizit als Gate | ui-foundations |
| runtime | Naming-Check | configured-not-enforced | [package.json][runtime-pkg] `naming:check` -> `scripts/check-vault-naming-contract.mjs` in `ci:check`; Test `tests/vault-naming-contract.test.mjs` | mittel | P1 | als Required Check binden | ui-foundations |
| runtime | Typecheck (Root) | not applicable | Root-[package.json][runtime-pkg] hat kein TS-Typecheck-Script (JS-Projekt am Root) | niedrig | P2 | am Root nicht anwendbar | ui-foundations |
| runtime | Typecheck (MCP-Subpaket) | configured-not-enforced | [mcp package.json][runtime-mcp-pkg] `build: tsc` liefert TS-Typecheck für das MCP-Subpaket; über `release-evidence.mjs` `mcp-build` ausgeführt, aber kein Required Merge-Context | mittel | P1 | MCP-`tsc` an Gate binden | ui-foundations |
| runtime | Knip (JS/TS) | UNVERIFIED | Knip ist JS/TS-basiert und auf Runtime grundsätzlich anwendbar; kein Knip in `ci:check` ([ci.yml][runtime-ci]) oder `release-evidence.mjs`; keine Knip-Config im vollständigen [Tree][runtime-tree] gefunden | mittel | P1 | Knip-Config als Projektentscheidung klären, dann Gate | ui-foundations |
| runtime | jscpd (JS/TS) | UNVERIFIED | jscpd ist JS/TS-basiert und auf Runtime grundsätzlich anwendbar; kein jscpd in Command-Sets; keine jscpd-Config im vollständigen [Tree][runtime-tree] | niedrig | P1 | jscpd-Config als Projektentscheidung klären | ui-foundations |
| studio | Lint/Tests/Typecheck/Naming/A11y/Knip/jscpd | UNVERIFIED | Aktueller `main`-[Tree][studio-tree] ohne `.github/workflows`; historische Runs mit Job `test` (Schritte "Compile Python", "Test read-only benchmark projection", jüngste Failures); kein aktuelles Workflow-Source | mittel | P1 | aktuelles Workflow-Source prüfen | ui-foundations |
| intelligence | Tests (pytest) | configured-not-enforced | [ci.yml][intel-ci] `on: pull_request` + `push` (main) + `workflow_dispatch` (manuell), job `test` -> `python -m pytest -q`; Check `test` success auf `d14ee2f3`. Hosted PR-Check vorhanden, aber ohne belegtes Required-Merge-Gate (Protection UNVERIFIED) | mittel | P1 | als Required Check binden, sobald Protection einsehbar | ui-foundations |
| intelligence | Lint (hosted, separat von pytest) | absent | [ci.yml][intel-ci] führt nur `pytest` aus; es gibt keinen von `pytest` getrennten hosted Lint-Schritt | mittel | P1 | bei Bedarf hosted Lint-Schritt ergänzen | ui-foundations |
| intelligence | Typecheck/Naming/A11y/Knip/jscpd (hosted) | not applicable | Python-Repo; Knip/jscpd sind JS/TS-basiert und greifen nicht; keine entsprechenden hosted Schritte in [ci.yml][intel-ci] | niedrig | P2 | nicht anwendbar | ui-foundations |
| intelligence | Lokale Hooks (Pre-Stop) | configured-not-enforced | `.kiro/hooks` plus `scripts/verify-before-stop.sh` führen `git diff --check HEAD`, `pytest` und Metadaten-Validierung aus; nur lokal, kein Merge-Gate ([Quelle](https://github.com/tbielich/ui-foundations-intelligence/blob/d14ee2f382c4e295cdfda7571963ac08b80c3452/scripts/verify-before-stop.sh)) | niedrig | P2 | Zweck dokumentieren; nicht als Durchsetzung werten | ui-foundations |
| connectors | Tests | configured-not-enforced | Tests im [Tree][conn-tree] (`tests/test_imap.py`, `tests/test_imap_review.py`, `tests/test_synthetic.py`), aber 0 Workflows / 0 Runs / 0 Checks: vorhandene Tests ohne hosted CI | hoch | P1 | CI etablieren, Tests ausführen | ui-foundations |
| connectors | Lint/Typecheck/Naming/A11y/Knip/jscpd | absent | 0 Workflows, 0 Runs, 0 Checks im [Tree][conn-tree] | hoch | P1 | CI-Pfad etablieren | ui-foundations |

### MCP / Provenance / Evidence / Release-Validierungen — Merge-Durchsetzung

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner |
|---|---|---|---|---|---|---|---|
| runtime | Release-Evidence | configured-not-enforced | [release-readiness.yml][runtime-release] `on: workflow_dispatch`, `permissions: contents: read`; `scripts/release-evidence.mjs` fixe Command-Liste; beobachteter Job [release-readiness run 40923892921][runtime-release-run] (alle Schritte inkl. finalem Gate success). Kein Required Check auf `main`. Job-lokal fail-closed (siehe unten) | mittel | P1 | Als bindendes Release-Gate definieren (menschliche Freigabe) | ui-foundations |
| runtime | Release-Evidence Fail-closed (job-lokal) | configured-not-enforced | `release-evidence.mjs`: PASS nur bei allen Exit 0 + Tarball+SHA-256 + aufgelöster Source-SHA + sauberer, unveränderter Source; fixe Command-Liste ohne Env-Override. Workflow-Schritt "Collect" `continue-on-error: true`, danach "Gate on honest evidence status" `exit 1` bei !=PASS. Dies ist job-lokales Fail-closed, kein Merge-Gate ([release-readiness.yml][runtime-release]) | niedrig | P1 | Verhalten beibehalten; an Merge/Release binden | ui-foundations |
| runtime | Artifact-Evidence | configured-not-enforced | Upload `release-readiness-evidence-<sha>`, `if-no-files-found: error`, `if: always()`; job-lokal, kein Required Merge-Context ([release-readiness.yml][runtime-release]) | niedrig | P1 | beibehalten | ui-foundations |
| runtime | MCP-Build/Test | configured-not-enforced | `release-evidence.mjs` ruft `packages/mcp-server` `build` (`tsc`) + `test:mcp` ([mcp package.json][runtime-mcp-pkg]); `.kiro/settings/mcp.json` im [Tree][runtime-tree]; kein Required Merge-Context | mittel | P1 | MCP-Checks an Release-Gate binden | ui-foundations |
| runtime | Provenance / Metadaten (hosted) | UNVERIFIED | kein eigenständiger hosted Provenance-/Metadaten-Check getrennt von Release-Evidence in [ci.yml][runtime-ci]/[release-readiness.yml][runtime-release] belegt | niedrig | P2 | Bedarf klären | ui-foundations |
| intelligence | Provenance / Metadaten (hosted) | UNVERIFIED | [ci.yml][intel-ci] führt `pytest` aus; Unit-/Contract-Tests der Metadatenlogik belegen keine Live-Validierung der Metadaten dieses PR. Ein eigenständiger hosted Live-PR-Metadaten-Gate ist in dieser CI nicht konfiguriert; effektive Merge-Durchsetzung bleibt wegen Protection-403 UNVERIFIED | mittel | P1 | Live-Gate und Testabdeckung getrennt nachweisen | ui-foundations | configured-not-enforced | Hosted Metadaten-/Provenance-Prüfung läuft als Teil des `test`-Jobs ([ci.yml][intel-ci]); kein Required Merge-Gate (Protection UNVERIFIED) | mittel | P1 | als Required Check binden, sobald Protection einsehbar | ui-foundations |
| intelligence | Provenance / Metadaten (lokal) | configured-not-enforced | Lokale Metadaten-Validierung über `scripts/verify-before-stop.sh` plus `.kiro/hooks`; nur lokal, kein Merge-Gate — distinkt von der hosted Prüfung ([Quelle](https://github.com/tbielich/ui-foundations-intelligence/blob/d14ee2f382c4e295cdfda7571963ac08b80c3452/scripts/verify-before-stop.sh)) | niedrig | P2 | als lokal kennzeichnen; nicht als Durchsetzung werten | ui-foundations |
| intelligence | MCP | not applicable | kein MCP-Subpaket im Intelligence-Repo beobachtet; MCP-Oberfläche für dieses Repo nicht einschlägig ([Quelle](https://github.com/tbielich/ui-foundations-intelligence/tree/d14ee2f382c4e295cdfda7571963ac08b80c3452)) | niedrig | P2 | n/a, solange kein MCP-Paket vorliegt | ui-foundations |
| intelligence | Artifact-/Release-Evidence | configured-not-enforced | [cloud-pipeline.yml](https://github.com/tbielich/ui-foundations-intelligence/blob/d14ee2f382c4e295cdfda7571963ac08b80c3452/.github/workflows/cloud-pipeline.yml) konfiguriert Workflow-Evidenz und `actions/upload-artifact`; dies ist getrennt vom `test`-Job. Konfiguration belegt keinen historischen erfolgreichen Artifact-Inhalt und kein Required-Merge-Gate | niedrig | P2 | revisionsgebundene Artefakt-Inhalte bei konkreter Veröffentlichung separat prüfen | ui-foundations | UNVERIFIED | kein dedizierter Release-Evidence-/Artifact-Upload-Pfad getrennt vom `test`-Job in [ci.yml][intel-ci] belegt | niedrig | P2 | Bedarf klären | ui-foundations |
| intelligence | Token-Rotation | configured-not-enforced | [rotate-publication-token.yml][intel-rotate] `on: schedule(cron 23 */4 * * *) + workflow_dispatch`, `permissions: contents: read`, **kein** `pull_request`-Trigger; Checks `rotate` success. Geplanter/manueller Job, kein Merge-Gate | niedrig | P1 | beibehalten; Rotation dokumentieren | ui-foundations |
| intelligence | Repo-Sanity (zentral) | configured-not-enforced | [repo-sanity.yml][intel-sanity] `on: schedule + workflow_dispatch`, ruft `repo-sanity-reusable.yml`; `repos: ["tbielich/ui-foundations-intelligence","tbielich/ui-foundations-runtime"]` — nur diese **zwei** Repos, nicht alle fünf. Checks `sanity / inspect` success, `sanity / persist` skipped | niedrig | P2 | Scope dokumentieren; kein Merge-Gate | ui-foundations |
| vault | MCP/Provenance/Artifact/Release | configured-not-enforced | [publish.yml][vault-publish] `on: workflow_dispatch`, Job `not-applicable` (Vault ist kein npm-Paket); kein MCP-Subpaket, kein Release-Evidence-Pfad, kein Merge-Gate | niedrig | P1 | Zweck dokumentieren | ui-foundations |
| studio | MCP/Provenance/Artifact/Release | UNVERIFIED | Aktueller `main`-[Tree][studio-tree] ohne `.github/workflows`; kein Release-/Provenance-/MCP-Beleg | mittel | P1 | aktuelles Workflow-Source prüfen | ui-foundations |
| connectors | MCP/Provenance/Artifact/Release | absent | 0 Workflows ([Tree][conn-tree]); Spec-Ordner `.kiro/specs/strato-readonly-research` vorhanden, aber kein hosted Evidence-/MCP-/Provenance-Pfad | mittel | P1 | Evidence-/CI-Pfad etablieren | ui-foundations |

### Hooks / Trigger / Path-Filter / Concurrency — Merge-Durchsetzung

| Repo | Kontrolle | Status | Evidenz | Risiko | Prio | Empfehlung | Vorgeschl. Owner |
|---|---|---|---|---|---|---|---|
| runtime | Git-Hooks (pre-commit) | configured-not-enforced | `.githooks/pre-commit` am gepinnten SHA unabhängig nachgeladen (`.audit-review/runtime-pre-commit.txt`): `set -e`, `npm run lint` dann `npm run test:unit` je `|| exit 1`. Lokaler, umgehbarer Hook (configured-not-enforced), serverseitig nicht erzwungen | mittel | P1 | als lokal kennzeichnen; echtes Gate serverseitig binden | ui-foundations |
| runtime | Kiro-Hooks | configured-not-enforced | `.kiro/hooks/*.json` im [Tree][runtime-tree] (post-task-validate, readme-release-update u. a.); kein Merge-Gate | niedrig | P2 | Zweck dokumentieren | ui-foundations |
| runtime | CI Trigger / Path-Filter | configured-not-enforced | [ci.yml][runtime-ci] `on: push` und `pull_request` **ohne** Branch-/Path-Filter; Required-Context-Lücke bleibt (kein gebundener Context) | niedrig | P2 | zuerst Required-Context schließen | ui-foundations |
| runtime | Concurrency | configured-not-enforced | [release-readiness.yml][runtime-release] `concurrency` mit `cancel-in-progress: false`; kein Merge-Gate | niedrig | P2 | ok | ui-foundations |
| intelligence | CI Trigger / Path-Filter | configured-not-enforced | [ci.yml][intel-ci] `on: pull_request` + `push` (main) + `workflow_dispatch`; Bindung als Required-Context UNVERIFIED (Protection-403) | niedrig | P2 | Required-Context binden | ui-foundations |
| intelligence | Concurrency (Rotation) | configured-not-enforced | [rotate-publication-token.yml][intel-rotate] teilt Concurrency-Gruppe `cloud-pipeline-tbielich/ui-foundations-runtime-306`, `cancel-in-progress: false` (serialisiert gegen Publikation) | niedrig | P2 | dokumentieren | ui-foundations |
| vault | CI Trigger / Path-Filter | configured-not-enforced | [ci.yml][vault-ci] `on: push` und `pull_request` **ohne** Branch-/Path-Filter; kein gebundener Required-Context | niedrig | P2 | Required-Context binden | ui-foundations |
| vault | Git-/Kiro-Hooks / Concurrency | not applicable | kein lokaler Git-Hook-Pfad und keine relevante Concurrency-Oberfläche im [Tree][vault-tree] beobachtet | niedrig | P2 | n/a | ui-foundations |
| studio | Hooks / Trigger / Path / Concurrency | UNVERIFIED | aktueller `main`-[Tree][studio-tree] ohne `.github/workflows`; Trigger/Hooks/Concurrency nicht einsehbar | mittel | P1 | aktuelles Workflow-Source prüfen | ui-foundations |
| connectors | Hooks / Trigger / Path / Concurrency | absent | 0 Workflows im [Tree][conn-tree]; keine CI-Trigger-, Hook- oder Concurrency-Oberfläche | mittel | P1 | CI-Pfad etablieren | ui-foundations |

## Offene Evidenzanfragen (präzise)

1. `ui-foundations-runtime` (Entscheidung, keine Evidenzlücke): `require_code_owner_reviews: true` ist konfiguriert, der vollständige rekursive API-Tree (`data.truncated: false`) enthält jedoch keine `CODEOWNERS`-Datei. Offen ist eine künftige CODEOWNERS-Entscheidung — ob und mit welcher Zuordnung eine `CODEOWNERS`-Datei angelegt wird. Der `ci.yml`-Inhalt (Trigger ohne Filter, Matrix) und der `.githooks/pre-commit`-Inhalt sind bereits unabhängig geprüft und nicht mehr offen.
2. `ui-foundations-runtime`: Knip/jscpd sind JS/TS-basiert und grundsätzlich anwendbar; im vollständigen Tree wurde keine Konfiguration gefunden. Offen ist die Projektentscheidung, ob diese Werkzeuge vorgesehen sind.
3. `ui-foundations-studio`: aktuelles `.github/workflows`-Source auf `main` (Head-Tree enthält keines) bzw. Klärung, ob `studio-checks.yml` auf dem aktuellen Head noch registriert ist.
4. `studio`, `intelligence`, `connectors`: Nachweis effektiver Merge-Durchsetzung trotz 403-Pro-Feature — z. B. Screenshots der Branch-Settings oder ein berechtigter Ruleset-Export.
5. Bestätigung der Eigentümerschaft je Kontrolle; alle Owner-Vorschläge sind unbestätigt (`ui-foundations` als Default-Steward).

## Methodische Hinweise

- Alle SHAs und Endpoints stammen aus `.audit-input/*/compact.json`; die vollständigen rekursiven Trees (`data.truncated: false`) aus `.audit-input/*/supplement.json`; der Runtime-Hook aus `.audit-review/runtime-pre-commit.txt`. Aufnahmezeitpunkt `2026-11-02T06:33:31Z` aus `manifest.json` (`captured_utc`).
- `403`/`404` wurden nach Semantik getrennt: explizit ungeschützt/deaktiviert vs. unzugänglich (403 Pro-Feature) vs. keine Analyse zurückgegeben (`no analysis found`).
- Das Enforcement-Urteil bezieht sich durchgehend auf den Merge. Job-lokal erfolgreiche, geplante oder dispatch-ausgelöste Prüfungen sind `configured-not-enforced`, solange kein Required-Merge-Gate belegt ist.
- Diese Analyse behauptet keine eigene Verifikation über den Snapshot hinaus und wurde nicht durch einen Push getestet. Die unabhängige Codex-Verifikation wird gesondert ergänzt.

## Evidenz-Links (Reference-Definitionen)

Blob- und Tree-Links sind an den eingefrorenen Head-SHAs der Identitätstabelle gepinnt. API-Endpoint-Links verweisen auf vollständige Repo-Pfade (keine `...`-Platzhalter).

<!-- Vault @ a0c58d1f97c1b08621d6d1103a7f734c5c89a70f -->
[vault-tree]: https://github.com/tbielich/ui-foundations-vault/tree/a0c58d1f97c1b08621d6d1103a7f734c5c89a70f
[vault-ci]: https://github.com/tbielich/ui-foundations-vault/blob/a0c58d1f97c1b08621d6d1103a7f734c5c89a70f/.github/workflows/ci.yml
[vault-publish]: https://github.com/tbielich/ui-foundations-vault/blob/a0c58d1f97c1b08621d6d1103a7f734c5c89a70f/.github/workflows/publish.yml
[vault-protection]: https://api.github.com/repos/tbielich/ui-foundations-vault/branches/main/protection
[vault-ruleset]: https://api.github.com/repos/tbielich/ui-foundations-vault/rulesets/24978374
[vault-validate-run]: https://github.com/tbielich/ui-foundations-vault/actions/runs/41309298153/job/124856127526
[vault-adr-browser]: https://github.com/tbielich/ui-foundations-vault/blob/a0c58d1f97c1b08621d6d1103a7f734c5c89a70f/decisions/bounded-browser-verification.md

<!-- Runtime @ aa153b79668df7c3b655a96d9541171de1899580 -->
[runtime-tree]: https://github.com/tbielich/ui-foundations-runtime/tree/aa153b79668df7c3b655a96d9541171de1899580
[runtime-ci]: https://github.com/tbielich/ui-foundations-runtime/blob/aa153b79668df7c3b655a96d9541171de1899580/.github/workflows/ci.yml
[runtime-release]: https://github.com/tbielich/ui-foundations-runtime/blob/aa153b79668df7c3b655a96d9541171de1899580/.github/workflows/release-readiness.yml
[runtime-pkg]: https://github.com/tbielich/ui-foundations-runtime/blob/aa153b79668df7c3b655a96d9541171de1899580/package.json
[runtime-mcp-pkg]: https://github.com/tbielich/ui-foundations-runtime/blob/aa153b79668df7c3b655a96d9541171de1899580/packages/mcp-server/package.json
[runtime-protection]: https://api.github.com/repos/tbielich/ui-foundations-runtime/branches/main/protection
[runtime-ruleset]: https://api.github.com/repos/tbielich/ui-foundations-runtime/rulesets/24978370
[runtime-release-run]: https://github.com/tbielich/ui-foundations-runtime/actions/runs/40923892921/job/123624145193

<!-- Studio @ 95cfb968db86645049565175517ee4446fe1178d (privat) -->
[studio-tree]: https://github.com/tbielich/ui-foundations-studio/tree/95cfb968db86645049565175517ee4446fe1178d
[studio-protection]: https://api.github.com/repos/tbielich/ui-foundations-studio/branches/main/protection
[studio-ruleset]: https://api.github.com/repos/tbielich/ui-foundations-studio/rulesets?includes_parents=true
[studio-rules]: https://api.github.com/repos/tbielich/ui-foundations-studio/rules/branches/main

<!-- Intelligence @ d14ee2f382c4e295cdfda7571963ac08b80c3452 (privat) -->
[intel-tree]: https://github.com/tbielich/ui-foundations-intelligence/tree/d14ee2f382c4e295cdfda7571963ac08b80c3452
[intel-ci]: https://github.com/tbielich/ui-foundations-intelligence/blob/d14ee2f382c4e295cdfda7571963ac08b80c3452/.github/workflows/ci.yml
[intel-rotate]: https://github.com/tbielich/ui-foundations-intelligence/blob/d14ee2f382c4e295cdfda7571963ac08b80c3452/.github/workflows/rotate-publication-token.yml
[intel-sanity]: https://github.com/tbielich/ui-foundations-intelligence/blob/d14ee2f382c4e295cdfda7571963ac08b80c3452/.github/workflows/repo-sanity.yml
[intel-protection]: https://api.github.com/repos/tbielich/ui-foundations-intelligence/branches/main/protection
[intel-ruleset]: https://api.github.com/repos/tbielich/ui-foundations-intelligence/rulesets?includes_parents=true

<!-- Connectors @ e06faf24f5dccfcd3e08c7beefffb4f6871247b5 (privat) -->
[conn-tree]: https://github.com/tbielich/ui-foundations-connectors/tree/e06faf24f5dccfcd3e08c7beefffb4f6871247b5
[conn-protection]: https://api.github.com/repos/tbielich/ui-foundations-connectors/branches/main/protection
[conn-ruleset]: https://api.github.com/repos/tbielich/ui-foundations-connectors/rulesets?includes_parents=true

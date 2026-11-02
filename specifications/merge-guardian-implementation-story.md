---
id: specification.merge-guardian-implementation-story
title: Merge Guardian Implementation Story
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-11-02
updated: 2026-11-02
authority: source
summary: Staged, evidence-driven implementation story (proposal) for a Merge Guardian that moves UIF repositories from audit-only to enforced merge controls under human approval gates. No CI, authority, or publishing changes are made here.
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
    - specification.vault-metadata
    - workflow.operational.release-review
  governed_by:
    - governance.precedence
verification:
  status: unverified
  method: Kiro proposal derived from publication.merge-guardian-baseline-2026-11-02 (itself pending Codex verification). Not executed, not enforced.
  pending:
    - Independent Codex verification of the baseline findings is a precondition for any enforcing stage.
assumptions:
  - Die Baseline-Befunde (publication.merge-guardian-baseline-2026-11-02) sind Kiro-Analyse und noch unabhängig von Codex zu verifizieren.
  - Diese Spezifikation besitzt keine Ausführungsautorität; sie beschreibt gewünschtes Verhalten, nicht Implementierung.
  - Eine benannte kanonische "Release Guardian"-Autorität wurde im Vault nicht gefunden (UNVERIFIED). Bestehende Quellen release-review und die Laufzeit-Release-Readiness sind davon verschieden und bleiben getrennt.
---

# Merge Guardian Implementation Story

Codex-Nachtrag: Die unabhängige [Prüfquittung](../publications/merge-guardian-verification-2026-11-02.md) ist beigefügt. Diese Story bleibt ein nicht genehmigter Implementierungsvorschlag.

## Zweck und Grenzen

Diese Spezifikation ist ein **Vorschlag**. Sie beschreibt, welches Verhalten ein "Merge Guardian" über die fünf UI-Foundations-Repositories herstellen soll und in welcher Reihenfolge. Sie ist eine Spezifikation im Sinne der Precedence (`governance.precedence`): normativ für erwartetes Verhalten, aber untergeordnet gegenüber Governance, Prinzipien und ADRs. Sie erteilt keine Ausführungsautorität.

Aus dieser Datei erfolgt **jetzt keine** Implementierung, keine CI-/Protection-/Ruleset-/Security-Mutation, kein Deployment, keine neue Autorität und keine Veröffentlichung. Jede Durchsetzung erfolgt außerhalb dieser Datei und ausschließlich nach menschlicher Freigabe gemäß `governance.execution-authority`.

Die Befunde, auf denen die Story beruht, sind in [`publication.merge-guardian-baseline-2026-11-02`](../publications/merge-guardian-baseline-2026-11-02.md) dokumentiert und stellen Kiro-Analyse dar, die noch der unabhängigen Codex-Verifikation bedarf.

## Zielzustand (verhaltensbasiert)

Ein Merge auf `main` eines UIF-Repositories soll nur dann möglich sein, wenn:

1. die Änderung agent-attributierbar und von der freigebenden menschlichen Identität unterscheidbar ist (`governance.execution-authority`);
2. mindestens ein benannter, tatsächlich ausgeführter Status-Check am Merge bestanden wurde;
3. mindestens eine unabhängige menschliche Freigabe für die geprüfte Revision vorliegt;
4. Branch-Integrität (kein Force-Push, kein Löschen, kein Non-Fast-Forward) ohne Umgehung durch Standardakteure gilt;
5. die Durchsetzung aus Protection- plus Ruleset- plus effektiven Regeln belegbar ist, nicht nur aus der Präsenz eines Workflows oder einem job-lokalen Fail-closed-Verhalten.

## Prinzipien der Einführung

- **Evidenz vor Durchsetzung.** Jede Stufe erzeugt zunächst Nachweise, bevor sie blockiert.
- **Fail-closed statt fail-open.** Fehlende oder nicht eindeutige Evidenz führt nicht zu einem grünen Status.
- **Menschliche Freigabe bleibt die Merge-Grenze.** Agenten produzieren, Menschen genehmigen; Ausführungserfolg ist keine Genehmigung.
- **Keine stille Governance-Änderung.** Owner, Rationale und Review-Status werden dokumentiert.

## Priorisierung

- **P0 — Sicherheit und Durchsetzbarkeit:** fehlende Merge-Gates, Rulesets ohne PR-/Check-Regeln mit Bypass-Actor, unzugängliche/abwesende Branch-Settings, fehlendes Secret Scanning dort, wo Tokens rotiert werden (`intelligence`).
- **P1 — Code-Gesundheit:** Required Checks für Lint/Tests/Naming/a11y/MCP-`tsc`, Release-Evidence als Gate, Knip/jscpd (erst nach Config-Klärung), CI für `connectors`.
- **P2 — optionale Ergonomie:** Commit-Signaturen, Path-Filter, Dokumentation von Hooks, Reusable-Workflow-Scope.

## Abhängigkeiten

1. Codex-Verifikation der Baseline ist Vorbedingung für jede durchsetzende Stufe.
2. Sichtbarkeit der privaten Repos (`studio`, `intelligence`, `connectors`: 403 Pro-Feature) oder alternative Durchsetzungsevidenz ist Vorbedingung für P0-Aussagen zu diesen Repos.
3. Für Required Checks muss zunächst ein stabiler, benannter Check-Context existieren (z. B. Runtime `build`/`ci:check`, Intelligence `test`), bevor er als Required markiert wird.
4. `require_code_owner_reviews` ist bei Runtime konfiguriert, greift aber erst mit einer `CODEOWNERS`-Datei. Der vollständige rekursive API-Tree (`data.truncated: false`) enthält aktuell keine `CODEOWNERS`-Datei; dies ist eine künftige CODEOWNERS-Entscheidung, keine Evidenzlücke.
5. Knip-/jscpd-Gates hängen von vorhandener, geprüfter Konfiguration ab (im Snapshot nicht nachgewiesen).

## Rollout-Stufen

### Stufe 0 — Audit-only (Baseline)

- **Verhalten:** nur Beobachtung und Reporting. Keine Blockierung. Entspricht dem aktuellen Zustand plus dem Baseline-Dokument.
- **Akzeptanztests (P0):**
  - Gap-Matrix für alle fünf Repos vorhanden ([`publication.merge-guardian-baseline-2026-11-02`](../publications/merge-guardian-baseline-2026-11-02.md)), Status-Spalte strikt eines von enforced/configured-not-enforced/absent/UNVERIFIED/not applicable.
  - Jede Evidenzlücke ist explizit als UNVERIFIED mit konkreter Evidenzanfrage markiert.
- **Akzeptanztests (P1):**
  - Owner-Vorschläge dokumentiert und als unbestätigt gekennzeichnet.
- **Freigabe-Gate:** Mensch bestätigt die Baseline **nach** unabhängiger Codex-Verifikation.

### Stufe 1 — Warn (nicht blockierend)

- **Verhalten:** Checks laufen auf PRs und melden Status, blockieren den Merge aber noch nicht. Fehlende Evidenz erzeugt eine sichtbare Warnung, keinen roten Required-Status.
- **Scope je Repo:**
  - runtime: benannter CI-Context (`build`/`ci:check`) als nicht-required Check sichtbar; Secret-Scanning-Status reporten.
  - intelligence: vorhandenen `test`-Check (pytest) als sichtbaren, noch nicht-required Context reporten.
  - vault: `validate`-Check reporten; Scope der Audit-Selbsttests vs. Full-Repo-Audit klarstellen.
  - connectors: minimale CI etablieren, die vorhandene `tests/test_*.py` ausführt und als Warnung meldet.
  - studio: aktuellen Workflow-Status klären (Head-Tree ohne `.github/workflows`) und Durchsetzungslücke als Warnung ausweisen.
- **Akzeptanztests (P0):**
  - Für jedes Repo existiert mindestens ein benannter Check-Context, der auf PRs läuft (oder die Lücke ist explizit als Warnung ausgewiesen).
- **Akzeptanztests (P1):**
  - Release-Evidence (runtime) bleibt job-lokal fail-closed, aber nicht Merge-blockierend.
  - Warnungen sind in der PR-Oberfläche sichtbar und reproduzierbar.
- **Freigabe-Gate:** Mensch genehmigt den Übergang zu Stufe 2 pro Repo.

### Stufe 2 — Blocking (durchgesetzt)

- **Verhalten:** benannte Required Checks und mindestens eine menschliche Approval sind Merge-Voraussetzung. Branch-Integritätsregeln gelten ohne Standard-Bypass. Nicht-Bypass-Akteure können `main` nur per genehmigtem PR aktualisieren.
- **Scope je Repo (P0-Reihenfolge):**
  - runtime: `required_approving_review_count >= 1`, `dismiss_stale_reviews: true`, benannter Required Check (z. B. `build`/`ci:check`), CODEOWNERS-Entscheidung treffen und Datei anlegen (derzeit keine `CODEOWNERS` im vollständigen Tree), Ruleset-Bypass konsistent zu `enforce_admins` reduzieren.
  - vault: durchsetzbares PR-/Check-Gate über Ruleset oder Protection; Secret Scanning plus Push Protection aktivieren.
  - intelligence: Secret Scanning aktivieren (Repo rotiert Publikations-Token); `test` als Required Check binden; Durchsetzung belegbar machen.
  - studio/connectors: nach hergestellter Sichtbarkeit analoge Gates.
- **Akzeptanztests (P0):**
  - Durchsetzung ist aus Protection- plus Ruleset- plus effektiven Regeln belegbar, nicht nur aus Workflow-Präsenz oder job-lokalem Fail-closed.
  - Kein Standardakteur kann Required Checks oder Approval ohne protokollierten, zeitlich begrenzten Ausnahmepfad umgehen.
- **Akzeptanztests (P1):**
  - Release-Evidence (runtime) ist als Release-Gate gebunden und bleibt fail-closed; der MCP-`tsc`-Build ist Teil des Gate-Command-Satzes.
- **Freigabe-Gate:** Mensch genehmigt die Aktivierung pro Repo; Material-Änderungen nach Freigabe erfordern erneute Freigabe.

## Human Approval Gates

Jeder Stufenübergang und jede durchsetzende Änderung erfordert eine unabhängig attributierbare menschliche Freigabe für die geprüfte Revision. Agenten dürfen vorbereiten und Nachweise erzeugen, aber nicht ihre eigene Produktion genehmigen (`governance.execution-authority`). Die Freigabe bindet an die konkrete Revision; nachträgliche Material-Änderungen setzen die Freigabe zurück.

## False Positives und Ausnahmen

- Ausnahmen (Exemptions) sind nur mit **Owner**, **Begründung** und **Ablaufdatum** (Expiry) zulässig.
- Eine Ausnahme ohne Expiry ist unzulässig; der Default-Expiry ist kurz (Empfehlung: 30 Tage), danach fällt das Gate automatisch auf durchgesetzt zurück.
- False Positives werden als Nachweis dokumentiert (betroffener Check, Revision, Grund) und fließen in die Justierung des jeweiligen Checks, nicht in eine pauschale Abschaltung.
- Ausnahmen werden protokolliert und sind reviewbar; sie dürfen keine stille Governance-Änderung bewirken.

## Baseline-Policy

- Die Baseline ist der in [`publication.merge-guardian-baseline-2026-11-02`](../publications/merge-guardian-baseline-2026-11-02.md) dokumentierte Zustand zum Aufnahmezeitpunkt `2026-11-02T06:33:31Z` (`captured_utc` des Snapshot-Manifests).
- Jede Stufe wird gegen diese Baseline gemessen; Abweichungen werden als Fortschritt oder Regression ausgewiesen.
- UNVERIFIED-Einträge bleiben UNVERIFIED, bis zusätzliche Evidenz vorliegt; sie werden nicht als "bestanden" interpretiert.

## Rollback

- Jede durchsetzende Änderung ist umkehrbar: der vorherige Protection-/Ruleset-Zustand wird vor Aktivierung als Nachweis festgehalten.
- Bei nachgewiesener, breiter Blockade legitimer Arbeit kann eine Stufe pro Repo auf "Warn" zurückgestuft werden; dies erfordert dieselbe menschliche Freigabe wie die Aktivierung und wird protokolliert.
- Rollback ist eine letzte Maßnahme und ersetzt nicht die Justierung einzelner Checks über den Exemption-Pfad.

## Ausrichtung an kanonischen Quellen

- **"Release Guardian" (benannte Autorität):** Im Vault wurde keine kanonische Quelle mit diesem Namen gefunden; der Bezug ist UNVERIFIED. Diese Story erfindet dafür keinen ADR-Dateinamen und keine neue Autorität.
- **Release-Review (Vault):** [`workflow.operational.release-review`](../operational/release-review.md) beschreibt Release-Review-Schritte (Lifecycle, Relationship-Resolution, Verifikation). Der Merge Guardian kann dessen Quality Gates an durchgesetzte Checks binden, erfindet aber keine neuen Links. Diese Quelle ist von der Laufzeit-Release-Readiness verschieden.
- **Release-Readiness (Laufzeit):** `release-readiness.yml` und `scripts/release-evidence.mjs` sind der belegte, job-lokal fail-closed Evidence-Pfad (`permissions: contents: read`, fixe Command-Liste, PASS nur bei allen Exit 0 und sauberer, unveränderter Source). Dies ist ein manuell dispatchter Dry-Run, kein Merge-Gate; der Merge Guardian referenziert das Fail-closed-Verhalten als Vorbild.
- **Naming:** Runtime `naming:check` -> `check-vault-naming-contract.mjs` und `tests/vault-naming-contract.test.mjs` sind die belegte Naming-Prüfung; als Required Check zu binden.
- **Accessibility:** a11y wird über den Browser-Testpfad (`test:browser:only`, Playwright) abgedeckt, zugelassen durch den Vault-ADR [`decisions/bounded-browser-verification.md`](../decisions/bounded-browser-verification.md). Vollständige WCAG-Konformität erfordert manuelle Prüfung mit assistiven Technologien und Expertenreview und ist über CI allein nicht belegbar.
- **MCP:** `release-evidence.mjs` ruft den `packages/mcp-server`-Build (`tsc`, zugleich TS-Typecheck des Subpakets) und `test:mcp`; `.kiro/settings/mcp.json` ist im Runtime-Tree. MCP-Checks werden an das Release-Gate gebunden, nicht als separate Autorität behandelt.
- **Provenienz/Ausführung:** `governance.execution-authority` und `specification.agent-execution-contract` bestimmen Attribution, Rollentrennung und revisionsgebundene Freigabe.

## Akzeptanzkriterien (gesamt)

1. Jede der drei Stufen hat explizite, prüfbare Akzeptanztests (nach P0/P1/P2 geordnet) und ein menschliches Freigabe-Gate.
2. Durchsetzungsaussagen sind aus Protection + Ruleset + effektiven Regeln belegbar; Workflow-Präsenz oder job-lokales Fail-closed allein genügt nicht.
3. Alle Ausnahmen tragen Owner, Begründung und Expiry; Baseline- und Rollback-Pfad sind je Repo dokumentiert und umkehrbar.
4. Kanonische Bezüge bleiben getrennt: "Release Guardian" UNVERIFIED, release-review und Laufzeit-Release-Readiness distinkt; kein erfundener ADR-Name.
5. Keine Implementierung, kein Deployment, keine neue Autorität, keine Protection-/Ruleset-/Security-Mutation und keine Veröffentlichung erfolgt aus dieser Spezifikation heraus.

## Offene Punkte (an Codex/Mensch)

- Unabhängige Codex-Verifikation der Baseline-Befunde vor jeder durchsetzenden Stufe.
- Herstellung der Sichtbarkeit für `studio`, `intelligence`, `connectors` (403 Pro-Feature) oder alternative Durchsetzungsevidenz.
- Künftige CODEOWNERS-Entscheidung für Runtime: `require_code_owner_reviews` ist konfiguriert, der vollständige rekursive Tree enthält jedoch keine `CODEOWNERS`-Datei. Offen ist, ob und mit welcher Zuordnung eine Datei angelegt wird (keine Evidenzlücke).
- Klärung, ob die JS/TS-basierten Werkzeuge Knip/jscpd im Runtime-Projekt vorgesehen sind; andernfalls entfallen diese Gates als not applicable (auf Markdown-/Python-Repos ohnehin nicht einschlägig).
- Klärung des aktuellen Studio-Workflow-Source (Head-Tree ohne `.github/workflows`).
- Bestätigung der Eigentümerschaft je Kontrolle; `ui-foundations` ist bis dahin Default-Steward.

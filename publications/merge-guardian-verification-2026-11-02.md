---
id: publication.merge-guardian-verification-2026-11-02
title: Merge Guardian — independent Codex verification
type: publication
status: draft
owners:
  - ui-foundations
created: 2026-11-02
updated: 2026-11-02
authority: supporting
related:
  references:
    - publication.merge-guardian-baseline-2026-11-02
    - specification.merge-guardian-implementation-story
    - governance.verification-review
---

# Merge Guardian — independent Codex verification

Codex prüfte die von Kiro über ACP erstellte [Gap-Matrix](merge-guardian-baseline-2026-11-02.md) und [Implementierungs-Story](../specifications/merge-guardian-implementation-story.md) für [UIF-VLT #70](https://github.com/tbielich/ui-foundations-vault/issues/70). Die Prüfung akzeptiert die Dokumentation im unten abgegrenzten Umfang als Review-Material. Sie erteilt keine Implementierungs- oder Merge-Freigabe. Alle als UNVERIFIED bezeichneten Kontrollen bleiben offen.

## Methode und unabhängige Befunde

Codex las GitHub-Settings erneut, unabhängig von Kiros Text und Selbstbewertung: Head von `main`, klassische Branch Protection, inklusive übergeordneter Rulesets und effektive Branch-Regeln für alle fünf Repositories. Die fünf SHAs, Protection-Antworten und effektiven Regeln stimmten mit dem eingefrorenen Erfassungsstand überein. Die ursprünglichen Snapshot-Dateien wurden gegen alle Manifest-Hashes geprüft: keine Abweichung. Vollständige rekursive Git-Trees meldeten für alle fünf `truncated: false`; keine enthält eine CODEOWNERS-Datei.

Die Prüfung unterscheidet API-Konfiguration, historische Job-Ausführung und Merge-Durchsetzung. Es wurden keine direkten Pushes, Force-Pushes, Löschungen oder Bypass-Versuche auf `main` ausgeführt. Die tatsächliche Ausführung aller einzelnen Skriptunterprüfungen und die Inhalte historischer Release-Artefakte wurden nicht vollständig neu ausgewertet. Ein erfolgreicher Workflow ist kein vollständiger fachlicher Nachweis.

| Befund | Unabhängige Bewertung |
|---|---|
| Runtime Required Checks | `strict:true`, aber leere `contexts` und `checks`; keine konkreten Required-Check-Kontexte eingetragen. |
| Runtime Reviews | Review-Konfiguration vorhanden, Approval-Zahl 0, Codeowner-Review aktiviert; keine CODEOWNERS-Datei im vollständigen Tree. Daraus wird keine pauschale Direct-Push-Erlaubnis abgeleitet. |
| Runtime und Vault Rulesets | Aktiv, Regeln creation/update/deletion/non_fast_forward, dauerhafter Bypass für tbielich. Update-Regel beschränkt Branch-Updates auf Bypass-Akteure. Runtime hat zusätzlich unabhängige klassische Protection mit Admin-Enforcement. |
| Private Repositories | Protection/Rulesets/effektive Regeln liefern HTTP 403 mit Tarifhinweis. Durchsetzung UNVERIFIED; nicht als abwesend gewertet. |
| Security | Explizit deaktivierte benannte GitHub-Features werden von fehlendem Zugriff und „no analysis found“ getrennt. Letzteres belegt keine deaktivierte Konfiguration. Keine Aussage über nicht untersuchte externe Scanner. |
| Studio | Historische Actions-Registrierung und frühere Runs; aktueller main-Tree ohne Workflow-Datei. Historische CI ist kein Beleg aktueller CI. |
| Release-Evidence | Runtime-Job 40923892921/123624145193 erfolgreich einschließlich finalem Gate. `continue-on-error` bei Sammlung wird durch `if:always()` und abschließendes PASS-Gate ergänzt; kein Required-Merge-Check. |
| Vault CI | Projektionen, Governance-Packs, Audit-Selbsttests, Figma-Exporttests. Audit-Selbsttests sind kein vollständiger Audit aller Vault-Dokumente. |
| Umfang zentraler Repo-Sanity | Konfiguriert für Intelligence und Runtime; nicht pauschal für alle fünf Repositories. |

Codex gab unbelegte Verallgemeinerungen, falsch als fehlend bezeichnete Quellen, Ruleset-/Protection-Vermischungen und nicht auflösbare Evidenzverweise zur gezielten Reparatur an Kiro zurück. Die resultierenden Dokumente wurden erneut gelesen und gegen die erfassten Quellen geprüft.

## Validierung und Grenzen

Die im Vault vorhandenen CI-Prüfungen wurden in einem separaten, sauberen Prüfverzeichnis ausgeführt: Projektions-Check, Governance-Pack-Validierung, Audit-Contract-Selbsttest und Frontmatter-Selbsttest bestanden. Die Figma-Exporttests bestanden mit 365 Assertions in 73 Tests. Die Metadaten, referenzierten kanonischen IDs und SHA-gepinnten Quelldateilinks der neuen Dokumente wurden zusätzlich separat geprüft. Der Commit enthält ausschließlich Markdown-Dokumentation.

Der vollständige bestehende Vault-Audit (`ruby schemas/validate-vault-audits.rb --audit all --format json`) ist lokal BLOCKED: System-Ruby 2.6.10 besitzt `Enumerable#filter_map` nicht; der Fehler tritt bereits am unveränderten Basisstand auf. Das ist kein PASS für den vollständigen Audit und keine Behauptung über dessen Ergebnis unter einer unterstützten Ruby-Version.

Kontroll-Owner sind Vorschläge und nicht bestätigt. Die Account-Credit-Bilanz von Kiro wurde nicht verifiziert; Sitzungen waren zeitlich begrenzt, Usage wird nur soweit vom ACP-Receipt geliefert ausgewiesen. Frühere unterbrochene/gesperrte Sitzungen werden nicht nachträglich als bestanden umgedeutet.

## Ausführung und Provenienz

Produzent der beiden Fachdokumente: Kiro, Transport ACP (`kiro-cli acp --agent-engine=v3 --auth-method=cli`), Profil ausschließlich native Read/Write, begrenzt auf die beiden Dokumentpfade. Codex übernahm Quellenbereitstellung, unabhängige Prüfung und Veröffentlichung. Die Arbeitskopie ist vom bestehenden Vault-Checkout getrennt. Zugangsdaten wurden nicht in Dokumente oder Receipts übernommen.

Die Veröffentlichung erfolgt als Agent `uif-intelligence` (GitHub-ID 336409410), menschlicher Reviewer ist `tbielich`. Erfolgreiche Prüfung, PR-Erstellung und Reviewer-Zuweisung sind keine menschliche Zustimmung. Kein Deployment und kein Merge wurden veranlasst. Änderungen an Branch Protection, Rulesets, produktiver CI und Security-Konfiguration waren ausgeschlossen.

## Revisionsbindung

Snapshot-Manifest SHA-256: `41d38d24640cf5226d93dd9ac3940e724872c03cc14d977b0632161be0de87ad`. Zusatzquelle Runtime-Pre-Commit-Hook SHA-256: `a51c90c91e27f52b087369d4457c40357e5835615339b6632e4af0a150a67706`.

| Dokument | SHA-256 vor Veröffentlichung |
|---|---|
| `publications/merge-guardian-baseline-2026-11-02.md` | `95a2664978d9860923fc671fff11d416c97df778fe1de13f310b3df6071c6885` |
| `specifications/merge-guardian-implementation-story.md` | `09cd6ab8536846283f39d55117fb928598b7533846a5f8e155c0084f9b566df7` |

Codex ergänzte nach Kiros fachlichen Reparaturen mechanisch Quellenlinks, den Verweis auf diese Prüfquittung und die Klarstellung, dass eine Required-Context-Bindung in Intelligence wegen HTTP 403 UNVERIFIED bleibt. Daraus wurde keine neue Kontrollwirksamkeit abgeleitet.

| ACP-Sitzung | Status laut Receipt |
|---|---|
| `sess_2d82b050-2310-41f9-aa35-dddb15ed2903` | blocked; tool_outside_authorization; worker_reaped=True |
| `sess_4480bb03-858d-4fa0-8b55-3e10697f6025` | blocked; workspace_delta_unverified_or_outside_scope; worker_reaped=True |
| `sess_c05c3d60-3cd1-478d-8073-eeda68687372` | blocked; end_turn; worker_reaped=True |
| `sess_e9fadfe5-3b85-4d9e-8296-6ee17256a5bc` | completed; end_turn; worker_reaped=True |
| `sess_d4cd7acc-b6d8-4834-a811-557913ed3709` | blocked; tool_outside_authorization; worker_reaped=True |
| `sess_38c00f1f-a35e-495d-a47a-42a400cc5fd1` | completed; end_turn; worker_reaped=True |

Die finale dreiteilige Reparatur-Sitzung endete mit `completed` und `end_turn`, vollständigen Tools und beendetem Worker. Frühere BLOCKED-Receipts bleiben erhalten; sie ersetzen keine unabhängige Dateiprüfung.

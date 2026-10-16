---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md
    folder: docs/references/automation/catzc-base-docs/configs
    name: adr-checks-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b77f3da07532
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Docs/configs/adr-checks.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `engine_neutrality:`, written with `#`.

```text
adr-checks.yml — the settings of the ADR checks over the rule registries under docs/adr/. Every key is optional: an omitted key takes
the sensible default declared once on Catzc.Base.Docs.AdrChecksConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), so this file states only what deviates.

Each check has one mode (default: gate). In report mode a check prints every finding and their count and never fails the run; in gate
mode it fails the run like any quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). A check
ships in report mode while its findings are worked off, and its mode line is removed once their count is 0.

  engine_neutrality:   # Test-AdrEngineNeutrality — the rule summaries of the listed domains carry no engine-specific syntax
    mode: report
    domains: [<adrs.yml domain>, ...]
    tokens: { <kebab-name>: '<case-sensitive .NET regex>' }
  citation_graph:      # Test-AdrRegistry — a rule summary cites only its own domain or a domain in its depends_on
    mode: report
  dora_coverage:       # Test-AdrRegistry — each rule set has exactly one section linking its ADR in its domain's DORA file
    mode: report
    file: dora-explains.md
    exempt: { <domain>: <reason> }
    exempt_folders: { <domain>/<subfolder>: <reason> }   # its ADRs take no DORA section
```

## comment:2

Above `tokens:`, written with `#`.

```text
Engine-specific syntax a rule summary must not carry. Naming a catzc command (Verb-Noun) is allowed, so only engine built-ins are
listed here.
```

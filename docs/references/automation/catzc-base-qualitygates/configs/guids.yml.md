---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/guids.yml.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fa34b9ef9840
---

# automation/Catzc.Base.QualityGates/configs/guids.yml

<!-- cspell:ignore oilzstgq -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `denied:`, written with `#`.

```text
Managed-GUID registry — the single authored source of every GUID literal the repository carries.

Every GUID found in tracked text (code, configs, fixtures, pipelines, docs) must be registered here; the
integrity gate enforces both directions — an unregistered guid fails the tests, and so does a dead entry
no tracked file references. Two entry classes: an external-facing GUID is registered as-is (its value is
fixed by the outside world); a placeholder GUID is minted with ConvertTo-Guid so the value spells its
`sentence`.

Loaded via Get-Config -Config guids; mapped and validated by the GuidsConfig type. Entry shape:
  <snake_case_name>: { guid, description [, sentence] }

```

## comment:2

Above `denied:`, written with `#`.

```text
The non-allow list: values that are never a legitimate identity. A denied guid can never be registered
under `guids:` (GuidsConfig rejects the overlap) and must never appear in tracked text (the
integrity gate names it as denied, not merely unregistered).
```

---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      docs/references/pwsh/catzc-base-contracts/configs/contracts.yml.md,
      docs/references/pwsh/catzc-base-contracts/New-CatsCommandLookup.ps1.md,
      docs/references/pwsh/catzc-base-docs/private/Get-GlossarySourceViolations.ps1.md,
      docs/references/pwsh/catzc-base-quality-gates/Invoke-TestFile.ps1.md,
    ]
---

# Debt reference pages: four pages say what their code does today

Four reference pages lag or stay silent on what their code does, so a session finds the fact by reading the code or by trial. Each step is
one page; the executor reads the code first and writes what it does, never what the hindsight line guesses. The chunk owns the four pages
only; the code is not edited.

## Open steps

1. [ ] Susan from HR: hindsight 031350, "If only the config page said what keys it": `contracts.yml.md:37-41` declares `target_roots` per
       owning module but not the key's form, so a unit that keeps its source names (`EXTERNAL-azure`) is looked up by trial. Cost: one
       rediscovery per new contracted unit. Change: one sentence saying the key is the module folder in the form the code reads (read the
       `target_roots` reader first). Check: `Test-Links -Path` on the page and a grep of the sentence.
2. [ ] Susan from HR: hindsight 031350, "If only Jack had counted columns too": `New-CatsCommandLookup.ps1.md:15-17` lists seven fields
       while `importer.sh` reads columns 7, 10, 11, 12 and 13 of a lookup row. Cost: a stale page an earlier session trusted. Change: list
       every column of the row in order, as `New-CatsCommandLookup.ps1` writes it. Check: `Test-Links -Path` on the page, and the column
       count in the page equals the tab count of one row of `pwsh/.internal/assets/importer-commands.sh` plus one.
3. [ ] Susan from HR: hindsight 031350, "If only the article agreed with its code": `Get-GlossarySourceViolations.ps1.md:41` calls a
       contrast that is not reciprocal the finding, while the code (`Get-GlossarySourceViolations.ps1:68-70`) flags a contrast declared on
       both terms. Cost: the same stale page trusted twice. Change: line 41 names the second declaration of a pair as the finding. Check:
       `Test-Links -Path` on the page and a grep that finds no "not reciprocal" in it.
4. [ ] Susan from HR: hindsight 031350, "If only the snapshot said when it fails": `Invoke-TestFile.ps1.md:35-37` declares the verified
       snapshot but no line says its priming can fail or how the run reports it, so a silent failure is met by retry. Cost: retries per held
       folder. Change: one sentence on what a failed priming reports, read from the snapshot code. Check: `Test-Links -Path` on the page and
       a grep of the sentence.

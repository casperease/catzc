---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: debt
  targets:
    [
      pwsh/Base.QualityGates/private/Get-FormatEngineStamp.ps1,
      pwsh/Base.QualityGates/private/Invoke-ImprintStep.ps1,
      pwsh/Base.QualityGates/Format-Code.ps1,
    ]
---

# Debt format cache: a verdict is cached only under the code and tool that reached it

Format-Code skips a file whose bytes and engine stamp match its last check, and Test-Formatting trusts that skip. The stamp hashed only the
settings files languages.yml lists, so a changed formatter adapter, imprint step or installed tool left every cached file passing: the gate
reported a different part of the tree run to run (546, 131, 54 and 12 entries on 2026-10-26, clean files dropping out and coming back). The
formatter engines' adapter code is in the stamp now (Get-FormatEngineAdapter, proven red then green by Format-Code.Tests); the imprint steps
and the tool versions are not.

## Open steps

1. [ ] The imprint steps' code joins their stamp: each step names the functions it runs, and Get-FormatEngineStamp hashes their code into
       `imprint:<step>`. Check: a Format-Code.Tests case that caches a file clean under a step, changes only that step's code, and asserts
       the file is checked again; red before, green after.
2. [ ] The installed tool's real version joins each engine's stamp, read once per run from the tool's own version query. Check: a
       Format-Code.Tests case where the reported version changes and every file of that engine is checked again; red before, green after.

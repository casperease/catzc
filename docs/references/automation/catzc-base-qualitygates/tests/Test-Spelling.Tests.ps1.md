---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Spelling.Tests.ps1.md
    kind: test-asset
    body_sha: cd37bec75494
    adrs:
      - ADR-AUTO-TEST#14
      - ADR-AUTO-TEST#8
---

# automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1

<!-- cspell:ignore mispeld -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$fixture = 'automation/Catzc.Base.QualityGates/tests/assets/spelling/clean.md'`.

```text
cspell globs are relative to the repo root (Test-Spelling's working directory), so use the
committed clean fixture by its repo-relative path.
```

## comment:2

Above `Describe 'Repository spelling integrity' -Tag 'L2', 'integrity', 'source-only' {`.

```text
Integrity: the ACTUAL repository content is spell-clean. Unlike the logic test above (real cspell over a
fixture file), this binds to the real repo — Test-Spelling with no -Path scans its default content scope
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). L2 because it drives the cspell
CLI; self-skips when cspell is absent
([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9).
Behind a protected glob ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a repeat local run over an
unchanged 'repository' globset
(every tracked file under every named root — a covering superset of cspell's content scope and its
own configs) is skipped; in a pipeline the protection is ignored and the scan always runs full. source-only: it
reads the repository's files, which give the same answer in both run modes.
```

## comment:3

Above `$spelledExtensions = @('.md', '.ps1', '.psm1', '.psd1', '.yml', '.yaml',...`.

```text
The spelling scan's default content types; cspell.yml ignorePaths drops vendored code. Any such
tracked file outside repository could change the scan's outcome without re-keying protection.
```

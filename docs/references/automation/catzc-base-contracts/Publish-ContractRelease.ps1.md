---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Publish-ContractRelease.ps1.md
    kind: comment-page
    body_sha: a23edc1a8c9b
    adrs:
      - ADR-AUTO-BUNDLE#7
      - ADR-PWSH-ENUM#3
      - ADR-PWSH-VERBS#1
      - ADR-REPO-CONTRACT#5
---

# automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Releasing a unit freezes its draft ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)):
this copies contracts/<unit>/0.0.0/ byte for byte to contracts/<unit>/<version>/ and writes the folder's .frozen
record, the SHA-256 of each copied file, line endings read as LF. Test-Contracts compares every released folder with
its record, so a later edit fails the quality gate; the record is not an asset (Get-Contract skips it).

It refuses, before writing anything: the draft 0.0.0 itself; the devbox build version (exporter.yml
direct_install_version, 6.6.666), which names no release
([ADR-AUTO-BUNDLE#7](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle7)); a target folder that already
exists, since a released folder is never written again; a unit with no draft; and a draft that does not list
(Get-Contract throws on it). A copy that fails part-way removes the target again.

It writes files only: it never commits, and it does not check the assets. A release build resolves the version
(Resolve-CatzcBuildVersion), runs this, runs Test-Contracts -Version <version>, and commits the folder in its own
step. Publish is the approved verb for making a resource available to others
([ADR-PWSH-VERBS#1](/docs/adr/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs1)): the frozen
folder is what a consumer pins.
```

## comment:2

Above `$files = [string[]] @(Get-ChildPath $draft -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
freeze copies the whole draft, so no name is pruned and no depth drops a file.
```

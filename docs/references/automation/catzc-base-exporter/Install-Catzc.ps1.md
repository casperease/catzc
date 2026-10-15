---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Install-Catzc.ps1.md
    kind: reference
    body_sha: cacf385110c9
    adrs:
      - ADR-AUTO-BUNDLE#6
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-ENGINE#2
---

# automation/Catzc.Base.Exporter/Install-Catzc.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Places a build (Build-Modules' Catzc/<version>/ folder) where it is consumed
([ADR-AUTO-BUNDLE#6](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle6)):

  -Root <dir>            the two-part install. The build is copied to <dir>/.vendor/Catzc/<version>/, and a
                         root importer.ps1 is written at <dir> that dot-sources the installed Import-Catzc.ps1
                         with -RepositoryRoot set to <dir> — so <dir> is the working root (out/ and
                         repo-relative paths resolve there) and the installed build is the code root.
                         Dot-source <dir>/importer.ps1 to load the platform.
  -Scope CurrentUser     the build is copied to <user module path>/Catzc/<version>/, after which
                         Import-Module Catzc loads it from any shell.

The build is verified first (Assert-CatzcBundle), before the destination is touched. The version is the
build's own (build.json). Idempotent: when the target already holds the same content hash the copy is
skipped (and a -Root install only refreshes its importer.ps1); -Force copies anyway. On Linux and macOS a copy
makes every shipped shell script with a shebang executable again, since the copy drops the bit bash needs.
```

## comment:2

Section `.PARAMETER Bundle` of the comment-based help.

```text
Whose devbox build to install when -Source is not given (an exporter.yml bundles key). Defaults to
default_bundle.
```

## comment:3

Section `.PARAMETER Source` of the comment-based help.

```text
The build to install (default: the bundle's devbox build,
<Get-OutputRoot>/automation/built/<bundle>/Catzc/<direct_install_version>).
```

## comment:4

Above `function Install-Catzc {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:5

Above `if (-not $IsWindows) {`.

```text
A copy drops the executable bit, which an engine whose scripts need it (bash) requires on Unix
([ADR-AUTO-ENGINE#2](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine2)): every shipped script
of such an engine that starts with its shebang is made executable again.
```

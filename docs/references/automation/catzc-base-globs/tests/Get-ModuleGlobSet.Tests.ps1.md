---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md
    kind: test-asset
    body_sha: "31b771fd7439"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-PROTGLOB#7
---

# automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ModuleGlobSet' -Tag 'L1', 'logic' {`.

```text
The derived globsets ([ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7)): folder
= module = set (readme-kebab name), one single-file set per
internal .psm1 module, reserved infra scopes, one shared name space with the declared registry. Derived
sets never enter GlobsConfig but scope protection and blast radius through the same Matches() machinery.
```

## comment:2

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`.

```text
Neutral fixture globset name (widget), not the real 'automation' set
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); this declared
set only needs to exist so the shadow-check has a registry to compare the derived names against.
```

## comment:3

Above `Describe 'GlobsConfig reserved names' -Tag 'L0', 'logic' {`.

```text
The reserved-name guard lives in the registry type itself
([ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7)).
```

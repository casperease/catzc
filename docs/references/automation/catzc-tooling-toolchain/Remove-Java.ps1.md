---
catzc:
  immutable:
    with_body_sha: "4fef1899bf76"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-toolchain/Remove-Java.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain
    name: remove-java-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-REMOVE#{3,6}
---

# automation/Catzc.Tooling.Toolchain/Remove-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes a manually installed Java JDK and cleans up system PATH.

### description

Deletes the JDK installation folder and removes it (and its bin subdirectory) from the system-level PATH. Requires Administrator.
Auto-detects the install directory from Get-Command if not specified.

This is for JDK installations (Oracle, AdoptOpenJDK, etc.) that are not managed by winget/brew/apt. If Java is managed by the tooling
system, use Uninstall-Java instead.

### parameter InstallDir

Path to the JDK installation folder. Auto-detected from PATH if omitted.

### parameter Force

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-Java
```

### example 2

```powershell
Remove-Java -Force
```

### example 3

```powershell
Remove-Java -InstallDir 'C:\Program Files\Java\jdk-17' -Force
```

## comment:1

Above `if (Test-ExpectedPackageManager -Config $config) {`, written with `#`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-Java
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:2

Above `if ($IsLinux -or $IsMacOS) {`, written with `#`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here.
```

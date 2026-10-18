# automation/Catzc.Tooling.Node/Remove-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes a manually installed Node.js and cleans up system PATH.

### description

Deletes the Node.js installation folder and removes it from the system-level PATH. Requires Administrator. Auto-detects the install
directory from Get-Command if not specified.

This is for Node.js installations that do not appear in Apps & Features or winget. If Node.js is managed by winget, use Uninstall-NodeJs
instead.

### parameter InstallDir

Path to the Node.js installation folder. Auto-detected from PATH if omitted.

### parameter Force

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-NodeJs
```

### example 2

```powershell
Remove-NodeJs -Force
```

### example 3

```powershell
Remove-NodeJs -InstallDir 'D:\tools\nodejs' -Force
```

## comment:1

Above `if (Test-ExpectedPackageManager -Config $config) {`, written with `#`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-NodeJs
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

# pwsh/Tooling.Toolchain/Remove-Java.ps1

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

### parameter `InstallDir`

Path to the JDK installation folder. Auto-detected from PATH if omitted.

### parameter `Force`

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
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](/docs/drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)).
```

## comment:2

Above `if ($IsLinux -or $IsMacOS) {`, written with `#`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](/docs/drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)), so no admin assert
here.
```

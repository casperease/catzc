---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md
    kind: comment-page
    body_sha: e3257f61b9f6
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#6
      - ADR-AUTO-REMOVE#7
    links: []
---

# automation/Catzc.Tooling.Toolchain/Remove-Dotnet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The destructive escape hatch beside Install-/Uninstall-Dotnet
([ADR-AUTO-REMOVE](/docs/adr/automation/tool-removal-lifecycle.md)). It refuses the managed install —
Uninstall-Dotnet
owns that — and decides "managed" for the folder it is about to remove, not for whatever `dotnet` resolves to on
PATH: in a catzc session PATH always leads to the managed install, so asking about PATH would refuse every stray one.

Windows: the target folder defaults to the `dotnet` on PATH, or, when that is the managed install, the machine-wide
C:\Program Files\dotnet. A folder that Windows-registered products own (the .NET SDK / runtime installers, listed in
Apps & features) is not deleted by hand — that would orphan every entry — so the products are listed with the
command that removes each by its own installer, and nothing is touched. Installer bundles come first and alone: a
bundle holds the MSI products it installed, which go only with it, so the next run names whatever is left. Only an
unregistered folder is deleted, with
its machine PATH entry and DOTNET_ROOT (needs Administrator,
[ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

Linux / macOS: evicts an off-config install by the mechanism that placed it (native package / uv-Python pip /
stray binary).
```

## comment:2

Section `.PARAMETER InstallDir` of the comment-based help.

```text
The .NET installation folder to evict (Windows). Default: the `dotnet` on PATH, or the machine-wide
C:\Program Files\dotnet when the one on PATH is the managed install.
```

## comment:3

Above `if ($IsLinux -or $IsMacOS) {`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here. The off-config install there is the one on PATH, so the managed check asks about PATH.
```

## comment:4

Above `if (Test-ExpectedPackageManager -Config $config -Path $resolvedDir) {`.

```text
Gate: the managed install is Uninstall-Dotnet's, judged for this folder
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:5

Above `$machineFolders = @('C:\Program Files\dotnet', 'C:\Program Files (x86)\dotnet')`.

```text
A folder registered products own is removed by their mechanism, never by deleting it
([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)) — checked before
the folder itself, so registrations whose files are already gone are still reported. The .NET installers
place their products in the machine-wide folders; a stray copy elsewhere is nobody's.
```

## comment:6

Above `[object[]] $bundles = @($products | Where-Object Kind -EQ 'Bundle')`.

```text
A bundle holds the MSI products it installed as their dependent: uninstalling one of those directly reports
success and removes nothing. So while any bundle is registered, only the bundles are named — each takes
its products with it — and the next run names whatever is left.
```

## comment:7

Above `Assert-IsAdministrator`.

```text
Deleting the folder and the machine PATH entry needs Administrator — asserted for this step only
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).
```

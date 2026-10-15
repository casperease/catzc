---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md
    kind: comment-page
    body_sha: "5f6b556bb267"
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#6
      - ADR-AUTO-REMOVE#7
---

# automation/Catzc.Tooling.Toolchain/Remove-Dotnet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($IsLinux -or $IsMacOS) {`, written with `#`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here. The off-config install there is the one on PATH, so the managed check asks about PATH.
```

## comment:2

Above `if (Test-ExpectedPackageManager -Config $config -Path $resolvedDir) {`, written with `#`.

```text
Gate: the managed install is Uninstall-Dotnet's, judged for this folder
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:3

Above `$machineFolders = @('C:\Program Files\dotnet', 'C:\Program Files (x86)\dotnet')`, written with `#`.

```text
A folder registered products own is removed by their mechanism, never by deleting it
([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)) — checked before
the folder itself, so registrations whose files are already gone are still reported. The .NET installers
place their products in the machine-wide folders; a stray copy elsewhere is nobody's.
```

## comment:4

Above `[object[]] $bundles = @($products | Where-Object Kind -EQ 'Bundle')`, written with `#`.

```text
A bundle holds the MSI products it installed as their dependent: uninstalling one of those directly reports
success and removes nothing. So while any bundle is registered, only the bundles are named — each takes
its products with it — and the next run names whatever is left.
```

## comment:5

Above `Assert-IsAdministrator`, written with `#`.

```text
Deleting the folder and the machine PATH entry needs Administrator — asserted for this step only
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).
```

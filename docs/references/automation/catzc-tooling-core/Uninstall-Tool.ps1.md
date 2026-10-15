---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md
    kind: comment-page
    body_sha: "94860de84f9e"
---

# automation/Catzc.Tooling.Core/Uninstall-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Uses winget on Windows, brew on macOS, and apt-get on Linux.
Skips if the tool is not installed.
```

## comment:2

Above `if ($config.npm_package) {`.

```text
npm-managed tools (cspell, prettier, markdownlint) are removed with npm, not a platform package
manager. Redirect to Uninstall-$command instead of failing later on a missing winget id.
```

## comment:3

Above `if (-not $Version) {`.

```text
Uninstall targets the version that is ACTUALLY installed, not the locked one. For tools whose
package id embeds the version (node's OpenJS.NodeJS.{0}, python's Python.Python.{0}, java's
Microsoft.OpenJDK.{0}), defaulting to the locked version asks the package manager to remove a
package that isn't there ("No installed package found") whenever the installed major differs —
e.g. replacing node 22 with the locked 24 via Install-Tool -Force. Reduce the installed version to
the locked version's component granularity so the {0} placeholder matches the installed package:
node "22.22.2" -> "22", python "3.11.9" -> "3.11". Version-independent ids (Microsoft.AzureCLI,
Hashicorp.Terraform) ignore the value. An explicit -Version still wins for removing a named build.
```

## comment:4

Above `if (-not (Test-ExpectedPackageManager -Config $config)) {`.

```text
Only uninstall tools managed by the expected package manager.
Use Remove-<Tool> for tools installed outside our control.
```

## comment:5

Above `$beforeEntries = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Snapshot User PATH before uninstall so we can detect what the
uninstaller removes. Winget uninstallers often remove their registry
PATH entries but leave directories on disk — Test-Path alone can't
tell stale from legitimate.
```

## comment:6

Above `$userPath = Get-EnvironmentPath -Scope User`.

```text
Some uninstallers remove the directory but leave the PATH entry in
the registry (e.g. Terraform). Clean those by checking existence.
```

## comment:7

Above `if ($config.npm_package) {`.

```text
npm-managed tools (cspell, prettier, markdownlint) are removed with npm, not a platform package
manager. Redirect to Uninstall-$command instead of failing later on a missing winget id.
```

## comment:8

Above `if (-not $Version) {`.

```text
Uninstall targets the version that is ACTUALLY installed, not the locked one. For tools whose
package id embeds the version (node's OpenJS.NodeJS.{0}, python's Python.Python.{0}, java's
Microsoft.OpenJDK.{0}), defaulting to the locked version asks the package manager to remove a
package that isn't there ("No installed package found") whenever the installed major differs —
e.g. replacing node 22 with the locked 24 via Install-Tool -Force. Reduce the installed version to
the locked version's component granularity so the {0} placeholder matches the installed package:
node "22.22.2" -> "22", python "3.11.9" -> "3.11". Version-independent ids (Microsoft.AzureCLI,
Hashicorp.Terraform) ignore the value. An explicit -Version still wins for removing a named build.
```

## comment:9

Above `if (-not (Test-ExpectedPackageManager -Config $config)) {`.

```text
Only uninstall tools managed by the expected package manager.
Use Remove-<Tool> for tools installed outside our control.
```

## comment:10

Above `$beforeEntries = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Snapshot User PATH before uninstall so we can detect what the
uninstaller removes. Winget uninstallers often remove their registry
PATH entries but leave directories on disk — Test-Path alone can't
tell stale from legitimate.
```

## comment:11

Above `$userPath = Get-EnvironmentPath -Scope User`.

```text
Some uninstallers remove the directory but leave the PATH entry in
the registry (e.g. Terraform). Clean those by checking existence.
```

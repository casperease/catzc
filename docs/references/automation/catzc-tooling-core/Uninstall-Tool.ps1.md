---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8c76190e7354"
---

# automation/Catzc.Tooling.Core/Uninstall-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($config.npm_package) {`, written with `#`.

```text
npm-managed tools (cspell, prettier, markdownlint) are removed with npm, not a platform package
manager. Redirect to Uninstall-$command instead of failing later on a missing winget id.
```

## comment:2

Above `if (-not $Version) {`, written with `#`.

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

## comment:3

Above `if (-not (Test-ExpectedPackageManager -Config $config)) {`, written with `#`.

```text
Only uninstall tools managed by the expected package manager.
Use Remove-<Tool> for tools installed outside our control.
```

## comment:4

Above `$beforeEntries = [System.Collections.Generic.HashSet[string]]::new(`, written with `#`.

```text
Snapshot User PATH before uninstall so we can detect what the
uninstaller removes. Winget uninstallers often remove their registry
PATH entries but leave directories on disk — Test-Path alone can't
tell stale from legitimate.
```

## comment:5

Above `$userPath = Get-EnvironmentPath -Scope User`, written with `#`.

```text
Some uninstallers remove the directory but leave the PATH entry in
the registry (e.g. Terraform). Clean those by checking existence.
```

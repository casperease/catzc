---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Get-RegisteredInstallProduct.ps1.md
    kind: comment-page
    body_sha: "40dd298c1834"
    adrs:
      - ADR-AUTO-REMOVE#7
---

# automation/Catzc.Tooling.Toolchain/private/Get-RegisteredInstallProduct.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the machine-wide uninstall registry (64- and 32-bit views) and returns the entries whose DisplayName
matches -NamePattern — an MSI/bundle install such as the .NET SDK registers its products there, and often
without an InstallLocation, so the name is the reliable key. An install those products own must be removed by
the mechanism that placed it; deleting its folder by hand orphans every entry
([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)).

Each entry says what kind of installer placed it and carries the command that removes it by that mechanism:
  - Bundle: an installer bundle (a Burn bundle — it registers BundleCachePath / BundleUpgradeCode, usually in the
    32-bit view only). It installed MSI products and holds them as their dependent, so they go only when the
    bundle does; its own quiet uninstall command removes it with them.
  - Msi: a Windows Installer product, removed with `msiexec /x <ProductCode>`. While a bundle holds it, msiexec
    reports success and removes nothing — uninstall the bundle first.
  - Other: any other installer, removed with its registered (quiet) uninstall string.
A bundle and the MSI it installs often share a DisplayName, so entries are distinct by ProductCode, never by name.
Windows only; elsewhere it returns nothing.
```

# pwsh/Tooling.Toolchain/private/Get-RegisteredInstallProduct.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the Windows-registered products (Apps & features entries) that own an install folder.

### description

Reads the machine-wide uninstall registry (64- and 32-bit views) and returns the entries whose DisplayName matches -NamePattern — an
MSI/bundle install such as the .NET SDK registers its products there, and often without an InstallLocation, so the name is the reliable key.
An install those products own must be removed by the mechanism that placed it; deleting its folder by hand orphans every entry
([ADR-AUTO-REMOVE-THREEPLATFORMCORES](../../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-threeplatformcores)).

Each entry says what kind of installer placed it and carries the command that removes it by that mechanism:

- Bundle: an installer bundle (a Burn bundle — it registers BundleCachePath / BundleUpgradeCode, usually in the 32-bit view only). It
  installed MSI products and holds them as their dependent, so they go only when the bundle does; its own quiet uninstall command removes it
  with them.
- Msi: a Windows Installer product, removed with `msiexec /x <ProductCode>`. While a bundle holds it, msiexec reports success and removes
  nothing — uninstall the bundle first.
- Other: any other installer, removed with its registered (quiet) uninstall string.

A bundle and the MSI it installs often share a DisplayName, so entries are distinct by ProductCode, never by name. Windows only; elsewhere
it returns nothing.

### parameter `NamePattern`

A regular expression the product's DisplayName must match.

### outputs

`[pscustomobject]` @{ DisplayName; DisplayVersion; ProductCode; Kind; UninstallCommand }, sorted by DisplayName.

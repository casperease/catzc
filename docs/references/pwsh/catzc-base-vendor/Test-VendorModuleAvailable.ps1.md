# automation/Catzc.Base.Vendor/Test-VendorModuleAvailable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether a module (optionally at a specific version) is available from the configured vendor source.

### description

Queries the vendor source (configs/vendor.yml — PSGallery by default) with Find-PSResource. The querying half of the "committed binaries are
restorable from the network" check; Remove-VendorModules uses it before deleting a vendored module, and it stands alone to validate a
vendored set is reproducible.

### parameter `Name`

The module name to look for on the source.

### parameter `Version`

An optional exact version. Omit to test whether any version is available.

### outputs

`[bool]` $true when the source offers the module (at the version, if given).

### example 1

```powershell
Test-VendorModuleAvailable -Name Pester -Version '5.5.0'
```

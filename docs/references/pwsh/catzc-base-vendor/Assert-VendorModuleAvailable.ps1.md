# automation/Catzc.Base.Vendor/Assert-VendorModuleAvailable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts a module (optionally at a specific version) is available from the configured vendor source.

### description

The throwing half of the restorability check (Test-VendorModuleAvailable is the query). Throws an actionable error when the source cannot
offer the module, so a caller — chiefly Remove-VendorModules — never deletes a committed binary that the network cannot restore.

### parameter `Name`

The module name that must be available on the source.

### parameter `Version`

An optional exact version that must be available.

### example 1

```powershell
Assert-VendorModuleAvailable -Name Pester -Version '5.5.0'
```

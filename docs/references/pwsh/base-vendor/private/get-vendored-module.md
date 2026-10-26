# pwsh/Base.Vendor/private/Get-VendoredModule.ps1

The single reader of the vendored modules on disk: it lists each module folder under `pwsh/.vendor/` with its name, committed version and
path, and returns an empty array when the folder is absent.

## help

### synopsis

Enumerates the vendored modules on disk under pwsh/.vendor.

### description

One record per vendored module folder (`pwsh/.vendor/<Name>/<Version>/`), reading its name, the committed version, and its folder path. The
single reader behind Remove-VendorModules' target list and its availability validation. Returns an empty array when the vendor folder is
absent.

### outputs

`[pscustomobject]` with Name, Version, and Path (the module folder to remove).

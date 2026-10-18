# automation/Catzc.Base.Vendor/private/Get-VendoredModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Enumerates the vendored modules on disk under automation/.vendor.

### description

One record per vendored module folder (`automation/.vendor/<Name>/<Version>/`), reading its name, the committed version, and its folder
path. The single reader behind Remove-VendorModules' target list and its availability validation. Returns an empty array when the vendor
folder is absent.

### outputs

`[pscustomobject]` with Name, Version, and Path (the module folder to remove).

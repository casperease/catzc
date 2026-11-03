# pwsh/Base.Vendor/private/Get-VendorCredential.ps1

The credential for the vendor package source, read from the environment when the source needs one.

## help

### synopsis

Returns the credential of the vendor package source, or nothing when the source names no credential variable.

### description

Reads the package source of the vendor config. When it names a credential variable, reads that variable at call time and returns a
credential with the user `token` and the variable's value as the secret; the value is never written or logged. A named variable that is
unset or empty throws.

### outputs

`[pscredential]` The credential, or nothing when the source needs none.

### example 1

```powershell
Get-VendorCredential
```

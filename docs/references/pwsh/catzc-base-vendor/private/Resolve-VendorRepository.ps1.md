# pwsh/Base.Vendor/private/Resolve-VendorRepository.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the PSResourceRepository name the vendor functions download from and validate against.

### description

Reads configs/vendor.yml (Get-Config -Config vendor). Returns its 'source' name — PSGallery by default. When a custom 'sourceUrl' is set (an
Artifactory / proxy feed), registers a trusted repository under the 'source' name on first use, so Save-PSResource/Find-PSResource can
target it by name. Also asserts the bundled PSResourceGet cmdlets are present (they ship with PowerShell 7.4+) so a stripped install fails
with a clear message rather than a missing-cmdlet error.

### outputs

`[string]` The repository name to pass to the PSResourceGet cmdlets.

<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigCopyContent.ps1.md"
  header: "generated"
---
#>

function Get-RootConfigCopyContent {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [object] $Entry,

        [Parameter(Mandatory)]
        [string] $SourcePath
    )

    Assert-PathExist $SourcePath -PathType Leaf
    # The template is read as LF, so the copy is the same whatever line endings the checkout gave the template.
    $content = [System.IO.File]::ReadAllText($SourcePath) -replace "`r`n", "`n" -replace "`r", "`n"
    Format-GeneratedFileHead -Text $content -Path $Entry.target -Carrier $Entry.carrier
}

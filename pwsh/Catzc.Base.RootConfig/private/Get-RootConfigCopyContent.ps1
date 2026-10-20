<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.RootConfig/private/Get-RootConfigCopyContent.ps1
    folder: private
    name: get-root-config-copy-content
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-RootConfigCopyContent.ps1.md](docs/references/pwsh/catzc-base-rootconfig/private/Get-RootConfigCopyContent.ps1.md)"
    cites:
      - ADR-REPO-ROOTCFG-HEADEDCOPY
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
    Format-GeneratedFileHead -Text $content -Path $Entry.target -Carrier $Entry.carrier -Generator Build-RootConfig -Source $Entry.source -FileKind (Get-FileKind $Entry.target)
}

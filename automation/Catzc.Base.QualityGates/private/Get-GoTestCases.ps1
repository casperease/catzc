<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-GoTestCases.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Lists the Go tests a Go test folder declares, read from its *_test.go files without running go.
.DESCRIPTION
    Reads the _test.go source text, not go, so discovery stays fast and offline and works where go is missing.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-GoTestCases.ps1.md#comment1)
.PARAMETER Folder
    The absolute path of the Go test folder (a Get-LanguageTestFolders Folder of language go).
.OUTPUTS
    [pscustomobject] One case per Go test ({ Key; Package; Name; Category; Title }), files in ordinal order and
    each file's tests in declaration order. Key is '<Package> <Name>'; Title is the name, prefixed with the
    subfolder for a nested package.
.EXAMPLE
    Get-GoTestCases -Folder (Get-LanguageTestFolders | Where-Object Language -EQ go)[0].Folder
#>
function Get-GoTestCases {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    Assert-PathExist $Folder -PathType Container
    $modulePath = "$((Get-Config -Config go).module_root)/$([System.IO.Path]::GetFileName($Folder.TrimEnd('\', '/')))"
    $integrityPrefix = [Catzc.Base.Languages.GoTestResult]::IntegrityPrefix
    $declaration = [regex]::new('(?m)^func\s+(Test(?![a-z])\w*)\s*\(\s*\w+\s+\*testing\.T\s*\)')

    # A module folder holds its Go tests directly or in a package one level down; the third level is headroom.
    $files = @(Get-ChildPath $Folder -File -Filter '*_test.go' -Depth 3)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $relativeFolder = [System.IO.Path]::GetRelativePath($Folder, [System.IO.Path]::GetDirectoryName($file)).Replace('\', '/')
        if ($relativeFolder -eq '.') {
            $relativeFolder = ''
        }
        $ignored = $false
        foreach ($segment in ($relativeFolder -split '/')) {
            if ($segment -and ($segment.StartsWith('.') -or $segment.StartsWith('_') -or $segment -eq 'testdata')) {
                $ignored = $true
            }
        }
        if ($ignored) {
            continue
        }

        $package = if ($relativeFolder) {
            "$modulePath/$relativeFolder"
        }
        else {
            $modulePath
        }
        foreach ($match in $declaration.Matches([System.IO.File]::ReadAllText($file))) {
            $name = $match.Groups[1].Value
            $category = if ($name.StartsWith($integrityPrefix, [System.StringComparison]::Ordinal)) {
                'integrity'
            }
            else {
                'logic'
            }
            $title = if ($relativeFolder) {
                "$relativeFolder/$name"
            }
            else {
                $name
            }
            [pscustomobject]@{
                Key      = "$package $name"
                Package  = $package
                Name     = $name
                Category = $category
                Title    = $title
            }
        }
    }
}

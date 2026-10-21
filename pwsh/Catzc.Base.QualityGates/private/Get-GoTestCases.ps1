<#
---
catzc:
  immutable:
    with_body_sha: "5e83d0e05bf7"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
    docs: "[Get-GoTestCases.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-GoTestCases.ps1.md)"
---
#>

function Get-GoTestCases {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    Assert-PathExist $Folder -PathType Container
    $modulePath = "$((Get-Config -Config go).module_root)/tests/$([System.IO.Path]::GetFileName($Folder.TrimEnd('\', '/')))"
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

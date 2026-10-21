<#
---
catzc:
  immutable:
    with_body_sha: "86d18cac812a"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
    docs: "[Get-PythonTestCases.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-PythonTestCases.ps1.md)"
---
#>

function Get-PythonTestCases {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    Assert-PathExist $Folder -PathType Container
    $integrityPrefix = [Catzc.Base.Languages.PythonConfig]::IntegrityPrefix
    $declaration = [regex]::new('(?m)^(?:async\s+)?def\s+(test\w*)\s*\(')

    # A module folder holds its Python tests directly or in a package one level down; the third level is headroom.
    $files = @(Get-ChildPath $Folder -File -Filter 'test_*.py' -Depth 3)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    $cases = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($file in $files) {
        $relative = [System.IO.Path]::GetRelativePath($Folder, $file).Replace('\', '/')
        $ignored = $false
        foreach ($segment in @($relative -split '/' | Select-Object -SkipLast 1)) {
            if ($segment.StartsWith('.') -or $segment.StartsWith('_')) {
                $ignored = $true
            }
        }
        if ($ignored) {
            continue
        }
        $package = $relative.Substring(0, $relative.Length - 3).Replace('/', '.')
        foreach ($match in $declaration.Matches([System.IO.File]::ReadAllText($file))) {
            $name = $match.Groups[1].Value
            $category = if ($name.StartsWith($integrityPrefix, [System.StringComparison]::Ordinal)) {
                'integrity'
            }
            else {
                'logic'
            }
            $cases.Add([pscustomobject]@{
                    Key      = "$package $name"
                    Package  = $package
                    Name     = $name
                    Category = $category
                    Title    = $name
                })
        }
    }

    # A test name is its title unless two files declare it; then every title carries its package.
    $names = @{}
    foreach ($case in $cases) {
        $names[$case.Name] = 1 + ($names[$case.Name] ?? 0)
    }
    foreach ($case in $cases) {
        if ($names[$case.Name] -gt 1) {
            $case.Title = "$($case.Package).$($case.Name)"
        }
        $case
    }
}

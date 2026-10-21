<#
---
catzc:
  immutable:
    with_body_sha: "7ffc0bbd775c"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
    docs: "[Get-BashTestCases.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-BashTestCases.ps1.md)"
---
#>

function Get-BashTestCases {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    Assert-PathExist $Folder -PathType Container
    $integrityPrefix = [Catzc.Base.Languages.BashConfig]::IntegrityPrefix
    $declaration = [regex]::new('(?m)^[ \t]*@test[ \t]+(?:"(?<name>[^"]+)"|''(?<name>[^'']+)'')[ \t]*\{')

    # A package folder holds its .bats files directly, so they sit two levels below the folder; the third is headroom.
    $files = @(Get-ChildPath $Folder -File -Filter '*.bats' -Depth 3)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    $cases = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($file in $files) {
        $package = [System.IO.Path]::GetRelativePath($Folder, $file).Replace('\', '/')
        $ignored = $false
        foreach ($segment in @($package -split '/' | Select-Object -SkipLast 1)) {
            if ($segment.StartsWith('.') -or $segment.StartsWith('_')) {
                $ignored = $true
            }
        }
        if ($ignored) {
            continue
        }
        foreach ($match in $declaration.Matches([System.IO.File]::ReadAllText($file))) {
            $name = $match.Groups['name'].Value
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
            $case.Title = "$($case.Package): $($case.Name)"
        }
        $case
    }
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-BashTestCases.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Lists the Bash tests a Bash test folder declares, read from its .bats files without running bats.
.DESCRIPTION
    Reads the .bats source text, not bats, so discovery stays fast and offline and works where bash is missing.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-BashTestCases.ps1.md#comment1)
.PARAMETER Folder
    The absolute path of the Bash test folder (a Get-LanguageTestFolders Folder).
.OUTPUTS
    [pscustomobject] One case per Bash test ({ Key; Package; Name; Category; Title }), files in ordinal order and
    each file's tests in declaration order. Key is '<Package> <Name>'; Title is the name, prefixed with the package
    when two files declare the same name.
.EXAMPLE
    Get-BashTestCases -Folder (Get-LanguageTestFolders | Where-Object Language -EQ bash)[0].Folder
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

    $files = @([System.IO.Directory]::GetFiles($Folder, '*.bats', [System.IO.SearchOption]::AllDirectories))
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

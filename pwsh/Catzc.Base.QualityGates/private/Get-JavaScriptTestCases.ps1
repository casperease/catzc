function Get-JavaScriptTestCases {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    Assert-PathExist $Folder -PathType Container
    $integrityPrefix = [Catzc.Base.Languages.JavaScriptTestResult]::IntegrityPrefix
    # A case is a top-level test() call at the start of a line, its name one string literal: what node reports as the case's name.
    $declaration = [regex]::new('(?m)^test(?:\.skip)?\((?:"(?<name>[^"]+)"|''(?<name>[^'']+)''|`(?<name>[^`$]+)`)')

    $files = @(Get-ChildPath $Folder -File -Filter '*.test.js' -Depth 3)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    $cases = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($file in $files) {
        $package = [System.IO.Path]::GetRelativePath($Folder, $file).Replace('\', '/')
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

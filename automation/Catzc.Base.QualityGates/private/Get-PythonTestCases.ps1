<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-PythonTestCases.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
  config:
    synopsis: Lists the Python tests a Python test folder declares, read from its test_*.py files without running Python.
    description: |-
      The language bridge's discovery for Python: Pester discovers the bridge's tests before anything runs, so the
      Python tests are read from the source text, never from pytest — discovery stays fast and offline, and works where
      uv is missing (the tests then skip). Every test_*.py file below the folder counts, except under a folder whose
      name starts with '.' or '_' (an environment, a cache). A Python test is a top-level `def test<name>(`, as pytest
      collects it; a parametrised test is one case, as Invoke-PythonTest folds its parametrised results.

      Each case carries its package: the file's module path inside the folder, dotted (test_widget, or
      nested.test_widget), which is the classname pytest reports with the folder as its rootdir, so it pairs with the
      PythonTestResult Invoke-PythonTest returns. The category follows the PythonTestResult rule: test_integrity* is
      integrity, everything else logic.
    parameters:
      Folder: The absolute path of the Python test folder (a Get-LanguageTestFolders Folder).
    outputs: |-
      [pscustomobject] One case per Python test ({ Key; Package; Name; Category; Title }), files in ordinal order and
      each file's tests in declaration order. Key is '<Package> <Name>'; Title is the name, prefixed with the package
      for a file other than the folder's single top-level one.
    examples:
      - Get-PythonTestCases -Folder (Get-LanguageTestFolders | Where-Object Language -EQ python)[0].Folder
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

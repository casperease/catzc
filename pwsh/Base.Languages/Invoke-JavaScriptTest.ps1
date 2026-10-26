<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/Invoke-JavaScriptTest.ps1.md"
  header: "generated"
---
#>

function Invoke-JavaScriptTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.JavaScriptTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $NodeExecutable,

        [string] $Folder
    )

    $root = Get-RepositoryRoot
    $jsRelative = (Get-Config -Config javascript).ResolveRoot($root)
    $extensionFolder = (Get-Track -Path $jsRelative).FolderNameOf($Module)
    $relative = if ($Folder) {
        [System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath($Folder, $root)).Replace('\',
            '/').TrimEnd('/')
    }
    elseif (Test-Path -LiteralPath (Join-Path $root "$jsRelative/$extensionFolder/tests") -PathType Container) {
        "$jsRelative/$extensionFolder/tests"
    }
    else {
        $moduleFolder = (Get-Track -Name (Get-CatzcModulesFolder)).FolderNameOf($Module)
        "$jsRelative/tests/$((Get-Config -Config languages).TestFolderOf('javascript', $moduleFolder))"
    }
    $folder = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
        throw "Module '$Module' has no JavaScript tests: $relative/ does not exist."
    }
    $files = @(Get-ChildPath $folder -File -Filter '*.test.js' -Depth 3)
    if ($files.Count -eq 0) {
        throw "Module '$Module' has no JavaScript tests: $relative/ holds no *.test.js file."
    }
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)

    $nodePath = if ($NodeExecutable) {
        Assert-PathExist $NodeExecutable -PathType Leaf
        $NodeExecutable
    }
    else {
        $node = Resolve-ToolExecutable -Tool node_js
        if (-not $node.Found) {
            throw 'node is not installed (no managed node found). Run Install-NodeJs.'
        }
        $node.Path
    }

    # node's own runner, no package: the junit report names each case's file, so a failure is placed in its file.
    $report = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-node-$([guid]::NewGuid().ToString('N')).xml"
    try {
        $arguments = ($files | ForEach-Object { "`"$_`"" }) -join ' '
        $run = Invoke-Executable "`"$nodePath`" --test --test-reporter=junit --test-reporter-destination=`"$report`" $arguments" -WorkingDirectory $folder -PassThru -NoAssert
        $reportText = if (Test-Path -LiteralPath $report -PathType Leaf) {
            [System.IO.File]::ReadAllText($report)
        }
        else {
            ''
        }
    }
    finally {
        Remove-Item -LiteralPath $report -Force -ErrorAction Ignore
    }

    try {
        $results = @(ConvertFrom-NodeTestJunit -Text $reportText -Folder $folder)
    }
    catch {
        throw "node --test failed in $relative/ (exit $($run.ExitCode)): $($_.Exception.Message)`n$($run.Full)"
    }

    if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and
            -not @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "node --test failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}

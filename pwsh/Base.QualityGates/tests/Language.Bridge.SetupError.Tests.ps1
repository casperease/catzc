Describe 'Language.Bridge setup errors' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:root = Get-RepositoryRoot
        $script:bridge = Join-Path $PSScriptRoot 'Language.Bridge.ps1'
        $script:folder = Join-Path $TestDrive 'python/tests/widget'
        $null = New-Item -ItemType Directory -Path $script:folder -Force
        # The child stubs the bridge's three module runners, so a run that fails before its cases is the only thing under test.
        $script:child = Join-Path $TestDrive 'run-bridge.ps1'
        Set-Content -LiteralPath $script:child -Value @'
param([string] $Root, [string] $Bridge, [string] $Folder)
Set-Location -LiteralPath $Root
. ./importer.ps1 *> $null
& (Get-Module Catzc.Base.QualityGates) {
    param($folder)
    function script:Get-LanguageTestFolders { [pscustomobject]@{ Language = 'python'; Folder = $folder; Module = 'Catzc.Widget' } }
    function script:Get-PythonTestCases {
        [pscustomobject]@{ Title = 'test_widget_spins'; Key = 'test_widget_spins'; Category = 'logic' }
        [pscustomobject]@{ Title = 'test_gadget_turns'; Key = 'test_gadget_turns'; Category = 'logic' }
    }
    function script:Get-LanguageTestOutcomes { throw 'ruff check failed in python/tests/widget/ (exit 1): F401 `os` imported but unused' }
} $Folder
$container = New-PesterContainer -Path $Bridge -Data @{ Language = 'python'; TestFolder = $Folder }
$configuration = New-PesterConfiguration
$configuration.Run.Container = $container
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = 'None'
$result = Invoke-Pester -Configuration $configuration
foreach ($test in $result.Tests) {
    "$($test.Result)|$($test.ExpandedName)|$($test.ErrorRecord.Exception.Message -join ' ')"
}
'@
    }

    It 'fails every case of every engine with the engine run message, never as a parent-block failure' {
        $run = Invoke-Executable "pwsh -NoProfile -File `"$script:child`" -Root `"$script:root`" -Bridge `"$script:bridge`" -Folder `"$script:folder`"" `
            -WorkingDirectory $script:root -PassThru -NoAssert -Silent -TimeoutSeconds 120
        $rows = @($run.Output -split "`r?`n" | Where-Object { $_ -match '^(Passed|Failed|Skipped|NotRun)\|' })
        $rows.Count | Should -Be (2 * [Catzc.Base.Engines.ExecutionEngines]::Names.Count) -Because $run.Full
        foreach ($row in $rows) {
            $result, $name, $message = $row -split '\|', 3
            $result | Should -BeExactly 'Failed' -Because $name
            $message | Should -BeLike 'The * run failed before its cases ran: ruff check failed in python/tests/widget/*F401*' -Because $name
            $message | Should -Not -BeLike '*setup in some parent block*' -Because $name
        }
    }
}

Describe 'Language.Bridge setup errors' -Tag 'L2', 'logic', 'ADR-AUTO-TEST-COLLAPSEINPUTCLUSTERS' {
    BeforeAll {
        $script:root = Get-RepositoryRoot
        $script:bridge = Get-CatzcModuleRoot 'assets/Language.Bridge.ps1' -Module Catzc.Base.QualityGates
        $script:folder = Join-Path $TestDrive 'python/tests/widget'
        $null = New-Item -ItemType Directory -Path $script:folder -Force
        # The child stubs the bridge's three module runners, so a run that fails before its cases is the only thing under test; one child answers both inputs, the plain folder and the folder named as the engine proof.
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
function Invoke-BridgeRun([string] $Scope) {
    $container = New-PesterContainer -Path $Bridge -Data @{ Language = 'python'; TestFolder = $Folder }
    $configuration = New-PesterConfiguration
    $configuration.Run.Container = $container
    $configuration.Run.PassThru = $true
    $configuration.Output.Verbosity = 'None'
    $result = Invoke-Pester -Configuration $configuration
    foreach ($test in $result.Tests) {
        "$Scope|$($test.Result)|$($test.ExpandedName)|$($test.ErrorRecord.Exception.Message -join ' ')"
    }
}
Invoke-BridgeRun -Scope plain
$global:proofFolder = $Folder
function global:Get-Config { [pscustomobject]@{ engine_proof = @($global:proofFolder) } }
Invoke-BridgeRun -Scope proof
'@
        $script:run = Invoke-Executable "pwsh -NoProfile -File `"$script:child`" -Root `"$script:root`" -Bridge `"$script:bridge`" -Folder `"$script:folder`"" `
            -WorkingDirectory $script:root -PassThru -NoAssert -Silent -TimeoutSeconds 180
        $script:rows = @($script:run.Output -split "`r?`n" | Where-Object { $_ -match '^(plain|proof)\|' })
    }

    It 'fails every case of <label> with the engine run message, never as a parent-block failure' -ForEach @(
        @{ scope = 'plain'; label = 'the engine'; engines = 1 }
        @{ scope = 'proof'; label = 'every engine of the engine proof'; engines = [Catzc.Base.Engines.ExecutionEngines]::Names.Count }
    ) {
        $rows = @($script:rows | Where-Object { $_ -like "$scope|*" })
        $rows.Count | Should -Be (2 * $engines) -Because $script:run.Full
        foreach ($row in $rows) {
            $null, $result, $name, $message = $row -split '\|', 4
            $result | Should -BeExactly 'Failed' -Because $name
            $message | Should -BeLike 'The * run failed before its cases ran: ruff check failed in python/tests/widget/*F401*' -Because $name
            $message | Should -Not -BeLike '*setup in some parent block*' -Because $name
        }
    }
}

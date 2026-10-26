Describe 'Get-VsCodeSession' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'modules'
        $script:shadow = Join-Path $TestDrive 'shadow'
        New-Item -ItemType Directory -Path $script:shadow -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $script:shadow 'Catzc.Types.widget01.dll') -Value 'widget'
        Set-Content -LiteralPath (Join-Path $script:shadow 'Catzc.Types.widget02.dll') -Value 'widget'
        Mock Get-TypesShadowRoot -ModuleName Catzc.Base.VSCode { $script:shadow }

        $script:logs = Join-Path $TestDrive 'logs'
        $newest = Join-Path $script:logs '20260101T000000/window1/exthost/ms-vscode.powershell'
        New-Item -ItemType Directory -Path $newest -Force | Out-Null
        New-Item -ItemType Directory -Path (Join-Path $script:logs '20250101T000000') -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $newest 'PowerShell.log') -Value @(
            '[info] Starting PowerShell (x64)',
            '[info] PowerShell process started with PID: 1',
            '[info] Failed to get file for fileUri',
            '[warning] PowerShell process terminated or Extension Terminal was closed, PID: 1'
        )

        Mock Get-LoadedTypeDrift -ModuleName Catzc.Base.VSCode {
            [pscustomobject]@{ Current = $false; LoadedHash = 'widget01'; SourceHash = 'widget02'; Drift = @('changed Mod.One/Alpha') }
        }
        Mock Get-FileLockingProcess -ModuleName Catzc.Base.VSCode {
            if ($Path -like '*widget01*') {
                [Catzc.Base.Files.FileLockingProcess]::new(42, 'pwsh.exe', 'pwsh', [datetime]::new(2026, 1, 1, 10, 0,
                    0), $null, $null)
            }
        }
    }

    BeforeEach {
        $script:termProgram = $env:TERM_PROGRAM
        $env:TERM_PROGRAM = 'vscode'
    }

    AfterEach {
        $env:TERM_PROGRAM = $script:termProgram
    }

    It 'refuses to run outside VS Code' {
        $env:TERM_PROGRAM = $null
        { Get-VsCodeSession -ModulesRoot $script:root -LogRoot $script:logs } | Should -Throw '*VS Code*'
    }

    It 'names the loaded instance, the sources hash and the drift of this session' {
        $session = Get-VsCodeSession -ModulesRoot $script:root -LogRoot $script:logs
        $session.HostName | Should -Be $Host.Name
        $session.ProcessId | Should -Be $PID
        $session.LoadedHash | Should -Be 'widget01'
        $session.SourceHash | Should -Be 'widget02'
        $session.Current | Should -BeFalse
        $session.Drift | Should -Be @('changed Mod.One/Alpha')
    }

    It 'lists the builds in the shadow root, and the held ones with their holders' {
        $session = Get-VsCodeSession -ModulesRoot $script:root -LogRoot $script:logs
        $session.Builds | Should -Be @('Catzc.Types.widget01.dll', 'Catzc.Types.widget02.dll')
        $session.HeldBuilds |
            Should -Be @('Catzc.Types.widget01.dll held by pwsh.exe (PID 42, started 2026-01-01 10:00)')
    }

    It 'reads the newest log session and only the extension log lines that start or end a session' {
        $session = Get-VsCodeSession -ModulesRoot $script:root -LogRoot $script:logs
        (Split-Path $session.LogSession -Leaf) | Should -Be '20260101T000000'
        $session.PowerShellLogLines.Count | Should -Be 3
        $session.PowerShellLogLines | Should -Not -Contain '[info] Failed to get file for fileUri'
    }

    It 'names the variables the editor and its extensions contributed' {
        $session = Get-VsCodeSession -ModulesRoot $script:root -LogRoot $script:logs
        $session.ContributedVariables | Should -Contain 'TERM_PROGRAM'
    }

    It 'tells the session in one line' {
        $session = Get-VsCodeSession -ModulesRoot $script:root -LogRoot $script:logs
        "$session" |
            Should -Be "pwsh $PID in $($Host.Name): types widget01 of sources widget02 (bound to an earlier instance); 1 held build(s)"
    }
}

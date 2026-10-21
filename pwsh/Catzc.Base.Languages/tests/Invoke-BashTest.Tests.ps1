<#
---
catzc:
  immutable:
    with_body_sha: "33535792828d"
  edges:
    docs: "[Invoke-BashTest.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Languages/Invoke-BashTest.ps1
    cites:
      - ADR-AUTO-TEST-NOOVERMOCKING
---
#>

Describe 'Invoke-BashTest' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:bashRoot = Join-Path $script:root 'bash'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:bashRoot 'tests/catzc-widget') -Force
        $null = New-Item -ItemType File -Path (Join-Path $script:bashRoot '.vendor/bats-core/bin/bats') -Force
        $null = New-Item -ItemType File -Path (Join-Path $script:root 'importer.sh') -Force
        $script:buildEntry = Join-Path $TestDrive 'build/Import-Catzc.ps1'
        $null = New-Item -ItemType File -Path $script:buildEntry -Force
        $script:widgetReport = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/bats-widget.xml')

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'languages' } {
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                        bash = [ordered]@{ extensions = @('.sh'); no_formatter = 'never'; naming = [ordered]@{ folder = 'kebab' } }
                    }
                })
        }
    }

    BeforeEach {
        $script:report = $script:widgetReport
        $script:exit = 1
        $script:seen = [System.Collections.Generic.List[object]]::new()
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Languages { 'C:\widget\engine\bash.exe' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $script:seen.Add([pscustomobject]@{
                    Command   = $Command
                    Directory = $WorkingDirectory
                    Engine    = $env:CATZC_ENGINE
                    Entry     = $env:CATZC_ENGINE_ENTRY
                    Importer  = $env:CATZC_IMPORTER
                    Root      = $env:CATZC_REPOSITORY_ROOT
                })
            if ($script:report) {
                $folder = [regex]::Match($Command, '--output "([^"]+)"').Groups[1].Value
                [System.IO.File]::WriteAllText((Join-Path $folder 'report.xml'), $script:report)
            }
            [Catzc.Base.Execution.CliResult]::new('bats output', '', $script:exit)
        }
    }

    Context 'the bats command' {
        It 'runs the vendored bats under bash from the Bash root, recursively, with a JUnit report' {
            $null = Invoke-BashTest Catzc.Widget
            $script:seen[0].Command | Should -BeLike '"C:\widget\engine\bash.exe" .vendor/bats-core/bin/bats --recursive --report-formatter junit --output "*" "tests/catzc-widget"'
            $script:seen[0].Directory | Should -Be $script:bashRoot
        }

        It 'passes the bash engine contract: importer.sh to source, the build entry for cats, and the root, then restores it' {
            $null = Invoke-BashTest Catzc.Widget -EntryScript $script:buildEntry
            $script:seen[0].Engine | Should -Be 'bash'
            $script:seen[0].Entry | Should -Be (Join-Path $script:root 'importer.sh').Replace('\', '/')
            $script:seen[0].Importer | Should -Be (Resolve-Path -LiteralPath $script:buildEntry).ProviderPath
            $script:seen[0].Root | Should -Be $script:root
            Test-Path Env:CATZC_ENGINE_ENTRY | Should -BeFalse
        }

        It 'runs the caller''s -EngineExecutable without locating bash itself' {
            $callerBash = Join-Path $TestDrive 'caller bash/bash.exe'
            $null = New-Item -ItemType File -Path $callerBash -Force
            $null = Invoke-BashTest Catzc.Widget -EngineExecutable $callerBash
            Should -Invoke Resolve-EngineExecutable -ModuleName Catzc.Base.Languages -Times 0 -Exactly
            $script:seen[0].Command | Should -BeLike "`"$callerBash`" *"
        }

        It 'throws when the module has no Bash test folder' {
            { Invoke-BashTest Catzc.Sprocket } | Should -Throw '*bash/tests/catzc-sprocket/ does not exist*'
        }

        It 'runs the named folder, a module''s own tests/ under the bash track, relative to the Bash root' {
            $own = Join-Path $script:bashRoot 'Widget.Kit/tests'
            $null = New-Item -ItemType Directory -Path $own -Force
            $null = Invoke-BashTest Widget.Kit -Folder $own
            $script:seen[0].Command | Should -BeLike '*--output "*" "Widget.Kit/tests"'
            { Invoke-BashTest Widget.Kit -Folder 'bash/Widget.Nothing/tests' } | Should -Throw '*bash/Widget.Nothing/tests/ does not exist*'
        }

        It 'throws with "Run Update-BatsVendor" when the vendored runner is missing, before running anything' {
            $bare = Join-Path $TestDrive 'bare-repo'
            $null = New-Item -ItemType Directory -Path (Join-Path $bare 'bash/tests/catzc-widget') -Force
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'bare-repo' }
            { Invoke-BashTest Catzc.Widget } | Should -Throw '*bats-core runner is missing*Run Update-BatsVendor*'
            $script:seen.Count | Should -Be 0
        }
    }

    Context 'the results' {
        It 'returns one record per test, with outcomes and categories' {
            $results = @(Invoke-BashTest Catzc.Widget)
            $results | Should -HaveCount 4
            ($results | Where-Object Name -EQ 'integrity: widget ships').Outcome | Should -Be 'fail'
            ($results | Where-Object Name -EQ 'integrity: widget ships').Category | Should -Be 'integrity'
        }

        It 'throws when bats fails with no failing test (no report: a .bats file that does not parse)' {
            $script:report = ''
            { Invoke-BashTest Catzc.Widget } | Should -Throw '*bats failed*exit 1*no failing test*'
        }
    }
}

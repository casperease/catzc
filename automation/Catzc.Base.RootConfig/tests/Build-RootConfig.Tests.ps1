<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
    kind: test
---
#>

# cspell:ignore nbeta nmodule  -- the escape-sequence artifacts in the "alpha`nbeta" and "`nmodule …" fixture strings
Describe 'Build-RootConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Isolate through the seams
        # ([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): mock the
        # config seam (Get-Config) and the generator
        # dispatch, and redirect the repository root to a fixture tree (TestKit) so Resolve-RepoPath binds
        # inside it.
        $script:fake = New-FakeRepositoryRoot -Files @{
            'sources/fixture.yml' = "alpha: 1`nbeta: 2`n"
        }
        $script:copyTarget = Join-Path $script:fake.Root 'fixture.yml'
        $script:genTarget = Join-Path $script:fake.Root 'generated.txt'

        Mock Write-Message -ModuleName Catzc.Base.RootConfig { }
        # The fake root is not the loaded code root, so the derived run mode reads 'build'; pin the source mode.
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'source' }
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { "rendered output`n" }
        # The link mechanism is its own unit (Set-FileLink.Tests.ps1) — here it is a mocked boundary, so these
        # tests assert only that the link branch dispatches to it and skips content composition.
        Mock Set-FileLink -ModuleName Catzc.Base.RootConfig { $false }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{
                files = @(
                    [pscustomobject]@{ target = 'fixture.yml'; source = 'sources/fixture.yml'; generator = $null; comment = 'hash'; optIn = $true; committed = $false; copyAsLink = $false }
                    [pscustomobject]@{ target = 'generated.txt'; source = $null; generator = 'Fake-Generator'; comment = 'none'; optIn = $true; committed = $true; copyAsLink = $false }
                    [pscustomobject]@{ target = 'linked.yml'; source = 'sources/fixture.yml'; generator = $null; comment = 'none'; optIn = $true; committed = $false; copyAsLink = $true }
                    [pscustomobject]@{ target = 'opted-out.yml'; source = 'sources/missing.yml'; generator = $null; comment = 'none'; optIn = $false; committed = $false; copyAsLink = $false }
                )
            }
        }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Remove-Item $script:copyTarget, $script:genTarget -Force -ErrorAction Ignore
    }

    It 'copies a source entry out with the hash header naming the source' {
        Build-RootConfig | Out-Null
        $text = [System.IO.File]::ReadAllText($script:copyTarget)
        ($text -split "`n")[0] | Should -Match '^# GENERATED FILE'
        $text | Should -Match ([regex]::Escape('sources/fixture.yml'))
        $text | Should -Match "alpha: 1`nbeta: 2"
    }

    It 'renders a generator entry through the dispatch, verbatim (no header injected)' {
        Build-RootConfig | Out-Null
        [System.IO.File]::ReadAllText($script:genTarget) | Should -BeExactly "rendered output`n"
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Name -eq 'Fake-Generator' -and $Target -eq 'generated.txt' }
    }

    It 'skips opted-out entries entirely (their missing source never throws)' {
        $result = Build-RootConfig -PassThru
        @($result.Target) | Should -Be @('fixture.yml', 'generated.txt', 'linked.yml')
    }

    It 'materialises a copyAsLink entry through Set-FileLink with the resolved paths' {
        Build-RootConfig | Out-Null
        Should -Invoke Set-FileLink -ModuleName Catzc.Base.RootConfig -Times 1 -Exactly -ParameterFilter {
            $Path -eq (Join-Path $script:fake.Root 'linked.yml') -and
            $Target -eq (Join-Path $script:fake.Root 'sources/fixture.yml')
        }
    }

    It 'skips content composition for a copyAsLink entry — nothing is written' {
        Build-RootConfig | Out-Null
        # Set-FileLink is mocked, so the target exists only if the copy path wrote it.
        Test-Path (Join-Path $script:fake.Root 'linked.yml') | Should -BeFalse
    }

    It 'passes -DryRun through to Set-FileLink' {
        Build-RootConfig -DryRun | Out-Null
        Should -Invoke Set-FileLink -ModuleName Catzc.Base.RootConfig -ParameterFilter { [bool] $DryRun }
    }

    It '-PassThru reports CopyAsLink per entry' {
        $result = Build-RootConfig -PassThru
        ($result | Where-Object { $_.Target -eq 'linked.yml' }).CopyAsLink | Should -BeTrue
        ($result | Where-Object { $_.Target -eq 'fixture.yml' }).CopyAsLink | Should -BeFalse
    }

    It 'treats a linked target as stale for a copy entry, even with identical content' {
        # A comment:none entry flipped back from copyAsLink: the composed copy is byte-identical to the source,
        # so only the is-link check can convert the leftover link back into an independent file.
        $sourceOnDisk = Join-Path $script:fake.Root 'sources/fixture.yml'
        New-Item -ItemType HardLink -Path $script:copyTarget -Target $sourceOnDisk | Out-Null

        $result = Build-RootConfig -Target 'fixture.yml' -PassThru
        $result.Changed | Should -BeTrue
        (Get-Item -LiteralPath $script:copyTarget -Force).LinkType | Should -BeNullOrEmpty
        # The source of truth is untouched by the severing write.
        [System.IO.File]::ReadAllText($sourceOnDisk) | Should -BeExactly "alpha: 1`nbeta: 2`n"
    }

    It 'is idempotent — a second run rewrites nothing' {
        Build-RootConfig | Out-Null
        $result = Build-RootConfig -PassThru
        ($result | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'with -DryRun does not write a missing target but reports the change' {
        $result = Build-RootConfig -DryRun -PassThru
        Test-Path $script:copyTarget | Should -BeFalse
        ($result | Where-Object { $_.Target -eq 'fixture.yml' }).Changed | Should -BeTrue
    }

    It '-Target filters to one entry' {
        $result = Build-RootConfig -Target 'fixture.yml' -PassThru
        @($result) | Should -HaveCount 1
        Test-Path $script:genTarget | Should -BeFalse
    }

    It 'throws when -Target matches no opted-in entry' {
        { Build-RootConfig -Target 'opted-out.yml' } | Should -Throw '*No opted-in root-config entry*'
    }

    It 'is a reported no-op in build mode — nothing is read, composed, or written' {
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'build' }
        Mock Write-FileIfChanged -ModuleName Catzc.Base.RootConfig { $true }
        Build-RootConfig | Should -BeNullOrEmpty
        Should -Invoke Write-FileIfChanged -ModuleName Catzc.Base.RootConfig -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Message -like '*built Catzc package*' }
    }
}

Describe 'Build-RootConfig — multi-file generator' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # A wildcard entry whose generator renders one { Target; Content } record per file; every file is written
        # on its own and reported in its own row. Neutral fixture names
        # ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
        $script:fake = New-FakeRepositoryRoot -Files @{
            'widgets/alpha/.keep' = ''
            'widgets/beta/.keep'  = ''
        }
        $script:alpha = Join-Path $script:fake.Root 'widgets/alpha/gadget.txt'
        $script:beta = Join-Path $script:fake.Root 'widgets/beta/gadget.txt'

        Mock Write-Message -ModuleName Catzc.Base.RootConfig { }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'source' }
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{ Target = 'widgets/alpha/gadget.txt'; Content = "alpha`n" }
            [pscustomobject]@{ Target = 'widgets/beta/gadget.txt'; Content = "beta`n" }
        }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{
                files = @(
                    [pscustomobject]@{ target = 'widgets/*/gadget.txt'; source = $null; generator = 'New-Widget'; comment = 'none'; optIn = $true; committed = $false; copyAsLink = $false }
                )
            }
        }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Remove-Item $script:alpha, $script:beta -Force -ErrorAction Ignore
    }

    It 'passes the wildcard target to the generator and writes every record' {
        Build-RootConfig | Out-Null
        [System.IO.File]::ReadAllText($script:alpha) | Should -BeExactly "alpha`n"
        [System.IO.File]::ReadAllText($script:beta) | Should -BeExactly "beta`n"
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Name -eq 'New-Widget' -and $Target -eq 'widgets/*/gadget.txt' }
    }

    It 'reports one row per file, each under its own target and the entry''s generator' {
        $result = Build-RootConfig -PassThru
        @($result.Target) | Should -Be @('widgets/alpha/gadget.txt', 'widgets/beta/gadget.txt')
        @($result.Path) | Should -Be @($script:alpha, $script:beta)
        @($result | Where-Object { $_.Generator -eq 'New-Widget' -and $_.Changed }) | Should -HaveCount 2
    }

    It 'rewrites only the stale file' {
        Build-RootConfig | Out-Null
        [System.IO.File]::WriteAllText($script:beta, "stale`n")
        $result = Build-RootConfig -PassThru
        @($result | Where-Object Changed).Target | Should -Be 'widgets/beta/gadget.txt'
        [System.IO.File]::ReadAllText($script:beta) | Should -BeExactly "beta`n"
    }

    It '-Target naming one file of the wildcard entry writes only that file' {
        $result = Build-RootConfig -Target 'widgets/beta/gadget.txt' -PassThru
        @($result) | Should -HaveCount 1
        $result.Target | Should -Be 'widgets/beta/gadget.txt'
        Test-Path $script:alpha | Should -BeFalse
    }

    It '-Target naming the pattern writes every file of the entry' {
        @(Build-RootConfig -Target 'widgets/*/gadget.txt' -PassThru) | Should -HaveCount 2
    }

    It 'throws when -Target matches the pattern but names no rendered file' {
        { Build-RootConfig -Target 'widgets/gamma/gadget.txt' } | Should -Throw "*renders no file 'widgets/gamma/gadget.txt'*"
    }
}

Describe 'Build-RootConfig — real rootconfig.yml' -Tag 'L1', 'integrity', 'source-only' {
    It 'resolves every opted-in entry without writing (sources exist, generators render)' {
        # -DryRun composes every opted-in target's content — a source file that is missing, or an unknown generator, throws.
        $result = Build-RootConfig -DryRun -PassThru -Silent
        @($result).Count | Should -BeGreaterThan 0
    }

    It 'renders every managed root file drift-free, importer.ps1 included (Test-GeneratedFiles)' {
        @(Build-RootConfig -DryRun -PassThru -Silent | Where-Object { $_.Target -eq 'importer.ps1' }) | Should -HaveCount 1
        $result = Test-GeneratedFiles -Generator Build-RootConfig -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Build-RootConfig — the real New-GoWorkspace generator, <_>/ root' -Tag 'L1', 'logic' -ForEach @('go', '.go') {
    BeforeAll {
        Import-InternalModule TestKit

        # The wiring the L0 tests mock away on both sides: a fixture registry names New-GoWorkspace, the real dispatch
        # calls it, and Build-RootConfig writes what it renders. Only the registry, the run mode, and the go pin are
        # mocked, so the result is independent of the shipped config
        # ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
        $script:goRoot = $_
        $script:fake = New-FakeRepositoryRoot -WorkingRootOnly -Files @{ "$($script:goRoot)/tests/widget/widget_test.go" = "package widget`n" }
        $script:registry = [Catzc.Base.RootConfig.RootConfigFiles]::new(@{
                files = @(
                    @{ target = 'go.work'; generator = 'New-GoWorkspace'; optIn = $true }
                    @{ target = '*/tests/*/go.mod'; generator = 'New-GoWorkspace'; optIn = $true }
                )
            })
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'rootconfig' } { $script:registry }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'source' }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.27' }
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        $script:report = Join-Path $TestDrive 'generated-files'
        $script:work = Join-Path $script:fake.Root 'go.work'
        $script:modTarget = "$($script:goRoot)/tests/widget/go.mod"
        $script:mod = Join-Path $script:fake.Root $script:modTarget
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'reports both missing files as stale, each attributed to New-GoWorkspace' {
        (Test-GeneratedFiles -Generator New-GoWorkspace -PassThru -OutputFolder $script:report).Issues | Should -Be @(
            "go.work: stale — New-GoWorkspace would change it; regenerate with: Build-RootConfig 'go.work'"
            "$($script:modTarget): stale — New-GoWorkspace would change it; regenerate with: Build-RootConfig '$($script:modTarget)'"
        )
    }

    It 'writes go.work and the go.mod under the Go root, with the pin as the go directive' {
        @(Build-RootConfig -PassThru -Silent).Target | Should -Be @('go.work', $script:modTarget)
        [System.IO.File]::ReadAllText($script:work) | Should -Match ("`n`t\./" + [regex]::Escape($script:goRoot) + "/tests/widget`n")
        [System.IO.File]::ReadAllText($script:work) | Should -Match "`ngo 1\.27`n"
        [System.IO.File]::ReadAllText($script:mod) | Should -Match "`nmodule catzc/go/tests/widget`n`ngo 1\.27`n$"
    }

    It 'is byte-stable: a second run changes nothing, and Test-GeneratedFiles passes' {
        $before = (Get-FileHash $script:work).Hash + (Get-FileHash $script:mod).Hash
        @(Build-RootConfig -PassThru -Silent | Where-Object Changed) | Should -HaveCount 0
        ((Get-FileHash $script:work).Hash + (Get-FileHash $script:mod).Hash) | Should -Be $before
        $result = Test-GeneratedFiles -Generator New-GoWorkspace -PassThru -OutputFolder $script:report
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'names the one stale go.mod, and Build-RootConfig with its path repairs only that file' {
        [System.IO.File]::WriteAllText($script:mod, "module stale`n")
        (Test-GeneratedFiles -Generator New-GoWorkspace -PassThru -OutputFolder $script:report).Issues |
            Should -Be @("$($script:modTarget): stale — New-GoWorkspace would change it; regenerate with: Build-RootConfig '$($script:modTarget)'")
        $rows = @(Build-RootConfig $script:modTarget -PassThru -Silent)
        $rows.Target | Should -Be $script:modTarget
        $rows.Changed | Should -BeTrue
        (Test-GeneratedFiles -Generator New-GoWorkspace -PassThru -OutputFolder $script:report).IssueCount | Should -Be 0
    }
}

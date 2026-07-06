# cspell:ignore nbeta  -- the escape-sequence artifact in the "alpha`nbeta" fixture strings
Describe 'Build-RootConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Isolate through the seams (ADR-PESTER:2): mock the config seam (Get-Config) and the generator
        # dispatch, and redirect the repository root to a fixture tree (TestKit) so Resolve-RepoPath binds
        # inside it.
        $script:fake = New-FakeRepositoryRoot -Files @{
            'sources/fixture.yml' = "alpha: 1`nbeta: 2`n"
        }
        $script:copyTarget = Join-Path $script:fake.Root 'fixture.yml'
        $script:genTarget = Join-Path $script:fake.Root 'generated.txt'

        Mock Write-Message -ModuleName Catzc.Base.RootConfig { }
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
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Name -eq 'Fake-Generator' }
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
}

Describe 'Build-RootConfig — real rootconfig.yml' -Tag 'L1', 'integrity' {
    It 'resolves every opted-in entry without writing (sources exist, generators render)' {
        # -DryRun composes every opted-in target's content — a missing source file or unknown generator throws.
        $result = Build-RootConfig -DryRun -PassThru -Silent
        @($result).Count | Should -BeGreaterThan 0
    }

    It 'renders importer.ps1 drift-free — the committed shim matches its generator' {
        $importer = @(Build-RootConfig -DryRun -PassThru -Silent | Where-Object { $_.Target -eq 'importer.ps1' })
        $importer | Should -HaveCount 1
        $importer[0].Changed | Should -BeFalse -Because 'the committed importer.ps1 must equal what New-Importer renders (regenerate with New-Importer -Force)'
    }
}

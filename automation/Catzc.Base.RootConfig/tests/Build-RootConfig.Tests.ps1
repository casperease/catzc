# cspell:ignore nbeta nmodule  -- the escape-sequence artifacts in the "alpha`nbeta" and "`nmodule …" fixture strings
Describe 'Build-RootConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        $script:fake = New-FakeRepositoryRoot -Files @{
            'sources/fixture.yml' = "alpha: 1`nbeta: 2`n"
        }
        $script:copyTarget = Join-Path $script:fake.Root 'fixture.yml'
        $script:genTarget = Join-Path $script:fake.Root 'generated.txt'

        Mock Write-Message -ModuleName Catzc.Base.RootConfig { }
        # The fixture generator is no loaded function, so the head's path for it is pinned.
        Mock Get-GeneratorPath -ModuleName Catzc.Base.Languages { "automation/Catzc.Widget/$Name.ps1" }
        # The fake root is not the loaded code root, so the derived run mode reads 'build'; pin the source mode.
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'source' }
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { "rendered output`n" }
        Mock Set-FileLink -ModuleName Catzc.Base.RootConfig { $false }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{
                files = @(
                    [pscustomobject]@{ target = 'fixture.yml'; source = 'sources/fixture.yml'; sources = @(); generator = $null; carrier = $null; optIn = $true; committed = $false; copyAsLink = $false }
                    [pscustomobject]@{ target = 'generated.txt'; source = $null; sources = @('sources/fixture.yml'); generator = 'Fake-Generator'; carrier = 'dotfile'; optIn = $true; committed = $true; copyAsLink = $false }
                    [pscustomobject]@{ target = 'linked.yml'; source = 'sources/fixture.yml'; sources = @(); generator = $null; carrier = $null; optIn = $true; committed = $false; copyAsLink = $true }
                    [pscustomobject]@{ target = 'opted-out.yml'; source = 'sources/missing.yml'; sources = @(); generator = $null; carrier = $null; optIn = $false; committed = $false; copyAsLink = $false }
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

    It 'copies a source entry out under a generated head naming the source and Build-RootConfig as its generator' {
        Build-RootConfig | Out-Null
        $text = [System.IO.File]::ReadAllText($script:copyTarget)
        $text | Should -MatchExactly '^# ---\n# catzc:\n#   immutable:\n#     with_body_sha: "?[0-9a-f]{12}"?\n#     repo_status: locked\n#     path: fixture\.yml\n#     source: sources/fixture\.yml\n#     kind: other\n#     language: yaml\n#     filetype: yml\n#     generator: automation/Catzc\.Widget/Build-RootConfig\.ps1\n# ---\n\nalpha: 1\nbeta: 2\n$'
    }

    It 'renders a generator entry through the dispatch, under a head naming the generator and its sources' {
        Build-RootConfig | Out-Null
        [System.IO.File]::ReadAllText($script:genTarget) | Should -MatchExactly '^# ---\n# catzc:\n#   immutable:\n#     with_body_sha: "?[0-9a-f]{12}"?\n#     repo_status: locked\n#     path: generated\.txt\n#     source: sources/fixture\.yml\n#     kind: other\n#     filetype: txt\n#     generator: automation/Catzc\.Widget/Fake-Generator\.ps1\n# ---\n\nrendered output\n$'
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

    It 'skips the whole render on a warm run, and renders again when a source or a target changed' -Tag 'ADR-AUTO-CACHE#10' {
        Build-RootConfig | Out-Null
        Build-RootConfig | Out-Null
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -Times 1 -Exactly

        [System.IO.File]::WriteAllText((Join-Path $script:fake.Root 'sources/fixture.yml'), "alpha: 1`nbeta: 3`n")
        Build-RootConfig | Out-Null
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -Times 2 -Exactly

        [System.IO.File]::AppendAllText($script:genTarget, "edited by hand`n")
        Build-RootConfig | Out-Null
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -Times 3 -Exactly
        [System.IO.File]::ReadAllText($script:genTarget) | Should -Not -Match 'edited by hand'

        [System.IO.File]::WriteAllText((Join-Path $script:fake.Root 'sources/fixture.yml'), "alpha: 1`nbeta: 2`n")
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

        $script:fake = New-FakeRepositoryRoot -Files @{
            'widgets/alpha/.keep' = ''
            'widgets/beta/.keep'  = ''
        }
        $script:alpha = Join-Path $script:fake.Root 'widgets/alpha/gadget.txt'
        $script:beta = Join-Path $script:fake.Root 'widgets/beta/gadget.txt'
        # The pattern of the generated head a generator's file carries, over the content the generator rendered; the body hash is any 12 hex digits.
        $script:headed = {
            param([string] $Target, [string] $Body)
            '^# ---\n# catzc:\n#   immutable:\n#     with_body_sha: "?[0-9a-f]{12}"?\n#     repo_status: locked\n#     path: ' + [regex]::Escape($Target) + '\n#     kind: other\n#     filetype: txt\n#     generator: automation/Catzc\.Widget/New-Widget\.ps1\n# ---\n\n' + [regex]::Escape($Body).Replace("`n", '\n') + '$'
        }

        Mock Write-Message -ModuleName Catzc.Base.RootConfig { }
        Mock Get-GeneratorPath -ModuleName Catzc.Base.Languages { "automation/Catzc.Widget/$Name.ps1" }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'source' }
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{ Target = 'widgets/alpha/gadget.txt'; Content = "alpha`n" }
            [pscustomobject]@{ Target = 'widgets/beta/gadget.txt'; Content = "beta`n" }
        }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{
                files = @(
                    [pscustomobject]@{ target = 'widgets/*/gadget.txt'; source = $null; sources = @(); generator = 'New-Widget'; carrier = 'dotfile'; optIn = $true; committed = $false; copyAsLink = $false }
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
        [System.IO.File]::ReadAllText($script:alpha) | Should -MatchExactly (& $script:headed 'widgets/alpha/gadget.txt' "alpha`n")
        [System.IO.File]::ReadAllText($script:beta) | Should -MatchExactly (& $script:headed 'widgets/beta/gadget.txt' "beta`n")
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
        [System.IO.File]::ReadAllText($script:beta) | Should -MatchExactly (& $script:headed 'widgets/beta/gadget.txt' "beta`n")
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

        $script:goRoot = $_
        $script:fake = New-FakeRepositoryRoot -WorkingRootOnly -Files @{ "$($script:goRoot)/tests/widget/widget_test.go" = "package widget`n" }
        $script:registry = [Catzc.Base.RootConfig.RootConfigFiles]::new(@{
                files = @(
                    @{ target = 'go.work'; generator = 'New-GoWorkspace'; carrier = 'go-workspace'; optIn = $true }
                    @{ target = '*/tests/*/go.mod'; generator = 'New-GoWorkspace'; carrier = 'go-workspace'; optIn = $true }
                )
            })
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'rootconfig' } { $script:registry }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.RootConfig { 'source' }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.27' }
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        # The fake root is no git checkout, so no file is tracked and none carries a stamp to check.
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { @() }
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

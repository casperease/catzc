Describe 'Install-Catzc' -Tag 'L0', 'logic' {
    BeforeEach {
        # A valid fake source bundle (Assert-CatzcBundle must pass on it).
        $script:source = Join-Path $TestDrive ([System.Guid]::NewGuid())
        $compiled = Join-Path $source 'automation/.compiled'
        [System.IO.Directory]::CreateDirectory($compiled) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $compiled 'Catzc.Types.abc12345.dll'), 'MZ')
        $moduleDir = Join-Path $source 'automation/Catzc.Base.Widget'
        [System.IO.Directory]::CreateDirectory($moduleDir) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Get-Widget.ps1'), 'function Get-Widget { }')
        [System.IO.File]::WriteAllText((Join-Path $source 'importer.ps1'), '# source bundle importer')
        $hash = Get-CatzcContentHash -Path $source -Exclude 'build.json'
        [System.IO.File]::WriteAllText((Join-Path $source 'build.json'), (@{ contentHash = $hash } | ConvertTo-Json))

        $script:root = Join-Path $TestDrive ([System.Guid]::NewGuid())
    }

    It 'installs the module under the root .vendor and writes the importer at the root' {
        $result = Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent
        Test-Path (Join-Path $root '.vendor/Catzc/6.6.666/automation/Catzc.Base.Widget/Get-Widget.ps1') | Should -BeTrue
        Test-Path (Join-Path $root '.vendor/Catzc/6.6.666/build.json') | Should -BeTrue
        Test-Path $result.Importer | Should -BeTrue
    }

    It 'does not copy the source bundle importer into the installed module (two-part)' {
        Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent | Out-Null
        Test-Path (Join-Path $root '.vendor/Catzc/6.6.666/importer.ps1') | Should -BeFalse
    }

    It 'writes a root importer that points CatzcModulesRoot at the installed module' {
        Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText((Join-Path $root 'importer.ps1'))
        $text | Should -BeLike '*CatzcModulesRoot*.vendor/Catzc/6.6.666/automation*'
        $text | Should -BeLike '*Invoke-Importer -Bundle*'
    }

    It 'is idempotent — a re-install with the same content is reported already-current' {
        Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent | Out-Null
        $sentinel = Join-Path $root '.vendor/Catzc/6.6.666/automation/marker.txt'
        [System.IO.File]::WriteAllText($sentinel, 'kept')
        $again = Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent
        $again.AlreadyCurrent | Should -BeTrue
        Test-Path $sentinel | Should -BeTrue   # not re-copied
    }

    It 'with -Force re-copies the module' {
        Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent | Out-Null
        $sentinel = Join-Path $root '.vendor/Catzc/6.6.666/automation/marker.txt'
        [System.IO.File]::WriteAllText($sentinel, 'wiped')
        Install-Catzc -Root $root -Source $source -Version 6.6.666 -Force -Silent | Out-Null
        Test-Path $sentinel | Should -BeFalse   # a clean re-copy removed it
    }

    It 'with -DryRun writes nothing' {
        Install-Catzc -Root $root -Source $source -Version 6.6.666 -DryRun -Silent | Out-Null
        Test-Path (Join-Path $root 'importer.ps1') | Should -BeFalse
        Test-Path (Join-Path $root '.vendor/Catzc/6.6.666') | Should -BeFalse
    }

    It 'refuses an invalid source bundle' {
        [System.IO.File]::Delete((Join-Path $source 'build.json'))
        { Install-Catzc -Root $root -Source $source -Version 6.6.666 -Silent } | Should -Throw
    }
}

Describe 'Catzc bundle install-and-load (walking skeleton)' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        # Build to an isolated out root, install two-part into TestDrive, then load in a child pwsh.
        Mock Get-OutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Base.Exporter
        $built = Build-Catzc -Silent
        $script:root = Join-Path $TestDrive 'destination'
        Install-Catzc -Root $script:root -Source $built.Path -Version $built.Version -Silent | Out-Null

        $probe = Join-Path $TestDrive 'probe.ps1'
        $template = @'
. (Join-Path 'ROOT_PLACEHOLDER' 'importer.ps1')
[pscustomobject]@{ Repo = $env:RepositoryRoot; Modules = $env:CatzcModulesRoot; Out = (Get-OutputRoot); Tools = (Get-Config -Config tools).node_js.version; Ver = (Get-CatzcVersion); Name = (Get-AzureResourceName -Env dev -Region weu -Org fin -ShortName disco -Type rg) } | ConvertTo-Json -Compress
'@
        [System.IO.File]::WriteAllText($probe, $template.Replace('ROOT_PLACEHOLDER', $script:root))
        $script:loaded = pwsh -NoProfile -File $probe | ConvertFrom-Json
    }

    It 'loads the platform from the installed root, outside the repo (no .git)' {
        $script:loaded.Repo | Should -Be $script:root
        Test-Path (Join-Path $script:root '.git') | Should -BeFalse
    }

    It 'points CatzcModulesRoot at the installed module and out at the working root' {
        $script:loaded.Modules | Should -BeLike '*.vendor*Catzc*6.6.666*automation'
        $script:loaded.Out | Should -Be (Join-Path $script:root 'out')
    }

    It 'resolves config from the installed bundle' {
        $script:loaded.Tools | Should -Be '24'
    }

    It 'runs a real cross-module typed function (types from the prebuilt DLL, no Roslyn)' {
        $script:loaded.Name | Should -Be 'dev-weu-fin-disco-rg'
    }

    It 'reports the direct-install sentinel version' {
        $script:loaded.Ver | Should -Be '6.6.666'
    }
}

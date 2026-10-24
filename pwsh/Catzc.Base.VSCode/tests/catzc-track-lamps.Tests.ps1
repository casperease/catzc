Describe 'catzc-track-lamps' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:script = (Resolve-Path (Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps.js')).Path -replace '\\', '/'
        # Runs one exported function of the extension under node with JSON arguments and returns its JSON result.
        $script:call = {
            param([string] $Function, [object[]] $Arguments)
            $argumentFile = Join-Path $TestDrive 'arguments.json'
            [System.IO.File]::WriteAllText($argumentFile, (ConvertTo-Json -InputObject @($Arguments) -Depth 8 -Compress))
            $driver = "const m = require('$script:script'); const a = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'));" +
            " if ('$Function' === 'hiddenGlobs') a[1] = new Set(a[1]);" +
            " process.stdout.write(JSON.stringify(m['$Function'](...a)));"
            $output = & node -e $driver $argumentFile
            $LASTEXITCODE | Should -Be 0 -Because 'node runs the extension''s pure functions without an editor'
            # An array result enumerates into its items, an object result is one hashtable.
            $output | ConvertFrom-Json -AsHashtable
        }
        $script:covers = [ordered]@{ live = @('mods/Widget/Get-Widget.ps1'); tests = @('mods/Widget/tests', 'gadgets') }
        $script:known = [ordered]@{ markdown = @('.md'); yaml = @('.yml', '.yaml') }
        $script:root = (Join-Path $TestDrive 'repo') -replace '\\', '/'
        foreach ($file in 'mods/Widget/Get-Widget.ps1', 'mods/Widget/tests/Get-Widget.Tests.ps1', 'mods/Widget/README.md', 'gadgets/a.ps1', 'docs/x.md') {
            $null = New-Item -ItemType File -Force -Path (Join-Path $script:root $file)
        }
    }

    It 'hides nothing while every lamp is lit, which is the default' {
        @(& $script:call hiddenGlobs @($script:root, @(), 'markdown', $script:covers, $script:known)) | Should -HaveCount 0
    }

    It 'hides everything not marked live, on disk, while the fixtures lamp is unlit' {
        $globs = & $script:call hiddenGlobs @($script:root, @('fixtures'), '', $script:covers, $script:known)
        $globs | Should -Be @('docs', 'gadgets', 'mods/Widget/README.md', 'mods/Widget/tests')
    }

    It 'hides exactly the live cover while the live lamp is unlit' {
        & $script:call hiddenGlobs @($script:root, @('live'), '', $script:covers, $script:known) | Should -Be @('mods/Widget/Get-Widget.ps1')
    }

    It 'folds a folder whose every entry is hidden into the folder' {
        & $script:call hiddenGlobs @($script:root, @('live', 'fixtures'), '', $script:covers, $script:known) | Should -Be @('docs', 'gadgets', 'mods')
    }

    It 'hides every extension of each typed language while the language lamp is unlit' {
        $globs = & $script:call hiddenGlobs @($script:root, @('languages'), ' markdown ,yaml', $script:covers, $script:known)
        $globs | Should -Be @('**/*.md', '**/*.yaml', '**/*.yml')
    }

    It 'hides no language while the language lamp is lit, and ignores a language it does not know' {
        @(& $script:call hiddenGlobs @($script:root, @(), 'markdown', $script:covers, $script:known)) | Should -HaveCount 0
        & $script:call hiddenGlobs @($script:root, @('languages'), 'widgetish, markdown', $script:covers, $script:known) | Should -Be @('**/*.md')
    }

    It 'keeps every authored exclusion, drops the keys it added before, and never owns a key the settings already carry' {
        $result = & $script:call merge @([ordered]@{ '**/tmp' = $true; 'old/lamp' = $true; 'shared' = $true }, @('old/lamp'), @('shared', 'new/lamp'))
        @($result.next.Keys | Sort-Object) | Should -Be @('**/tmp', 'new/lamp', 'shared')
        $result.ours | Should -Be @('new/lamp')
    }
}

Describe 'catzc-track-lamps — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:cover = Get-AspectCover
        $script:tracked = @(Get-TrackedFile)
        $script:under = { param([string] $Path, [string[]] $Covers) @($Covers).Where({ $Path -ceq $_ -or $Path.StartsWith("$_/", [System.StringComparison]::Ordinal) }).Count -gt 0 }
    }

    It 'covers by the tests aspect every tracked file a folder module keeps in its tests folder' {
        # Aspects belong to units, so only a unit's tests are in scope; a holder track's files (docs, contracts) are in no aspect.
        $modules = Get-CatzcModulesFolder
        $tests = $script:tracked.Where({ $_ -like "$modules/*/tests/*" -and $_ -notlike "$modules/.*" })
        $tests.Count | Should -BeGreaterThan 0
        $tests.Where({ -not (& $script:under $_ $script:cover['tests']) }) | Should -BeNullOrEmpty
    }

    It 'puts out with the fixtures lamp everything on disk but the live files, and never a live file' {
        $root = (Get-RepositoryRoot) -replace '\\', '/'
        $script = (Resolve-Path (Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps.js')).Path -replace '\\', '/'
        $liveFile = Join-Path $TestDrive 'live.json'
        [System.IO.File]::WriteAllText($liveFile, (ConvertTo-Json -InputObject @($script:cover['live']) -Compress))
        $globs = @(& node -e "const m = require('$script'); const live = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8')); process.stdout.write(JSON.stringify(m.notLive('$root', live)));" $liveFile | ConvertFrom-Json)
        $globs | Should -Contain 'docs'
        $globs | Should -Contain 'go'
        $globs | Should -Not -Contain 'infrastructure' -Because 'the infrastructure track is live'
        foreach ($place in $script:cover['live']) {
            @($globs).Where({ $place -ceq $_ -or $place.StartsWith("$_/", [System.StringComparison]::Ordinal) }) | Should -BeNullOrEmpty -Because "$place is live"
        }
    }

    It 'never covers a live file by the tests aspect' {
        $languages = Get-Config -Config languages
        $live = $script:tracked.Where({ ($row = $languages.PlaceOf($_)) -and $row.live })
        $live.Where({ & $script:under $_ $script:cover['tests'] }) | Should -BeNullOrEmpty
    }

    It 'keeps the aspects disjoint: no tracked file under two aspects'' covers' {
        $script:tracked.Where({ (& $script:under $_ $script:cover['live']) -and (& $script:under $_ $script:cover['tests']) }) | Should -BeNullOrEmpty
    }

    It 'renders into the editor settings the covers the repository has now' {
        $settings = Get-Content -LiteralPath (Join-Path (Get-RepositoryRoot) '.vscode/settings.json') -Raw
        $rendered = (($settings -split "`n").Where({ $_ -notmatch '^\s*//' }) -join "`n" | ConvertFrom-Json -AsHashtable)['catzc.trackLamps.aspects']
        foreach ($name in $script:cover.Keys) {
            @($rendered[$name]) | Should -Be @($script:cover[$name]) -Because "a stale $name cover hides the wrong files"
        }
    }
}

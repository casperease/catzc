Describe 'catzc-track-lamps' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:script = (Resolve-Path (Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps.js')).Path -replace '\\', '/'
        # Runs one exported function of the extension under node with JSON arguments and returns its JSON result.
        $script:call = {
            param([string] $Function, [object[]] $Arguments)
            $argumentFile = Join-Path $TestDrive 'arguments.json'
            [System.IO.File]::WriteAllText($argumentFile, (ConvertTo-Json -InputObject @($Arguments) -Depth 8 -Compress))
            $driver = "const m = require('$script:script'); const a = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'));" +
            " if ('$Function' === 'hiddenGlobs' || '$Function' === 'census') a[1] = new Set(a[1]);" +
            " Promise.resolve(m['$Function'](...a)).then((r) => process.stdout.write(JSON.stringify(r)));"
            $output = & node -e $driver $argumentFile
            $LASTEXITCODE | Should -Be 0 -Because 'node runs the extension''s pure functions without an editor'
            # An array result enumerates into its items, an object result is one hashtable.
            $output | ConvertFrom-Json -AsHashtable
        }
        $script:covers = [ordered]@{ live = @('mods/Widget/Get-Widget.ps1'); tests = @('mods/Widget/tests', 'gadgets') }
        $script:known = [ordered]@{ markdown = @('.md'); yaml = @('.yml', '.yaml') }
        $script:tools = @('gadgets')
        $script:root = (Join-Path $TestDrive 'repo') -replace '\\', '/'
        foreach ($file in 'mods/Widget/Get-Widget.ps1', 'mods/Widget/tests/Get-Widget.Tests.ps1', 'mods/Widget/README.md', 'gadgets/a.ps1', 'docs/x.md') {
            $null = New-Item -ItemType File -Force -Path (Join-Path $script:root $file)
        }
    }

    It 'hides nothing while every lamp is lit, which is the default' {
        @(& $script:call hiddenGlobs @($script:root, @(), 'markdown', $script:covers, $script:known)) | Should -HaveCount 0
    }

    It 'hides exactly the live cover while the code lamp is unlit' {
        & $script:call hiddenGlobs @($script:root, @('code'), '', $script:covers, $script:known, $script:tools) | Should -Be @('mods/Widget/Get-Widget.ps1')
    }

    It 'hides exactly the vendor configuration while the tools lamp is unlit' {
        & $script:call hiddenGlobs @($script:root, @('tools'), '', $script:covers, $script:known, $script:tools) | Should -Be @('gadgets')
    }

    It 'hides everything on disk that is neither code nor tools while the tests lamp is unlit' {
        $globs = & $script:call hiddenGlobs @($script:root, @('tests'), '', $script:covers, $script:known, $script:tools)
        $globs | Should -Be @('docs', 'mods/Widget/README.md', 'mods/Widget/tests')
    }

    It 'hides the whole tree with every lamp unlit, folding each emptied folder' {
        & $script:call hiddenGlobs @($script:root, @('code', 'tests', 'tools'), '', $script:covers, $script:known, $script:tools) |
            Should -Be @('docs', 'gadgets', 'mods')
    }

    It 'takes a dead folder out of the tree while a lamp is unlit, whether the lamps emptied it or it is empty on disk' {
        $root = (Join-Path $TestDrive 'dead') -replace '\\', '/'
        foreach ($file in 'mods/Widget/Get-Widget.ps1', 'mods/Widget/tests/Get-Widget.Tests.ps1', 'notes/a.md', 'notes/b.md') {
            $null = New-Item -ItemType File -Force -Path (Join-Path $root $file)
        }
        $null = New-Item -ItemType Directory -Force -Path (Join-Path $root 'empty/deeper')
        $covers = [ordered]@{ live = @('mods/Widget/Get-Widget.ps1') }
        & $script:call hiddenGlobs @($root, @('code'), '', $covers, $script:known) | Should -Be @('empty', 'mods/Widget/Get-Widget.ps1')
        & $script:call hiddenGlobs @($root, @('languages'), 'markdown', $covers, $script:known) | Should -Be @('**/*.md', 'empty', 'notes')
        @(& $script:call hiddenGlobs @($root, @(), '', $covers, $script:known)) | Should -HaveCount 0 -Because 'all lamps lit shows the tree as without the extension'
    }

    It 'hides every extension of each typed language while the language lamp is unlit' {
        $globs = & $script:call hiddenGlobs @($script:root, @('languages'), ' markdown ,yaml', $script:covers, $script:known)
        $globs | Should -Be @('**/*.md', '**/*.yaml', '**/*.yml', 'docs') -Because 'docs holds only markdown, so it is a dead folder'
    }

    It 'hides no language while the language lamp is lit, and ignores a language it does not know' {
        @(& $script:call hiddenGlobs @($script:root, @(), 'markdown', $script:covers, $script:known)) | Should -HaveCount 0
        & $script:call hiddenGlobs @($script:root, @('languages'), 'widgetish, markdown', $script:covers, $script:known) | Should -Be @('**/*.md', 'docs')
    }

    It 'accounts for every file on disk: each lamp''s files, the files shown, and none against its lamp' {
        $globs = @(& $script:call hiddenGlobs @($script:root, @('tests'), '', $script:covers, $script:known, $script:tools))
        $tally = & $script:call census @($script:root, @('tests'), '', $script:covers, $script:known, $script:tools, $globs)
        $tally.total | Should -Be 5
        $tally.lamps.code | Should -Be 1
        $tally.lamps.tools | Should -Be 1
        $tally.lamps.tests | Should -Be 3
        $tally.shown | Should -Be 2
        @($tally.wrong) | Should -HaveCount 0
    }

    It 'hides every generated target while the generated lamp is off, whichever lamp holds it, and counts it as accounted for' {
        $generated = @('**/README.md')
        $globs = @(& $script:call hiddenGlobs @($script:root, @('generated'), '', $script:covers, $script:known, $script:tools, $generated))
        $globs | Should -Be @('**/README.md')
        $tally = & $script:call census @($script:root, @('generated'), '', $script:covers, $script:known, $script:tools, $globs, $generated)
        $tally.generated | Should -Be 1
        $tally.shown | Should -Be 4
        @($tally.wrong) | Should -HaveCount 0
    }

    It 'matches globs the way the repository reads them: ** any depth, * inside one segment' {
        $driver = "const m = require('$script:script'); const t = (g, p) => m.globMatcher(g)(p) ? 1 : 0;" +
        " process.stdout.write([t('out/**', 'out/a/b'), t('pwsh/*/*.psd1', 'pwsh/W/W.psd1'), t('pwsh/*/*.psd1', 'pwsh/W/x/W.psd1'), t('**/.gitkeep', '.gitkeep'), t('docs/**/.assets/*.png', 'docs/.assets/a.png')].join(''));"
        & node -e $driver | Should -Be '11011'
    }

    It 'reports a filter that went bananas: a file hidden or shown against its lamp' {
        $tally = & $script:call census @($script:root, @('tests'), '', $script:covers, $script:known, $script:tools, @('gadgets'))
        @($tally.wrong) | Should -Be @('docs/x.md', 'gadgets/a.ps1', 'mods/Widget/README.md', 'mods/Widget/tests/Get-Widget.Tests.ps1')
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

    It 'covers by the tests aspect every tracked file a module or the internal modules'' folder keeps in its tests folder' {
        # Aspects belong to units, so only a unit's tests are in scope; a holder track's files (docs, contracts) are in no aspect.
        $modules = Get-CatzcModulesFolder
        # Vendored code is no unit: its own test folders are tools, never this repository's tests.
        $tests = $script:tracked.Where({ $_ -clike "$modules/*/tests/*" -and $_ -notlike "$modules/.scriptanalyzer/*" -and $_ -notlike "$modules/.vendor/*" })
        $tests.Where({ $_ -like "$modules/.internal/tests/*" }).Count | Should -BeGreaterThan 0
        $tests.Where({ -not (& $script:under $_ $script:cover['tests']) }) | Should -BeNullOrEmpty
    }

    It 'marks every real config live, so the code lamp shows it: each module''s configs, the python modules'' and the internal modules''' {
        $configs = $script:tracked.Where({ $_ -like 'pwsh/*/configs/*.yml' -or $_ -like 'python/*/configs/*.yml' }) + @('pwsh/.internal/assets/types-load.yml')
        $configs.Where({ $_ -like 'python/*' }).Count | Should -BeGreaterThan 0
        $configs.Where({ -not (& $script:under $_ $script:cover['live']) }) | Should -BeNullOrEmpty
    }

    It 'puts out with the tests lamp everything on disk but the live files, and never a live file' {
        $root = (Get-RepositoryRoot) -replace '\\', '/'
        $script = (Resolve-Path (Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps.js')).Path -replace '\\', '/'
        $liveFile = Join-Path $TestDrive 'live.json'
        [System.IO.File]::WriteAllText($liveFile, (ConvertTo-Json -InputObject @($script:cover['live']) -Compress))
        $globs = @(& node -e "const m = require('$script'); const live = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8')); m.rest('$root', live).then((r) => process.stdout.write(JSON.stringify(r)));" $liveFile | ConvertFrom-Json)
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

    It 'accounts for every file on disk with each lamp off in turn: none shown or hidden against its lamp' {
        $root = (Get-RepositoryRoot) -replace '\\', '/'
        $script = (Resolve-Path (Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps.js')).Path -replace '\\', '/'
        $settings = Get-Content -LiteralPath (Join-Path $root '.vscode/settings.json') -Raw
        $rendered = ($settings -split "`n").Where({ $_ -notmatch '^\s*//' }) -join "`n" | ConvertFrom-Json -AsHashtable
        $lampFile = Join-Path $TestDrive 'lamps.json'
        [System.IO.File]::WriteAllText($lampFile, (ConvertTo-Json -InputObject ([ordered]@{
                        covers = $rendered['catzc.trackLamps.aspects']; tools = @($rendered['catzc.trackLamps.tools'])
                        generated = @($rendered['catzc.trackLamps.generated'])
                    }) -Depth 6 -Compress))
        $driver = "const m = require('$script'); const d = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'));" +
        " (async () => { const r = {}; for (const lamp of ['code', 'tests', 'tools', 'generated']) { const out = new Set([lamp]);" +
        " const g = await m.hiddenGlobs('$root', out, '', d.covers, {}, d.tools, d.generated); const t = await m.census('$root', out, '', d.covers, {}, d.tools, g, d.generated);" +
        " r[lamp] = { wrong: t.wrong.length, sum: t.lamps.code + t.lamps.tests + t.lamps.tools, total: t.total, first: t.wrong.slice(0, 3) }; }" +
        " process.stdout.write(JSON.stringify(r)); })();"
        $result = & node -e $driver $lampFile | ConvertFrom-Json -AsHashtable
        foreach ($lamp in 'code', 'tests', 'tools', 'generated') {
            $result[$lamp].wrong | Should -Be 0 -Because "with $lamp off no file may go against its lamp (first: $($result[$lamp].first -join ', '))"
            $result[$lamp].sum | Should -Be $result[$lamp].total -Because 'every file is code, tests or tools'
        }
    }

    It 'ships an on and an off icon for every lamp, each an SVG file the manifest names and the asset folder holds' {
        $entry = (Get-Config -Config vscode-extensions).extensions.Where({ $_.name -ceq 'catzc-track-lamps' })[0]
        $folder = Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps'
        $icons = @($entry.contributes['commands']).ForEach({ $_['icon']['dark'], $_['icon']['light'] }) | Sort-Object -Unique
        foreach ($icon in $icons) {
            $icon | Should -Match '^media/[a-z]+-(on|off)\.svg$'
            $file = Join-Path $folder ($icon -replace '^media/', '')
            Test-Path -LiteralPath $file | Should -BeTrue -Because "the manifest names $icon"
            ([xml](Get-Content -LiteralPath $file -Raw)).DocumentElement.LocalName | Should -Be 'svg'
        }
        foreach ($lamp in 'code', 'tests', 'tools', 'generated', 'languages') {
            $icons | Should -Contain "media/$lamp-on.svg"
            $icons | Should -Contain "media/$lamp-off.svg"
        }
    }

    It 'renders into the editor settings the covers the repository has now' {
        $settings = Get-Content -LiteralPath (Join-Path (Get-RepositoryRoot) '.vscode/settings.json') -Raw
        $rendered = (($settings -split "`n").Where({ $_ -notmatch '^\s*//' }) -join "`n" | ConvertFrom-Json -AsHashtable)['catzc.trackLamps.aspects']
        foreach ($name in $script:cover.Keys) {
            @($rendered[$name]) | Should -Be @($script:cover[$name]) -Because "a stale $name cover hides the wrong files"
        }
    }
}

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
        # Five files, claimed by overlapping filters of include/exclude sets: the README by tests (the module but its live file) and by
        # generated.
        $script:set = { param([string[]] $Include, [string[]] $Exclude = @()) [ordered]@{ include = $Include; exclude = $Exclude } }
        $script:filters = [ordered]@{
            code      = @(& $script:set @('mods/Widget/Get-Widget.ps1'))
            tests     = @(& $script:set @('mods/Widget/**') @('mods/Widget/Get-Widget.ps1'))
            tools     = @(& $script:set @('gadgets', 'gadgets/**'))
            generated = @(& $script:set @('**/README.md'))
            docs      = @(& $script:set @('docs', 'docs/**'))
        }
        $script:known = [ordered]@{ markdown = @('.md'); yaml = @('.yml', '.yaml') }
        $script:root = (Join-Path $TestDrive 'repo') -replace '\\', '/'
        foreach ($file in 'mods/Widget/Get-Widget.ps1', 'mods/Widget/tests/Get-Widget.Tests.ps1', 'mods/Widget/README.md', 'gadgets/a.ps1', 'docs/x.md') {
            $null = New-Item -ItemType File -Force -Path (Join-Path $script:root $file)
        }
        $script:hidden = { param([string[]] $Out, [string] $Field = '', [string] $Root = $script:root) & $script:call hiddenGlobs @($Root, $Out, $Field, $script:filters, $script:known) }
    }

    It 'hides nothing while every lamp is lit, which is the default' {
        @(& $script:hidden @()) | Should -HaveCount 0
    }

    It 'hides exactly what an unlit filter claims' {
        & $script:hidden @('code') | Should -Be @('mods/Widget/Get-Widget.ps1')
        & $script:hidden @('tools') | Should -Be @('gadgets')
    }

    It 'hides a file while any filter claiming it is unlit, so overlapping filters need no precedence (hide wins)' {
        & $script:hidden @('generated') | Should -Be @('mods/Widget/README.md')
        & $script:hidden @('tests') | Should -Be @('mods/Widget/README.md', 'mods/Widget/tests') -Because 'the README is tests as well as generated'
    }

    It 'classifies by the sets, so an exclude keeps a file out and a new file is classified with no list to update' {
        $null = New-Item -ItemType File -Force -Path (Join-Path $script:root 'mods/Widget/New-Widget.ps1')
        try {
            & $script:hidden @('code') | Should -Be @('mods/Widget/Get-Widget.ps1') -Because 'the new file is no live path'
            & $script:hidden @('tests') | Should -Be @('mods/Widget/New-Widget.ps1', 'mods/Widget/README.md', 'mods/Widget/tests')
        }
        finally {
            Remove-Item -LiteralPath (Join-Path $script:root 'mods/Widget/New-Widget.ps1')
        }
    }

    It 'takes a folder out of the tree when nothing in it is shown, as its topmost dead folder' {
        & $script:hidden @('code', 'tests', 'tools', 'docs') | Should -Be @('docs', 'gadgets', 'mods')
        $root = (Join-Path $TestDrive 'empty-on-disk') -replace '\\', '/'
        $null = New-Item -ItemType File -Force -Path (Join-Path $root 'mods/Widget/Get-Widget.ps1')
        $null = New-Item -ItemType Directory -Force -Path (Join-Path $root 'empty/deeper')
        & $script:hidden @('tools') '' $root | Should -Be @('empty') -Because 'a folder empty on disk is dead while any lamp is unlit'
    }

    It 'hides every extension of each typed language while the language lamp is unlit, and ignores a language it does not know' {
        & $script:hidden @('languages') ' markdown ,widgetish' | Should -Be @('**/*.md', 'docs') -Because 'docs holds only markdown, so it is a dead folder'
        @(& $script:hidden @() 'markdown') | Should -HaveCount 0
    }

    It 'writes a path in its on-disk spelling and matches without case on Windows' -Skip:(-not $IsWindows) {
        $filters = [ordered]@{ code = @(& $script:set @('mods/widget/get-widget.ps1')) }
        & $script:call hiddenGlobs @($script:root, @('code'), '', $filters, $script:known) | Should -BeExactly @('mods/Widget/Get-Widget.ps1')
    }

    It 'accounts for every file: its signature, the files shown, and none against its filters or unclaimed' {
        $globs = @(& $script:hidden @('tests'))
        $tally = & $script:call census @($script:root, @('tests'), '', $script:filters, $script:known, $globs)
        $tally.total | Should -Be 5
        $tally.shown | Should -Be 3
        $tally.signatures['tests+generated'] | Should -Be 1
        $tally.signatures['code'] | Should -Be 1
        @($tally.wrong) | Should -HaveCount 0
        @($tally.unclaimed) | Should -HaveCount 0
    }

    It 'reports a filter that went bananas, and a file no filter claims' {
        $tally = & $script:call census @($script:root, @('tests'), '', $script:filters, $script:known, @('gadgets'))
        @($tally.wrong | Sort-Object) | Should -Be @('gadgets/a.ps1', 'mods/Widget/README.md', 'mods/Widget/tests/Get-Widget.Tests.ps1')
        $root = (Join-Path $TestDrive 'unclaimed') -replace '\\', '/'
        $null = New-Item -ItemType File -Force -Path (Join-Path $root 'loose.txt')
        @((& $script:call census @($root, @(), '', $script:filters, $script:known, @())).unclaimed) | Should -Be @('loose.txt')
    }

    It 'matches globs the way the repository reads them: ** any depth, * inside one segment' {
        $driver = "const m = require('$script:script'); const t = (g, p) => m.globMatcher(g)(p) ? 1 : 0;" +
        " process.stdout.write([t('out/**', 'out/a/b'), t('pwsh/*/*.psd1', 'pwsh/W/W.psd1'), t('pwsh/*/*.psd1', 'pwsh/W/x/W.psd1'), t('**/.gitkeep', '.gitkeep'), t('docs/**/.assets/*.png', 'docs/.assets/a.png')].join(''));"
        & node -e $driver | Should -Be '11011'
    }

    It 'keeps every authored exclusion, drops the keys it added before, and never owns a key the settings already carry' {
        $result = & $script:call merge @([ordered]@{ '**/tmp' = $true; 'old/lamp' = $true; 'shared' = $true }, @('old/lamp'), @('shared', 'new/lamp'))
        @($result.next.Keys | Sort-Object) | Should -Be @('**/tmp', 'new/lamp', 'shared')
        $result.ours | Should -Be @('new/lamp')
    }
}

Describe 'catzc-track-lamps — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:aspects = Get-AspectGlobSet
        $script:tracked = @(Get-TrackedFile)
        $script:inAspect = { param([string] $Path, [string] $Aspect) @($script:aspects[$Aspect]).Where({ $_.Matches($Path) }, 'First').Count -gt 0 }
        $script:declared = @((Get-Config -Config filters).filters.ForEach({ $_.name }))
    }

    It 'puts in the tests aspect every tracked file a module or the internal modules'' folder keeps in its tests folder' {
        # Aspects belong to units, so only a unit's tests are in scope; vendored code is no unit, its test folders are tools.
        $modules = Get-CatzcModulesFolder
        $tests = $script:tracked.Where({ $_ -clike "$modules/*/tests/*" -and $_ -notlike "$modules/.vendor/*" })
        $tests.Where({ $_ -like "$modules/.internal/tests/*" }).Count | Should -BeGreaterThan 0
        $tests.Where({ -not (& $script:inAspect $_ 'tests') }) | Should -BeNullOrEmpty
    }

    It 'marks every real config live: each module''s configs, the python modules'' and the internal modules''' {
        $configs = $script:tracked.Where({ $_ -like 'pwsh/*/configs/*.yml' -or $_ -like 'python/*/configs/*.yml' }) + @('pwsh/.internal/assets/types-load.yml')
        $configs.Where({ $_ -like 'python/*' }).Count | Should -BeGreaterThan 0
        $configs.Where({ -not (& $script:inAspect $_ 'live') }) | Should -BeNullOrEmpty
    }

    It 'renders into the editor settings the filters the repository has now' {
        $settings = Get-Content -LiteralPath (Join-Path (Get-RepositoryRoot) '.vscode/settings.json') -Raw
        $rendered = (($settings -split "`n").Where({ $_ -notmatch '^\s*//' }) -join "`n" | ConvertFrom-Json -AsHashtable)['catzc.trackLamps.filters']
        @($rendered.Keys) | Should -Be $script:declared -Because 'the lamps follow the declaration order'
        foreach ($filter in Get-RepositoryFilter) {
            ConvertTo-Json -InputObject @($rendered[$filter.name]) -Depth 6 -Compress |
                Should -Be (ConvertTo-Json -InputObject @($filter.sets) -Depth 6 -Compress) -Because "a stale $($filter.name) filter hides the wrong files"
        }
    }

    It 'accounts for every file on disk with each filter off in turn: none against its filters, none unclaimed' {
        $root = (Get-RepositoryRoot) -replace '\\', '/'
        $script = (Resolve-Path (Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps.js')).Path -replace '\\', '/'
        $filterFile = Join-Path $TestDrive 'filters.json'
        $resolved = [ordered]@{}
        foreach ($filter in Get-RepositoryFilter) { $resolved[$filter.name] = @($filter.sets) }
        [System.IO.File]::WriteAllText($filterFile, (ConvertTo-Json -InputObject $resolved -Depth 8 -Compress))
        $driver = "const m = require('$script'); const f = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'));" +
        " (async () => { const r = {}; for (const lamp of Object.keys(f)) { const out = new Set([lamp]);" +
        " const g = await m.hiddenGlobs('$root', out, '', f, {}); const t = await m.census('$root', out, '', f, {}, g);" +
        " r[lamp] = { wrong: t.wrong.length, unclaimed: t.unclaimed.length, first: t.wrong.concat(t.unclaimed).slice(0, 3) }; }" +
        " process.stdout.write(JSON.stringify(r)); })();"
        $result = & node -e $driver $filterFile | ConvertFrom-Json -AsHashtable
        foreach ($lamp in $script:declared) {
            $result[$lamp].wrong | Should -Be 0 -Because "with $lamp off no file may go against its filters (first: $($result[$lamp].first -join ', '))"
            $result[$lamp].unclaimed | Should -Be 0 -Because "every file on disk belongs to a filter (first: $($result[$lamp].first -join ', '))"
        }
    }

    It 'gives every declared filter a lamp and no lamp without a filter: an on and an off command, each with its SVG icon' {
        $entry = (Get-Config -Config vscode-extensions).extensions.Where({ $_.name -ceq 'catzc-track-lamps' })[0]
        $commands = @($entry.contributes['commands'])
        $lamps = @($commands.ForEach({ $_['command'] -replace '^catzc\.lamps\.([a-z_]+)\.(putOut|light)$', '$1' }) | Select-Object -Unique)
        ($lamps | Sort-Object) | Should -Be (@($script:declared) + 'languages' | Sort-Object)
        $folder = Join-Path $PSScriptRoot '../assets/extensions/catzc-track-lamps'
        foreach ($lamp in $lamps) {
            foreach ($state in 'on', 'off') {
                $icons = @($commands.ForEach({ $_['icon']['dark'] }))
                $icons | Should -Contain "media/$lamp-$state.svg"
                ([xml](Get-Content -LiteralPath (Join-Path $folder "$lamp-$state.svg") -Raw)).DocumentElement.LocalName | Should -Be 'svg'
            }
        }
    }
}

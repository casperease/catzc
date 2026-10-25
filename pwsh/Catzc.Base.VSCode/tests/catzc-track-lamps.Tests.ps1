<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/tests/catzc-track-lamps.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'catzc-track-lamps' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:script = (Resolve-Path (Join-Path (Get-RepositoryRoot) 'js/catzc-track-lamps/extension.js')).Path -replace '\\', '/'
        # Runs one exported function of the extension under node with JSON arguments and returns its JSON result.
        $script:call = {
            param([string] $Function, [object[]] $Arguments)
            $argumentFile = Join-Path $TestDrive 'arguments.json'
            [System.IO.File]::WriteAllText($argumentFile, (ConvertTo-Json -InputObject @($Arguments) -Depth 8 -Compress))
            $driver = "const m = require('$script:script'); const a = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'));" +
            " if (['hiddenGlobs', 'census', 'evaluate'].includes('$Function')) a[1] = new Set(a[1]);" +
            " Promise.resolve(m['$Function'](...a)).then((r) => process.stdout.write(JSON.stringify(r)));"
            $output = & node -e $driver $argumentFile
            $LASTEXITCODE | Should -Be 0 -Because 'node runs the extension''s pure functions without an editor'
            # An array result enumerates into its items, an object result is one hashtable.
            $output | ConvertFrom-Json -AsHashtable
        }
    }

    # The engine-core cases run in node: js/catzc-track-lamps/tests/ (Invoke-JavaScriptTest); the shared vectors stay here, read from yml.
    It 'answers every shared vector of the lamp language: the files shown, the files no lamp claims, each lamp''s condition' {
        $vectors = Get-Content -LiteralPath (Join-Path $PSScriptRoot '../../Catzc.Base.Globs/tests/assets/lamp-vectors.yml') -Raw | ConvertFrom-Yaml -Ordered
        $vectors.cases.Count | Should -BeGreaterThan 0
        foreach ($case in $vectors.cases) {
            $answer = & $script:call evaluate @($vectors.lamps, @($case.lit), @($vectors.files), $case.facts)
            @($answer.shown | Sort-Object) | Should -Be @($case.shown | Sort-Object) -Because "$($case.name): shown"
            @($answer.unaccounted | Sort-Object) | Should -Be @($case.unaccounted | Sort-Object) -Because "$($case.name): unaccounted"
            foreach ($lamp in $case.conditions.Keys) {
                $answer.conditions[$lamp] | Should -Be $case.conditions[$lamp] -Because "$($case.name): the $lamp lamp's condition"
            }
        }
    }

    Context 'activated in a stub editor' {
        BeforeAll {
            $script:harness = (Resolve-Path (Join-Path $PSScriptRoot 'assets/catzc-track-lamps-harness.js')).Path
            # Runs one scenario of the harness over its own small repository and returns what the stub editor recorded.
            $script:scenario = {
                param([string] $Name, [switch] $WithEngine)
                $root = Join-Path $TestDrive "stub-$Name"
                foreach ($file in 'code/a.ps1', 'docs/x.md') {
                    $null = New-Item -ItemType File -Force -Path (Join-Path $root $file)
                }
                if ($WithEngine) {
                    $engine = Join-Path $root 'js/catzc-track-lamps/extension.js'
                    $null = New-Item -ItemType Directory -Force -Path (Split-Path $engine)
                    Copy-Item -LiteralPath $script:script -Destination $engine
                }
                $output = & node $script:harness $Name ($root -replace '\\', '/') $script:script 2>&1
                $LASTEXITCODE | Should -Be 0 -Because "the $Name scenario runs to its end: $output"
                $output | ConvertFrom-Json -AsHashtable
            }
        }

        It 'keeps a lamp that is not shipped out of the title row, logs the mismatch once, and sends no key when nothing changed' {
            $result = & $script:scenario keys
            $result.shownCode | Should -BeTrue
            $result.shownWidget | Should -BeFalse -Because 'the preview flag is off, so only shipped lamps reach the menu'
            $result.summary | Should -Not -BeNullOrEmpty -Because 'the orchestrator always has a colour'
            $result.mismatchLogs | Should -Be 1 -Because 'the shipped-lamps assert speaks once per mismatch, not on every call'
            $result.sentAfterNoChange | Should -Be 0 -Because 'a re-judge that changes nothing sends no context key'
        }

        It 'runs presses through one queue: no write overlaps another, and the last press has the last word' {
            $result = & $script:scenario queue
            $result.maxConcurrent | Should -Be 1
            @($result.afterThree) | Should -Contain 'code' -Because 'code was put out and docs vetoed, so code is hidden'
            @($result.afterThree) | Should -Contain 'docs'
            @($result.last) | Should -HaveCount 0 -Because 'both lamps were lit again by the last presses, so nothing is hidden'
            @($result.out) | Should -HaveCount 0
        }

        It 'keeps the disk index current from the editor''s file events' {
            $result = & $script:scenario index
            @($result.before) | Should -Be @('docs')
            @($result.afterCreate) | Should -Be @('docs', 'notes') -Because 'a created file the unlit docs lamp claims is hidden at once'
            @($result.afterDelete) | Should -Be @('notes') -Because 'the deleted file leaves docs empty on disk, and an empty folder shows'
        }

        It 'swaps the repository''s engine on a save, every old part disposed first, and falls back to its own copy when it does not load' {
            $result = & $script:scenario swap -WithEngine
            $result.first.light | Should -BeTrue -Because 'the shell runs the repository''s engine'
            $result.swapped.light | Should -BeTrue
            $result.swapped.registered | Should -BeGreaterThan $result.first.registered -Because 'the saved engine registered its commands anew'
            $result.swapped.disposed | Should -BeGreaterThan 0 -Because 'the old engine was disposed before the new one started'
            $result.broken.light | Should -BeTrue -Because 'the package''s own copy runs when the repository''s does not load'
            $result.broken.fellBack | Should -BeTrue
            @($result.duplicates) | Should -HaveCount 0 -Because 'no command is ever registered twice at once'
        }
    }

    It 'keeps files.exclude under the roof the editor''s processes take, for each shipped lamp off and vetoed in turn and for every lamp off' -Tag 'L1' {
        $repository = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path -replace '\\', '/'
        $harness = (Resolve-Path (Join-Path $PSScriptRoot 'assets/catzc-track-lamps-harness.js')).Path
        $output = & node $harness roof $repository $script:script 2>&1
        $LASTEXITCODE | Should -Be 0 -Because "the roof scenario runs: $output"
        $result = $output | ConvertFrom-Json -AsHashtable
        @($result.states).Count | Should -BeGreaterThan 20 -Because 'every shipped lamp is measured off and vetoed'
        foreach ($state in $result.states) {
            $state.size | Should -BeLessOrEqual $result.roof -Because "$($state.state) writes $($state.size) characters, over the $($result.roof) a spawned search or watcher process takes (spawn ENAMETOOLONG)"
        }
    }

}

Describe 'catzc-track-lamps — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:aspects = Get-AspectGlobSet
        $script:tracked = @(Get-TrackedFile)
        $script:inAspect = {
            param([string] $Path, [string] $Aspect)
            foreach ($set in @($script:aspects[$Aspect])) {
                if ($set.Matches($Path)) {
                    return $true
                }
            }
            $false
        }
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
        $script = (Resolve-Path (Join-Path $root 'js/catzc-track-lamps/extension.js')).Path -replace '\\', '/'
        $filterFile = Join-Path $TestDrive 'filters.json'
        $resolved = [ordered]@{}
        foreach ($filter in Get-RepositoryFilter) {
            $resolved[$filter.name] = @($filter.sets)
        }
        [System.IO.File]::WriteAllText($filterFile, (ConvertTo-Json -InputObject $resolved -Depth 8 -Compress))
        $driver = "const m = require('$script'); const f = JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'));" +
        ' (async () => { const r = {}; for (const lamp of Object.keys(f)) { const out = new Set([lamp]);' +
        " const g = await m.hiddenGlobs('$root', out, '', f, {}); const t = await m.census('$root', out, '', f, {}, g);" +
        ' r[lamp] = { wrong: t.wrong.length, unclaimed: t.unclaimed.length, first: t.wrong.concat(t.unclaimed).slice(0, 3) }; }' +
        ' process.stdout.write(JSON.stringify(r)); })();'
        $result = & node -e $driver $filterFile | ConvertFrom-Json -AsHashtable
        foreach ($lamp in $script:declared) {
            $result[$lamp].wrong | Should -Be 0 -Because "with $lamp off no file may go against its filters (first: $($result[$lamp].first -join ', '))"
            $result[$lamp].unclaimed | Should -Be 0 -Because "every file on disk belongs to a filter (first: $($result[$lamp].first -join ', '))"
        }
    }

    It 'gives every declared filter a lamp and no lamp without a filter: a veto and a light command per condition and one putOut, each with its SVG icon and one menu item' {
        $entry = (Get-Config -Config vscode-extensions).extensions.Where({ $_.name -ceq 'catzc-track-lamps' })[0]
        $contributes = InModuleScope Catzc.Base.VSCode -Parameters @{ Contributes = $entry.contributes } {
            param($Contributes)
            Expand-VsCodeCommandState -Contributes (Expand-VsCodeRepeat -Contributes $Contributes)
        }
        $all = @($contributes['commands'])
        # The orchestrator is no lamp: one command per colour, each with its icon, leftmost in the title row.
        $orchestrator = @($all.Where({ $_['command'] -like 'catzc.lamps.orchestrate.*' }))
        @($orchestrator.ForEach({ $_['command'] })) | Should -Be @('catzc.lamps.orchestrate.red', 'catzc.lamps.orchestrate.blue', 'catzc.lamps.orchestrate.green')
        # The open lamp is no switch either: one next command per condition, its empty icon drawn invisible.
        $next = @($all.Where({ $_['command'] -like 'catzc.lamps.open.next*' }))
        @($next.ForEach({ $_['command'] })) | Should -Be @('catzc.lamps.open.next', 'catzc.lamps.open.next.staged', 'catzc.lamps.open.next.unstaged', 'catzc.lamps.open.next.failed', 'catzc.lamps.open.next.empty')
        $commands = @($all.Where({ $_['command'] -notlike 'catzc.lamps.orchestrate.*' -and $_['command'] -notlike 'catzc.lamps.open.next*' }))
        $pattern = '^catzc\.lamps\.([a-z_]+)\.(putOut|veto|light)(\.(staged|unstaged|failed|empty))?$'
        $commands.Where({ $_['command'] -notmatch $pattern }).ForEach({ $_['command'] }) | Should -BeNullOrEmpty
        $lamps = @($commands.ForEach({ $_['command'] -replace $pattern, '$1' }) | Select-Object -Unique)
        $lamps | Should -Be (@($script:declared) + 'languages') -Because 'the filters lead in order and languages closes; the open lamp switches nothing'
        # Only the base glyphs are authored: every condition variant is rendered into the extension folder's media/.
        $rendered = InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $entry; Out = (Join-Path $TestDrive 'lamps') } {
            param($Entry, $Out)
            New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out
        }
        $folder = Join-Path $rendered 'media'
        $icons = @($commands.ForEach({ $_['icon']['dark'] }))
        $menu = @($contributes['menus']['view/title'])
        foreach ($lamp in $lamps) {
            foreach ($switch in 'on', 'off') {
                foreach ($condition in '', '-staged', '-unstaged', '-failed', '-empty') {
                    $icons | Should -Contain "media/$lamp-$switch$condition.svg"
                    ([xml](Get-Content -LiteralPath (Join-Path $folder "$lamp-$switch$condition.svg") -Raw)).DocumentElement.LocalName | Should -Be 'svg'
                }
            }
            $icons | Should -Contain "media/$lamp-veto.svg"
            ([xml](Get-Content -LiteralPath (Join-Path $folder "$lamp-veto.svg") -Raw)).DocumentElement.LocalName | Should -Be 'svg'
        }
        foreach ($command in $orchestrator) {
            ([xml](Get-Content -LiteralPath (Join-Path $folder ($command['icon']['dark'] -replace '^media/', '')) -Raw)).DocumentElement.LocalName | Should -Be 'svg'
            @($menu.Where({ $_['command'] -ceq $command['command'] -and $_['group'] -ceq 'navigation@0' })) | Should -HaveCount 1 -Because "$($command['command']) shows leftmost, once"
        }
        foreach ($command in @($commands) + @($next)) {
            @($menu.Where({ $_['command'] -ceq $command['command'] })) | Should -HaveCount 1 -Because "$($command['command']) shows in the title row once"
        }
        foreach ($command in $next) {
            $svg = [xml](Get-Content -LiteralPath (Join-Path $folder ($command['icon']['dark'] -replace '^media/', '')) -Raw)
            $invisible = $command['command'] -ceq 'catzc.lamps.open.next.empty'
            ($svg.DocumentElement.GetAttribute('opacity') -eq '0') | Should -Be $invisible -Because "only the open lamp's empty icon is invisible ($($command['command']))"
            $svg.DocumentElement.HasAttribute('data-empty') | Should -BeFalse -Because 'the marker is the renderer''s, never shipped'
        }
    }
}

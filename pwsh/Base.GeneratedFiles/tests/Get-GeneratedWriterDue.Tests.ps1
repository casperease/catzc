Describe 'Get-GeneratedWriterDue' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        $script:memo = Join-Path $TestDrive 'cache/generated-writers.json'
        # The writer rows in the order the registry's graph renders them, as Get-GeneratedWriterOrder answers.
        $script:rows = @(
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; inputs = @('widget/**'); outputs = @('docs/index.md') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Gadget', [ordered]@{ class = 'rollable'; inputs = @('gadget/*.yml'); outputs = @('docs/missing.md') })
            # A writer whose ignored target is one of its own inputs, as the root configs declare theirs.
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Sprocket', [ordered]@{ class = 'import-critical'; inputs = @('.sprocket.yml'); outputs = @('.sprocket.yml') })
            # A writer that writes one file into every folder a wildcard claims, as the root configs write each pyproject.toml.
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Cog', [ordered]@{ class = 'rollable'; inputs = @('cogs/*/cog.toml'); outputs = @('cogs/*/cog.lock') })
            # A writer whose output reads its own inputs, which the walk and the stamp count with the writer's.
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Gizmo', [ordered]@{ class = 'rollable'; outputs = @([ordered]@{ path = 'gizmo/*.png'; inputs = @('gizmo/*.yml') }) })
            # An untracked writer whose broad glob overlaps the narrower glob of Build-Cog, which claims the paths both match.
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Sprue', [ordered]@{ class = 'untracked'; inputs = @('sprue.yml'); outputs = @('cogs/**') })
        )
        # The paths the mocked git index tracks.
        $script:indexed = @()
        $script:write = {
            param([string] $Path, [string] $Text)
            $full = Join-Path $script:root $Path
            [void] [System.IO.Directory]::CreateDirectory((Split-Path $full))
            [System.IO.File]::WriteAllText($full, $Text)
        }
        # One judgement over the fixture tree and memo.
        $script:run = {
            InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Memo = $script:memo } {
                param($Root, $Memo)
                Get-GeneratedWriterDue -RepositoryRoot $Root -MemoPath $Memo
            }
        }
        # Stores a writer's stamp, as the importer does once the writer ran.
        $script:ran = {
            param([string] $Name)
            InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Name = $Name; Memo = $script:memo } {
                param($Root, $Name, $Memo)
                Save-GeneratedWriterStamp -Name $Name -RepositoryRoot $Root -MemoPath $Memo
            }
        }
        $script:due = { param($Rows, [string] $Name) ($Rows | Where-Object Name -eq $Name).Due }
    }

    BeforeEach {
        Mock Get-GeneratedWriterOrder -ModuleName Catzc.Base.GeneratedFiles { $script:rows }
        $script:indexed = @()
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.GeneratedFiles { $script:indexed }
        Remove-Item -LiteralPath $script:root, $script:memo -Recurse -ErrorAction Ignore
        & $script:write 'docs/index.md' 'widget'
        & $script:write 'widget/spin.txt' 'gadget'
        & $script:write '.sprocket.yml' 'sprocket: 1'
    }

    It 'is due when an input file changed since the last run, and not when none did' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        & $script:ran 'Build-Widget'
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeFalse
        & $script:write 'widget/spin.txt' 'gadget, wound'
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeTrue
    }

    It 'is due when an input only an output declares changed' {
        & $script:write 'gizmo/cog.yml' 'gizmo: 1'
        & $script:write 'gizmo/cog.png' 'gizmo'
        & $script:ran 'Build-Gizmo'
        & $script:due @(& $script:run) 'Build-Gizmo' | Should -BeFalse
        & $script:write 'gizmo/cog.yml' 'gizmo: 2'
        & $script:due @(& $script:run) 'Build-Gizmo' | Should -BeTrue
    }

    It 'is not due when only an output changed' {
        & $script:ran 'Build-Widget'
        & $script:write 'docs/index.md' 'widget, edited'
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeFalse
    }

    It 'is due when a commit changed an input, and never reads git' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.GeneratedFiles { }
        & $script:ran 'Build-Widget'
        & $script:write 'widget/spin.txt' 'gadget, pulled'
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeTrue
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'is due when an ignored target it declares as an input drifted' {
        & $script:ran 'Build-Sprocket'
        & $script:write '.sprocket.yml' 'sprocket: 2'
        & $script:due @(& $script:run) 'Build-Sprocket' | Should -BeTrue
    }

    It 'is due when a new folder appears that a wildcard input could write into, before the file exists' {
        & $script:write 'cogs/alpha/cog.toml' 'cog: alpha'
        & $script:write 'cogs/alpha/cog.lock' 'lock: alpha'
        & $script:ran 'Build-Cog'
        & $script:due @(& $script:run) 'Build-Cog' | Should -BeFalse
        [void] [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'cogs/beta'))
        & $script:due @(& $script:run) 'Build-Cog' | Should -BeTrue
    }

    It 'is not due when the same files carry the stamp stored at the last run' {
        & $script:ran 'Build-Widget'
        & $script:ran 'Build-Sprocket'
        $rows = @(& $script:run)
        & $script:due $rows 'Build-Widget' | Should -BeFalse
        & $script:due $rows 'Build-Sprocket' | Should -BeFalse
    }

    It 'is due when the memo is missing or unreadable' {
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeTrue
        [void] [System.IO.Directory]::CreateDirectory((Split-Path $script:memo))
        [System.IO.File]::WriteAllText($script:memo, '{ not json')
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeTrue
    }

    It 'is due when an output named without a wildcard is missing, with its stamp current' {
        & $script:ran 'Build-Gadget'
        & $script:due @(& $script:run) 'Build-Gadget' | Should -BeTrue
    }

    It 'is due when the index tracks a path under a wildcard output that is gone from disk, with its stamp current' -Tag 'ADR-REPO-ROOTCFG-ROLLOFFROUNDTRIP' {
        & $script:write 'cogs/alpha/cog.toml' 'cog: alpha'
        & $script:write 'cogs/alpha/cog.lock' 'lock: alpha'
        & $script:ran 'Build-Cog'
        $script:indexed = @('cogs/alpha/cog.lock')
        & $script:due @(& $script:run) 'Build-Cog' | Should -BeFalse
        $script:indexed = @('cogs/alpha/cog.lock', 'cogs/beta/cog.lock')
        & $script:due @(& $script:run) 'Build-Cog' | Should -BeTrue
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $Path -ccontains 'cogs/' -and $Path -ccontains 'gizmo/' }
    }

    It 'is not due for a tracked path gone from disk that a narrower glob of another writer claims' {
        & $script:write 'sprue.yml' 'sprue: 1'
        & $script:write 'cogs/alpha/cog.lock' 'lock: alpha'
        & $script:ran 'Build-Sprue'
        $script:indexed = @('cogs/alpha/cog.lock', 'cogs/beta/cog.lock')
        & $script:due @(& $script:run) 'Build-Sprue' | Should -BeFalse
    }

    It 'is due when a rollable wildcard output matches nothing on disk, though the index lists none of it, with its stamp current' -Tag 'ADR-REPO-ROOTCFG-ROLLOFFROUNDTRIP' {
        & $script:write 'gizmo/cog.yml' 'gizmo: 1'
        & $script:ran 'Build-Gizmo'
        & $script:due @(& $script:run) 'Build-Gizmo' | Should -BeTrue
        & $script:write 'gizmo/cog.png' 'gizmo'
        & $script:due @(& $script:run) 'Build-Gizmo' | Should -BeFalse
    }

    It 'is not due when a wildcard output of a writer that is not rollable matches nothing on disk' {
        & $script:write 'sprue.yml' 'sprue: 1'
        & $script:ran 'Build-Sprue'
        & $script:due @(& $script:run) 'Build-Sprue' | Should -BeFalse
    }

    It 'emits one typed record per writer, in the render order of the registry' -Tag 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
        $rows = @(& $script:run)
        $rows | Should -HaveCount 6
        $rows[0] | Should -BeOfType [Catzc.Base.GeneratedFiles.GeneratedWriterDue]
        @($rows.Name) | Should -Be @('Build-Widget', 'Build-Gadget', 'Build-Sprocket', 'Build-Cog', 'Build-Gizmo', 'Build-Sprue')
    }

    It 'judges only the writers it is named, and stores the stamp of a named writer only' {
        $rows = @(InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Memo = $script:memo } {
                param($Root, $Memo)
                Get-GeneratedWriterDue -Name 'Build-Gadget' -RepositoryRoot $Root -MemoPath $Memo
            })
        @($rows.Name) | Should -Be @('Build-Gadget')
        { & $script:ran 'Build-Widgets' } | Should -Throw "*'Build-Widgets' is not a writer of any module's generated.yml*"
    }
}

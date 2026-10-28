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
        )
        $script:write = {
            param([string] $Path, [string] $Text)
            $full = Join-Path $script:root $Path
            [void] [System.IO.Directory]::CreateDirectory((Split-Path $full))
            [System.IO.File]::WriteAllText($full, $Text)
        }
        # One judgement; -Changed is the git changed set, given so no test reads git.
        $script:run = {
            param([string[]] $Changed = @())
            InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Changed = $Changed; Memo = $script:memo } {
                param($Root, $Changed, $Memo)
                Get-GeneratedWriterDue -ChangedPath $Changed -RepositoryRoot $Root -MemoPath $Memo
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
        & $script:ran 'Build-Gizmo'
        & $script:due @(& $script:run) 'Build-Gizmo' | Should -BeFalse
        & $script:write 'gizmo/cog.yml' 'gizmo: 2'
        & $script:due @(& $script:run) 'Build-Gizmo' | Should -BeTrue
    }

    It 'is not due when only an output changed' {
        & $script:ran 'Build-Widget'
        & $script:write 'docs/index.md' 'widget, edited'
        & $script:due @(& $script:run @('docs/index.md')) 'Build-Widget' | Should -BeFalse
    }

    It 'is due when a commit changed an input and git shows no diff' {
        & $script:ran 'Build-Widget'
        & $script:write 'widget/spin.txt' 'gadget, pulled'
        & $script:due @(& $script:run @()) 'Build-Widget' | Should -BeTrue
    }

    It 'is due when an ignored target it declares as an input drifted' {
        & $script:ran 'Build-Sprocket'
        & $script:write '.sprocket.yml' 'sprocket: 2'
        & $script:due @(& $script:run) 'Build-Sprocket' | Should -BeTrue
    }

    It 'is due when a new folder appears that a wildcard input could write into, before the file exists' {
        & $script:write 'cogs/alpha/cog.toml' 'cog: alpha'
        & $script:ran 'Build-Cog'
        & $script:due @(& $script:run) 'Build-Cog' | Should -BeFalse
        [void] [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'cogs/beta'))
        & $script:due @(& $script:run) 'Build-Cog' | Should -BeTrue
    }

    It 'is not due when the same files carry the stamp stored at the last run' {
        & $script:ran 'Build-Widget'
        & $script:ran 'Build-Sprocket'
        $rows = @(& $script:run @('widget/spin.txt'))
        & $script:due $rows 'Build-Widget' | Should -BeFalse
        & $script:due $rows 'Build-Sprocket' | Should -BeFalse
    }

    It 'is due when the memo is missing or unreadable' {
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeTrue
        [void] [System.IO.Directory]::CreateDirectory((Split-Path $script:memo))
        [System.IO.File]::WriteAllText($script:memo, '{ not json')
        & $script:due @(& $script:run) 'Build-Widget' | Should -BeTrue
    }

    It 'is due when an output named without a wildcard is missing, whatever changed' {
        & $script:ran 'Build-Gadget'
        & $script:due @(& $script:run @('unrelated/b.txt')) 'Build-Gadget' | Should -BeTrue
    }

    It 'emits one typed record per writer, in the render order of the registry, each declaring its lists' -Tag 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
        $rows = @(& $script:run @())
        $rows | Should -HaveCount 5
        $rows[0] | Should -BeOfType [Catzc.Base.GeneratedFiles.GeneratedWriterDue]
        @($rows.Name) | Should -Be @('Build-Widget', 'Build-Gadget', 'Build-Sprocket', 'Build-Cog', 'Build-Gizmo')
        @($rows | Where-Object { -not $_.HasLists }) | Should -HaveCount 0
    }

    It 'judges only the writers it is named, and stores the stamp of a named writer only' {
        $rows = @(InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Memo = $script:memo } {
                param($Root, $Memo)
                Get-GeneratedWriterDue -Name 'Build-Gadget' -ChangedPath @() -RepositoryRoot $Root -MemoPath $Memo
            })
        @($rows.Name) | Should -Be @('Build-Gadget')
        { & $script:ran 'Build-Widgets' } | Should -Throw "*'Build-Widgets' is not a writer of any module's generated.yml*"
    }
}

<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-generated-files/tests/Get-GeneratedWriterDue.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-GeneratedWriterDue' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        $script:memo = Join-Path $TestDrive 'cache/generated-writers.json'
        $script:config = [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{
                    'Build-Widget'   = [ordered]@{ inputs = @('widget/**'); outputs = @('docs/index.md') }
                    'Build-Gadget'   = [ordered]@{ inputs = @('gadget/*.yml'); outputs = @('docs/missing.md') }
                    # A writer whose ignored target is one of its own inputs, as the root configs declare theirs.
                    'Build-Sprocket' = [ordered]@{ inputs = @('.sprocket.yml'); outputs = @('.sprocket.yml') }
                    # A writer that writes one file into every folder a wildcard claims, as the root configs write each pyproject.toml.
                    'Build-Cog'      = [ordered]@{ inputs = @('cogs/*/cog.toml') }
                    'Build-Gizmo'    = $null
                }
            })
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
        Mock Get-Config -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $Config -eq 'generated-files' } { $script:config }
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
        & $script:due @(& $script:run @('widget/spin.txt')) 'Build-Gizmo' |
            Should -BeTrue -Because 'a writer with neither list is due whenever anything changed'
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

    It 'says which writers have no lists, and is not due for them when nothing changed' {
        & $script:ran 'Build-Widget'
        $rows = @(& $script:run @())
        ($rows | Where-Object Name -eq 'Build-Gizmo').HasLists | Should -BeFalse
        & $script:due $rows 'Build-Gizmo' | Should -BeFalse
        ($rows | Where-Object Name -eq 'Build-Widget').HasLists | Should -BeTrue
        & $script:due $rows 'Build-Widget' | Should -BeFalse
    }

    It 'emits one typed record per writer, in declaration order' -Tag 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
        $rows = @(& $script:run @())
        $rows | Should -HaveCount 5
        $rows[0] | Should -BeOfType [Catzc.Base.GeneratedFiles.GeneratedWriterDue]
        @($rows.Name) | Should -Be @('Build-Widget', 'Build-Gadget', 'Build-Sprocket', 'Build-Cog', 'Build-Gizmo')
    }

    It 'reads git, once, when no changed set is given and a writer declares no lists' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.GeneratedFiles { 'gadget/a.yml' }
        $rows = @(InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Memo = $script:memo } {
                param($Root, $Memo)
                Get-GeneratedWriterDue -RepositoryRoot $Root -MemoPath $Memo
            })
        & $script:due $rows 'Build-Gizmo' | Should -BeTrue
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly
    }
}

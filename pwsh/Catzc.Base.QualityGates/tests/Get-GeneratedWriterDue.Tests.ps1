Describe 'Get-GeneratedWriterDue' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/index.md'), 'widget')
        $script:config = [Catzc.Base.QualityGates.GeneratedFilesConfig]::new([ordered]@{ writers = [ordered]@{
                    'Build-Widget' = [ordered]@{ inputs = @('widget/**'); outputs = @('docs/index.md') }
                    'Build-Gadget' = [ordered]@{ inputs = @('gadget/*.yml'); outputs = @('docs/missing.md') }
                    'Build-Gizmo'  = $null
                }
            })
        $script:run = {
            param([string[]] $Changed)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Changed = $Changed } {
                param($Root, $Changed)
                Get-GeneratedWriterDue -ChangedPath $Changed -RepositoryRoot $Root
            }
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'generated-files' } { $script:config }
    }

    It 'is due when a changed path matches an input, and not when none matches' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $rows = @(& $script:run @('widget/a.txt'))
        ($rows | Where-Object Name -eq 'Build-Widget').Due | Should -BeTrue
        ($rows | Where-Object Name -eq 'Build-Gizmo').Due | Should -BeTrue -Because 'a writer with neither list is due whenever anything changed'
        $rows = @(& $script:run @('unrelated/b.txt'))
        ($rows | Where-Object Name -eq 'Build-Widget').Due | Should -BeFalse
    }

    It 'is due when a changed path matches an output' {
        (@(& $script:run @('docs/index.md')) | Where-Object Name -eq 'Build-Widget').Due | Should -BeTrue
    }

    It 'is due when an output named without a wildcard is missing, whatever changed' {
        $rows = @(& $script:run @('unrelated/b.txt'))
        ($rows | Where-Object Name -eq 'Build-Gadget').Due | Should -BeTrue
    }

    It 'says which writers have no lists, and is not due for them when nothing changed' {
        $rows = @(& $script:run @())
        ($rows | Where-Object Name -eq 'Build-Gizmo').HasLists | Should -BeFalse
        ($rows | Where-Object Name -eq 'Build-Gizmo').Due | Should -BeFalse
        ($rows | Where-Object Name -eq 'Build-Widget').HasLists | Should -BeTrue
        ($rows | Where-Object Name -eq 'Build-Widget').Due | Should -BeFalse
    }

    It 'reads git when no changed set is given' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'gadget/a.yml' }
        $rows = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Get-GeneratedWriterDue -RepositoryRoot $Root })
        ($rows | Where-Object Name -eq 'Build-Gadget').Due | Should -BeTrue
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }
}

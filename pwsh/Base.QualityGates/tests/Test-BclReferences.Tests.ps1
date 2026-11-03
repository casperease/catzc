Describe 'Test-BclReferences' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:out = Join-Path $TestDrive 'out'
        $script:root = Join-Path $TestDrive 'modules'
        $hostUsing = "using System;`nusing System.Management.Automation;`n`nnamespace Catzc.Base.Widgets;`n"
        $plain = "using System;`n`nnamespace Catzc.Base.Widgets;`n"
        $files = [ordered]@{
            'Catzc.Base.Widgets/types/Widget.cs' = $hostUsing
            'Catzc.Base.Widgets/types/Gadget.cs' = $plain
            'Catzc.Base.Sprockets/types/Cog.cs'  = $hostUsing.Replace('using System.Management',
                'using static System.Management')
            'Catzc.Base.Widgets/assets/Note.cs'  = $hostUsing
            '.internal/types/Hidden.cs'          = $hostUsing
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $script:root $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            [System.IO.File]::WriteAllText($path, $files[$relative])
        }
        $script:bindings = {
            param([object[]] $Rows)
            [Catzc.Base.Languages.BclConfig]::new([ordered]@{ host_bindings = $Rows })
        }
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes when every host-bound type source has its row and every row is live' {
        $config = & $script:bindings @(
            [ordered]@{ file = 'Catzc.Base.Widgets/types/Widget.cs'; host = 'pwsh'; reason = 'Parses scripts.' }
            [ordered]@{ file = 'Catzc.Base.Sprockets/types/Cog.cs'; host = 'pwsh'; reason = 'Wraps a pipeline.' }
        )
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bcl' } { $config }.GetNewClosure()
        $result = Test-BclReferences -ModulesRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Sources'] | Should -Be 3
        $result.Facts['HostBound'] | Should -Be 2
    }

    It 'reads the working root''s modules tracks in build mode, never the installed code root' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        $repo = Join-Path $TestDrive 'consumer'
        $hostUsing = "using System;`nusing System.Management.Automation;`n"
        foreach ($relative in 'widget-modules/Widget.Kit/types/Widget.cs', '.vendor/Catzc/1.0.0/Catzc.Base.Gadgets/types/Gadget.cs') {
            $path = Join-Path $repo $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            [System.IO.File]::WriteAllText($path, $hostUsing)
        }
        $config = & $script:bindings @([ordered]@{ file = 'Widget.Kit/types/Widget.cs'; host = 'pwsh'; reason = 'Parses scripts.' })
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bcl' } { $config }.GetNewClosure()
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $repo }.GetNewClosure()
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.QualityGates { 'build' }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { Join-Path $repo '.vendor/Catzc/1.0.0' }.GetNewClosure()
        Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -ceq 'pwsh' } {
            [pscustomobject]@{ name = 'pwsh'; type = 'modules'; places = @('.vendor/Catzc/1.0.0') }
        }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { -not $Name } {
            [pscustomobject]@{ name = 'pwsh'; type = 'modules'; places = @('.vendor/Catzc/1.0.0') }
            [pscustomobject]@{ name = 'widgets'; type = 'modules'; places = @('widget-modules') }
        }
        $result = Test-BclReferences -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Sources'] | Should -Be 1
        $result.Facts['HostBound'] | Should -Be 1
    }

    It 'leaves a row whose type source is not among the scanned sources to the tree that owns it' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        $config = & $script:bindings @(
            [ordered]@{ file = 'Catzc.Base.Widgets/types/Widget.cs'; host = 'pwsh'; reason = 'Parses scripts.' }
            [ordered]@{ file = 'Catzc.Base.Sprockets/types/Cog.cs'; host = 'pwsh'; reason = 'Wraps a pipeline.' }
            [ordered]@{ file = 'Catzc.Base.Gizmos/types/Gizmo.cs'; host = 'pwsh'; reason = 'Lives in another tree.' }
        )
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bcl' } { $config }.GetNewClosure()
        $result = Test-BclReferences -ModulesRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Rows'] | Should -Be 3
    }

    It 'throws once naming a host-bound source without its row and a row whose source is not host-bound' {
        $config = & $script:bindings @(
            [ordered]@{ file = 'Catzc.Base.Widgets/types/Widget.cs'; host = 'pwsh'; reason = 'Parses scripts.' }
            [ordered]@{ file = 'Catzc.Base.Widgets/types/Gadget.cs'; host = 'pwsh'; reason = 'Unwraps a value.' }
        )
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bcl' } { $config }.GetNewClosure()
        $thrown = { Test-BclReferences -ModulesRoot $script:root -OutputFolder $script:out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-BclReferences failed: 2 issue(s)*'
        $message |
            Should -Match 'Catzc.Base.Sprockets/types/Cog.cs: uses System.Management.Automation without a host binding'
        $message | Should -Match 'bcl.yml Catzc.Base.Widgets/types/Gadget.cs: binds a type source that does not use'
    }
}

Describe 'Test-BclReferences — the shipped bcl.yml over the real type sources' -Tag 'L1', 'integrity' {
    It 'finds every host-bound type source bound, and every row live' {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $result = Test-BclReferences -OutputFolder (Join-Path $TestDrive 'out') -PassThru
        $result.Issues | Should -BeNullOrEmpty
        $result.Facts['HostBound'] | Should -Be $result.Facts['Rows']
    }
}

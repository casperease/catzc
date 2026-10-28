Describe 'Assert-GeneratedStaysCommitted' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:rows = @(
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; inputs = @('widget.yml'); outputs = @('widget/index.md') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Gadget', [ordered]@{ class = 'import-critical'; inputs = @('gadget.yml'); outputs = @('gadget/index.md', 'gadget/*.lock') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Update-Sprocket', [ordered]@{ class = 'snapshot'; outputs = @('sprocket/prices.json') })
        )
    }

    BeforeEach {
        Mock Get-GeneratedWriterOrder -ModuleName Catzc.Base.GeneratedFiles { $script:rows }
    }

    It 'accepts the deletion of a rollable generated file' {
        { Assert-GeneratedStaysCommitted -Path 'widget/index.md' } | Should -Not -Throw
    }

    It 'accepts the deletion of a file no writer declares' {
        { Assert-GeneratedStaysCommitted -Path 'cog/readme.md' } | Should -Not -Throw
    }

    It 'refuses the deletion of an import-critical output, naming the writer and class' {
        { Assert-GeneratedStaysCommitted -Path 'gadget/index.md' } | Should -Throw '*gadget/index.md (writer Build-Gadget, class import-critical)*'
    }

    It 'refuses a snapshot output and a wildcard output, counting each' {
        { Assert-GeneratedStaysCommitted -Path 'sprocket/prices.json', 'gadget/a.lock', 'widget/index.md' } | Should -Throw '*2 staged deletion(s)*'
    }

    It 'reads the staged deletions from git when no path is given' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.GeneratedFiles { $TestDrive }
        Mock Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Output = "widget/index.md`ngadget/index.md`n" } }
        { Assert-GeneratedStaysCommitted } | Should -Throw '*1 staged deletion(s)*gadget/index.md*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $Command -like '*diff --cached*--diff-filter=D*' } -Times 1 -Exactly
    }

    It 'passes when nothing is staged for deletion' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.GeneratedFiles { $TestDrive }
        Mock Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Output = '' } }
        { Assert-GeneratedStaysCommitted } | Should -Not -Throw
    }
}

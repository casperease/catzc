# Get-LanguageTestExecutable with the test folder discovery and the tool probe mocked: the source session hands down a
# language's tool only when it is found at the pin, and probes nothing for a language without test folders. Neutral
# fixture paths ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-LanguageTestExecutable' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:folders = @(
            [pscustomobject]@{ Language = 'go'; Folder = 'C:\widget\go\tests\catzc-widget'; Module = 'Catzc.Widget'; Name = 'catzc-widget' }
            [pscustomobject]@{ Language = 'python'; Folder = 'C:\widget\python\tests\catzc-widget'; Module = 'Catzc.Widget'; Name = 'catzc-widget' }
        )
        $script:probes = @{
            go     = [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\go\bin\go.exe' }
            uv     = [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\uv\uv.exe' }
            python = [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\uv\python.exe' }
        }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates { $script:folders }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates { $script:probes[$Tool] }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Engine -eq 'bash' } { 'C:\widget\bash\bash.exe' }
    }

    It 'returns go, uv and the bash engine when they are found' {
        $executables = InModuleScope Catzc.Base.QualityGates { Get-LanguageTestExecutable }
        $executables['go'] | Should -Be 'C:\widget\go\bin\go.exe'
        $executables['python'] | Should -Be 'C:\widget\uv\uv.exe'
        $executables['bash'] | Should -Be 'C:\widget\bash\bash.exe'
    }

    It 'returns an empty bash entry when the bash engine is not found' {
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Engine -eq 'bash' } { throw 'no bash' }
        $executables = InModuleScope Catzc.Base.QualityGates { Get-LanguageTestExecutable }
        $executables['bash'] | Should -BeExactly ''
        $executables['go'] | Should -Be 'C:\widget\go\bin\go.exe'
    }

    It 'returns an empty <Language> entry when <Case>' -ForEach @(
        @{ Language = 'go'; Tool = 'go'; Case = 'go is not found'; Found = $false; VersionOk = $false }
        @{ Language = 'go'; Tool = 'go'; Case = 'go misses the pin'; Found = $true; VersionOk = $false }
        @{ Language = 'python'; Tool = 'uv'; Case = 'uv misses the pin'; Found = $true; VersionOk = $false }
        @{ Language = 'python'; Tool = 'python'; Case = 'the python pin is not installed'; Found = $false; VersionOk = $false }
    ) {
        $script:probes[$Tool] = [pscustomobject]@{ Found = $Found; VersionOk = $VersionOk; Path = 'C:\widget\tool.exe' }
        $executables = InModuleScope Catzc.Base.QualityGates { Get-LanguageTestExecutable }
        $executables[$Language] | Should -BeExactly ''
    }

    It 'probes nothing for a language without test folders' {
        $script:folders = @($script:folders[0])
        $executables = InModuleScope Catzc.Base.QualityGates { Get-LanguageTestExecutable }
        $executables['python'] | Should -BeExactly ''
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Tool -in 'uv', 'python' }
    }

    It 'returns empty entries without probing when the repository has no test folder' {
        $script:folders = @()
        $executables = InModuleScope Catzc.Base.QualityGates { Get-LanguageTestExecutable }
        $executables['go'] | Should -BeExactly ''
        $executables['python'] | Should -BeExactly ''
        $executables['bash'] | Should -BeExactly ''
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Resolve-EngineExecutable -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

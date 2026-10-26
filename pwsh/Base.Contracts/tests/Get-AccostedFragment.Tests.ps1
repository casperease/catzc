Describe 'Get-AccostedFragment' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path $script:root -Force
        $script:write = {
            param([string] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:root 'widgets.accosted.yml'), $Text)
            'widgets.accosted.yml'
        }
        $script:contract = {
            param([string] $Name, [hashtable] $Specs)
            $parameters = @(foreach ($key in $Specs.Keys) {
                    [Catzc.Base.Contracts.ContractParameter]::Parse($key, $Specs[$key])
                })
            [pscustomobject]@{ Name = $Name; parameters = $parameters; Signature = "$Name(...)" }
        }
        $script:file = @'
runs:
  - - get_widget: { path: widgets/a.wdg, depth: 2, names: a }
    - test_gadget: { output_folder: out/test-gadget, strict: true }
  - - test_gadget:
'@
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'accosted' } { [Catzc.Base.Contracts.AccostedConfig]::new(@{}) }
        Mock Get-CommandContract -ModuleName Catzc.Base.Contracts {
            & $script:contract 'get_widget' @{ path = 'string!'; depth = 'int'; names = 'string[]' }
            & $script:contract 'test_gadget' @{ output_folder = 'string'; strict = 'switch' }
        }
    }

    It 'renders a run as one PowerShell line per command, strings quoted, numbers bare, a true switch as a bare flag' -Tag 'ADR-AUTO-ACCOSTED-ACCOSTEDONEREADER' {
        $path = & $script:write $script:file
        Get-AccostedFragment -Path $path -RunNumber 1 -RepositoryRoot $script:root |
            Should -Be "Get-Widget -Path 'widgets/a.wdg' -Depth 2 -Names 'a'`nTest-Gadget -OutputFolder 'out/test-gadget' -Strict"
    }

    It 'renders every run when none is named, a blank line between runs' {
        $path = & $script:write $script:file
        Get-AccostedFragment -Path $path -RepositoryRoot $script:root |
            Should -Be "Get-Widget -Path 'widgets/a.wdg' -Depth 2 -Names 'a'`nTest-Gadget -OutputFolder 'out/test-gadget' -Strict`n`nTest-Gadget"
    }

    It 'renders one command of a run' {
        $path = & $script:write $script:file
        Get-AccostedFragment -Path $path -RunNumber 1 -CommandNumber 2 -RepositoryRoot $script:root |
            Should -Be "Test-Gadget -OutputFolder 'out/test-gadget' -Strict"
    }

    It 'reads the file through the one reader, so a command no contract names is refused with the reader''s message' -Tag 'ADR-AUTO-ACCOSTED-ACCOSTEDONEREADER' {
        $path = & $script:write "runs:`n  - - get_gizmo: { path: a }"
        { Get-AccostedFragment -Path $path -RepositoryRoot $script:root } |
            Should -Throw "*'get_gizmo' is no contracted command*"
    }

    It 'throws on <Case>' -ForEach @(
        @{ Case = '-CommandNumber without -RunNumber'; Arguments = @{ CommandNumber = 1 }; Message = '*-CommandNumber names a command of one run, so it needs -RunNumber*' }
        @{ Case = 'a run the file does not hold'; Arguments = @{ RunNumber = 3 }; Message = '*holds 2 run(s), so there is no run 3*' }
        @{ Case = 'a command the run does not hold'; Arguments = @{ RunNumber = 2; CommandNumber = 2 }; Message = '*holds 1 command(s), so there is no command 2*' }
    ) {
        $path = & $script:write $script:file
        { Get-AccostedFragment -Path $path -RepositoryRoot $script:root @Arguments } | Should -Throw $Message
    }
}

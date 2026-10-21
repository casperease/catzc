<#
---
catzc:
  immutable:
    with_body_sha: "446ef40925f8"
  edges:
    code: pwsh/Catzc.Base.Contracts/Get-AccostedFile.ps1
---
#>

Describe 'Get-AccostedFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path $script:root -Force
        $script:write = {
            param([string] $Text)
            $path = Join-Path $script:root 'widgets.accosted.yml'
            [System.IO.File]::WriteAllText($path, $Text)
            'widgets.accosted.yml'
        }
        $script:contract = {
            param([string] $Name, [hashtable] $Specs)
            $parameters = @(foreach ($key in $Specs.Keys) {
                    [Catzc.Base.Contracts.ContractParameter]::Parse($key, $Specs[$key])
                })
            [pscustomobject]@{ Name = $Name; parameters = $parameters; Signature = "$Name(...)" }
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'accosted' } { [Catzc.Base.Contracts.AccostedConfig]::new(@{}) }
        Mock Get-CommandContract -ModuleName Catzc.Base.Contracts {
            & $script:contract 'get_widget' @{ path = 'string!'; depth = 'int'; names = 'string[]' }
            & $script:contract 'test_gadget' @{ output_folder = 'string'; strict = 'switch' }
            & $script:contract 'set_widget' @{ path = 'string!' }
        }
    }

    It 'returns the file when every command is contracted, harmless and called with fitting literals' {
        $path = & $script:write @'
runs:
  - - get_widget: { path: widgets/a.wdg, depth: 2, names: a }
    - test_gadget: { output_folder: out/test-gadget, strict: true }
  - - test_gadget:
'@
        $file = Get-AccostedFile -Path $path -RepositoryRoot $script:root
        $file | Should -BeOfType [Catzc.Base.Contracts.AccostedFile]
        $file.runs.Count | Should -Be 2
    }

    It 'rejects <Case>, naming where and the contract' -ForEach @(
        @{ Case = 'a command no contract names'; Yaml = "runs:`n  - - get_gizmo: { path: a }"; Message = "*run 1, command 1: 'get_gizmo' is no contracted command*" }
        @{ Case = 'a verb not on the list'; Yaml = "runs:`n  - - set_widget: { path: a }"; Message = "*'set_widget' is not harmless*find, get, measure, test*" }
        @{ Case = 'an unknown parameter'; Yaml = "runs:`n  - - get_widget: { path: a, colour: red }"; Message = "*'get_widget' has no parameter 'colour'*" }
        @{ Case = 'a missing mandatory parameter'; Yaml = "runs:`n  - - get_widget: { depth: 1 }"; Message = "*misses its mandatory parameter 'path'*" }
        @{ Case = 'a value of the wrong type'; Yaml = "runs:`n  - - get_widget: { path: a, depth: deep }"; Message = "*'depth' takes int*'deep' is not one*" }
        @{ Case = 'a list, even for a list parameter'; Yaml = "runs:`n  - - get_widget: { path: a, names: [a, b] }"; Message = "*'names' is given a list; cats passes one value per parameter*" }
        @{ Case = 'an output folder outside out/'; Yaml = "runs:`n  - - test_gadget: { output_folder: widgets/report }"; Message = "*'output_folder' writes to 'widgets/report', outside out/*" }
    ) {
        $path = & $script:write $Yaml
        { Get-AccostedFile -Path $path -RepositoryRoot $script:root } | Should -Throw $Message
    }

    It 'reads the contracts once, however many commands the file holds' {
        $path = & $script:write "runs:`n  - - get_widget: { path: a }`n    - get_widget: { path: b }"
        $null = Get-AccostedFile -Path $path -RepositoryRoot $script:root
        Should -Invoke Get-CommandContract -ModuleName Catzc.Base.Contracts -Times 1 -Exactly
    }
}

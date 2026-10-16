<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/tests/types/ContractFragment.Tests.ps1
    folder: tests/types
    name: contract-fragment-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/tests/types/ContractFragment.Tests.ps1.md
    cites:
      - ADR-REPO-CONTRACT#6
---
#>

Describe 'ContractFragment' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {
    Context 'a key subset of JSON and YAML' {
        BeforeAll {
            function Get-DataFinding {
                param([string] $Fragment, [string] $Target)
                $parsedFragment = $Fragment | ConvertFrom-Yaml -Ordered
                $parsedTarget = $Target | ConvertFrom-Yaml -Ordered
                [Catzc.Base.Contracts.ContractFragment]::MatchData($parsedFragment, $parsedTarget)
            }
        }

        It '<Rule>' -ForEach @(
            @{ Rule = 'requires every key path, allowing more keys in the target'; Fragment = "widget:`n  gadget: 1`n"; Pass = "widget:`n  gadget: 1`n  sprocket: 2`n"; Fail = "widget:`n  sprocket: 2`n"; Finding = '$.widget.gadget: the key is missing from the target' }
            @{ Rule = 'requires an equal scalar'; Fragment = "widget: gadget`n"; Pass = "widget: gadget`n"; Fail = "widget: sprocket`n"; Finding = "`$.widget: expected 'gadget', found 'sprocket'" }
            @{ Rule = 'compares numbers by value'; Fragment = "widget: 1.0`n"; Pass = "widget: 1`n"; Fail = "widget: 1.5`n"; Finding = '$.widget: expected 1, found 1.5' }
            @{ Rule = 'requires an object where the fragment has one'; Fragment = "widget:`n  gadget: 1`n"; Pass = "widget:`n  gadget: 1`n"; Fail = "widget: [1]`n"; Finding = '$.widget: expected an object, found [1]' }
            @{ Rule = 'pins only the key for a null'; Fragment = "widget:`n"; Pass = "widget:`n  gadget: 1`n"; Fail = "gadget: 1`n"; Finding = '$.widget: the key is missing from the target' }
            @{ Rule = 'matches each array element by some target element, in any order'; Fragment = "widget: [gadget, sprocket]`n"; Pass = "widget: [sprocket, cog, gadget]`n"; Fail = "widget: [gadget, cog]`n"; Finding = "`$.widget: fragment element [1] ('sprocket') is matched by no element of the target array" }
            @{ Rule = 'matches an object element by subset'; Fragment = "steps:`n  - uses: gadget`n"; Pass = "steps:`n  - name: widget`n  - uses: gadget`n    with: 1`n"; Fail = "steps:`n  - uses: sprocket`n"; Finding = "`$.steps: fragment element [0] ({uses: 'gadget'}) is matched by no element of the target array" }
            @{ Rule = 'requires an array where the fragment has one'; Fragment = "widget: [gadget]`n"; Pass = "widget: [gadget]`n"; Fail = "widget: gadget`n"; Finding = "`$.widget: expected an array, found 'gadget'" }
            @{ Rule = 'names a key that is not a plain word in brackets'; Fragment = "'widget gadget': 1`n"; Pass = "'widget gadget': 1`n"; Fail = "widget: 1`n"; Finding = "`$['widget gadget']: the key is missing from the target" }
        ) {
            @(Get-DataFinding $Fragment $Pass) | Should -BeNullOrEmpty
            @(Get-DataFinding $Fragment $Fail) | Should -Be @($Finding)
        }

        It 'lets two fragment elements be matched by the same target element' {
            @(Get-DataFinding "widget: [gadget, gadget]`n" "widget: [gadget]`n") | Should -BeNullOrEmpty
        }

        It 'compares a JSON fragment with a YAML-shaped value the same way' {
            $fragment = '{"widget":{"gadget":[1]}}' | ConvertFrom-Json -AsHashtable
            $target = "widget:`n  gadget: [2, 1]`n" | ConvertFrom-Yaml -Ordered
            @([Catzc.Base.Contracts.ContractFragment]::MatchData($fragment, $target)) | Should -BeNullOrEmpty
        }
    }

    Context 'the lines of any other text' {
        It '<Rule>' -ForEach @(
            @{ Rule = 'requires every non-blank line in order, not adjacent'; Fragment = "# Widget`n`nGadget`n"; Pass = "# Widget`n- cog`nGadget`n- sprocket`n"; Fail = "# Widget`n- cog`n"; Finding = "fragment line 3 'Gadget' is missing from the target" }
            @{ Rule = 'reports a line out of order'; Fragment = "# Widget`nGadget`n"; Pass = "# Widget`nGadget`n"; Fail = "Gadget`n# Widget`n"; Finding = "fragment line 2 'Gadget' is out of order: the target has it only at or before line 2, where fragment line 1 matched" }
            @{ Rule = 'trims trailing whitespace only'; Fragment = "  Gadget  `r`n"; Pass = "  Gadget`n"; Fail = "Gadget`n"; Finding = "fragment line 1 '  Gadget' is missing from the target" }
        ) {
            @([Catzc.Base.Contracts.ContractFragment]::MatchLines($Fragment, $Pass)) | Should -BeNullOrEmpty
            @([Catzc.Base.Contracts.ContractFragment]::MatchLines($Fragment, $Fail)) | Should -Be @($Finding)
        }
    }
}

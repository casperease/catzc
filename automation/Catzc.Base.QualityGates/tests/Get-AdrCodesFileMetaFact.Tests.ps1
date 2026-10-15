<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-AdrCodesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        # The fixture codes below are the only ones this index registers, each declaring rules 1 to 30.
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Docs.AdrCitationMap]::new(@{
                    'ADR-WIDGET'      = @{ path = 'docs/adr/widget.md'; rules = 1..30 }
                    'ADR-WIDGET-PART' = @{ path = 'docs/adr/widget-part.md'; rules = 1..30 }
                    'ADR-GADGET'      = @{ path = 'docs/adr/gadget.md'; rules = 1..30 }
                }, @())
        }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('adrs') } } }).kinds[0]

        function script:Get-Codes {
            param([string] $Body)
            $state = Get-MarkdownMetaState -Text $Body
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-AdrCodesFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            }
            , @($fact['adrs'])
        }
    }

    It 'lists each cited rule once, sorted by ordinal order' {
        $codes = Get-Codes "# docs/widget.md`n`nSee ADR-WIDGET-PART#3 and ADR-GADGET#12, then ADR-WIDGET-PART#3 again, and ADR-GADGET#2.`n"
        $codes | Should -Be @('ADR-GADGET#12', 'ADR-GADGET#2', 'ADR-WIDGET-PART#3')
    }

    It 'ignores the colon form a rule heading uses and a code with no rule number' {
        $codes = Get-Codes "### Rule ADR-WIDGET:1`n`nThe ADR-WIDGET decision.`n"
        $codes.Count | Should -Be 0
    }

    It 'finds a citation inside a link' {
        $codes = Get-Codes "[ADR-GADGET#4](/docs/adr/gadget.md#rule-adr-gadget4)`n"
        $codes | Should -Be @('ADR-GADGET#4')
    }

    It 'leaves out a rule the file defines itself and keeps the rules it cites elsewhere' {
        $codes = Get-Codes "### Rule ADR-WIDGET:1`n`nThis rule extends ADR-WIDGET#2, which sits in ADR-GADGET#4.`n`n### Rule ADR-WIDGET:2`n"
        $codes | Should -Be @('ADR-GADGET#4')
    }

    It 'drops a code the index does not register and a rule its ADR does not declare' {
        $codes = Get-Codes "See ADR-NOSUCH#1, ADR-GADGET#99 and ADR-GADGET#4.`n"
        $codes | Should -Be @('ADR-GADGET#4')
    }

    It 'returns an empty list for a file that cites nothing' {
        (Get-Codes "# docs/widget.md`n").Count | Should -Be 0
    }

    It 'does not read a citation from the front matter' {
        $codes = Get-Codes "---`ncatzc:`n  derived:`n    adrs:`n      - ADR-WIDGET#9`n---`nbody`n"
        $codes.Count | Should -Be 0
    }

    Context 'a code file, whose kind names it under domain_files' {
        BeforeAll {
            $script:codeKind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{
                        'adr-codes' = @{ keys = @('adrs'); settings = @{ domain_files = @('automation/**/types/*.cs') } }
                    }
                }).kinds[0]

            function script:Get-CodeCodes {
                param([string] $Text)
                $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
                $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                    param($State, $Kind)
                    Get-AdrCodesFileMetaFact -State $State -Path 'automation/Catzc.Widget/types/Widget.cs' -Kind $Kind
                }
                , @($fact['adrs'])
            }
        }

        It 'lists a bare domain code beside the rule codes, reading below the head only' {
            $text = "/*`n---`ncatzc:`n  derived:`n    adrs:`n      - ADR-HEAD#1`n---`n*/`n`n// ADR-WIDGET, ADR-GADGET#4 and ADR-WIDGET#2`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET#4', 'ADR-WIDGET', 'ADR-WIDGET#2')
        }

        It 'drops a bare code that is neither registered nor the prefix of a registered code' {
            (Get-CodeCodes "// ADR-NOSUCH, ADR-WIDGET and ADR-WIDGET-PART`n") | Should -Be @('ADR-WIDGET', 'ADR-WIDGET-PART')
        }

        It 'ignores the colon form of a rule heading' {
            # Built from two strings: a literal colon form would be respelled to the hash form by the string-citation alignment.
            (Get-CodeCodes ('// ADR-WIDGET' + ":1`n")).Count | Should -Be 0
        }

        It 'keeps a markdown file to rule codes even when the kind names code files' {
            $state = Get-MarkdownMetaState -Text "The ADR-WIDGET decision, ADR-GADGET#4.`n"
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                param($State, $Kind)
                Get-AdrCodesFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            }
            , @($fact['adrs']) | Should -Be @('ADR-GADGET#4')
        }
    }

    Context 'a code file, whose kind names it under held_files' {
        BeforeAll {
            $script:heldKind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{
                        'adr-codes' = @{ keys = @('adrs'); settings = @{ held_files = @('automation/**/types/*.cs') } }
                    }
                }).kinds[0]

            function script:Get-HeldCodes {
                param([string] $Text, [string] $Path = 'automation/Catzc.Widget/types/Widget.cs')
                $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
                $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:heldKind; Path = $Path } {
                    param($State, $Kind, $Path)
                    Get-AdrCodesFileMetaFact -State $State -Path $Path -Kind $Kind
                }
                , @($fact['adrs'])
            }
        }

        It 'keeps every code the head holds and adds the codes the text cites, sorted without duplicates' -Tag 'ADR-REPO-CODEMETA#2' {
            $text = "/*`n---`ncatzc:`n  derived:`n    adrs:`n      - ADR-HEAD#1`n      - ADR-GADGET#4`n---`n*/`n`n// ADR-GADGET#4 and ADR-WIDGET#2`nclass Widget {}`n"
            (Get-HeldCodes $text) | Should -Be @('ADR-GADGET#4', 'ADR-HEAD#1', 'ADR-WIDGET#2')
        }

        It 'derives from the text alone for a file the setting does not name' -Tag 'ADR-REPO-CODEMETA#2' {
            $text = "/*`n---`ncatzc:`n  derived:`n    adrs:`n      - ADR-HEAD#1`n---`n*/`n`n// ADR-WIDGET#2`nclass Widget {}`n"
            (Get-HeldCodes $text 'automation/Catzc.Widget/assets/widget.cs') | Should -Be @('ADR-WIDGET#2')
        }
    }
}

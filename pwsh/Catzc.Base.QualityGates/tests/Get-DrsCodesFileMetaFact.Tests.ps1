<#
---
catzc:
  immutable:
    with_body_sha: "4062200c8b6a"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-DrsCodesFileMetaFact.ps1
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FILEMETA-NOREADBACK
---
#>

Describe 'Get-DrsCodesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        # The one fixture kind below is a code file, so its class is what the kind's settings name.
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{ 'widget-type' = [ordered]@{ definition = 'A widget type.'; files = @('widgets/**/types/*.cs') } }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }

        # The fixture codes below are the only ones this index registers, each with its rules in authored order.
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Drs.DrsCitationMap]::new(@{
                    'ADR-WIDGET'      = @{ path = 'docs/drs/widget.md'; rules = [string[]] @('ADR-WIDGET-TURN', 'ADR-WIDGET-SPIN') }
                    'ADR-WIDGET-PART' = @{ path = 'docs/drs/widget-part.md'; rules = [string[]] @('ADR-WIDGET-PART-FOLD', 'ADR-WIDGET-PART-BEND') }
                    'ADR-GADGET'      = @{ path = 'docs/drs/gadget.md'; rules = [string[]] @('ADR-GADGET-LIFT', 'ADR-GADGET-DROP', 'ADR-GADGET-RE12') }
                }, @())
        }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'drs-codes' = @{ keys = @('cites') } } }).kinds[0]

        function script:Get-Codes {
            param([string] $Body)
            $state = Get-MarkdownMetaState -Text $Body
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-DrsCodesFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            }
            , @($fact['cites'])
        }
    }

    It 'lists each cited rule once, ordered by ADR and then by its place in the ADR' {
        $codes = Get-Codes "# docs/widget.md`n`nSee ADR-WIDGET-PART-BEND and ADR-GADGET-RE12, then ADR-WIDGET-PART-BEND again, and ADR-GADGET-LIFT.`n"
        $codes | Should -Be @('ADR-GADGET-LIFT', 'ADR-GADGET-RE12', 'ADR-WIDGET-PART-BEND')
    }

    It 'writes the ADR code, which means the whole ADR, when every rule the registry declares is cited' {
        (Get-Codes "ADR-GADGET-LIFT ADR-GADGET-DROP ADR-GADGET-RE12`n") | Should -Be @('ADR-GADGET')
        (Get-Codes "ADR-GADGET-LIFT ADR-GADGET-DROP ADR-GADGET-RE12 ADR-WIDGET-PART-FOLD`n") | Should -Be @('ADR-GADGET', 'ADR-WIDGET-PART-FOLD')
    }

    It 'keeps the rules while one rule of the ADR is not cited' {
        (Get-Codes "ADR-GADGET-LIFT ADR-GADGET-RE12`n") | Should -Be @('ADR-GADGET-LIFT', 'ADR-GADGET-RE12')
    }

    It 'reads a numbered citation, a group or a wildcard in body text as no citation' {
        $codes = Get-Codes ('The ADR-GADGET' + '#4 rule, the ADR-GADGET' + "#{2,3} group, the ADR-WIDGET-* family.`n")
        $codes.Count | Should -Be 0
    }

    It 'ignores a rule heading and an ADR code in a markdown file' {
        $codes = Get-Codes "### Rule ADR-WIDGET-PART-FOLD`n`nThe ADR-WIDGET-PART decision.`n"
        $codes.Count | Should -Be 0
    }

    It 'finds a citation inside a link' {
        $codes = Get-Codes "[ADR-GADGET-DROP](/docs/drs/gadget.md#rule-adr-gadget-drop)`n"
        $codes | Should -Be @('ADR-GADGET-DROP')
    }

    It 'leaves out a rule the file defines itself and keeps the rules it cites elsewhere' {
        $codes = Get-Codes "### Rule ADR-WIDGET-PART-FOLD`n`nThis rule extends ADR-WIDGET-PART-BEND, which sits in ADR-GADGET-DROP.`n`n### Rule ADR-WIDGET-PART-BEND`n"
        $codes | Should -Be @('ADR-GADGET-DROP')
    }

    It 'drops a code the index does not register and a rule its ADR does not declare' {
        $codes = Get-Codes "See ADR-UNLISTED-ONE-TWO, ADR-GADGET-SINK and ADR-GADGET-DROP.`n"
        $codes | Should -Be @('ADR-GADGET-DROP')
    }

    It 'returns an empty list for a file that cites nothing' {
        (Get-Codes "# docs/widget.md`n").Count | Should -Be 0
    }

    It 'does not read a citation from the front matter' {
        $codes = Get-Codes "---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET-SPIN`n---`nbody`n"
        $codes.Count | Should -Be 0
    }

    Context 'a code file, whose class the kind names under domain_classes' {
        BeforeAll {
            $script:codeKind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ 'drs-codes' = @{ keys = @('cites'); settings = @{ domain_classes = @('widget-*') } } }
                }).kinds[0]

            function script:Get-CodeCodes {
                param([string] $Text)
                $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
                $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                    param($State, $Kind)
                    Get-DrsCodesFileMetaFact -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -Kind $Kind
                }
                , @($fact['cites'])
            }
        }

        It 'lists an ADR code beside the rule codes of other ADRs, reading below the head only' {
            $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD-ONE-TWO`n---`n*/`n`n// ADR-GADGET, ADR-WIDGET-PART-BEND and ADR-WIDGET-TURN`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET', 'ADR-WIDGET-TURN', 'ADR-WIDGET-PART-BEND')
        }

        It 'lists a code alone when the text also cites a code below it, since a prefix selects everything below it' {
            $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD-ONE-TWO`n---`n*/`n`n// ADR-WIDGET, ADR-WIDGET-SPIN and ADR-WIDGET-PART-FOLD`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-WIDGET')
        }

        It 'drops a code that is neither registered nor the prefix of a registered code' {
            (Get-CodeCodes "// ADR-UNLISTED, ADR-GADGET and ADR-WIDGET-PART`n") | Should -Be @('ADR-GADGET', 'ADR-WIDGET-PART')
        }

        It 'ignores a numbered citation' {
            # Built from two strings, so the string-citation check reads no numbered citation in this file.
            (Get-CodeCodes ('// ADR-GADGET' + ':1 and ADR-GADGET' + "#2`n")).Count | Should -Be 0
        }

        It 'keeps a markdown file to rule codes even when the kind names code files' {
            $state = Get-MarkdownMetaState -Text "The ADR-WIDGET decision, ADR-GADGET-DROP.`n"
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                param($State, $Kind)
                Get-DrsCodesFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            }
            , @($fact['cites']) | Should -Be @('ADR-GADGET-DROP')
        }
    }

    Context 'a code file' {
        BeforeAll {
            $script:codeKind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ 'drs-codes' = @{ keys = @('cites'); select = @(@{ classes = @('widget-type') }) } }
                }).kinds[0]

            function script:Get-CodeCodes {
                param([string] $Text)
                $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
                $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                    param($State, $Kind)
                    Get-DrsCodesFileMetaFact -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -Kind $Kind
                }
                , @($fact['cites'])
            }
        }

        It 'derives the codes from the text alone and never keeps one the head lists' -Tag 'ADR-REPO-FILEMETA-NOREADBACK', 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
            $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD-ONE-TWO`n      - ADR-GADGET-LIFT`n---`n*/`n`n// ADR-GADGET-DROP and ADR-WIDGET-SPIN`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET-DROP', 'ADR-WIDGET-SPIN')
        }

        It 'gives the same codes whether the file has a head or not' -Tag 'ADR-REPO-FILEMETA-NOREADBACK' {
            $withHead = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD-ONE-TWO`n---`n*/`n`n// ADR-WIDGET-SPIN`nclass Widget {}`n"
            $without = "// ADR-WIDGET-SPIN`nclass Widget {}`n"
            (Get-CodeCodes $withHead) | Should -Be (Get-CodeCodes $without)
        }

        It 'writes the rules the text cites in the minimal form' -Tag 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
            $text = "// ADR-GADGET-RE12, ADR-GADGET-DROP and ADR-GADGET-LIFT`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET')
        }
    }

    It 'takes domain_classes from the classes the kind selects when it is not set' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER', 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
        $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ 'drs-codes' = @{ keys = @('cites'); select = @(@{ languages = @('markdown') }, @{ classes = @('widget-type') }) } }
            }).kinds[0]
        $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD-ONE-TWO`n---`n*/`n`n// ADR-WIDGET and ADR-GADGET-DROP`nclass Widget {}`n"
        $state = Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
        $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $kind } {
            param($State, $Kind)
            Get-DrsCodesFileMetaFact -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -Kind $Kind
        }
        $fact['cites'] | Should -Be @('ADR-GADGET-DROP', 'ADR-WIDGET')
    }
}

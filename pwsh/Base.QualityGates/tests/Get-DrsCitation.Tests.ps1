Describe 'Get-DrsCitation' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-NOREADBACK' {
    BeforeAll {
        # The one fixture kind below is a code file, so its class is what the domain classes name.
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{ 'widget-type' = [ordered]@{ definition = 'A widget type.'; files = @('widgets/**/types/*.cs') } }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }

        # The fixture codes below are the only ones this index registers, each with its rules in authored order.
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Drs.DrsCitationMap]::new(@{
                    'ADR-WIDGET'      = @{ path = 'docs/drs/widget.md'; rules = [string[]] @('ADR-WIDGET-TURN',
                            'ADR-WIDGET-SPIN')
                    }
                    'ADR-WIDGET-PART' = @{ path = 'docs/drs/widget-part.md'; rules = [string[]] @('ADR-WIDGET-PART-FOLD', 'ADR-WIDGET-PART-BEND') }
                    'ADR-GADGET'      = @{ path = 'docs/drs/gadget.md'; rules = [string[]] @('ADR-GADGET-LIFT',
                            'ADR-GADGET-DROP', 'ADR-GADGET-RE12')
                    }
                }, @())
        }

        function script:Get-Codes {
            param([string] $Body, [string] $Path = 'docs/widget.md', [string[]] $DomainClasses = @())
            $state = Get-MarkdownMetaState -Text $Body
            $codes = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Path = $Path; DomainClasses = $DomainClasses } {
                param($State, $Path, $DomainClasses)
                Get-DrsCitation -State $State -Path $Path -DomainClasses $DomainClasses
            }
            , @($codes)
        }

        function script:Get-CodeCodes {
            param([string] $Text)
            $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
            $codes = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state } {
                param($State)
                Get-DrsCitation -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -DomainClasses @('widget-*')
            }
            , @($codes)
        }
    }

    It 'cites only what the prose cites, never the codes of a yml drawio block' {
        $body = (
            "# docs/widget.md`n`nThe prose cites ADR-WIDGET-PART-BEND.`n`n" +
            "``````yml drawio`nabout:`n  rules: [ADR-WIDGET-PART-FOLD, ADR-GADGET-LIFT]`n```````n"
        )
        (Get-Codes $body) | Should -Be @('ADR-WIDGET-PART-BEND')
    }

    It 'lists each cited rule once, ordered by record and then by its place in the record' {
        $codes = Get-Codes "# docs/widget.md`n`nSee ADR-WIDGET-PART-BEND and ADR-GADGET-RE12, then ADR-WIDGET-PART-BEND again, and ADR-GADGET-LIFT.`n"
        $codes | Should -Be @('ADR-GADGET-LIFT', 'ADR-GADGET-RE12', 'ADR-WIDGET-PART-BEND')
    }

    It 'writes the record code, which means the whole record, when every rule the registry declares is cited' {
        (Get-Codes "ADR-GADGET-LIFT ADR-GADGET-DROP ADR-GADGET-RE12`n") | Should -Be @('ADR-GADGET')
        (Get-Codes "ADR-GADGET-LIFT ADR-GADGET-DROP ADR-GADGET-RE12 ADR-WIDGET-PART-FOLD`n") |
            Should -Be @('ADR-GADGET', 'ADR-WIDGET-PART-FOLD')
    }

    It 'keeps the rules while one rule of the record is not cited' {
        (Get-Codes "ADR-GADGET-LIFT ADR-GADGET-RE12`n") | Should -Be @('ADR-GADGET-LIFT', 'ADR-GADGET-RE12')
    }

    It 'reads a numbered citation, a group or a wildcard in body text as no citation' {
        (Get-Codes ('The ADR-GADGET' + '#4 rule, the ADR-GADGET' + "#{2,3} group, the ADR-WIDGET-* family.`n")).Count |
            Should -Be 0
    }

    It 'ignores a rule heading and the record code of its own record in a markdown file' {
        (Get-Codes "### Rule ADR-WIDGET-PART-FOLD`n`nThe ADR-WIDGET-PART decision.`n").Count | Should -Be 0
    }

    It 'cites a bare record code in a markdown file' {
        (Get-Codes "# docs/widget.md`n`nThe whole ADR-WIDGET-PART decision applies.`n") |
            Should -Be @('ADR-WIDGET-PART')
    }

    It 'finds a citation inside a link' {
        (Get-Codes "[ADR-GADGET-DROP](/docs/drs/gadget.md#rule-adr-gadget-drop)`n") | Should -Be @('ADR-GADGET-DROP')
    }

    It 'leaves out a rule the file defines itself and keeps the rules it cites elsewhere' {
        $codes = Get-Codes "### Rule ADR-WIDGET-PART-FOLD`n`nThis rule extends ADR-WIDGET-PART-BEND, which sits in ADR-GADGET-DROP.`n`n### Rule ADR-WIDGET-PART-BEND`n"
        $codes | Should -Be @('ADR-GADGET-DROP')
    }

    It 'drops a code the index does not register and a rule its record does not declare' {
        (Get-Codes "See ADR-UNLISTED-ONE-TWO, ADR-GADGET-SINK and ADR-GADGET-DROP.`n") | Should -Be @('ADR-GADGET-DROP')
    }

    It 'returns an empty list for a file that cites nothing' {
        (Get-Codes "# docs/widget.md`n").Count | Should -Be 0
    }

    It 'does not read a citation from the front matter' {
        (Get-Codes "---`ncatzc:`n  cites:`n    - ADR-WIDGET-SPIN`n---`nbody`n").Count | Should -Be 0
    }

    Context 'a code file, whose class the domain classes name' {
        It 'lists a record code beside the rule codes of other records, reading below the head only' {
            $text = "/*`n---`ncatzc:`n  cites:`n    - ADR-HEAD-ONE-TWO`n---`n*/`n`n// ADR-GADGET, ADR-WIDGET-PART-BEND and ADR-WIDGET-TURN`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET', 'ADR-WIDGET-TURN', 'ADR-WIDGET-PART-BEND')
        }

        It 'lists a code alone when the text also cites a code below it, since a prefix selects everything below it' {
            (Get-CodeCodes "// ADR-WIDGET, ADR-WIDGET-SPIN and ADR-WIDGET-PART-FOLD`nclass Widget {}`n") |
                Should -Be @('ADR-WIDGET')
        }

        It 'drops a code that is neither registered nor the prefix of a registered code' {
            (Get-CodeCodes "// ADR-UNLISTED, ADR-GADGET and ADR-WIDGET-PART`n") | Should -Be @('ADR-GADGET',
                'ADR-WIDGET-PART')
        }

        It 'ignores a numbered citation' {
            # Built from two strings, so the string-citation check reads no numbered citation in this file.
            (Get-CodeCodes ('// ADR-GADGET' + ':1 and ADR-GADGET' + "#2`n")).Count | Should -Be 0
        }

        It 'derives the codes from the text alone and never keeps one the head lists' -Tag 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
            $text = "/*`n---`ncatzc:`n  cites:`n    - ADR-HEAD-ONE-TWO`n    - ADR-GADGET-LIFT`n---`n*/`n`n// ADR-GADGET-DROP and ADR-WIDGET-SPIN`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET-DROP', 'ADR-WIDGET-SPIN')
        }
    }
}

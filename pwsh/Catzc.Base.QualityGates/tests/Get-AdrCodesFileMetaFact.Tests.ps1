Describe 'Get-AdrCodesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        # The one fixture kind below is a code file, so its class is what the kind's settings name.
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{ 'widget-type' = [ordered]@{ definition = 'A widget type.'; files = @('widgets/**/types/*.cs') } }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }

        # The fixture codes below are the only ones this index registers, each declaring rules 1 to 30.
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Docs.AdrCitationMap]::new(@{
                    'ADR-WIDGET'      = @{ path = 'docs/adr/widget.md'; rules = 1..30 }
                    'ADR-WIDGET-PART' = @{ path = 'docs/adr/widget-part.md'; rules = 1..30 }
                    'ADR-GADGET'      = @{ path = 'docs/adr/gadget.md'; rules = 1..30 }
                }, @())
        }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('cites') } } }).kinds[0]

        function script:Get-Codes {
            param([string] $Body)
            $state = Get-MarkdownMetaState -Text $Body
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-AdrCodesFileMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            }
            , @($fact['cites'])
        }
    }

    It 'lists each cited rule once, in the minimal form, ordered by code and then numerically' {
        $codes = Get-Codes "# docs/widget.md`n`nSee ADR-WIDGET-PART#3 and ADR-GADGET#12, then ADR-WIDGET-PART#3 again, and ADR-GADGET#2.`n"
        $codes | Should -Be @('ADR-GADGET#{2,12}', 'ADR-WIDGET-PART#3')
    }

    It 'folds a run of rules into a range' {
        $codes = Get-Codes "ADR-GADGET#4, ADR-GADGET#5, ADR-GADGET#6, ADR-GADGET#9.`n"
        $codes | Should -Be @('ADR-GADGET#{4-6,9}')
    }

    It 'writes the bare code, which means the whole ADR, when every rule the registry declares is cited' {
        $all = (1..30 | ForEach-Object { "ADR-GADGET#$_" }) -join ' '
        (Get-Codes "$all`n") | Should -Be @('ADR-GADGET')
        (Get-Codes "$all ADR-WIDGET-PART#3`n") | Should -Be @('ADR-GADGET', 'ADR-WIDGET-PART#3')
    }

    It 'keeps the numbers while one rule of the ADR is not cited' {
        $most = (1..29 | ForEach-Object { "ADR-GADGET#$_" }) -join ' '
        (Get-Codes "$most`n") | Should -Be @('ADR-GADGET#{1-29}')
    }

    It 'reads a wildcard or a group in body text as a mention, never a citation' {
        $codes = Get-Codes "The ADR-GADGET#* rules, the ADR-WIDGET-* family, and ADR-GADGET#{2,3}.`n"
        $codes.Count | Should -Be 0
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
        $codes = Get-Codes "See ADR-UNLISTED#1, ADR-GADGET#99 and ADR-GADGET#4.`n"
        $codes | Should -Be @('ADR-GADGET#4')
    }

    It 'drops a rule number past int range instead of throwing' {
        $codes = Get-Codes "See ADR-GADGET#-1 and ADR-GADGET#4.`n"
        $codes | Should -Be @('ADR-GADGET#4')
    }

    It 'returns an empty list for a file that cites nothing' {
        (Get-Codes "# docs/widget.md`n").Count | Should -Be 0
    }

    It 'does not read a citation from the front matter' {
        $codes = Get-Codes "---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET#9`n---`nbody`n"
        $codes.Count | Should -Be 0
    }

    Context 'a code file, whose class the kind names under domain_classes' {
        BeforeAll {
            $script:codeKind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ 'adr-codes' = @{ keys = @('cites'); settings = @{ domain_classes = @('widget-*') } } }
                }).kinds[0]

            function script:Get-CodeCodes {
                param([string] $Text)
                $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
                $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                    param($State, $Kind)
                    Get-AdrCodesFileMetaFact -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -Kind $Kind
                }
                , @($fact['cites'])
            }
        }

        It 'lists a bare domain code beside the rule codes of other ADRs, reading below the head only' {
            $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD#1`n---`n*/`n`n// ADR-WIDGET, ADR-GADGET#4 and ADR-WIDGET-PART#2`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET#4', 'ADR-WIDGET', 'ADR-WIDGET-PART#2')
        }

        It 'lists a bare code alone when the text also cites a rule of that ADR, since no numbers means the whole ADR' {
            $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD#1`n---`n*/`n`n// ADR-WIDGET and ADR-WIDGET#2`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-WIDGET')
        }

        It 'drops a bare code that is neither registered nor the prefix of a registered code' {
            (Get-CodeCodes "// ADR-UNLISTED, ADR-WIDGET and ADR-WIDGET-PART`n") | Should -Be @('ADR-WIDGET', 'ADR-WIDGET-PART')
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
            , @($fact['cites']) | Should -Be @('ADR-GADGET#4')
        }
    }

    Context 'a code file' {
        BeforeAll {
            $script:codeKind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ 'adr-codes' = @{ keys = @('cites'); select = @(@{ classes = @('widget-type') }) } }
                }).kinds[0]

            function script:Get-CodeCodes {
                param([string] $Text)
                $state = Get-CodeMetaState -Text $Text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
                $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:codeKind } {
                    param($State, $Kind)
                    Get-AdrCodesFileMetaFact -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -Kind $Kind
                }
                , @($fact['cites'])
            }
        }

        It 'derives the codes from the text alone and never keeps one the head lists' -Tag 'ADR-REPO-FILEMETA-NOREADBACK', 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
            $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD#1`n      - ADR-GADGET#4`n---`n*/`n`n// ADR-GADGET#4 and ADR-WIDGET#2`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET#4', 'ADR-WIDGET#2')
        }

        It 'gives the same codes whether the file has a head or not' -Tag 'ADR-REPO-FILEMETA-NOREADBACK' {
            $withHead = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD#1`n---`n*/`n`n// ADR-WIDGET#2`nclass Widget {}`n"
            $without = "// ADR-WIDGET#2`nclass Widget {}`n"
            (Get-CodeCodes $withHead) | Should -Be (Get-CodeCodes $without)
        }

        It 'writes the rules the text cites in the minimal form' -Tag 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
            $text = "// ADR-GADGET#2, ADR-GADGET#3 and ADR-GADGET#4`nclass Widget {}`n"
            (Get-CodeCodes $text) | Should -Be @('ADR-GADGET#{2-4}')
        }
    }

    It 'takes domain_classes from the classes the kind selects when it is not set' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER', 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
        $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ 'adr-codes' = @{ keys = @('cites'); select = @(@{ languages = @('markdown') }, @{ classes = @('widget-type') }) } }
            }).kinds[0]
        $text = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-HEAD#1`n---`n*/`n`n// ADR-WIDGET and ADR-GADGET#4`nclass Widget {}`n"
        $state = Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/'))
        $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $kind } {
            param($State, $Kind)
            Get-AdrCodesFileMetaFact -State $State -Path 'widgets/Catzc.Widget/types/Widget.cs' -Kind $Kind
        }
        $fact['cites'] | Should -Be @('ADR-GADGET#4', 'ADR-WIDGET')
    }
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-HelpHeadFinding.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-HelpHeadFinding.ps1
    adrs:
      - ADR-REPO-HELP#{3,4}
---
#>

Describe 'Get-HelpHeadFinding' -Tag 'L0', 'logic', 'ADR-REPO-HELP#4' {
    BeforeAll {
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<#', '#>')
        $script:find = {
            param([string] $Text)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; Form = $script:form } {
                param($Text, $Form)
                , @(Get-HelpHeadFinding -Text $Text -Form $Form)
            }
        }
        # A head with the given config lines, over a function with one parameter and a declared output type.
        $script:file = {
            param([string[]] $Config)
            $head = @('<#', '---', 'catzc:', '  derived:', '    path: automation/Catzc.Widget/Get-Gadget.ps1', '    kind: automation-function')
            if ($Config) {
                $head += '  config:'
                $head += $Config
            }
            $head += '---', '#>', ''
            ($head -join "`n") + "`nfunction Get-Gadget {`n    [CmdletBinding()]`n    [OutputType([string])]`n    param(`n        [string] `$Name`n    )`n}`n"
        }
        $script:good = @('    synopsis: Returns a gadget.', '    parameters:', '      Name: The name.', '    outputs: ''[string] The name.''')
    }

    It 'finds nothing in help that is in order' {
        (& $script:find (& $script:file $script:good)).Count | Should -Be 0
    }

    It 'reports a comment-based help block, whatever the head holds' {
        $text = (& $script:file $script:good).Replace('function Get-Gadget', "<#`n.SYNOPSIS`n    Old.`n#>`n" + 'function Get-Gadget')
        (& $script:find $text) | Should -Contain 'comment-based help is not used: write the synopsis, description, parameters, outputs and examples as keys of the head''s config'
    }

    It 'reports a head with no synopsis' {
        (& $script:find (& $script:file @())) | Should -Contain 'the head''s config has no synopsis'
        (& $script:find (& $script:file @('    parameters:', '      Name: The name.'))) | Should -Contain 'the head''s config has no synopsis'
    }

    It 'reports keys out of order' {
        $config = @('    parameters:', '      Name: The name.', '    synopsis: Returns a gadget.')
        (& $script:find (& $script:file $config)) | Should -Contain 'the help keys are out of order: parameters, synopsis, expected synopsis, parameters'
    }

    It 'reports a parameter with no entry and an entry for a parameter the function does not declare' {
        $found = & $script:find (& $script:file @('    synopsis: Returns a gadget.', '    parameters:', '      Other: The other.'))
        $found | Should -Contain 'the parameter Other is documented but the function declares no such parameter'
        $found | Should -Contain 'the parameter Name is declared but has no entry in parameters'
    }

    It 'reports an outputs string whose type differs from OutputType' {
        $config = @('    synopsis: Returns a gadget.', '    parameters:', '      Name: The name.', '    outputs: ''[int] The count.''')
        (& $script:find (& $script:file $config)) | Should -Contain 'outputs documents [int] but [OutputType] declares [string]'
    }

    It 'reports a line made of nothing but a citation' {
        $config = @('    synopsis: Returns a gadget.', '    description: |-', '      Does the thing.', '      [ADR-REPO-HELP#3](/docs/adr/repository/function-help.md#rule-adr-repo-help3)', '    parameters:', '      Name: The name.')
        (& $script:find (& $script:file $config)) | Should -Contain 'the help text description holds a line made of a citation or a page link, which the head derives'
    }
}

Describe 'Get-HelpPageFinding' -Tag 'L0', 'logic', 'ADR-REPO-HELP-FIVEFAULTSREPORTED' {
    BeforeAll {
        $script:code = "function Get-Widget {`n    [CmdletBinding()]`n    [OutputType([string])]`n    param(`n        [string] `$Name,`n        [switch] `$Force`n    )`n}`n"
        $script:page = {
            param([string] $Body)
            "# pwsh/Catzc.Widget/Get-Widget.ps1`n`nThe intro.`n`n## help`n`n$Body"
        }
        $script:find = {
            param([string] $Text, [string] $PageText)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; PageText = $PageText } {
                param($Text, $PageText)
                @(Get-HelpPageFinding -Text $Text -PageText $PageText)
            }
        }
    }

    It 'finds nothing in help that matches the function' {
        $body = "### synopsis`n`nGets a widget.`n`n### parameter ``Name```n`nThe name.`n`n### parameter ``Force```n`nSkips.`n`n### outputs`n`n[string] the name.`n"
        @(& $script:find $script:code (& $script:page $body)).Count | Should -Be 0
    }

    It 'reports a file with no page and a page with no help section' {
        & $script:find $script:code $null |
            Should -Be @('the file has no comment page: write its help in the page''s ## help section')
        & $script:find $script:code "# t`n`n## comment:1`n" | Should -Be @('the comment page has no ## help section')
    }

    It 'reports a parameter with no subsection, one the function does not declare, and the order of the param block' {
        $body = "### synopsis`n`nGets.`n`n### parameter ``Force```n`nSkips.`n`n### parameter ``Name```n`nThe name.`n`n### parameter ``Size```n`nGone.`n"
        $found = & $script:find $script:code (& $script:page $body)
        $found | Should -Contain 'the parameter Size is documented but the function declares no such parameter'
        @($found | Where-Object { $_ -like '*not in the order of the param block*' }).Count | Should -Be 1
        $found = & $script:find $script:code (& $script:page "### synopsis`n`nGets.`n`n### parameter ``Name```n`nThe name.`n")
        $found | Should -Contain 'the parameter Force is declared but has no ### parameter subsection'
    }

    It 'reports an outputs type that differs from [OutputType]' {
        $body = "### synopsis`n`nGets.`n`n### parameter ``Name```n`nN.`n`n### parameter ``Force```n`nF.`n`n### outputs`n`n[int] a count.`n"
        & $script:find $script:code (& $script:page $body) |
            Should -Be @('outputs documents [int] but [OutputType] declares [string]')
    }

    It 'reports a comment-based help block and a help line made of a citation alone' {
        $legacy = "<#`n.SYNOPSIS`n    Gets.`n#>`n" + $script:code
        $body = "### synopsis`n`nGets.`n`n### description`n`n[ADR-WIDGET-SPINS](/docs/drs/widget.md#rule-adr-widget-spins)`n`n### parameter ``Name```n`nN.`n`n### parameter ``Force```n`nF.`n"
        $found = & $script:find $legacy (& $script:page $body)
        $found |
            Should -Contain 'comment-based help is not used: write the help in the ## help section of the comment page'
        $found |
            Should -Contain 'a help line is made of nothing but a citation or a page link, which the tooling derives'
    }

    It 'reports a comment-based help block indented inside the function' {
        $indented = $script:code.Replace("{`n    [CmdletBinding()]",
            "{`n    <#`n    .SYNOPSIS`n        Gets.`n    #>`n    [CmdletBinding()]")
        $body = "### synopsis`n`nGets.`n`n### parameter ``Name```n`nN.`n`n### parameter ``Force```n`nF.`n"
        & $script:find $indented (& $script:page $body) |
            Should -Be @('comment-based help is not used: write the help in the ## help section of the comment page')
    }

    It 'passes the section''s shape faults through' {
        & $script:find $script:code (& $script:page "### description`n`nGets.`n`n### parameter ``Name```n`nN.`n`n### parameter ``Force```n`nF.`n") |
            Should -Be @('the help section has no synopsis')
    }

    It 'yields nothing for a file that does not parse' {
        @(& $script:find 'function Get-Widget {' $null).Count | Should -Be 0
    }
}

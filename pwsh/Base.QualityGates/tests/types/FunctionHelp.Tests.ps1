Describe 'FunctionHelp' -Tag 'L0', 'logic', 'ADR-REPO-HELP-HELPONCOMMENTPAGE' {
    BeforeAll {
        $script:config = [ordered]@{
            synopsis    = 'Gets a widget.'
            description = "Reads the widget registry.`n`n- one`n- two"
            parameters  = [ordered]@{ Name = 'The widget name.'; Force = 'Skips the gadget check.' }
            outputs     = '[Widget] the widget.'
            examples    = @('Get-Widget -Name cog', "`$w = Get-Widget -Name cog`n`$w.Size")
        }
        $script:section = [Catzc.Base.QualityGates.FunctionHelp]::FromConfig($script:config).ToSection()
    }

    It 'renders the help in the fixed shape, each subsection once and in order, its text as written' -Tag 'ADR-REPO-HELP-MARKDOWNASWRITTEN' {
        $script:section | Should -BeExactly (
            "## help`n`n### synopsis`n`nGets a widget.`n`n### description`n`nReads the widget registry.`n`n- one`n- two`n`n" +
            "### parameter ``Name```n`nThe widget name.`n`n### parameter ``Force```n`nSkips the gadget check.`n`n### outputs`n`n``[Widget]`` the widget.`n`n" +
            "### example 1`n`n``````powershell`nGet-Widget -Name cog`n```````n`n### example 2`n`n``````powershell`n`$w = Get-Widget -Name cog`n`$w.Size`n```````n")
    }

    It 'reads back what it renders' {
        $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse("# docs`n`n$($script:section)")
        $help.present | Should -BeTrue
        $help.findings.Count | Should -Be 0
        $help.synopsis | Should -BeExactly 'Gets a widget.'
        $help.description | Should -BeExactly "Reads the widget registry.`n`n- one`n- two"
        @($help.parameters | ForEach-Object Key) | Should -Be @('Name', 'Force')
        $help.outputs | Should -BeExactly '`[Widget]` the widget.'
        $help.examples[1] | Should -BeExactly "`$w = Get-Widget -Name cog`n`$w.Size"
    }

    It 'reads a synopsis a formatter wrapped as the one line it was written as' {
        $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse("## help`n`n### synopsis`n`nGets a widget`nfrom the registry.`n")
        $help.synopsis | Should -BeExactly 'Gets a widget from the registry.'
    }

    It 'never takes a heading inside an example fence for a subsection' {
        $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse("## help`n`n### synopsis`n`nGets.`n`n### example 1`n`n``````powershell`n### not a heading`n```````n")
        $help.findings.Count | Should -Be 0
        $help.examples[0] | Should -BeExactly '### not a heading'
    }

    It 'reports a subsection the shape does not name, one out of order, text before the first, and a missing synopsis' -Tag 'ADR-REPO-HELP-FIVEFAULTSREPORTED' {
        $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse("## help`n`nstray`n`n### outputs`n`nx`n`n### description`n`ny`n`n### remarks`n`nz`n")
        $help.findings |
            Should -Contain 'the help section holds text before its first subsection: put it under ### synopsis or ### description'
        @($help.findings | Where-Object { $_ -like '*out of order*' }).Count | Should -Be 1
        $help.findings | Should -Contain 'the help section has a subsection the shape does not name: ''### remarks'''
        $help.findings | Should -Contain 'the help section has no synopsis'
    }

    It 'reads a parameter name written as code, and reports one written bare' -Tag 'ADR-REPO-HELP-HELPONCOMMENTPAGE' {
        $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse("## help`n`n### synopsis`n`nGets.`n`n### parameter ``Slot```n`nThe slot.`n`n### parameter Gadget`n`nThe gadget.`n")
        @($help.parameters | ForEach-Object Key) | Should -Be @('Slot', 'Gadget')
        $help.findings |
            Should -Be @('the parameter heading ''### parameter Gadget'' writes its name as code: ''### parameter `Gadget`''')
    }

    It 'stops the section at the page''s next section, so a comment section is no help' {
        $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse("## help`n`n### synopsis`n`nGets.`n`n## comment:1`n`n### stray`n")
        $help.findings.Count | Should -Be 0
    }

    It 'reports no section on a page without one' {
        [Catzc.Base.QualityGates.FunctionHelp]::Parse("# docs`n`n## comment:1`n").present | Should -BeFalse
    }

    Context 'plain help text as Markdown' -Tag 'ADR-REPO-HELP-MARKDOWNASWRITTEN' {
        BeforeAll {
            $script:md = { param([string] $Text) [Catzc.Base.QualityGates.FunctionHelp]::Markdown($Text) }
        }

        It 'spans a placeholder, a glob and a bracket token, and leaves code spans, links and URLs as written' {
            & $script:md 'Writes <out>/widget, globs **/*.wdg and returns [string[]] (see `<kept>`, [ADR-WIDGET-TURN](/docs/drs/widget.md) and <https://example.com>).' |
                Should -BeExactly 'Writes `<out>/widget`, globs `**/*.wdg` and returns `[string[]]` (see `<kept>`, [ADR-WIDGET-TURN](/docs/drs/widget.md) and <https://example.com>).'
        }

        It 'spans a placeholder with spaces in it, and a URL with a placeholder in it, and turns any other bare URL into an autolink' {
            & $script:md "'<widget path>#<old anchor>' -> new" |
                Should -BeExactly "'``<widget path>#<old anchor>``' -> new"
            & $script:md 'under <widget root>/gadget/<name>, by default' |
                Should -BeExactly 'under `<widget root>/gadget/<name>`, by default'
            & $script:md "'<file hash>:<stamp>' is kept" | Should -BeExactly "'``<file hash>:<stamp>``' is kept"
        }

        It 'keeps a code span the author broke across two lines as one span' {
            & $script:md "a top-level ``func Test<Name>(t`n*testing.T)`` whose name" |
                Should -BeExactly "a top-level ``func Test<Name>(t`n*testing.T)`` whose name"
            & $script:md 'The URL (https://example.com/<owner>/<repo>), or https://example.com/dl/?mode=json.' |
                Should -BeExactly 'The URL (`https://example.com/<owner>/<repo>`), or <https://example.com/dl/?mode=json>.'
        }

        It 'writes emphasis with underscores and keeps strong emphasis' {
            & $script:md 'takes a widget *name*, **never** an id' |
                Should -BeExactly 'takes a widget _name_, **never** an id'
        }

        It 'moves an indented list to the margin with a blank line around it, a star marker written as a dash' {
            & $script:md "Checks:`n  * the widget exists;`n    and is shaped`n  * the gadget is known.`nThen it returns." |
                Should -BeExactly "Checks:`n`n- the widget exists;`n  and is shaped`n- the gadget is known.`n`nThen it returns."
        }

        It 'keeps a nested item under its parent and an ordered list numbered as written' {
            & $script:md "1. first`n   - inner`n2. second" | Should -BeExactly "1. first`n   - inner`n2. second"
        }

        It 'fences an aligned layout verbatim, moved to the margin' {
            & $script:md "Keys:`n  widget_files   — all *.wdg files`n  gadget_folder  — the gadgets/ folder`nDone." |
                Should -BeExactly "Keys:`n`n``````text`nwidget_files   — all *.wdg files`ngadget_folder  — the gadgets/ folder`n```````n`nDone."
        }

        It 'keeps a fenced block as written' {
            & $script:md "Run:`n`n``````powershell`nGet-Widget *`n```````n" |
                Should -BeExactly "Run:`n`n``````powershell`nGet-Widget *`n``````"
        }
    }

    Context 'writing the section into a page' -Tag 'ADR-REPO-COMMENTS-PAGEISAUTHORED' {
        It 'puts a new section before the page''s first section and keeps every other byte' {
            $page = "# docs/x.ps1`n`nThe intro.`n`n## comment:1`n`nAbove ``x``.`n"
            [Catzc.Base.QualityGates.FunctionHelp]::WithSection($page, "## help`n`n### synopsis`n`nGets.`n") |
                Should -BeExactly "# docs/x.ps1`n`nThe intro.`n`n## help`n`n### synopsis`n`nGets.`n`n## comment:1`n`nAbove ``x``.`n"
        }

        It 'appends the section to a page with no section yet' {
            [Catzc.Base.QualityGates.FunctionHelp]::WithSection("# docs/x.ps1`n`nThe intro.`n",
                "## help`n`n### synopsis`n`nGets.`n") |
                Should -BeExactly "# docs/x.ps1`n`nThe intro.`n`n## help`n`n### synopsis`n`nGets.`n"
        }

        It 'replaces an existing section, so a second write changes nothing' {
            $page = "# t`n`n## help`n`n### synopsis`n`nOld.`n`n## comment:1`n`nx`n"
            $once = [Catzc.Base.QualityGates.FunctionHelp]::WithSection($page, "## help`n`n### synopsis`n`nNew.`n")
            $once | Should -BeExactly "# t`n`n## help`n`n### synopsis`n`nNew.`n`n## comment:1`n`nx`n"
            [Catzc.Base.QualityGates.FunctionHelp]::WithSection($once, "## help`n`n### synopsis`n`nNew.`n") |
                Should -BeExactly $once
        }
    }
}

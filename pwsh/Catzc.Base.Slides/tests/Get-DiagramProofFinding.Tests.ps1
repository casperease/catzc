Describe 'Get-DiagramProofFinding' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-DECLARATION' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widgets')) | Out-Null
        $script:proof = @'
runs:
  - - get_widget: { path: widgets/a.wdg, depth: 2 }
    - get_gadget:
  - - get_widget: { path: widgets/b.wdg }
'@
        [System.IO.File]::WriteAllText((Join-Path $script:root 'widgets/widgets.accosted.yml'), $script:proof)
        $script:find = {
            param([string] $Text)
            InModuleScope Catzc.Base.Slides -Parameters @{ Root = $script:root; Text = $Text } {
                param($Root, $Text)
                Get-DiagramProofFinding -Stem 'docs/widgets/.assets/widget-act' -Text $Text -RepositoryRoot $Root
            }
        }
        $script:action = @'
about:
  proves: widgets/widgets.accosted.yml
content:
  style: action
  action:
    call: { get_widget: { path: widgets/a.wdg, depth: 2 } }
  effects:
    - { id: e-one, ring: 1, where: local, says: the widget is read, proves: { get_gadget: } }
'@
    }

    BeforeEach {
        Mock Get-AccostedFile -ModuleName Catzc.Base.Slides {
            [Catzc.Base.Contracts.AccostedFile]::new((ConvertFrom-Yaml -Yaml $script:proof -Ordered))
        }
    }

    It 'is inert for a band diagram, whatever its about holds' {
        @(& $script:find "about:`n  proves: nowhere.accosted.yml`ncontent:`n  title: widgets`n  bands: []").Count | Should -Be 0
        Should -Invoke Get-AccostedFile -ModuleName Catzc.Base.Slides -Times 0 -Exactly
    }

    It 'passes an action diagram whose action and effects all occur in the proof file' {
        @(& $script:find $script:action).Count | Should -Be 0
        Should -Invoke Get-AccostedFile -ModuleName Catzc.Base.Slides -Times 1 -Exactly
    }

    It 'passes the calls variant of the action' {
        $text = $script:action -replace '    call: \{[^\r\n]*\}', "    calls:`n      - { get_widget: { path: widgets/a.wdg, depth: 2 } }`n      - { get_gadget: }"
        @(& $script:find $text).Count | Should -Be 0
    }

    It 'asks for about.proves when an action diagram names no file' {
        @(& $script:find "about:`n  lens: meta`ncontent:`n  style: action").Count | Should -Be 1
        (@(& $script:find "about:`n  lens: meta`ncontent:`n  style: action"))[0] | Should -BeLike '*names the accosted file that proves it in about.proves'
    }

    It 'names a proof file that does not exist' {
        $text = $script:action -replace 'widgets/widgets.accosted.yml', 'widgets/missing.accosted.yml'
        (@(& $script:find $text))[0] | Should -BeLike "*about.proves names 'widgets/missing.accosted.yml', which does not exist"
    }

    It 'names a drawn command the file does not run, with where it is drawn: <Case>' -ForEach @(
        @{ Case = 'an action whose arguments differ'; Replace = 'depth: 2 } }'; With = 'depth: 3 } }'; Where = 'action.call' }
        @{ Case = 'an effect whose command is not in the file'; Replace = 'proves: { get_gadget: } }'; With = 'proves: { get_gizmo: } }'; Where = 'effects[e-one].proves' }
    ) {
        $findings = @(& $script:find ($script:action.Replace($Replace, $With)))
        $findings.Count | Should -Be 1
        $findings[0] | Should -BeLike "*: $([WildcardPattern]::Escape($Where)) '*' with these arguments is not a command of widgets/widgets.accosted.yml"
    }
}

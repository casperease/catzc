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
  lens: action
  proves: widgets/widgets.accosted.yml
content:
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
        Mock Get-CommandContract -ModuleName Catzc.Base.Contracts {
            foreach ($spec in @(
                    @{ Name = 'get_widget'; Specs = @{ path = 'string!'; depth = 'int' } }
                    @{ Name = 'get_gadget'; Specs = @{} }
                    @{ Name = 'set_widget'; Specs = @{ path = 'string!' } }
                )) {
                $parameters = @(foreach ($key in $spec.Specs.Keys) {
                        [Catzc.Base.Contracts.ContractParameter]::Parse($key, $spec.Specs[$key])
                    })
                [pscustomobject]@{ Name = $spec.Name; parameters = $parameters; Signature = "$($spec.Name)(...)" }
            }
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
        @(& $script:find "about:`n  lens: action`ncontent:`n  title: widgets").Count | Should -Be 1
        (@(& $script:find "about:`n  lens: action`ncontent:`n  title: widgets"))[0] | Should -BeLike '*names the accosted file that proves it in about.proves'
    }

    It 'names a proof file that does not exist' {
        $text = $script:action -replace 'widgets/widgets.accosted.yml', 'widgets/missing.accosted.yml'
        (@(& $script:find $text))[0] | Should -BeLike "*about.proves names 'widgets/missing.accosted.yml', which does not exist"
    }

    It 'passes a mutating action the proof file does not hold, as it is a contracted command that fits' {
        $text = $script:action.Replace('call: { get_widget: { path: widgets/a.wdg, depth: 2 } }', 'call: { set_widget: { path: widgets/a.wdg } }')
        @(& $script:find $text).Count | Should -Be 0
    }

    It 'names an action that breaks its contract, with where it is drawn: <Case>' -ForEach @(
        @{ Case = 'an uncontracted command'; Replace = 'call: { get_widget: { path: widgets/a.wdg, depth: 2 } }'; With = 'call: { set_gizmo: { path: a } }'; Message = "*: action.call: 'set_gizmo' is no contracted command*" }
        @{ Case = 'a bad argument'; Replace = 'depth: 2 } }'; With = 'depth: deep } }'; Message = "*: action.call: 'depth' takes int*" }
    ) {
        $findings = @(& $script:find ($script:action.Replace($Replace, $With)))
        $findings.Count | Should -Be 1
        $findings[0] | Should -BeLike $Message
    }

    It 'passes an executing effect the proof file does not hold, as it is a contracted command that fits' {
        $text = $script:action.Replace('proves: { get_gadget: } }', 'call: { set_widget: { path: widgets/a.wdg } } }')
        @(& $script:find $text).Count | Should -Be 0
    }

    It 'names an executing effect that breaks its contract, with where it is drawn: <Case>' -ForEach @(
        @{ Case = 'an uncontracted command'; With = 'call: { set_gizmo: { path: a } } }'; Message = "*: effects[e-one].call: 'set_gizmo' is no contracted command*" }
        @{ Case = 'a bad argument'; With = 'call: { get_widget: { path: a, depth: deep } } }'; Message = "*: effects[e-one].call: 'depth' takes int*" }
    ) {
        $findings = @(& $script:find ($script:action.Replace('proves: { get_gadget: } }', $With)))
        $findings.Count | Should -Be 1
        $findings[0] | Should -BeLike ($Message.Replace('[', '`[').Replace(']', '`]'))
    }

    It 'refuses an effect that carries <Case>' -ForEach @(
        @{ Case = 'both proves and call'; With = 'proves: { get_gadget: }, call: { get_gadget: } }'; Message = '*effects`[e-one`] carries both proves and call*' }
        @{ Case = 'neither proves nor call'; With = '}'; Message = '*effects`[e-one`] carries neither proves nor call*' }
    ) {
        $findings = @(& $script:find ($script:action.Replace('proves: { get_gadget: } }', $With)))
        $findings.Count | Should -Be 1
        $findings[0] | Should -BeLike $Message
    }

    It 'names an effect whose command is not in the proof file, with where it is drawn' {
        $findings = @(& $script:find ($script:action.Replace('proves: { get_gadget: } }', 'proves: { get_gizmo: } }')))
        $findings.Count | Should -Be 1
        $findings[0] | Should -BeLike "*: $([WildcardPattern]::Escape('effects[e-one].proves')) '*' with these arguments is not a command of widgets/widgets.accosted.yml"
    }
}

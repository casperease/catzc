Describe 'Move-FunctionHelp' -Tag 'L0', 'logic', 'ADR-REPO-HELP-HELPONCOMMENTPAGE' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'help-repository'
        $script:codePath = 'widgets/Catzc.Widget/Get-Widget.ps1'
        $script:pagePath = "docs/references/$($script:codePath).md"
        $script:headed = "<#`n---`ncatzc:`n  immutable:`n    path: widgets/Catzc.Widget/Get-Widget.ps1`n  config:`n    synopsis: Gets a widget.`n    parameters:`n      Name: The widget name.`n---`n#>`n`nfunction Get-Widget {`n    param([string] `$Name)`n}`n"
        $script:move = {
            param([switch] $DryRun)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Path = $script:codePath; DryRun = [bool] $DryRun } {
                param($Root, $Path, $DryRun)
                Move-FunctionHelp -Path $Path -RepositoryRoot $Root -DryRun:$DryRun
            }
        }
    }

    BeforeEach {
        Remove-Item -LiteralPath $script:widgetRoot -Recurse -Force -ErrorAction Ignore
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'widgets/Catzc.Widget')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:codePath), $script:headed)
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'comments' } {
            $comments = [pscustomobject]@{}
            $comments | Add-Member -MemberType ScriptMethod -Name PageFor -Value { param($Path) "docs/references/$Path.md" }
            $comments
        }
    }

    It 'writes the help onto a fresh page and leaves the head its facts without the config part' {
        $result = & $script:move
        $result.Moved | Should -BeTrue
        $page = [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:pagePath))
        $page.StartsWith("# widgets/Catzc.Widget/Get-Widget.ps1`n`nThe comments of the file") | Should -BeTrue
        $page.EndsWith("`n`n## help`n`n### synopsis`n`nGets a widget.`n`n### parameter ``Name```n`nThe widget name.`n") | Should -BeTrue
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:codePath)) |
            Should -BeExactly "<#`n---`ncatzc:`n  immutable:`n    path: widgets/Catzc.Widget/Get-Widget.ps1`n---`n#>`n`nfunction Get-Widget {`n    param([string] `$Name)`n}`n"
    }

    It 'puts the help before the comment sections of an existing page and keeps them as they are' -Tag 'ADR-REPO-COMMENTS-PAGEISAUTHORED' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot ([System.IO.Path]::GetDirectoryName($script:pagePath)))) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:pagePath), "# t`n`nThe intro.`n`n## comment:1`n`nAbove ``x``.`n")
        & $script:move | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:pagePath)) |
            Should -BeExactly "# t`n`nThe intro.`n`n## help`n`n### synopsis`n`nGets a widget.`n`n### parameter ``Name```n`nThe widget name.`n`n## comment:1`n`nAbove ``x``.`n"
    }

    It 'removes a head left with nothing but its config part' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:codePath), "<#`n---`ncatzc:`n  config:`n    synopsis: Gets.`n---`n#>`n`nfunction Get-Widget { }`n")
        & $script:move | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:codePath)) | Should -BeExactly "function Get-Widget { }`n"
    }

    It 'changes nothing on a second move, once the head holds no help' {
        & $script:move | Out-Null
        $second = & $script:move
        $second.Moved | Should -BeFalse
        $second.Reason | Should -BeExactly 'the head holds no help'
    }

    It 'leaves a file alone whose config part holds a key that is no help key, naming it' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:codePath), "<#`n---`ncatzc:`n  config:`n    synopsis: Gets.`n    owner: gadget-team`n---`n#>`n`nfunction Get-Widget { }`n")
        $result = & $script:move
        $result.Moved | Should -BeFalse
        $result.Reason | Should -BeLike '*no help keys (owner)*'
        [System.IO.File]::Exists((Join-Path $script:widgetRoot $script:pagePath)) | Should -BeFalse
    }

    It 'keeps each code it is handed as a real link in the description, after any description there is' -Tag 'ADR-REPO-FILEMETA-NOREADBACK' {
        $links = '[ADR-WIDGET-TURN](/docs/adr/widget.md#rule-adr-widget-turn)', '[ADR-GADGET](/docs/adr/gadget.md)'
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Path = $script:codePath; Links = $links } {
            param($Root, $Path, $Links)
            Move-FunctionHelp -Path $Path -RepositoryRoot $Root -RestsOn $Links -DryRun
        }
        $result.PageText.Contains("### synopsis`n`nGets a widget.`n`n### description`n`nIt rests on [ADR-WIDGET-TURN](/docs/adr/widget.md#rule-adr-widget-turn) and [ADR-GADGET](/docs/adr/gadget.md).`n`n### parameter ``Name``") | Should -BeTrue
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:codePath), "<#`n---`ncatzc:`n  config:`n    synopsis: Gets.`n    description: Reads the registry.`n---`n#>`n`nfunction Get-Widget { }`n")
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Path = $script:codePath; Links = @($links[0]) } {
            param($Root, $Path, $Links)
            Move-FunctionHelp -Path $Path -RepositoryRoot $Root -RestsOn $Links -DryRun
        }
        $result.PageText.Contains("### description`n`nReads the registry.`n`nIt rests on [ADR-WIDGET-TURN](/docs/adr/widget.md#rule-adr-widget-turn).`n") | Should -BeTrue
    }

    It 'adds no sentence for an empty or a null list of codes' {
        foreach ($links in @(@(), $null)) {
            $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Path = $script:codePath; Links = $links } {
                param($Root, $Path, $Links)
                Move-FunctionHelp -Path $Path -RepositoryRoot $Root -RestsOn $Links -DryRun
            }
            $result.Moved | Should -BeTrue
            $result.PageText.Contains('It rests on') | Should -BeFalse
        }
    }

    It 'computes both texts under -DryRun and writes neither file' -Tag 'ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT' {
        $result = & $script:move -DryRun
        $result.Moved | Should -BeTrue
        $result.PageText | Should -BeLike '*## help*'
        [System.IO.File]::Exists((Join-Path $script:widgetRoot $script:pagePath)) | Should -BeFalse
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:codePath)) | Should -BeExactly $script:headed
    }
}

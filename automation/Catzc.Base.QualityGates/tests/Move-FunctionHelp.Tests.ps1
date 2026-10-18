Describe 'Move-FunctionHelp' -Tag 'L0', 'logic', 'ADR-REPO-HELP#1' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'help-repository'
        $script:codePath = 'automation/Catzc.Widget/Get-Widget.ps1'
        $script:pagePath = "docs/references/$($script:codePath).md"
        $script:headed = "<#`n---`ncatzc:`n  immutable:`n    path: automation/Catzc.Widget/Get-Widget.ps1`n  config:`n    synopsis: Gets a widget.`n    parameters:`n      Name: The widget name.`n---`n#>`n`nfunction Get-Widget {`n    param([string] `$Name)`n}`n"
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
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'automation/Catzc.Widget')) | Out-Null
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
        $page | Should -BeLike "# automation/Catzc.Widget/Get-Widget.ps1`n`nThe comments of the file*`n`n## help`n`n### synopsis`n`nGets a widget.`n`n### parameter Name`n`nThe widget name.`n"
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:codePath)) |
            Should -BeExactly "<#`n---`ncatzc:`n  immutable:`n    path: automation/Catzc.Widget/Get-Widget.ps1`n---`n#>`n`nfunction Get-Widget {`n    param([string] `$Name)`n}`n"
    }

    It 'puts the help before the comment sections of an existing page and keeps them as they are' -Tag 'ADR-REPO-COMMENTS#6' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot ([System.IO.Path]::GetDirectoryName($script:pagePath)))) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:pagePath), "# t`n`nThe intro.`n`n## comment:1`n`nAbove ``x``.`n")
        & $script:move | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:pagePath)) |
            Should -BeExactly "# t`n`nThe intro.`n`n## help`n`n### synopsis`n`nGets a widget.`n`n### parameter Name`n`nThe widget name.`n`n## comment:1`n`nAbove ``x``.`n"
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

    It 'computes both texts under -DryRun and writes neither file' -Tag 'ADR-AUTO-DRYRUN#2' {
        $result = & $script:move -DryRun
        $result.Moved | Should -BeTrue
        $result.PageText | Should -BeLike '*## help*'
        [System.IO.File]::Exists((Join-Path $script:widgetRoot $script:pagePath)) | Should -BeFalse
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $script:codePath)) | Should -BeExactly $script:headed
    }
}

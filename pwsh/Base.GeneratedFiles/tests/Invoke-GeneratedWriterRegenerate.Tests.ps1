Describe 'Invoke-GeneratedWriterRegenerate' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([string] $Name, [string] $Regenerate, [string[]] $Outputs)
            [Catzc.Base.Variants.GeneratedWriterRow]::new($Name, [ordered]@{ class = 'rollable'; regenerate = $Regenerate; outputs = $Outputs })
        }
        $script:run = {
            param($Writer, $Writers)
            InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Writer = $Writer; Writers = $Writers } {
                param($Writer, $Writers)
                Invoke-GeneratedWriterRegenerate -Writer $Writer -Writers $Writers -RepositoryRoot 'widget-root'
            }
        }
    }

    BeforeEach {
        $script:seen = [System.Collections.Generic.List[string]]::new()
        $script:exit = 0
        Mock Get-Config -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $Config -eq 'tools' } { @{ gadget = @{ command = 'gadget' } } }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Found = $true; Path = 'C:/tools/gadget.exe' } }
        Mock Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles {
            $script:seen.Add($Command)
            [pscustomobject] @{ ExitCode = $script:exit; Full = 'widget output' }
        }
        # The outputs were rolled off: the disk holds none, the index still names them.
        Mock Get-GeneratedWriterInputFile -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ File = [string[]] @(); Folder = [string[]] @() } }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.GeneratedFiles {
            @('docs/deck/.assets/gadget.slide.png', 'docs/deck/.assets/widget.png', 'docs/deck/.assets/gadget.png', 'docs/deck/widget.slide.md')
        }
    }

    It 'runs the command line once, through the managed tool, from the root, when it names no path' {
        $writer = & $script:make 'widget_kit.py' 'gadget run widget' @('gadgets/*.svg')
        & $script:run $writer @($writer)
        @($script:seen) | Should -Be @('"C:/tools/gadget.exe" run widget')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly -ParameterFilter { $WorkingDirectory -ceq 'widget-root' -and $PassThru -and $NoAssert }
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'runs once per committed output the writer claims, in order, when {path} names it, though the outputs are deleted' {
        $picture = & $script:make 'widget picture' 'gadget picture {path}' @('docs/deck/.assets/*.png')
        $render = & $script:make 'widget render' 'gadget render {path}' @('docs/deck/.assets/*.slide.png')
        & $script:run $picture @($picture, $render)
        @($script:seen) | Should -Be @(
            '"C:/tools/gadget.exe" picture "docs/deck/.assets/gadget.png"'
            '"C:/tools/gadget.exe" picture "docs/deck/.assets/widget.png"'
        )
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly -ParameterFilter { $Path -ceq 'docs/deck/.assets/' }
    }

    It 'runs once with every committed output the writer claims, quoted and in order, when {paths} names them' {
        $picture = & $script:make 'widget picture' 'gadget picture {paths}' @('docs/deck/.assets/*.png')
        $render = & $script:make 'widget render' 'gadget render {paths}' @('docs/deck/.assets/*.slide.png')
        & $script:run $picture @($picture, $render)
        @($script:seen) | Should -Be @('"C:/tools/gadget.exe" picture "docs/deck/.assets/gadget.png" "docs/deck/.assets/widget.png"')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles -Times 1 -Exactly
    }

    It 'runs nothing when {paths} names them and the writer claims no output' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.GeneratedFiles { @('docs/deck/widget.slide.md') }
        $writer = & $script:make 'widget render' 'gadget render {paths}' @('docs/deck/.assets/*.slide.png')
        & $script:run $writer @($writer)
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'throws, naming the writer and the output, when a run fails' {
        $script:exit = 2
        $writer = & $script:make 'widget_kit.py' 'gadget run widget' @('gadgets/*.svg')
        { & $script:run $writer @($writer) } | Should -Throw "*writer 'widget_kit.py' failed (exit 2)*widget output*"
    }

    It 'throws, naming the writer, when the command line starts with no tool tools.yml declares' {
        $writer = & $script:make 'gadget_kit.py' '. ./gadget.ps1' @('gadgets/*.svg')
        { & $script:run $writer @($writer) } | Should -Throw "*writer 'gadget_kit.py' regenerates with '.', which tools.yml does not declare*"
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.GeneratedFiles -Times 0 -Exactly
    }

    It 'throws when the tool is not installed' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.GeneratedFiles { [pscustomobject] @{ Found = $false; Path = '' } }
        $writer = & $script:make 'widget_kit.py' 'gadget run widget' @('gadgets/*.svg')
        { & $script:run $writer @($writer) } | Should -Throw "*'gadget', which is not installed*"
    }
}

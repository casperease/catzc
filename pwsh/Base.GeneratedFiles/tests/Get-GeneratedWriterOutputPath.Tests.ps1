Describe 'Get-GeneratedWriterOutputPath' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:rows = @(
            [Catzc.Base.Variants.GeneratedWriterRow]::new('widget picture', [ordered]@{ class = 'rollable'; outputs = @('docs/deck/.assets/*.png') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('widget render', [ordered]@{ class = 'rollable'; outputs = @('docs/deck/.assets/*.slide.png') })
        )
        $script:claim = {
            param([int] $Index, [string[]] $Path)
            Get-GeneratedWriterOutputPath -Writer $script:rows[$Index] -Writers $script:rows -Path $Path
        }
        $script:paths = @('docs/deck/.assets/gadget.slide.png', 'docs/deck/.assets/gadget.png', 'docs/deck/gadget.slide.md', 'docs\deck\.assets\widget.png')
    }

    It 'gives a path two outputs match to the output with the more literal characters' {
        @(& $script:claim 0 $script:paths) | Should -Be @('docs/deck/.assets/gadget.png', 'docs/deck/.assets/widget.png')
        @(& $script:claim 1 $script:paths) | Should -Be @('docs/deck/.assets/gadget.slide.png')
    }

    It 'answers no path for no candidate' {
        @(& $script:claim 0 @()) | Should -HaveCount 0
    }
}

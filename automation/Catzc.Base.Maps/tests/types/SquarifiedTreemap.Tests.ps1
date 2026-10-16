<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/tests/types/SquarifiedTreemap.Tests.ps1
    folder: tests/types
    name: squarified-treemap-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'SquarifiedTreemap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:keys = @('widget-a', 'widget-b', 'gadget-c', 'gadget-d', 'widget-e', 'gadget-f', 'widget-g', 'gadget-h', 'widget-i')
        $script:weights = [double[]] @(500, 300, 120, 60, 10, 7, 3, 1, 1)
        $script:layout = { param([string[]] $k, [double[]] $w) [Catzc.Base.Maps.SquarifiedTreemap]::Layout($k, $w, 20, 30, 400, 250) }
        $script:describe = { param($rectangles) @($rectangles | ForEach-Object { '{0}:{1:R},{2:R},{3:R},{4:R}' -f $_.Key, $_.X, $_.Y, $_.Width, $_.Height }) -join ';' }
    }

    It 'keeps every rectangle inside the bounds' {
        foreach ($rect in & $script:layout $script:keys $script:weights) {
            $rect.X | Should -BeGreaterOrEqual (20 - 1e-9)
            $rect.Y | Should -BeGreaterOrEqual (30 - 1e-9)
            ($rect.X + $rect.Width) | Should -BeLessOrEqual (420 + 1e-9)
            ($rect.Y + $rect.Height) | Should -BeLessOrEqual (280 + 1e-9)
            $rect.Width | Should -BeGreaterThan 0
            $rect.Height | Should -BeGreaterThan 0
        }
    }

    It 'never overlaps two rectangles, and tiles the whole box' {
        $rectangles = @(& $script:layout $script:keys $script:weights)
        for ($i = 0; $i -lt $rectangles.Count; $i++) {
            for ($j = $i + 1; $j -lt $rectangles.Count; $j++) {
                $a = $rectangles[$i]
                $b = $rectangles[$j]
                $overlapX = [Math]::Min($a.X + $a.Width, $b.X + $b.Width) - [Math]::Max($a.X, $b.X)
                $overlapY = [Math]::Min($a.Y + $a.Height, $b.Y + $b.Height) - [Math]::Max($a.Y, $b.Y)
                ([Math]::Max(0, $overlapX) * [Math]::Max(0, $overlapY)) | Should -BeLessThan 1e-6 -Because "$($a.Key) and $($b.Key) must not overlap"
            }
        }
        ($rectangles | Measure-Object -Property Area -Sum).Sum | Should -BeGreaterThan (400 * 250 - 1e-6)
    }

    It 'gives each rectangle an area proportional to its weight, within 1 %' {
        $total = ($script:weights | Measure-Object -Sum).Sum
        foreach ($rect in & $script:layout $script:keys $script:weights) {
            $expected = $rect.Weight / $total * 400 * 250
            [Math]::Abs($rect.Area - $expected) / $expected | Should -BeLessThan 0.01 -Because "$($rect.Key) has weight $($rect.Weight)"
        }
    }

    It 'is deterministic: the same rectangles on every run and whatever the input order' {
        $first = & $script:describe (& $script:layout $script:keys $script:weights)
        & $script:describe (& $script:layout $script:keys $script:weights) | Should -Be $first
        $reversedKeys = [string[]] $script:keys.Clone()
        $reversedWeights = [double[]] $script:weights.Clone()
        [Array]::Reverse($reversedKeys)
        [Array]::Reverse($reversedWeights)
        & $script:describe (& $script:layout $reversedKeys $reversedWeights) | Should -Be $first
    }

    It 'orders the rectangles heaviest first, ties by ordinal key, and drops a zero weight' {
        $rectangles = [Catzc.Base.Maps.SquarifiedTreemap]::Layout(@('gadget', 'Widget', 'widget', 'sprocket'), [double[]] @(2, 2, 5, 0), 0, 0, 100, 100)
        @($rectangles.Key) | Should -Be @('widget', 'Widget', 'gadget')
    }

    It 'returns no rectangle when every weight is zero' {
        @([Catzc.Base.Maps.SquarifiedTreemap]::Layout(@('widget'), [double[]] @(0), 0, 0, 10, 10)).Count | Should -Be 0
    }

    It 'throws on a negative weight, a duplicate key, mismatched lengths and an empty box' {
        { [Catzc.Base.Maps.SquarifiedTreemap]::Layout(@('widget'), [double[]] @(-1), 0, 0, 10, 10) } | Should -Throw '*not a number of zero or more*'
        { [Catzc.Base.Maps.SquarifiedTreemap]::Layout(@('widget', 'widget'), [double[]] @(1, 2), 0, 0, 10, 10) } | Should -Throw '*listed twice*'
        { [Catzc.Base.Maps.SquarifiedTreemap]::Layout(@('widget'), [double[]] @(1, 2), 0, 0, 10, 10) } | Should -Throw '*1 keys but 2 weights*'
        { [Catzc.Base.Maps.SquarifiedTreemap]::Layout(@('widget'), [double[]] @(1), 0, 0, 0, 10) } | Should -Throw '*is empty*'
    }
}

Describe 'Get-SlideOrderFinding' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-SLIDEFILE' {
    BeforeAll {
        $script:find = {
            param([object[]] $Order)
            $slides = @(for ($i = 0; $i -lt $Order.Count; $i++) {
                    [pscustomobject]@{ Id = "widget-$i"; Order = $Order[$i] }
                })
            @(& (Get-Module Catzc.Base.Slides) { param($s) Get-SlideOrderFinding -Slide $s -Deck 'decks/widget-deck' } $slides | ForEach-Object { "$_" })
        }
    }

    It 'finds nothing in a deck ordered from 1 without a gap' {
        & $find @(2, 1, 3) | Should -BeNullOrEmpty
    }

    It 'names each order two slides hold, and the slides holding it' {
        & $find @(1, 1, 2) | Should -Be @("decks/widget-deck: field 'order': the order 1 is held by 2 slides: widget-0, widget-1")
    }

    It 'names the first gap only' {
        & $find @(1, 3, 5) | Should -Be @("decks/widget-deck: field 'order': the orders have a gap: expected 2, found 3")
    }

    It 'leaves an order that is not a whole number to the slide''s own finding' {
        & $find @(1, 'second', 2) | Should -BeNullOrEmpty
    }
}

# pwsh/Base.Slides/private/Get-SlideOrderFinding.ps1

The deck-level order check shared by the render and the gate: it finds an order two slides hold, and a gap.

## help

### synopsis

Finds the faults in a deck's slide orders: an order two slides hold, and a gap.

### description

The one deck-level order check, shared by the render (Build-SlideDeck) and the gate (Test-Slides) (ADR-REPO-SLIDES-SLIDEFILE): the orders of
a deck run from 1 with no gap, and no two slides hold one order. A duplicate names the slides that hold it; only the first gap is named. An
order that is not a whole number is skipped here, since Get-SlideFinding reports it against its slide.

### parameter `Slide`

The deck's slides as Read-SlideFile returns them.

### parameter `Deck`

The deck folder, repository-relative, which each fault names.

### outputs

`[Catzc.Base.Slides.SlideFault]` one per fault found; none when the orders are whole.

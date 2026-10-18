<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
    folder: tests/types
    name: slides-kit-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-SLIDES#2
---
#>

Describe 'SlidesKit' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES#2' {
    BeforeAll {
        $script:raw = @{
            token  = @{ bg = '#101010'; accent = '#ABCDEF' }
            face   = @{ display = "'Widget Serif', Georgia, serif"; display_href = 'https://fonts.example/widget'; text = 'Arial, sans-serif' }
            scale  = @{ h2 = 72; body = 32 }
            layout = @{ gutter = 128 }
        }
    }

    It 'maps every section it is given and reads a value by section and key' {
        $kit = [Catzc.Base.Slides.SlidesKit]::new($script:raw)
        $kit.Value('token.bg') | Should -Be '#101010'
        $kit.Value('face.text') | Should -Be 'Arial, sans-serif'
        $kit.Value('scale.h2') | Should -Be '72'
        $kit.Value('layout.gutter') | Should -Be '128'
    }

    It 'takes the declared default output folder for an omitted render.out' -Tag 'ADR-AUTO-DEFAULT#6' {
        ([Catzc.Base.Slides.SlidesKit]::new($script:raw)).Value('render.out') | Should -Be 'out/slides'
        ([Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; render = @{ out = 'out/gadget' } })).Value('render.out') | Should -Be 'out/gadget'
    }

    It 'lists the families from the face stacks with their links' {
        $families = @(([Catzc.Base.Slides.SlidesKit]::new($script:raw)).Families())
        $families.Count | Should -Be 2
        $families[0].Key | Should -Be 'Widget Serif'
        $families[0].Value | Should -Be 'https://fonts.example/widget'
        $families[1].Key | Should -Be 'Arial'
        $families[1].Value | Should -BeNullOrEmpty
    }

    It 'rejects a reference to a value the kit does not declare' {
        $kit = [Catzc.Base.Slides.SlidesKit]::new($script:raw)
        { $kit.Value('token.gadget') } | Should -Throw '*declares no value ''token.gadget''*'
        { $kit.Value('gadget.bg') } | Should -Throw '*declares no value*'
        { $kit.Value('bg') } | Should -Throw '*<section>.<key>*'
    }

    It 'requires the two faces' {
        { [Catzc.Base.Slides.SlidesKit]::new(@{ token = @{ bg = '#101010' } }) } | Should -Throw '*face.display is required*face.text is required*'
    }

    It 'rejects an unknown section, a section that is not a mapping, and a nested value' {
        { [Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; gadget = @{ a = 1 } }) } | Should -Throw '*unknown section ''gadget''*'
        { [Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; token = 'x' }) } | Should -Throw '*section ''token'' must be a mapping*'
        { [Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; token = @{ bg = @{ deep = 1 } } }) } | Should -Throw '*token.bg must be one scalar value*'
    }

    It 'rejects a token that is not a hex colour and a size that is not a whole number of pixels' {
        { [Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; token = @{ bg = 'navy' } }) } | Should -Throw '*token.bg ''navy'' must be a six-digit hex colour*'
        { [Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; scale = @{ h2 = 'big' } }) } | Should -Throw '*scale.h2 ''big'' must be a whole number of pixels*'
        { [Catzc.Base.Slides.SlidesKit]::new(@{ face = $script:raw.face; layout = @{ gutter = 0 } }) } | Should -Throw '*layout.gutter ''0'' must be a whole number of pixels*'
    }

    It 'reads the family from a quoted stack and from a bare one' {
        [Catzc.Base.Slides.SlidesKit]::FamilyOf("'Widget Serif', Georgia, serif") | Should -Be 'Widget Serif'
        [Catzc.Base.Slides.SlidesKit]::FamilyOf('Arial, sans-serif') | Should -Be 'Arial'
        [Catzc.Base.Slides.SlidesKit]::FamilyOf('') | Should -Be ''
    }
}

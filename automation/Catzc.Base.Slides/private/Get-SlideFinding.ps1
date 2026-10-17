<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Slides/private/Get-SlideFinding.ps1
    folder: private
    name: get-slide-finding
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Renders one slide through its pattern and returns the rendered section with every fault found.
    description: |-
      The one place the checks of a slide live, shared by the render and the gate (ADR-REPO-SLIDES#3, ADR-REPO-SLIDES#4): the head
      names a pattern the kit holds and a whole-number order; the pattern's fields are filled within their capacities; every cited code
      is a rule the ADR index knows; a body that quotes a rule carries the registry's text verbatim; and every text of every field is
      found in the rendered section. Nothing is fixed and nothing shrinks; each fault names the file and the field.
    parameters:
      Slide: A slide as Read-SlideFile returns it.
      Kit: The kit as Get-SlidesKit returns it.
      Page: The slide's position in the deck, written where the pattern shows a page number.
      RepositoryRoot: The repository root, for the ADR index and for the paths the faults name.
    outputs: '[pscustomobject] @{ Html; Faults ([Catzc.Base.Slides.SlideFault[]]) }.'
---
#>

function Get-SlideFinding {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Slide,

        [Parameter(Mandatory)]
        [pscustomobject] $Kit,

        [Parameter(Mandatory)]
        [int] $Page,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $faults = [System.Collections.Generic.List[Catzc.Base.Slides.SlideFault]]::new()
    $relative = $Slide.Path
    $rootPrefix = $RepositoryRoot.TrimEnd('\', '/')
    if ($relative.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        $relative = $relative.Substring($rootPrefix.Length).TrimStart('\', '/')
    }
    $relative = $relative.Replace('\', '/')
    $result = [pscustomobject]@{ Html = ''; Faults = @() }

    if ($Slide.Order -isnot [int] -and $Slide.Order -isnot [long]) {
        $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'order', "the head's config.order is a whole number from 1; found '$($Slide.Order)'"))
    }
    elseif ([long] $Slide.Order -lt 1) {
        $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'order', "the head's config.order is a whole number from 1; found '$($Slide.Order)'"))
    }

    if ([string]::IsNullOrWhiteSpace($Slide.Pattern)) {
        $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'pattern', "the head names no pattern (config.pattern); the kit holds: $(@($Kit.Patterns.Keys | Sort-Object) -join ', ')"))
        $result.Faults = $faults.ToArray()
        return $result
    }
    if (-not $Kit.Patterns.ContainsKey($Slide.Pattern)) {
        $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'pattern', "the kit '$($Kit.Kit)' holds no pattern '$($Slide.Pattern)'; it holds: $(@($Kit.Patterns.Keys | Sort-Object) -join ', ')"))
        $result.Faults = $faults.ToArray()
        return $result
    }

    $config = $Kit.Config
    $kitValue = [System.Func[string, string]] { param([string] $reference) $config.Value($reference) }
    $render = $Kit.Patterns[$Slide.Pattern].Render($Slide.Source, $relative, $kitValue, $Slide.Id, $Page)
    foreach ($fault in $render.Faults) {
        $faults.Add($fault)
    }

    foreach ($cite in $Slide.Cites) {
        # A bare code names the whole ADR, so its first rule stands for it; #n and #{n-m} name rules, checked by their first number.
        $match = [regex]::Match($cite, '^(ADR-[A-Z0-9]+(?:-[A-Z0-9]+)*)(?:#(?:(\d+)|\{(\d+)[^}]*\}))?$')
        if (-not $match.Success) {
            $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'cites', "'$cite' is not a citation of the form ADR-NAME, ADR-NAME#n or ADR-NAME#{n-m}"))
            continue
        }
        $number = if ($match.Groups[2].Success) {
            $match.Groups[2].Value
        }
        elseif ($match.Groups[3].Success) {
            $match.Groups[3].Value
        }
        else {
            '1'
        }
        if ($null -eq (Get-AdrRuleText -Code "$($match.Groups[1].Value)#$number" -RepositoryRoot $RepositoryRoot)) {
            $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'cites', "the ADR index knows no rule '$cite'"))
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($Slide.Quotes)) {
        $registry = Get-AdrRuleText -Code $Slide.Quotes -RepositoryRoot $RepositoryRoot
        if ($null -eq $registry) {
            $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'quotes', "the ADR index knows no rule '$($Slide.Quotes)'"))
        }
        else {
            $body = if ($Slide.Source.Fields.ContainsKey('body')) {
                @($Slide.Source.Fields['body'].Items | ForEach-Object Text) -join ' '
            }
            else {
                ''
            }
            $normal = [regex]::Replace($body, '\s+', ' ').Trim()
            if ($normal -cne $registry) {
                $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'body', "quotes $($Slide.Quotes) but differs from the registry.`n  slide:    $normal`n  registry: $registry"))
            }
        }
    }

    $rendered = [Catzc.Base.Slides.SlidePattern]::TextOf($render.Html)
    if ($Slide.Source.Title -and $rendered.IndexOf($Slide.Source.Title, [System.StringComparison]::Ordinal) -lt 0) {
        $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, 'title', 'the title is not in the rendered slide'))
    }
    foreach ($field in $Slide.Source.Fields.Values) {
        foreach ($text in $field.Texts()) {
            if ($rendered.IndexOf($text, [System.StringComparison]::Ordinal) -lt 0) {
                $faults.Add([Catzc.Base.Slides.SlideFault]::new($relative, $field.Name, "the text '$text' is not in the rendered slide"))
            }
        }
    }

    $result.Html = $render.Html
    $result.Faults = $faults.ToArray()
    $result
}

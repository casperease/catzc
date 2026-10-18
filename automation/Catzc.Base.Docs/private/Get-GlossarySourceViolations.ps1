<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-GlossarySourceViolations.ps1
    folder: private
    name: get-glossary-source-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
    cites:
      - ADR-REPO-VOCAB
---
#>

function Get-GlossarySourceViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [object[]] $Source = @(Get-GlossarySources)
    )

    $violations = [System.Collections.Generic.List[string]]::new()
    $domains = [System.Collections.Generic.HashSet[string]]::new([string[]] @((Get-Config -Config adrs).Domains.Name), [System.StringComparer]::Ordinal)

    # First pass: who owns each term and key (the first source in order keeps it), plus the per-source facts.
    $termSource = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $termConcept = [System.Collections.Generic.Dictionary[string, Catzc.Base.Docs.GlossaryConcept]]::new([System.StringComparer]::Ordinal)
    $keyOwner = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($item in $Source) {
        if (-not $item.Tracked) {
            $violations.Add("$($item.Path): the glossary source is not tracked by git — a source lives in the repository (ADR-REPO-VOCAB#3)")
        }
        foreach ($concept in $item.Config.concepts) {
            $term = $concept.term
            if ($termSource.ContainsKey($term)) {
                $violations.Add("$($item.Path): term '$term' is already defined by $($termSource[$term]) — a term has one definition (ADR-REPO-VOCAB#1)")
            }
            else {
                $termSource[$term] = $item.Path
                $termConcept[$term] = $concept
            }
            if ($keyOwner.ContainsKey($concept.key)) {
                $violations.Add("$($item.Path): concept '$term': key '$($concept.key)' is already used by $($keyOwner[$concept.key]) (ADR-REPO-VOCAB#1)")
            }
            else {
                $keyOwner[$concept.key] = "'$term' in $($item.Path)"
            }
            if (-not $domains.Contains($concept.domain)) {
                $violations.Add("$($item.Path): concept '$term': domain '$($concept.domain)' is not an adrs.yml domain (ADR-REPO-VOCAB#1)")
            }
        }
    }

    # Second pass: references between concepts, now that every term is known.
    foreach ($item in $Source) {
        foreach ($concept in $item.Config.concepts) {
            $term = $concept.term
            foreach ($avoid in $concept.avoid) {
                if ($termSource.ContainsKey($avoid.phrase)) {
                    $violations.Add("$($item.Path): concept '$term': avoided phrase '$($avoid.phrase)' is the term defined by $($termSource[$avoid.phrase]) (ADR-REPO-VOCAB#5)")
                }
            }
            foreach ($other in $concept.contrasts.Keys) {
                if (-not $termConcept.ContainsKey($other)) {
                    $violations.Add("$($item.Path): concept '$term': contrast target '$other' is not a defined term (ADR-REPO-VOCAB#3)")
                }
                elseif (-not $termConcept[$other].contrasts.ContainsKey($term)) {
                    $violations.Add("$($item.Path): concept '$term': contrasts '$other', but '$other' ($($termSource[$other])) does not contrast '$term' back (ADR-REPO-VOCAB#4)")
                }
            }
            foreach ($kind in $concept.relations.Keys) {
                foreach ($target in $concept.relations[$kind]) {
                    if (-not $termConcept.ContainsKey($target)) {
                        $violations.Add("$($item.Path): concept '$term': $kind target '$target' is not a defined term (ADR-REPO-VOCAB#3)")
                    }
                }
            }
        }
    }

    $violations.ToArray()
}

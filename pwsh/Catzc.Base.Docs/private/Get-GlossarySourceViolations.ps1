<#
---
catzc:
  immutable:
    with_body_sha: "7ee420c37d8a"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
    docs: "[Get-GlossarySourceViolations.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-GlossarySourceViolations.ps1.md)"
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
            $violations.Add("$($item.Path): the glossary source is not tracked by git — a source lives in the repository (ADR-REPO-VOCAB-SOURCESINREPOSITORY)")
        }
        foreach ($concept in $item.Config.concepts) {
            $term = $concept.term
            if ($termSource.ContainsKey($term)) {
                $violations.Add("$($item.Path): term '$term' is already defined by $($termSource[$term]) — a term has one definition (ADR-REPO-VOCAB-DEFINEDTERM)")
            }
            else {
                $termSource[$term] = $item.Path
                $termConcept[$term] = $concept
            }
            if ($keyOwner.ContainsKey($concept.key)) {
                $violations.Add("$($item.Path): concept '$term': key '$($concept.key)' is already used by $($keyOwner[$concept.key]) (ADR-REPO-VOCAB-DEFINEDTERM)")
            }
            else {
                $keyOwner[$concept.key] = "'$term' in $($item.Path)"
            }
            if (-not $domains.Contains($concept.domain)) {
                $violations.Add("$($item.Path): concept '$term': domain '$($concept.domain)' is not an adrs.yml domain (ADR-REPO-VOCAB-DEFINEDTERM)")
            }
        }
    }

    # Second pass: references between concepts, now that every term is known.
    foreach ($item in $Source) {
        foreach ($concept in $item.Config.concepts) {
            $term = $concept.term
            foreach ($avoid in $concept.avoid) {
                if ($termSource.ContainsKey($avoid.phrase)) {
                    $violations.Add("$($item.Path): concept '$term': avoided phrase '$($avoid.phrase)' is the term defined by $($termSource[$avoid.phrase]) (ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED)")
                }
            }
            foreach ($other in $concept.contrasts.Keys) {
                if (-not $termConcept.ContainsKey($other)) {
                    $violations.Add("$($item.Path): concept '$term': contrast target '$other' is not a defined term (ADR-REPO-VOCAB-SOURCESINREPOSITORY)")
                }
                elseif (-not $termConcept[$other].contrasts.ContainsKey($term)) {
                    $violations.Add("$($item.Path): concept '$term': contrasts '$other', but '$other' ($($termSource[$other])) does not contrast '$term' back (ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED)")
                }
            }
            foreach ($kind in $concept.relations.Keys) {
                foreach ($target in $concept.relations[$kind]) {
                    if (-not $termConcept.ContainsKey($target)) {
                        $violations.Add("$($item.Path): concept '$term': $kind target '$target' is not a defined term (ADR-REPO-VOCAB-SOURCESINREPOSITORY)")
                    }
                }
            }
        }
    }

    $violations.ToArray()
}

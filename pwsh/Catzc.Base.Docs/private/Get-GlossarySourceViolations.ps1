<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossarySourceViolations.ps1.md"
  warning: "Generated Header"
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
    $drs = Get-Config -Config drs
    $domains = [System.Collections.Generic.HashSet[string]]::new([string[]] @($drs.Domains.Name), [System.StringComparer]::Ordinal)

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
                $violations.Add("$($item.Path): concept '$term': domain '$($concept.domain)' is not an drs.yml domain (ADR-REPO-VOCAB-DEFINEDTERM)")
            }
            # The type checks only the shape; the registry decides how many segments a rule's code has after its kind.
            if (-not $drs.CodeForm.IsRule($concept.defined_by)) {
                $violations.Add("$($item.Path): concept '$term': defined_by '$($concept.defined_by)' is not a rule's code under the drs.yml kinds; an ADR's code names no rule (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED)")
            }
        }
    }

    # Second pass: references between concepts, now that every term is known.
    $contrasted = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
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
                # A contrast is declared once and the build shows it on both entries; the second declaration of a pair is the finding.
                elseif ($termConcept[$other].contrasts.ContainsKey($term) -and -not $contrasted.Add("$other`n$term")) {
                    $violations.Add("$($item.Path): concept '$term': contrasts '$other', which '$other' ($($termSource[$other])) already declares; declare a contrast once (ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED)")
                }
                else {
                    [void] $contrasted.Add("$term`n$other")
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

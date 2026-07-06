<#
.SYNOPSIS
    Ask the catzc docs — a deterministic browser over the ADRs, modules, and approved verbs.
.DESCRIPTION
    "Ask cats": surfaces what the catzc system can do from what the repository already knows, offline and
    deterministically (no network, no LLM). With no argument it prints the overview of what you can ask; an
    area narrows it:

      Show-Cats adr [query]     the ADR codes and titles; with a query, the matching ADRs and their rules
      Show-Cats module [name]   the modules; with a name substring, the public functions they export
      Show-Cats verbs           the approved verbs in use across the tree

    Output is presentation only (the information stream, docs/adr/automation/powershell/console-output-matters.md);
    the function returns nothing. Live bicep templates are out of scope here — use Get-BicepTemplates. The reads
    are memoized for the session by the private getters (docs/adr/automation/caching.md).
.PARAMETER Area
    What to ask about: adr, module, or verbs. Omitted (the default) prints the overview.
.PARAMETER Query
    Narrows the area: an ADR code/title substring for 'adr', a module-name substring for 'module'. Ignored by
    'verbs' and the overview.
.EXAMPLE
    Show-Cats
    Prints the overview of what you can ask.
.EXAMPLE
    Show-Cats adr naming
    Summarizes the ADRs whose code or title contains 'naming', with each rule's one-line summary.
.EXAMPLE
    Show-Cats module azure
    Lists the public functions of every module whose name contains 'azure'.
#>
function Show-Cats {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string] $Area,

        [Parameter(Position = 1)]
        [string] $Query
    )

    $normalized = $Area.Trim().ToLowerInvariant()

    switch ($normalized) {
        { $_ -in '', 'overview', 'help' } {
            Write-Message 'cats — ask the catzc docs. Areas you can ask:' -NoHeader -ForegroundColor Cyan
            Write-Message '' -NoHeader
            Write-Message '  adr [query]     ADR codes and titles; with a query, the matching ADRs and their rules' -NoHeader
            Write-Message '  module [name]   the modules; with a name substring, the functions they export' -NoHeader
            Write-Message '  verbs           the approved verbs in use across the tree' -NoHeader
            Write-Message '' -NoHeader
            Write-Message 'Also: how-to guides in docs/how-to, the FAQ in docs/faq.md, live bicep templates via Get-BicepTemplates.' -NoHeader
            break
        }
        'adr' {
            # Plain assignment (not @(...)): the getter returns a comma-wrapped array (ADR-CACHE exemplar),
            # which assignment receives intact — wrapping it again in @() would nest it one level too deep.
            $entries = Get-CatsAdrIndex
            if ($Query) {
                $matched = @($entries | Where-Object { $_.Code -like "*$Query*" -or $_.Title -like "*$Query*" })
                if ($matched.Count -eq 0) {
                    Write-Message "No ADR matches '$Query'. Run 'Show-Cats adr' for the full list." -NoHeader
                    break
                }
                $enforcers = Get-CatsRuleEnforcers
                foreach ($entry in $matched) {
                    Write-Message "$($entry.Code)  $($entry.Title)" -NoHeader -ForegroundColor Cyan
                    Write-Message "  docs/adr/$($entry.Path)" -NoHeader
                    $rules = @(Get-CatsAdrRules -AdrPath (Resolve-RepoPath "docs/adr/$($entry.Path)"))
                    foreach ($rule in $rules) {
                        $summary = if ($rule.Summary.Length -gt 100) {
                            $rule.Summary.Substring(0, 97) + '...'
                        }
                        else {
                            $rule.Summary
                        }
                        Write-Message "  $($rule.Id)  $summary" -NoHeader

                        # Show what mechanically enforces this rule (tests + analyzer rules), if anything —
                        # the citation is the '#' form of the registry id (docs/adr/index.md).
                        $entryEnforcers = $enforcers[($rule.Id -replace ':', '#')]
                        if ($entryEnforcers) {
                            $parts = @()
                            if ($entryEnforcers.Analyzers.Count) {
                                $parts += "analyzer: $($entryEnforcers.Analyzers -join ', ')"
                            }
                            if ($entryEnforcers.Tests.Count) {
                                $parts += "$($entryEnforcers.Tests.Count) test(s)"
                            }
                            if ($parts) {
                                Write-Message "      enforced by $($parts -join '; ')" -NoHeader
                            }
                        }
                    }
                    Write-Message '' -NoHeader
                }
                break
            }
            Write-Message 'ADR codes (run ''Show-Cats adr <query>'' to summarize one):' -NoHeader -ForegroundColor Cyan
            $width = 0
            foreach ($entry in $entries) {
                if ($entry.Code.Length -gt $width) {
                    $width = $entry.Code.Length
                }
            }
            foreach ($entry in ($entries | Sort-Object Code)) {
                Write-Message "  $($entry.Code.PadRight($width))  $($entry.Title)" -NoHeader
            }
            break
        }
        { $_ -in 'module', 'modules' } {
            $modules = Get-CatsModules
            if ($Query) {
                $matched = @($modules | Where-Object { $_.Module -like "*$Query*" })
                if ($matched.Count -eq 0) {
                    Write-Message "No module matches '$Query'. Run 'Show-Cats module' for the full list." -NoHeader
                    break
                }
                foreach ($module in $matched) {
                    Write-Message "$($module.Module)  ($($module.Functions.Count) functions)" -NoHeader -ForegroundColor Cyan
                    foreach ($function in $module.Functions) {
                        Write-Message "  $function" -NoHeader
                    }
                    Write-Message '' -NoHeader
                }
                break
            }
            Write-Message 'Modules (run ''Show-Cats module <name>'' for a module''s functions):' -NoHeader -ForegroundColor Cyan
            $width = 0
            foreach ($module in $modules) {
                if ($module.Module.Length -gt $width) {
                    $width = $module.Module.Length
                }
            }
            foreach ($module in $modules) {
                Write-Message "  $($module.Module.PadRight($width))  $($module.Functions.Count) functions" -NoHeader
            }
            break
        }
        { $_ -in 'verb', 'verbs' } {
            $modules = Get-CatsModules
            $counts = @{}
            foreach ($module in $modules) {
                foreach ($function in $module.Functions) {
                    $verb = ($function -split '-', 2)[0]
                    if (-not $verb) {
                        continue
                    }
                    $counts[$verb] = if ($counts.ContainsKey($verb)) {
                        $counts[$verb] + 1
                    }
                    else {
                        1
                    }
                }
            }
            Write-Message 'Approved verbs in use (verb  functions):' -NoHeader -ForegroundColor Cyan
            foreach ($verb in ($counts.Keys | Sort-Object)) {
                Write-Message "  $($verb.PadRight(12))  $($counts[$verb])" -NoHeader
            }
            break
        }
        default {
            throw "Show-Cats: unknown area '$Area'. Ask one of: adr, module, verbs — or run Show-Cats with no argument for the overview."
        }
    }
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Show-Cats.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-CACHE
      - ADR-AUTO-CONSOLE
---
#>

<#
.SYNOPSIS
    Ask the catzc docs — a deterministic browser over the ADRs, modules, and approved verbs.
.DESCRIPTION
    Output is presentation only on the information stream; the function returns nothing for a caller to use.
.PARAMETER Area
    What to ask about: adr, module, or verbs. Omitted (the default) prints the overview.
.PARAMETER Query
    Ignored by verbs and the overview, which have nothing to narrow.
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
            Write-Message 'Also: how-to guides in docs/how-to, the FAQ in docs/how-to/getting-started/automation/faq.md, live bicep templates via Get-BicepTemplates.' -NoHeader
            break
        }
        'adr' {
            # Not wrapped in @(): the getter's array is comma-wrapped, and @() would nest it one level too deep.
            # [comment:3](/docs/references/automation/catzc-base-docs/Show-Cats.ps1.md#comment3)
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

                        # Enforcers are keyed by the hash form of the id, so the registry colon is swapped first.
                        # [comment:4](/docs/references/automation/catzc-base-docs/Show-Cats.ps1.md#comment4)
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

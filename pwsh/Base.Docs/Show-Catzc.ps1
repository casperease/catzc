function Show-Catzc {
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
            # Plain assignment: the getter returns a comma-wrapped array, and @() would nest it a level too deep.
            $entries = Get-DrsIndex
            if ($Query) {
                $matched = @($entries | Where-Object { $_.Code -like "*$Query*" -or $_.Title -like "*$Query*" })
                if ($matched.Count -eq 0) {
                    Write-Message "No ADR matches '$Query'. Run 'Show-Catzc adr' for the full list." -NoHeader
                    break
                }
                $enforcers = Get-RuleEnforcers
                $root = (Get-Config -Config drs).Root
                foreach ($entry in $matched) {
                    Write-Message "$($entry.Code)  $($entry.Title)" -NoHeader -ForegroundColor Cyan
                    Write-Message "  $root/$($entry.Path)" -NoHeader
                    $rules = @(Get-DrsRules -DrsPath (Resolve-RepoPath "$root/$($entry.Path)"))
                    foreach ($rule in $rules) {
                        $summary = if ($rule.Summary.Length -gt 100) {
                            $rule.Summary.Substring(0, 97) + '...'
                        }
                        else {
                            $rule.Summary
                        }
                        Write-Message "  $($rule.Id)  $summary" -NoHeader

                        # What mechanically enforces the rule, the tests and analyzer rules, keyed by its code.
                        $entryEnforcers = $enforcers[$rule.Id]
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
            Write-Message 'ADR codes (run ''Show-Catzc adr <query>'' to summarize one):' -NoHeader -ForegroundColor Cyan
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
            $modules = Get-CatzcModuleExport
            if ($Query) {
                $matched = @($modules | Where-Object { $_.Module -like "*$Query*" })
                if ($matched.Count -eq 0) {
                    Write-Message "No module matches '$Query'. Run 'Show-Catzc module' for the full list." -NoHeader
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
            Write-Message 'Modules (run ''Show-Catzc module <name>'' for a module''s functions):' -NoHeader -ForegroundColor Cyan
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
            $modules = Get-CatzcModuleExport
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
            throw "Show-Catzc: unknown area '$Area'. Ask one of: adr, module, verbs — or run Show-Catzc with no argument for the overview."
        }
    }
}

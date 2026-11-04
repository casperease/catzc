function Assert-BuiltBundleStore {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $bundles = @((Get-Config -Config exporter).bundles.Keys | Sort-Object)
    $missing = [System.Collections.Generic.List[string]]::new()
    foreach ($bundle in $bundles) {
        # The dry run reports the stamp and the store location the build event of this tree fills, and writes nothing.
        $plan = Build-Modules -Bundle $bundle -DryRun -Silent
        $recordFile = [System.IO.Path]::Combine($plan.StoreRoot, 'build.json')
        $stored = $false
        if ([System.IO.File]::Exists($recordFile)) {
            try {
                $record = [System.IO.File]::ReadAllText($recordFile) | ConvertFrom-Json -AsHashtable
                $stored = $record.ContainsKey('sourceStamp') -and "$($record['sourceStamp'])" -ceq $plan.SourceStamp
            }
            catch {
                Write-Verbose "Stored build of '$bundle' does not parse ($($_.Exception.Message))"
            }
        }
        if (-not $stored) {
            $missing.Add($bundle)
        }
    }

    if ($missing.Count -gt 0) {
        $events = ($missing | ForEach-Object { "Build-Modules -Bundle $_" }) -join '; '
        throw "The post-build run tests the built bundles, and the build store holds no build at this tree's source stamp for: $($missing -join ', '). Run the build event first: $events"
    }
}

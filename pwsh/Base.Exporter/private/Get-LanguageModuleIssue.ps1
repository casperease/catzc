function Get-LanguageModuleIssue {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [AllowNull()]
        [object[]] $Languages
    )

    $root = [System.IO.Path]::GetFullPath($BuildRoot).TrimEnd('\', '/')
    $issues = [System.Collections.Generic.List[string]]::new()

    $languageEntries = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in @($Languages | Where-Object { $_ })) {
        $entryRoot = "$($entry['path'])".Replace('\', '/').Trim('/')
        if ($entryRoot -ne '') {
            $languageEntries.Add([pscustomobject]@{ Root = $entryRoot; Entry = $entry })
        }
    }
    $languageRoots = @($languageEntries | ForEach-Object { $_.Root })

    # Every file once, build-relative and forward-slashed, through a named whole-tree walk.
    $files = @(foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @() -PruneVendor $false) {
            [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/')
        })

    # A folder under a place that no entry names is an issue: the places hold exactly the modules the list records.
    foreach ($place in @($languageRoots | Where-Object { $_.Contains('/') } |
                ForEach-Object { $_.Substring(0, $_.LastIndexOf('/')) } | Sort-Object -Unique)) {
        $placeFolder = [System.IO.Path]::Combine($root, $place)
        if (-not [System.IO.Directory]::Exists($placeFolder)) {
            continue
        }
        $named = @($languageRoots | Where-Object { $_.StartsWith("$place/", [System.StringComparison]::Ordinal) } |
                ForEach-Object { $_.Substring($place.Length + 1) })
        foreach ($directory in [System.IO.Directory]::EnumerateDirectories($placeFolder)) {
            $leaf = [System.IO.Path]::GetFileName($directory)
            if ($leaf -cnotin $named) {
                $issues.Add("folder '$place/$leaf' is under the language place '$place' but no build.json languages entry names it")
            }
        }
    }

    # Every module the list names exists in the packaged form of its language, by the form the handler recorded.
    $readList = {
        param($relative)
        @([System.IO.File]::ReadAllText([System.IO.Path]::Combine($root, $relative)) | ConvertFrom-Json -AsHashtable)
    }
    foreach ($row in $languageEntries) {
        $moduleRoot = $row.Root
        $form = "$($row.Entry['form'])"
        $record = $row.Entry['record']
        $label = "language module '$moduleRoot' ($form)"
        $prefix = "$moduleRoot/"
        if (-not [System.IO.Directory]::Exists([System.IO.Path]::Combine($root, $moduleRoot))) {
            $issues.Add("$label is recorded in build.json but has no folder")
            continue
        }
        $inModule = @($files | Where-Object { $_.StartsWith($prefix, [System.StringComparison]::Ordinal) } |
                ForEach-Object { $_.Substring($prefix.Length) })

        switch ($form) {
            'source' {
                # The handler's own count is the files it listed; its executables carrier ships when it recorded executables.
                $carrier = $null -ne $record -and $record.ContainsKey('Executables')
                if ($carrier -and 'executables.json' -notin $inModule) {
                    $issues.Add("$label is missing its executables.json")
                }
                $shipped = @($inModule | Where-Object { $_ -cne 'executables.json' }).Count
                if ($null -ne $record -and $record.ContainsKey('Files') -and $shipped -ne $record['Files']) {
                    $issues.Add("$label ships $shipped file(s) but its handler listed $($record['Files'])")
                }
            }
            'vsix' {
                $artifacts = @($inModule | Where-Object { $_ -match '^[^/]+\.[^/]+-[^/]+\.vsix$' })
                if ($artifacts.Count -ne 1) {
                    $issues.Add("$label is missing its extension: expected exactly one <publisher>.<name>-<version>.vsix, found $($artifacts.Count)")
                }
            }
            'binary' {
                if ('binaries.json' -notin $inModule) {
                    $issues.Add("$label is missing its binaries.json")
                    break
                }
                try {
                    $binaries = @(& $readList "$moduleRoot/binaries.json")
                }
                catch {
                    $issues.Add("$label has a binaries.json that does not parse ($($_.Exception.Message))")
                    break
                }
                foreach ($binary in $binaries) {
                    if ("$($binary['path'])" -notin $inModule) {
                        $issues.Add("$label is missing the binary $($binary['path']) that its binaries.json lists")
                    }
                }
                if ($null -ne $record -and $record.ContainsKey('Platforms') -and $binaries.Count -ne $record['Platforms']) {
                    $issues.Add("$label lists $($binaries.Count) binaries in binaries.json but was built for $($record['Platforms']) platform(s)")
                }
            }
            'wheels' {
                if ('uv.lock' -in $inModule) {
                    if ('wheels.json' -notin $inModule) {
                        $issues.Add("$label is missing its wheels.json")
                        break
                    }
                    try {
                        $wheels = @(& $readList "$moduleRoot/wheels.json")
                    }
                    catch {
                        $issues.Add("$label has a wheels.json that does not parse ($($_.Exception.Message))")
                        break
                    }
                    foreach ($wheel in $wheels) {
                        if ("wheels/$($wheel['name'])" -notin $inModule) {
                            $issues.Add("$label is missing the wheel $($wheel['name']) that its wheels.json lists")
                        }
                    }
                }
            }
            default {
                $issues.Add("$label records a form this check does not know")
            }
        }
    }

    $issues.ToArray()
}

# A strict stand-in for `bicep build-params` that reads only the forms BicepParamWriter writes and throws on any other line; the real compile is proven at L2.
$script:readBicepParams = {
    param([string[]] $Lines, [string] $Source)

    $state = @{ Index = 0; Source = $Source }
    $fail = { param($line) throw "BicepParams.Fixture: cannot read '$line' in $($state.Source)" }
    $literal = {
        param([string] $text)
        switch -Regex ($text) {
            "^'((?:[^'\\]|\\.)*)'$" {
                return [regex]::Replace($Matches[1], '\\(.)', { param($m) switch ($m.Groups[1].Value) {
                            'n' {
                                "`n"
                            } 'r' {
                                "`r"
                            } 't' {
                                "`t"
                            } default {
                                $_
                            }
                        } })
            }
            '^-?\d+$' {
                return [long] $text
            }
            '^true$' {
                return $true
            }
            '^false$' {
                return $false
            }
            '^null$' {
                return $null
            }
        }
        & $fail $text
    }
    $quoted = { param([string] $text) if ($text -notmatch "^'((?:[^'\\]|\\.)*)'$") {
            & $fail $text
        } & $literal $text }
    # A value starting on the current line: a literal, the opening of a block, or az.getSecret.
    $value = $null
    $value = {
        param([string] $text)
        if ($text -eq '[') {
            $items = [System.Collections.Generic.List[object]]::new()
            while ($true) {
                $state.Index++
                $line = $Lines[$state.Index].Trim()
                if ($line -eq ']') {
                    return , $items.ToArray()
                }
                $items.Add((& $value $line))
            }
        }
        if ($text -eq '{') {
            $map = [ordered]@{}
            while ($true) {
                $state.Index++
                $line = $Lines[$state.Index].Trim()
                if ($line -eq '}') {
                    return $map
                }
                if ($line -notmatch "^(?<key>[A-Za-z_][A-Za-z0-9_]*|'(?:[^'\\]|\\.)*'): (?<rest>.+)$") {
                    & $fail $line
                }
                $key = if ($Matches['key'].StartsWith("'")) {
                    & $quoted $Matches['key']
                }
                else {
                    $Matches['key']
                }
                $map[$key] = & $value $Matches['rest']
            }
        }
        if ($text -like 'az.getSecret(*') {
            $arguments = @(if ($text -eq 'az.getSecret(') {
                    $collected = [System.Collections.Generic.List[string]]::new()
                    while ($true) {
                        $state.Index++
                        $line = $Lines[$state.Index].Trim()
                        if ($line -eq ')') {
                            break
                        }
                        $collected.Add($line.TrimEnd(','))
                    }
                    $collected.ToArray()
                }
                elseif ($text -match '^az\.getSecret\((?<args>.+)\)$') {
                    @($Matches['args'] -split ",\s*(?=')")
                }
                else {
                    & $fail $text
                })
            $parts = @($arguments | ForEach-Object { & $quoted $_.Trim() })
            if ($parts.Count -notin 4, 5) {
                & $fail $text
            }
            $reference = [ordered]@{
                keyVault   = [ordered]@{ id = "/subscriptions/$($parts[0])/resourceGroups/$($parts[1])/providers/Microsoft.KeyVault/vaults/$($parts[2])" }
                secretName = $parts[3]
            }
            if ($parts.Count -eq 5) {
                $reference['secretVersion'] = $parts[4]
            }
            return @{ reference = $reference }
        }
        & $literal $text
    }

    $parameters = [ordered]@{}
    for ($state.Index = 0; $state.Index -lt $Lines.Count; $state.Index++) {
        $line = $Lines[$state.Index]
        if ($line -match '^\s*$' -or $line -match '^\s*//' -or $line -match "^\s*using\s+'") {
            continue
        }
        if ($line -notmatch '^param (?<name>[A-Za-z_][A-Za-z0-9_]*) = (?<rest>.+)$') {
            & $fail $line
        }
        $name = $Matches['name']
        $rest = $Matches['rest'].Trim()
        $parsed = & $value $rest
        $parameters[$name] = if ($rest -like 'az.getSecret(*') {
            $parsed
        }
        else {
            @{ value = $parsed }
        }
    }
    $parameters
}

# A literal-only stand-in for `bicep build-params` that throws on any other line, never guessing; the real compile is proven at L2.
$script:compileBicepParams = {
    param([string] $Arguments)
    if ($Arguments -notmatch 'bicep build-params --file "(?<file>[^"]+)" --outfile "(?<out>[^"]+)"') {
        return $false
    }
    $file = $Matches['file']
    $out = $Matches['out']
    $json = [ordered]@{
        '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
        contentVersion = '1.0.0.0'
        parameters     = & $script:readBicepParams ([System.IO.File]::ReadAllLines($file)) $file
    }
    [System.IO.File]::WriteAllText($out, ($json | ConvertTo-Json -Depth 20))
    $true
}

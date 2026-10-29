function Merge-BicepSlotYamlText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [System.Collections.IDictionary] $Parameters = @{},

        [string] $ResourceGroup
    )

    $lines = [System.Collections.Generic.List[string]]::new([string[]] @($Text -replace "`r", '' -split "`n"))
    if ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') {
        $lines.RemoveAt($lines.Count - 1)
    }

    # The first line at or after $From whose indent is at most $Indent and that is not blank or a comment, or the line count.
    $blockEnd = {
        param([int] $From, [int] $Indent)
        for ($index = $From; $index -lt $lines.Count; $index++) {
            $line = $lines[$index]
            if ($line.Trim() -eq '' -or $line.TrimStart().StartsWith('#')) {
                continue
            }
            if (($line.Length - $line.TrimStart().Length) -le $Indent) {
                return $index
            }
        }
        $lines.Count
    }
    # Steps back over the blank and comment lines that end a block, so they stay with what follows it.
    $contentEnd = {
        param([int] $Start, [int] $End)
        while ($End -gt $Start + 1 -and ($lines[$End - 1].Trim() -eq '' -or $lines[$End - 1].TrimStart().StartsWith('#'))) {
            $End--
        }
        $End
    }

    if ($Parameters.Count -gt 0) {
        $root = $lines.IndexOf('ParametersFile:')
        if ($root -lt 0) {
            $lines.Add('ParametersFile:')
            $root = $lines.Count - 1
        }
        $rootEnd = & $blockEnd ($root + 1) 0
        $section = -1
        for ($index = $root + 1; $index -lt $rootEnd; $index++) {
            if ($lines[$index] -ceq '  parameters:') {
                $section = $index
            }
        }
        if ($section -lt 0) {
            $lines.Insert($root + 1, '  parameters:')
            $section = $root + 1
        }
        foreach ($name in @($Parameters.Keys)) {
            $yaml = (ConvertTo-Yaml ([ordered]@{ $name = $Parameters[$name] })) -replace "`r", ''
            $block = @($yaml.TrimEnd("`n") -split "`n" | ForEach-Object { "    $_" })
            $sectionEnd = & $contentEnd $section (& $blockEnd ($section + 1) 2)
            $start = -1
            for ($index = $section + 1; $index -lt $sectionEnd; $index++) {
                if ($lines[$index] -ceq "    ${name}:" -or $lines[$index].StartsWith("    ${name}: ", [System.StringComparison]::Ordinal)) {
                    $start = $index
                }
            }
            if ($start -lt 0) {
                $lines.InsertRange($sectionEnd, [string[]] $block)
                continue
            }
            $end = & $contentEnd $start (& $blockEnd ($start + 1) 4)
            $lines.RemoveRange($start, $end - $start)
            $lines.InsertRange($start, [string[]] $block)
        }
    }

    if (-not [string]::IsNullOrEmpty($ResourceGroup)) {
        $line = "ResourceGroup: $ResourceGroup"
        $existing = -1
        for ($index = 0; $index -lt $lines.Count; $index++) {
            if ($lines[$index].StartsWith('ResourceGroup:', [System.StringComparison]::Ordinal)) {
                $existing = $index
            }
        }
        if ($existing -ge 0) {
            $lines[$existing] = $line
        }
        else {
            $root = $lines.IndexOf('ParametersFile:')
            if ($root -lt 0) {
                $lines.Add($line)
            }
            else {
                $lines.Insert($root, $line)
            }
        }
    }

    ($lines -join "`n") + "`n"
}

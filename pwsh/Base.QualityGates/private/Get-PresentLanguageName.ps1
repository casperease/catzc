function Get-PresentLanguageName {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    # A language is present when a tracked file resolves to it; one probe per distinct name suffix is enough.
    $present = [System.Collections.Generic.List[string]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($tracked in Get-TrackedFile) {
        $leaf = $tracked.Substring($tracked.LastIndexOfAny([char[]] @('/', '\')) + 1)
        $dot = $leaf.IndexOf('.', 1)
        $suffix = if ($dot -gt 0) {
            $leaf.Substring($dot)
        }
        else {
            ''
        }
        if (-not $seen.Add($suffix)) {
            continue
        }
        $language = Get-FileLanguage -Path $tracked
        if ($language -and -not $present.Contains($language.name)) {
            $present.Add($language.name)
        }
    }
    [string[]] @($present)
}

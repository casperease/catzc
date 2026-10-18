Describe 'The file-kinds registry against the tracked files' -Tag 'L2', 'logic', 'ADR-REPO-FILEMETA-METAKIND' {
    # Read at discovery: -ForEach needs the declared classes before any BeforeAll runs.
    $declared = foreach ($entry in (Get-Config -Config file-kinds).kinds) {
        @{ Class = $entry.role }
        foreach ($subkind in $entry.subkinds) {
            @{ Class = "$($entry.role)/$($subkind.subkind)" }
        }
    }

    BeforeAll {
        $script:claimed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($path in Get-TrackedFile) {
            [void] $script:claimed.Add((Get-FileKind $path).Class)
        }
    }

    It 'a tracked file is placed in <Class>, so the kind is reachable' -ForEach $declared {
        # A kind that holds only subkinds is reached through them: its class is the prefix of theirs.
        $reached = $script:claimed.Contains($Class) -or @($script:claimed | Where-Object { $_.StartsWith("$Class/", [System.StringComparison]::Ordinal) }).Count -gt 0
        $reached | Should -BeTrue -Because "no tracked file resolves to '$Class': its globs match nothing, or an earlier kind takes every file"
    }

    It 'no kind is mostly shadowed by an earlier one the registry does not pair it with in overlaps' -Tag 'ADR-REPO-FILEMETA-ROLE' {
        $shadows = @((Get-Config -Config file-kinds).Shadowing([string[]] @(Get-TrackedFile)))
        $shadows | Should -BeNullOrEmpty -Because (@($shadows | ForEach-Object { "'$($_.By)' takes $($_.Taken) of the $($_.Matched) files '$($_.Hidden)' matches; list [$($_.By), $($_.Hidden.Split('/')[0])] in overlaps when that is intended" }) -join '; ')
    }
}

<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-docs/Add-SessionLearning.ps1.md"
  header: "generated"
---
#>

function Add-SessionLearning {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Learning,

        [ValidateSet('learnings', 'hindsight')]
        [string] $Log = 'learnings',

        [ValidatePattern('^[A-Z][a-z]+( [A-Za-z]+){0,3}$', Options = 'None', ErrorMessage = "Author '{0}' must be a capitalised person name of at most four words, the robot's persona in agents.yml.")]
        [string] $Author,

        [DateTime] $Date = [DateTime]::Today
    )

    $config = Get-Config -Config $Log
    $folder = Join-Path (Get-RepositoryRoot) $config.folder
    $day = $Date.ToString('yyyy-MM-dd', [cultureinfo]::InvariantCulture)
    if ($Author) {
        $day = "$day $Author"
    }
    $encoding = [System.Text.UTF8Encoding]::new($false)

    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $sentences = @(foreach ($sentence in $Learning) {
            $text = "$sentence".Trim()
            Assert-True ($text.Length -gt 0) -ErrorText 'Add-SessionLearning: a learning is empty.'
            Assert-True ($text.IndexOfAny([char[]] "`r`n") -lt 0) -ErrorText "Add-SessionLearning: '$text' holds a line break; give one learning per sentence."
            if (-not $seen.Add($text)) {
                Write-Message "Add-SessionLearning: skipped '$text', already given in this call." -Warning
                continue
            }
            $text
        })

    [void] [System.IO.Directory]::CreateDirectory($folder)
    $written = [System.Collections.Generic.List[string]]::new()
    $started = 'Started '
    foreach ($text in $sentences) {
        # A file's start time is its 'Started <time>.' line, not its name or its file time, so the order survives a clone.
        $dated = @(foreach ($file in $config.FilesIn($folder)) {
                $line = @([System.IO.File]::ReadAllLines($file) | Where-Object { $_.StartsWith($started, [StringComparison]::Ordinal) } | Select-Object -First 1)
                Assert-True ($line.Count -eq 1) -ErrorText "Add-SessionLearning: '$file' has no '$started<time>.' line."
                [pscustomobject]@{ Path = $file; Since = [DateTimeOffset]::Parse($line[0].Substring($started.Length).TrimEnd('.'), [cultureinfo]::InvariantCulture) }
            })
        [string[]] $files = @($dated | Sort-Object -Property Since | ForEach-Object Path)
        $current = if ($files.Count -gt 0) {
            $files[-1]
        }
        else {
            $null
        }
        if (-not $current -or @([System.IO.File]::ReadAllLines($current) | Where-Object { $_.StartsWith('- ') }).Count -ge $config.lines_per_file) {
            $since = [DateTimeOffset]::Now.ToString('o', [cultureinfo]::InvariantCulture)
            $digest = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes("$($config.folder)|$since"))
            $sha = [Convert]::ToHexString($digest).Substring(0, 6).ToLowerInvariant()
            $current = Join-Path $folder "$($config.prefix)$sha.md"
            [System.IO.File]::WriteAllText($current, "# $($config.title) $sha`n`n$started$since.`n`n", $encoding)
            [string[]] $files = @($files) + $current
            for ($i = 0; $i -lt $files.Count - $config.files; $i++) {
                [System.IO.File]::Delete($files[$i])
            }
        }
        $parts = $text.Split('`')
        for ($i = 0; $i -lt $parts.Count; $i += 2) {
            $parts[$i] = $parts[$i].Replace('<', '\<')
        }
        $markdown = $parts -join '`'
        $item = @(Format-MarkdownParagraph "${day}: $markdown" -FirstPrefix '- ' -ContinuationPrefix '  ' | ForEach-Object { $_ }) -join "`n"
        [System.IO.File]::AppendAllText($current, "$item`n", $encoding)
        if (-not $written.Contains($current)) {
            $written.Add($current)
        }
    }
    $written
}

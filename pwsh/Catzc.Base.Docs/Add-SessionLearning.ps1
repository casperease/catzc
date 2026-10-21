<#
---
catzc:
  immutable:
    with_body_sha: eb7e3e930f45
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Add-SessionLearning.Tests.ps1
    docs: "[Add-SessionLearning.ps1.md](docs/references/pwsh/catzc-base-docs/Add-SessionLearning.ps1.md)"
---
#>

function Add-SessionLearning {
    <#
    .SYNOPSIS
        Appends dated sentences to a rolling log: a few markdown files of bounded length, first in first out; the learnings log by default.

    .DESCRIPTION
        A learning is a forward memory for the next agents that work the same material: it completes "In hindsight I wish I knew this
        fact: …", and states what is true of the repository now, never the story of the session that found it. The session-finalize
        skill calls this with the lines of its "What I learned" section. Each sentence becomes one line,
        `- <yyyy-MM-dd>: <sentence>`, appended to the newest file in the log's folder; a file that holds lines_per_file lines is full,
        so the next line starts a new file, `<prefix><sha>.md`, `<sha>` the first six hex of a SHA-256 of the folder and its start time,
        headed `# <title> <sha>` and then `Started <time>.`, the start time the files are ordered by. A long line is wrapped at
        140 columns as the markdown formatter wraps a list item (Format-MarkdownParagraph), so the log passes the markdown lint as written;
        a line is counted by the line that starts it. When a new file would make more than
        `files` files, the oldest is deleted: git keeps it once committed. Lines are never edited and a repeat across calls is kept, since
        a line that recurs shows what keeps mattering; only a sentence given twice in one call (a relayed batch) is written once, and each
        skip is reported with a warning. Every log is one LearningsConfig instance, registered in configs.yml under its own name: the
        learnings log (`learned<sha>.md`, "Session learnings") and the hindsight log the 2020-hindsight robot keeps (`hindsight<sha>.md`,
        "Hindsight", in .claude/hindsight). The defaults (5 files of 50 lines) are declared once on LearningsConfig.

    .PARAMETER Learning
        The sentences, one line each; a sentence holds no line break.

    .PARAMETER Log
        The config name of the log to append to, a LearningsConfig in configs.yml. Default: learnings.

    .PARAMETER Author
        The person name of the robot writing the lines, its persona in agents.yml (Jack, Susan from HR); the line then reads
        `- <yyyy-MM-dd> <Author>: <sentence>`, so a log says who wrote what. Default: none, the line carries the date only.

    .PARAMETER Date
        The date written on each line. Default: today.

    .OUTPUTS
        [string] Each file written to, in order.
    #>
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
        $dated = @(foreach ($file in [System.IO.Directory]::GetFiles($folder, "$($config.prefix)*.md")) {
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

<#
---
catzc:
  config:
    synopsis: Moves the help of one PowerShell file from its head's config part to the `## help` section of its comment page.
    description: |-
      The help keys (synopsis, description, parameters, inputs, outputs, examples, notes) are rendered in the section's fixed shape
      ([ADR-REPO-HELP#1](/docs/adr/repository/function-help.md#rule-adr-repo-help1)), their text kept as written, and the head loses its
      config part; a head left with nothing else goes. A page that does not exist yet starts the way the comment exporter starts one, and an
      existing page keeps every other byte, its comment sections included. A help section already on the page is replaced, so a second
      move changes nothing once the head holds no help. A config part that holds a key that is no help key, or does not parse, is
      reported and the file is left alone, so no authored key is lost.
    parameters:
      Path: The file's repository-relative, '/'-separated path.
      RepositoryRoot: The repository root the path is relative to.
      DryRun: Compute the new texts without writing either file.
    outputs: |-
      [pscustomobject] { Path; Page; Moved; Reason; Text; PageText }: Moved is false with a Reason when nothing moves, and Text and
      PageText are the texts the two files have after the move.
---
#>

function Move-FunctionHelp {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [switch] $DryRun
    )

    $helpKeys = 'synopsis', 'description', 'parameters', 'inputs', 'outputs', 'examples', 'notes'
    $full = Join-Path $RepositoryRoot $Path
    $text = [System.IO.File]::ReadAllText($full)
    $form = (Get-Config -Config file-carriers).Find('powershell').Form()
    $state = Get-CodeMetaState -Text $text -Form $form
    $page = (Get-Config -Config comments).PageFor($Path)
    $outcome = [pscustomobject]@{ Path = $Path; Page = $page; Moved = $false; Reason = $null; Text = $text; PageText = $null }
    if ($state.ConfigLines.Count -eq 0) {
        $outcome.Reason = 'the head holds no help'
        return $outcome
    }
    Assert-NotNull $page -ErrorText "Move-FunctionHelp: comments.yml maps '$Path' to no comment page, so its help has nowhere to go."

    $yaml = (@($state.ConfigLines | ForEach-Object { if ($_.Length -ge 4) {
                    $_.Substring(4)
                }
                else {
                    $_
                } }) -join "`n")
    try {
        $config = ConvertFrom-Yaml -Yaml $yaml -Ordered
    }
    catch {
        $outcome.Reason = "the head's config does not parse as YAML: $($_.Exception.Message)"
        return $outcome
    }
    if ($config -isnot [System.Collections.IDictionary]) {
        $outcome.Reason = "the head's config part is not a map"
        return $outcome
    }
    $foreign = @($config.Keys | Where-Object { $_ -notin $helpKeys })
    if ($foreign.Count -gt 0) {
        $outcome.Reason = "the head's config holds keys that are no help keys ($($foreign -join ', ')): move them by hand"
        return $outcome
    }

    $pageFull = Join-Path $RepositoryRoot $page
    $pageText = if ([System.IO.File]::Exists($pageFull)) {
        [System.IO.File]::ReadAllText($pageFull)
    }
    else {
        [Catzc.Base.QualityGates.CommentEngine]::FreshPage($Path)
    }
    $section = [Catzc.Base.QualityGates.FunctionHelp]::FromConfig($config).ToSection()
    $outcome.PageText = [Catzc.Base.QualityGates.FunctionHelp]::WithSection($pageText, $section)
    $outcome.Text = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $form).WithoutConfig()
    $outcome.Moved = $true
    if (-not $DryRun) {
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($pageFull)) | Out-Null
        [System.IO.File]::WriteAllText($pageFull, $outcome.PageText, $utf8NoBom)
        [System.IO.File]::WriteAllText($full, $outcome.Text, $utf8NoBom)
    }
    $outcome
}

<#
.SYNOPSIS
    Computes the meta block of every in-scope Markdown file — the one place Format-MarkdownMeta and Test-MarkdownMeta share
    ([ADR-REPO-MDMETA#3](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta3)).
.DESCRIPTION
    Each file's `derived` part is rebuilt from the imprint kinds of the registry, and its authored `config` part is kept as written.
    A file whose block holds a key no kind owns is reported as Unowned and left unchanged, since writing it would drop the author's key
    ([ADR-REPO-MDMETA#5](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta5)).
.PARAMETER RepositoryRoot
    The repository root paths are relative to.
.PARAMETER Path
    Optional files or folders to limit the scope to.
.PARAMETER Config
    The meta-kind registry. Default: the shipped one.
.OUTPUTS
    [pscustomobject] @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each
    finding @{ Path; Line; Kind; Actual; Expected }.
#>
function Invoke-MarkdownMetaEngine {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Catzc.Base.QualityGates.MarkdownMetaConfig] $Config = (Get-Config -Config markdown-meta)
    )

    $files = Get-MarkdownMetaScope -RepositoryRoot $RepositoryRoot -Path $Path
    $owned = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Config.Imprint() | ForEach-Object { $_.keys }))

    $entries = foreach ($file in $files) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $file))
        $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($text)
        $block = $document.MetaBlock
        $findings = [System.Collections.Generic.List[pscustomobject]]::new()

        # A key no kind owns is the author's: report it and leave the file alone.
        $section = ''
        foreach ($line in @($block | Select-Object -Skip 1)) {
            if ($line -match '^  (?<key>[^\s#][^:]*):') {
                $section = $Matches.key
                if ($section -notin 'derived', 'config') {
                    $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.$section"; Expected = 'derived or config' })
                }
            }
            elseif ($section -eq 'derived' -and $line -match '^    (?<key>[^\s#-][^:]*):' -and -not $owned.Contains($Matches.key.Trim('"'))) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.derived.$($Matches.key)"; Expected = 'a key a meta kind owns' })
            }
        }

        $fixed = $text
        if ($findings.Count -eq 0) {
            $facts = Get-MarkdownMetaFact -Document $document -Path $file -Config $Config
            $rendered = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($block))
            $fixed = $document.WithMetaBlock($rendered)
            if ($fixed -cne $text) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 1; Kind = 'Drift'; Actual = 'the meta block as written'; Expected = 'the imprinted meta block' })
            }
        }
        [pscustomobject]@{ Path = $file; Findings = $findings; Fixed = $fixed }
    }

    [pscustomobject]@{
        FileCount = $files.Count
        Files     = @($entries | Where-Object { $_.Findings.Count -gt 0 })
    }
}

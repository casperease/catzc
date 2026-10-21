<#
---
catzc:
  immutable:
    with_body_sha: "149b74997318"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Invoke-FileMetaEngine.Tests.ps1
    docs: "[Invoke-FileMetaEngine.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Invoke-FileMetaEngine.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-KINDSCOPE
---
#>

function Invoke-FileMetaEngine {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Catzc.Base.QualityGates.FileMetaConfig] $Config = (Get-Config -Config file-meta),

        [pscustomobject[]] $Entry
    )

    # @() around the whole if: an empty file list must stay an array (.Count under strict mode).
    $files = @(if ($PSBoundParameters.ContainsKey('Entry')) {
            $Entry
        }
        else {
            Get-FileMetaScope -RepositoryRoot $RepositoryRoot -Path $Path -Config $Config
        })
    # The imprinted parts are wholly the engine's: a key no kind owns there is dropped on imprint, and only the config part is the author's.
    $parts = 'immutable', 'edges', 'config'
    $codeHeads = Test-FileHeadVariant -Minimal

    $entries = foreach ($entry in $files) {
        $file = $entry.Path
        $carrier = $entry.Carrier.carrier
        $isHead = $carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead
        $isProperty = $carrier -eq [Catzc.Base.Languages.CarrierKind]::Property
        $findings = [System.Collections.Generic.List[pscustomobject]]::new()

        # A path the index lists but the working tree has lost, a deletion not yet staged, has nothing to imprint or to look beside.
        if (-not [System.IO.File]::Exists((Join-Path $RepositoryRoot $file))) {
            continue
        }

        # A sidecar carrier keeps the block in the Markdown file beside the file, which is in scope on its own, so only its presence is checked.
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Sidecar) {
            $name = [System.IO.Path]::GetFileName($file)
            $name = $name.Substring(0, $name.IndexOf('.'))
            $segments = $name -split '--'
            $stem = $name
            if ($segments.Count -ge 3) {
                $stem = $segments[1..($segments.Count - 2)] -join '--'
            }
            $sidecar = $entry.Carrier.sidecar.Replace('{base}', $file.Substring(0, $file.LastIndexOf('.'))).Replace('{stem}', $stem)
            $exists = if ($sidecar.Contains('*')) {
                # One folder level may be a wildcard: the description is found in whichever folder beside the article holds it.
                $before, $after = $sidecar -split '\*', 2
                $root = Join-Path $RepositoryRoot $before
                [System.IO.Directory]::Exists($root) -and @([System.IO.Directory]::GetDirectories($root)).Where({ [System.IO.File]::Exists($_ + $after) }).Count -eq 1
            }
            else {
                [System.IO.File]::Exists((Join-Path $RepositoryRoot $sidecar))
            }
            if (-not $exists) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'MissingSidecar'; Actual = 'no file'; Expected = $sidecar })
            }
            [pscustomobject]@{ Path = $file; Findings = $findings; Fixed = $null }
            continue
        }

        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $file))

        # A key no kind owns is the author's: report it and leave the file alone.
        if ($isProperty) {
            $property = $entry.Carrier.property
            $state = Get-PropertyMetaState -Text $text -Property $property -Strip $entry.Carrier.strip
            $state | Add-Member -NotePropertyName Rest -NotePropertyValue $text
            # A text that is no JSON object has no top level to hold the property, so it carries no block.
            if (-not $state.IsObject) {
                [pscustomobject]@{ Path = $file; Findings = $findings; Fixed = $text }
                continue
            }
            if ($state.Foreign) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "property '$property' holds something else"; Expected = 'a catzc meta block, or no such property' })
            }
            foreach ($section in $state.Sections | Where-Object { $_ -notin $parts }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.$section"; Expected = 'immutable, edges or config' })
            }
        }
        elseif ($isHead) {
            $form = $entry.Carrier.Form()
            $state = Get-CodeMetaState -Text $text -Form $form
            foreach ($section in $state.Sections | Where-Object { $_ -notin $parts }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.$section"; Expected = 'immutable, edges or config' })
            }
        }
        else {
            $state = Get-MarkdownMetaState -Text $text -Key $entry.Carrier.key
            # A parent key written as a flow mapping or a scalar is the author's to open up; the block cannot nest under it.
            if (-not $state.CanHoldMetaBlock) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "a key above $($entry.Carrier.key) holds a flow or scalar value"; Expected = 'a block mapping the catzc block can nest under' })
            }
            foreach ($section in $state.Sections | Where-Object { $_ -notin $parts }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.$section"; Expected = 'immutable, edges or config' })
            }
        }

        $fixed = $text
        $policy = $Config.PolicyFor((Get-FileKind $file).Class, ($isHead -or $isProperty), $codeHeads)
        $hasBlock = if ($isProperty -or $isHead) {
            $state.HasHead
        }
        else {
            $state.HasMetaBlock
        }
        # A forbidden block that holds an authored config part is the author's to move: stripping it would drop their keys.
        if ($findings.Count -eq 0 -and $policy -eq [Catzc.Base.QualityGates.HeadPolicy]::Forbidden -and $state.ConfigLines.Count -gt 0) {
            $findings.Add([pscustomobject]@{ Path = $file; Line = 1; Kind = 'ForbiddenConfig'; Actual = 'a config part'; Expected = 'no meta block, as the head policy forbids one' })
        }
        $skip = $policy -eq [Catzc.Base.QualityGates.HeadPolicy]::Optional -and -not $hasBlock
        if ($findings.Count -eq 0 -and -not $skip) {
            $facts = if ($policy -in [Catzc.Base.QualityGates.HeadPolicy]::Forbidden, [Catzc.Base.QualityGates.HeadPolicy]::Config) {
                [pscustomobject]@{ Immutable = [ordered]@{}; Edges = [ordered]@{} }
            }
            else {
                Get-FileMetaFact -State $state -Path $file -Config $Config
            }
            $fixed = if ($isProperty) {
                Format-PropertyMetaHead -Text $text -Property $property -Strip $entry.Carrier.strip -Immutable $facts.Immutable -Edges $facts.Edges
            }
            elseif ($isHead) {
                Format-CodeMetaHead -Text $text -Form $form -Immutable $facts.Immutable -Edges $facts.Edges
            }
            else {
                Format-MarkdownMetaBlock -Text $text -Immutable $facts.Immutable -Edges $facts.Edges -Key $entry.Carrier.key
            }
            if ($fixed -cne $text) {
                $expected = if ($policy -eq [Catzc.Base.QualityGates.HeadPolicy]::Forbidden) {
                    'no meta block, as the head policy forbids one'
                }
                elseif ($policy -eq [Catzc.Base.QualityGates.HeadPolicy]::Config) {
                    'the authored config part alone, as the head policy keeps nothing else'
                }
                else {
                    'the imprinted meta block'
                }
                $findings.Add([pscustomobject]@{ Path = $file; Line = 1; Kind = 'Drift'; Actual = 'the meta block as written'; Expected = $expected })
            }
        }
        [pscustomobject]@{ Path = $file; Findings = $findings; Fixed = $fixed }
    }

    [pscustomobject]@{
        FileCount = $files.Count
        Files     = @($entries | Where-Object { $_.Findings.Count -gt 0 })
    }
}

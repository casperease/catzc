<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#5
---
#>

<#
.SYNOPSIS
    Computes the meta block of every in-scope file — the one place Format-FileMeta and Test-FileMeta share.
.DESCRIPTION
    An unowned key is reported and the file left alone, since writing would drop the author's key.
.PARAMETER RepositoryRoot
    The repository root paths are relative to.
.PARAMETER Path
    Optional files or folders to limit the scope to.
.PARAMETER Config
    The meta-kind registry. Default: the shipped one.
.PARAMETER Entry
    The files to check, each { Path; Carrier }, instead of the scope git and the registries give.
.OUTPUTS
    [pscustomobject] @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each
    finding @{ Path; Line; Kind; Actual; Expected }.
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
    $owned = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Config.Imprint() | ForEach-Object { $_.keys }))

    $entries = foreach ($entry in $files) {
        $file = $entry.Path
        $carrier = $entry.Carrier.carrier
        $isHead = $carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead
        $isProperty = $carrier -eq [Catzc.Base.Languages.CarrierKind]::Property
        $findings = [System.Collections.Generic.List[pscustomobject]]::new()

        # A sidecar carrier keeps the block in the Markdown file beside the file, which is in scope on its own, so only its presence is checked.
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Sidecar) {
            $sidecar = $entry.Carrier.sidecar.Replace('{base}', $file.Substring(0, $file.LastIndexOf('.')))
            if (-not [System.IO.File]::Exists((Join-Path $RepositoryRoot $sidecar))) {
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
            foreach ($section in $state.Sections | Where-Object { $_ -notin 'derived', 'config' }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.$section"; Expected = 'derived or config' })
            }
            foreach ($key in $state.DerivedKeys | Where-Object { -not $owned.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.derived.$key"; Expected = 'a key a meta kind owns' })
            }
        }
        elseif ($isHead) {
            $form = $entry.Carrier.Form()
            $state = Get-CodeMetaState -Text $text -Form $form
            foreach ($section in $state.Sections | Where-Object { $_ -notin 'derived', 'config' }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.$section"; Expected = 'derived or config' })
            }
            foreach ($key in $state.DerivedKeys | Where-Object { -not $owned.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.derived.$key"; Expected = 'a key a meta kind owns' })
            }
        }
        else {
            $state = Get-MarkdownMetaState -Text $text
            foreach ($section in $state.Sections | Where-Object { $_ -notin 'derived', 'config' }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.$section"; Expected = 'derived or config' })
            }
            foreach ($key in $state.DerivedKeys | Where-Object { -not $owned.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.derived.$key"; Expected = 'a key a meta kind owns' })
            }
        }

        $fixed = $text
        if ($findings.Count -eq 0) {
            $facts = Get-FileMetaFact -State $state -Path $file -Config $Config
            $fixed = if ($isProperty) {
                Format-PropertyMetaHead -Text $text -Property $property -Strip $entry.Carrier.strip -Fact $facts
            }
            elseif ($isHead) {
                Format-CodeMetaHead -Text $text -Form $form -Fact $facts
            }
            else {
                Format-MarkdownMetaBlock -Text $text -Fact $facts
            }
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

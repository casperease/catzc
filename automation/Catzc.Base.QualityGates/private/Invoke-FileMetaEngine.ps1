<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1
    folder: private
    name: invoke-file-meta-engine
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Invoke-FileMetaEngine.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#5
  config:
    synopsis: Computes the meta block of every in-scope file — the one place Format-FileMeta and Test-FileMeta share.
    description: |-
      Each file's `immutable` and `edges` parts are rebuilt from the imprint kinds of the registry, and its authored `config` part is kept as written.
      A file whose block holds a key no kind owns is reported as Unowned and left unchanged, since writing it would drop the author's key
      ([ADR-REPO-FILEMETA#5](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta5)).
    parameters:
      RepositoryRoot: The repository root paths are relative to.
      Path: Optional files or folders to limit the scope to.
      Config: 'The meta-kind registry. Default: the shipped one.'
      Entry: The files to check, each { Path; Carrier }, instead of the scope git and the registries give.
    outputs: |-
      [pscustomobject] @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each
      finding @{ Path; Line; Kind; Actual; Expected }.
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
    $ownedImmutable = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Config.KeysOf('immutable')))
    $ownedEdges = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Config.KeysOf('edges')))
    $parts = 'immutable', 'edges', 'config'

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

        # A path the index lists but the working tree has lost, a deletion not yet staged, has nothing to imprint.
        if (-not [System.IO.File]::Exists((Join-Path $RepositoryRoot $file))) {
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
            foreach ($key in $state.ImmutableKeys | Where-Object { -not $ownedImmutable.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.immutable.$key"; Expected = 'a key a meta kind owns' })
            }
            foreach ($key in $state.EdgeKeys | Where-Object { -not $ownedEdges.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.edges.$key"; Expected = 'an edge a meta kind owns' })
            }
        }
        elseif ($isHead) {
            $form = $entry.Carrier.Form()
            $state = Get-CodeMetaState -Text $text -Form $form
            foreach ($section in $state.Sections | Where-Object { $_ -notin $parts }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.$section"; Expected = 'immutable, edges or config' })
            }
            foreach ($key in $state.ImmutableKeys | Where-Object { -not $ownedImmutable.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.immutable.$key"; Expected = 'a key a meta kind owns' })
            }
            foreach ($key in $state.EdgeKeys | Where-Object { -not $ownedEdges.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'UnownedHead'; Actual = "catzc.edges.$key"; Expected = 'an edge a meta kind owns' })
            }
        }
        else {
            $state = Get-MarkdownMetaState -Text $text
            foreach ($section in $state.Sections | Where-Object { $_ -notin $parts }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.$section"; Expected = 'immutable, edges or config' })
            }
            foreach ($key in $state.ImmutableKeys | Where-Object { -not $ownedImmutable.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.immutable.$key"; Expected = 'a key a meta kind owns' })
            }
            foreach ($key in $state.EdgeKeys | Where-Object { -not $ownedEdges.Contains($_) }) {
                $findings.Add([pscustomobject]@{ Path = $file; Line = 0; Kind = 'Unowned'; Actual = "catzc.edges.$key"; Expected = 'an edge a meta kind owns' })
            }
        }

        $fixed = $text
        if ($findings.Count -eq 0) {
            $facts = Get-FileMetaFact -State $state -Path $file -Config $Config
            $fixed = if ($isProperty) {
                Format-PropertyMetaHead -Text $text -Property $property -Strip $entry.Carrier.strip -Immutable $facts.Immutable -Edges $facts.Edges
            }
            elseif ($isHead) {
                Format-CodeMetaHead -Text $text -Form $form -Immutable $facts.Immutable -Edges $facts.Edges
            }
            else {
                Format-MarkdownMetaBlock -Text $text -Immutable $facts.Immutable -Edges $facts.Edges
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

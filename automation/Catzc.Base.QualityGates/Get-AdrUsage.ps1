<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Get-AdrUsage.ps1
    name: get-adr-usage
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-AdrUsage.Tests.ps1
  config:
    synopsis: Lists every ADR citation and ADR link the tracked files hold in their meta heads.
    description: |-
      Reads the `adrs` and `links` lists that Format-FileMeta imprints, so it scans no body and runs no regular expression over the
      repository: a file whose head is stale shows its stale head, which Test-FileMeta reports. One row per citation, in the order git
      lists the files. A code or rule the ADR index does not register, such as a placeholder named in a comment, gives no row. A bare
      code is the whole ADR (Rule is null). A file whose carrier is a JSON property or a sidecar is not listed.

      GroupBy Rule answers "who cites this rule": one row per code and rule, with the documents that cite it. GroupBy Document answers
      "what does this file cite": one row per citing file, with its citations.
    parameters:
      RepositoryRoot: The repository root. Defaults to the loaded repository root.
      Path: Optional files or folders to limit the scan to.
      Code: Keep only rows for these citation codes, such as ADR-PWSH-ERROR.
      Source: Keep only rows from the `head` (cited in the file) or from a `link` (linked from the file).
      GroupBy: '`Rule` for one row per cited rule, `Document` for one row per citing file. Default: the ungrouped rows.'
    outputs: |-
      [pscustomobject] one @{ Path; Code; Rule; Source }, or with GroupBy Rule @{ Code; Rule; Count; Documents }, or with GroupBy Document
      @{ Path; Count; Citations }.
    examples:
      - Get-AdrUsage -Code ADR-PWSH-ERROR -GroupBy Rule
      - Get-AdrUsage -Path docs/adr -Source link -GroupBy Document | Sort-Object Count -Descending
---
#>

function Get-AdrUsage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string[]] $Path,

        [string[]] $Code,

        [ValidateSet('head', 'link')]
        [string] $Source,

        [ValidateSet('Rule', 'Document')]
        [string] $GroupBy
    )

    $map = Get-AdrCitationMap -RepositoryRoot $RepositoryRoot
    $config = Get-Config -Config file-meta
    $rows = foreach ($entry in Get-FileMetaScope -RepositoryRoot $RepositoryRoot -Path $Path -Config $config) {
        $carrier = $entry.Carrier.carrier
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Property -or $carrier -eq [Catzc.Base.Languages.CarrierKind]::Sidecar) {
            continue
        }
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $entry.Path))
        $arguments = @{ Text = $text; Path = $entry.Path; Map = $map }
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead) {
            $arguments['Form'] = $entry.Carrier.Form()
        }
        foreach ($row in Get-AdrUsageRow @arguments) {
            if ($Code -and $row.Code -notin $Code) {
                continue
            }
            if ($Source -and $row.Source -ne $Source) {
                continue
            }
            $row
        }
    }

    if ($GroupBy) {
        Group-AdrUsage -Row @($rows) -By $GroupBy
        return
    }
    $rows
}

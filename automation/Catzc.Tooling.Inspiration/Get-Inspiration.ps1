<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Inspiration
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-INSPIRE#{1,2}
  config:
    synopsis: Lists the inspirations catzc reads for ideas, and whether each is available on this machine.
    description: |-
      Reads the inspirations from configs/inspiration.yml (Get-Config -Config inspiration, whose type declares the sensible
      default, the one 'eac' entry; [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)),
      resolves each root on this machine (Resolve-InspirationRoot), and returns one Inspiration record per pick: Id, Root,
      Available, Description, Paths.

      An inspiration is read for ideas, never as a reference implementation
      ([ADR-REPO-INSPIRE#2](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire2)), and the work carries on without
      one that is absent ([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)). So an
      inspiration whose root does not exist here is reported with Available false, never thrown on.

        - No arguments: every available inspiration, in file order.
        - -Id: that inspiration, available or not; an unknown id throws.
        - -Count: that many distinct inspirations at random, from the available ones (every one with
          -IncludeUnavailable), clamped to how many there are. -Seed makes the pick deterministic.
    parameters:
      Id: The id of one inspiration (its inspiration.yml entry).
      Count: How many inspirations to pick at random. 0 picks none; more than there are picks them all, shuffled.
      Seed: Seeds the random pick, so the same seed over the same inspirations picks the same ones in the same order.
      IncludeUnavailable: Lists, or picks from, the inspirations that are not available here too.
    examples:
      - Get-Inspiration
      - Get-Inspiration eac
      - Get-Inspiration -Count 1 -Seed 7
---
#>

function Get-Inspiration {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Catzc.Tooling.Inspiration.Inspiration])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [Parameter(Mandatory, ParameterSetName = 'Random')]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $Count,

        [Parameter(ParameterSetName = 'Random')]
        [int] $Seed,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Random')]
        [switch] $IncludeUnavailable
    )

    $inspirations = @(
        foreach ($entry in (Get-Config -Config inspiration).inspirations) {
            $root = Resolve-InspirationRoot $entry.root
            [Catzc.Tooling.Inspiration.Inspiration]::new($entry.id, $root, [IO.Directory]::Exists($root), $entry.description, $entry.paths)
        }
    )

    if ($PSCmdlet.ParameterSetName -eq 'Id') {
        $found = @($inspirations | Where-Object Id -CEQ $Id)
        $known = @(foreach ($inspiration in $inspirations) {
                $inspiration.Id
            })
        Assert-True ($found.Count -eq 1) -ErrorText "Unknown inspiration '$Id' in inspiration.yml (known ids: $($known -join ', '))"
        return $found[0]
    }

    $pool = @(
        if ($IncludeUnavailable) {
            $inspirations
        }
        else {
            $inspirations | Where-Object Available
        }
    )
    if ($PSCmdlet.ParameterSetName -eq 'All') {
        return $pool
    }

    # A partial Fisher-Yates shuffle: the first $take positions are a uniform random pick, in pick order.
    $random = if ($PSBoundParameters.ContainsKey('Seed')) {
        [Random]::new($Seed)
    }
    else {
        [Random]::new()
    }
    $take = [Math]::Min($Count, $pool.Count)
    for ($i = 0; $i -lt $take; $i++) {
        $j = $random.Next($i, $pool.Count)
        $swap = $pool[$i]
        $pool[$i] = $pool[$j]
        $pool[$j] = $swap
    }
    if ($take -gt 0) {
        $pool[0..($take - 1)]
    }
}

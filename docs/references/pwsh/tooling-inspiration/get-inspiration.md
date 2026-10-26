# pwsh/Tooling.Inspiration/Get-Inspiration.ps1

The command that lists the inspirations catzc reads for ideas and reports whether each is available on this machine. It reads
`configs/inspiration.yml`, resolves each root with the private `Resolve-InspirationRoot` and returns one `Inspiration` record per pick.

## help

### synopsis

Lists the inspirations catzc reads for ideas, and whether each is available on this machine.

### description

Reads the inspirations from configs/inspiration.yml (Get-Config -Config inspiration, whose type declares the sensible default, the one 'eac'
entry; [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)),
resolves each root on this machine (Resolve-InspirationRoot), and returns one Inspiration record per pick: Id, Root, Available, Description,
Paths.

An inspiration is read for ideas, never as a reference implementation
([ADR-REPO-INSPIRE-NEVERREFERENCE](../../../drs/repository/inspiration.md#rule-adr-repo-inspire-neverreference)), and the work carries on
without one that is absent
([ADR-REPO-INSPIRE-SIBLINGFORIDEAS](../../../drs/repository/inspiration.md#rule-adr-repo-inspire-siblingforideas)). So an inspiration whose
root does not exist here is reported with Available false, never thrown on.

- No arguments: every available inspiration, in file order.
- -Id: that inspiration, available or not; an unknown id throws.
- -Count: that many distinct inspirations at random, from the available ones (every one with -IncludeUnavailable), clamped to how many there
  are. -Seed makes the pick deterministic.

### parameter `Id`

The id of one inspiration (its inspiration.yml entry).

### parameter `Count`

How many inspirations to pick at random. 0 picks none; more than there are picks them all, shuffled.

### parameter `Seed`

Seeds the random pick, so the same seed over the same inspirations picks the same ones in the same order.

### parameter `IncludeUnavailable`

Lists, or picks from, the inspirations that are not available here too.

### example 1

```powershell
Get-Inspiration
```

### example 2

```powershell
Get-Inspiration eac
```

### example 3

```powershell
Get-Inspiration -Count 1 -Seed 7
```

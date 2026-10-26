# pwsh/Base.Config/private/Merge-ConfigFragment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Merges a consumer overlay's config fragment onto a bundled config, key by key.

### description

A fragment states only the keys that differ ([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)):

- a map merges into the bundled map recursively;
- a scalar or a list replaces the bundled value (a list is never appended to, so the result is predictable);
- an explicit null removes the key, so the config type's declared default applies.

A key the fragment does not name keeps the bundled value. Neither input is changed; the result is a new ordered dictionary, which the
config's own type then validates like any parsed config.

### parameter `Base`

The parsed bundled config.

### parameter `Fragment`

The parsed overlay fragment.

### parameter `Disjoint`

Merges the parts of one split config, which are disjoint: a key both inputs set as a value throws, never overrides. Maps under one key still
merge, part by part.

## comment:1

Above `[switch] $Disjoint`, written with `#`.

```text
The parts of one split config are disjoint: a key two parts both set as a value is an error, never an
override.
```

# pwsh/Base.Config/private/Merge-ConfigFragment.ps1

The private merge that lays a consumer overlay's config fragment over a bundled config, or joins the disjoint parts of one split config.

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

## Disjoint parts

The parts of one split config are disjoint: a key two parts both set as a value is an error, never an override.

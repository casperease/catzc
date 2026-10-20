# ADR: Infrastructure kinds — templates, configuration slots and reusable modules, placed by the track

## Rules: ADR-AZ-IACKIND

### Rule ADR-AZ-IACKIND-THREEKINDS

The infrastructure code has three kinds: IaC templates (a folder holding a deployable `main.bicep` and its `options.yml`), their
configuration slots (the `<env>[-<slot>].yml` files under each template's configuration folder, one per subscription's resource group,
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), and reusable Bicep modules (one
`.bicep` file each, used by templates and never deployed alone). Every infrastructure file is of one kind.

- [The three kinds](#the-three-kinds)

### Rule ADR-AZ-IACKIND-TRACKPLACESKINDS

The infrastructure track names each kind's place under `kinds:` in `variants.yml` (`templates`, `configs`, `modules`), and the tooling finds
a kind only through `Get-TrackPlace -Track infrastructure -TrackKind <kind>`, never through a path written in code. A repository that keeps
its infrastructure elsewhere maps the three kinds in its own `variants.yml`, and the tooling follows unchanged.

- [The track places the kinds](#the-track-places-the-kinds)

## Context

The catzc tooling is exported to other repositories and can run with no repository of its own, so no folder layout is fixed: a track
resolves every placement ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](../design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster)), and a
consumer binds to a track, never to its paths
([ADR-DSGN-TRACK-SUBSCRIBABLENOTPATHCOUPLED](../design/tracks.md#rule-adr-dsgn-track-subscribablenotpathcoupled)). A track's places say
which files belong to it, but the infrastructure code needs more than membership: building a template, reading its configuration slots and
listing the modules each look in a different part of the track. Writing those parts as literal paths in the tooling ties every repository to
this one's layout.

## Decision

### The three kinds

An IaC template is the unit that deploys: its folder holds `main.bicep`, `options.yml` and a `README.md`, and its name is the template's
name. A configuration slot is one file of a template's configuration tree; slot and customer names are discovered from disk, never listed
([ADR-AZ-DATAMOD](azure-data-model.md)). A reusable module is one `.bicep` file a template references; a change to it reaches every template
that uses it.

### The track places the kinds

The `infrastructure` track keeps its places, which decide membership as for every track (the longest place wins), and adds a `kinds:` map
from each kind to a place pattern inside one of those places. A pattern may hold one `*` segment, so the configuration folders of every
template are one kind (`infrastructure/templates/*/configuration`). The tooling resolves a kind through `Get-TrackPlace`; a kind the track
does not name is an error that names the track's kinds and the config to declare it in.

## Consequences

- No code under the module root writes an infrastructure path; the templates, configuration slots and modules move by an edit to
  `variants.yml`.
- A consumer repository that keeps its templates elsewhere states three entries and the tooling works on its layout.
- Static configuration that hands paths to an outside tool (spell-check ignore paths, file-kind globs) keeps its own copy of the path,
  because it cannot call the resolver.

# pwsh/Base.Variants/configs/variants.yml

The repo-wide variants: a growing dictionary of switches fixed for the importer session
([ADR-REPO-VARIANT](../../../../drs/repository/repo-variants.md)). Edit a value and re-run the importer to apply it. The file is loaded by
`Get-Config -Config variants`, validated by the VariantsConfig type, and read only through the module's `Get-`, `Test-` and `Assert-`
commands.

## naming

The order of the segments in every generated Azure resource name: a preset, `standard` or `classic`, or an explicit list naming all eight
segments (env, slot, region, org, short_name, customer, role, type) exactly once
([ADR-AZ-NAMING](../../../../drs/azure/azure-naming-standard.md)). Changing it re-spells every resource name, so every typed name in each
template's configuration has to be edited to match; it is deliberately not a casual flip.

## git_workspace

How changes reach main. `main-direct` allows direct commits to main, the default for a single-author trunk. `main-via-pr` sends everything
through a pull request, so local work happens on a branch and the only forbidden direct commit is one made while standing on main.
Automation that commits, such as `Sync-GeneratedFile`, stops on exactly that condition. Moving from one author to several is the time to
flip it.

## have_customers

Which customers this repo deploys for ([ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md)): `false` for none, `all` for every
customer in `customer.yml`, or a list of names. `customer.yml` is the catalogue of who the customers are; this variant says which of them
the repo deploys. This repo ships customer templates, such as the per-customer foundation, so it enables all of them.

## aspects

Per-track conventions ([DDR-ASPECT](../../../../drs/design/module-aspects.md)): an ordered, first-match list whose last aspect is the `**`
catch-all. Whether the catch-all is live is the container's call. Automation is code, so its `live` aspect is closed and a stray file falls
to the `tests` catch-all and never ships. Infrastructure is a deployment, so everything under a template ships and `live` is the catch-all;
only an explicit `tests/` folder is not live. Patterns are relative to the unit root, and the ordering makes the aspects disjoint and
exhaustive.

## tracks

The repository's root concerns, the one declaration of what a track is ([DDR-TRACK](../../../../drs/design/tracks.md)), read through
`Get-Track`. Each entry declares its members, its type, and optionally its vendor, the file languages of its tech-stack
([DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)), its kinds, and its namespace settings.

- The repository's own pipeline definitions are live in the same way as the Bicep tree: a pipeline or workflow is what runs, and a test
  asset under `tests/` belongs to the tests aspect.
- The gitignored build outputs are members too, so a clean finds them in the model; each one's generated fact comes from its generator's
  target.
- `namespace_exempt` lists the files that name the product rather than a module folder, so they keep the namespace on disk: the loaders
  PowerShell names its modules after, and the types assembly's identity.

## comment:1

Above `naming: standard`, written with `#`.

```text
Flipping this re-spells every resource name, so every typed name in each template's configuration must be edited to match.
A preset (standard, classic) or an explicit list naming each segment once, e.g. [type, org, short_name, customer, env, region, slot, role].
```

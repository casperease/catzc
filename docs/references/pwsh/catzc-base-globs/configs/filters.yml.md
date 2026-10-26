# pwsh/Base.Globs/configs/filters.yml

The repository's filters: named views over the hard model, in lamp order. `Get-RepositoryFilter` resolves them into the include and exclude
sets each one claims files by, through the typed `FiltersConfig` record (`FiltersConfig.cs`).

## How a filter selects

A filter is the union of its selectors and may claim files another filter claims. The view is the union of the lit lamps
(DDR-FILTER-TOTALUNION), and every file on disk is claimed by at least one. The selectors are `aspect.<aspect>`, `track.<track>`,
`track_type.<type>` (the snake form of the type), `glob.<pattern>`, `generated` and `root_config`.

## Preview lamps

Preview lamps are declared and resolved like every other. The extension's preview flag keeps them out of the Explorer's title row until they
ship, and the extension asserts that only the shipped lamps reach the menu.

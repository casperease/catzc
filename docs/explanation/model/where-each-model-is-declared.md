# Where each model is declared: its config, its query, and the gate that keeps it true

```text
Each model is declared once, answered by one query, and kept true by one gate.

Supports ADR-AUTO-DEFAULT-ONERESOLUTIONORDER and ADR-REPO-FOLDERS-NAMESARESETTINGS (meta lens).
```

A model that lives in more than one place drifts, so each one is declared once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). The table
names, for each part of the [physical model](the-physical-model.md) and the [meta model](the-meta-model.md), the one config that declares
it, the query that answers it, and the gate that refuses a tree that disagrees with it.

| Model                  | Declared in                                                    | Query                                             | Gate                            |
| ---------------------- | -------------------------------------------------------------- | ------------------------------------------------- | ------------------------------- |
| Folder names           | `pwsh/Catzc.Base.Languages/configs/languages.yml` (layout)     | `LanguagesConfig.FolderOf`                        | `Test-FolderConventions`        |
| Tracks and places      | `pwsh/Catzc.Base.Variants/configs/variants.yml`                | `Get-Track`, `Get-TrackPlace`                     | `Test-TrackDeclaration`         |
| Track types            | `pwsh/Catzc.Base.Variants/configs/module-types.yml`            | `Get-Track`                                       | `Test-TrackDeclaration`         |
| File languages         | `pwsh/Catzc.Base.Languages/configs/languages.yml`              | `LanguagesConfig.PlaceOf`                         | the config's validation on read |
| The world map          | the tracks and the file languages above                        | `Get-WorldMap`                                    | `Test-WorldMap`                 |
| Aspects                | the layout rows of `languages.yml`                             | `Get-Aspect`                                      | `Test-AspectDeclaration`        |
| Link relations         | the links in the files, and the convention rows                | `Get-LinkEdge`                                    | `Test-LinkDirections`           |
| Modules                | the layout, by placement                                       | `Get-CatzcModule`, `Get-ModuleProfile`            | `Test-FolderConventions`        |
| Dependencies and order | `pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml`        | `Get-ModuleDependencyEdges`, `Get-ModuleOrder`    | `Test-FunctionDependency`       |
| Record domains         | `pwsh/Catzc.Base.Drs/configs/drs.yml` and the decision records | `Get-DrsDomainEdges`, `Get-DrsUsage`              | `Test-DrsRegistry`              |
| The glossary           | each module's `configs/glossary.yml`                           | `docs/drs/glossary.md`, built by `Build-Glossary` | `Test-Glossary`                 |

A folder name in this table is itself a setting with the conventional name as its default
([ADR-REPO-FOLDERS-NAMESARESETTINGS](../../drs/repository/conventional-folders.md#rule-adr-repo-folders-namesaresettings)), so the table
names the defaults; a repository that overrides one keeps the same model under its own name.

# pwsh/Base.Folders/configs/folder-walk.yml

The folder-walk config: the depth, the folders a walk never enters and whether searches skip the `.vendor` folder. `Get-ChildPath`,
`PathSet` and the generated-file writers' walk read it.

## Keys

Every key is optional: an omitted key takes the default declared once on `FolderWalkConfig`, and a `Get-ChildPath` parameter overrides it.

- **`prune_vendor_in_searches`** — when true, a search never enters the `.vendor` folder. Read anywhere as
  `global.folder-walk.prune_vendor_in_searches`.
- **`exclude`** — the folders a walk never enters. It replaces the type's default (`.git`, `node_modules`, `out`), never extends it, and a
  pruned name is skipped at every depth. The shipped list adds the tool caches a language leaves inside a module or a track
  (`.terraform`, `.ruff_cache`, `.venv`), which are never its files.

# pwsh/Base.Variants/types/ModulePlace.cs

A place under a root folder where modules of one type are found, and how a path in that place names its module.

## How a path names its module

- **folder** — the first folder under the root, never a dot-prefixed one, with the place's prefix put before its PascalCase name when there
  is one.
- **file** — a file of the place's extension directly under the root, named without the extension.
- **root** — the root folder itself, named by its last segment.

`TailOf` gives the `/`-separated path of a file under the module `NameOf` named for it; call it only for a path `NameOf` placed. A file
place's module is the file itself, so its tail is the file's own name.

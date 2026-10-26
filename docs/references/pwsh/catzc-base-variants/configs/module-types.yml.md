# pwsh/Base.Variants/configs/module-types.yml

The one definition of what a module is, by type: where modules of each type are placed, and how a path in a place names its module. It is
read as the ModuleTypesConfig type.

## Places

A place is a root folder and a rule for how a path under it names its module:

- **`folder`** — the first folder under the root, never a dot-prefixed one, with `prefix` put before its PascalCase name;
- **`file`** — a file of the extension directly under the root;
- **`root`** — the root folder itself.

Types are checked in the order written, and places in the order of their type; the first one to place a path names its module.

## Extending it

A consumer extends the file with a config fragment, which adds a type (checked after these) or replaces the places of one.

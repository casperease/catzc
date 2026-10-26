# pwsh/Base.Variants/types/ModuleTypesConfig.cs

The one definition of what a module is, by type: where modules of each type are placed in the repository, and how a file path names its
module. It is local to catzc and global to every file. A consumer extends it with a config fragment, which either adds a type (checked after
these) or replaces the places of one: a map merges key by key, a list replaces.

## Entries

Each type allows two keys, `definition` and `places`; any other key throws. Each place becomes a ModulePlace, which names the module a path
in it belongs to.

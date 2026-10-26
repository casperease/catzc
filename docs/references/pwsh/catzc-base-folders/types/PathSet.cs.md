# pwsh/Base.Folders/types/PathSet.cs

A set of file paths a type owns: files named under a base, and the files a pattern finds through the bounded walker. The paths are full,
sorted and unique, so the same tree always gives the same set.

## Adding by pattern

`AddPattern(folder, pattern, depth)` adds the files below a folder whose names match a pattern, to the depth given (1 is the folder itself),
with the config's folder names pruned. A folder that does not exist adds nothing, so a set over an optional tree stays valid before the tree
exists. The overload without a depth uses the config's depth.

## Pruned names

`Pruned` gives the folder names a walk skips: the config's `exclude` list, plus the `.vendor` folder when searches prune it.

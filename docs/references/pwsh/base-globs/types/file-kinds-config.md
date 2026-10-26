# pwsh/Base.Globs/types/FileKindsConfig.cs

The typed record for `file-kinds.yml`, the one definition of what a file is, by role.

## What it holds

Every kind has a one-sentence definition, the globs that select it, and optional subkinds that narrow it. The fallback kind is declared
here, once. The record is local to catzc and global to every file.

## Extension

A consumer extends it by a config fragment, which adds a kind or replaces the globs of one: a map merges key by key and a list replaces.

# pwsh/Base.Docs/types/DocMapping.cs

One explicit README copy-in entry from `configs/readme.yml`: an authored `source` docs file copied out to `<folder>/README.md`. Both are
repository-root-relative, '/'-separated communication-form paths ([ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)). It
mirrors a `readme.yml` mappings entry, snake_case keys.

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties and
its constructor uses the base's `Req` extraction helper.

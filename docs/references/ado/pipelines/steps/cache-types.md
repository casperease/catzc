# .ado/pipelines/steps/cache-types.yaml

The step template that restores the C# types build from the pipeline cache, so a job loads it instead of compiling it.

## Behaviour

- **Resolve** — it imports the types module and sets `CatzcTypesShadowRoot` from its one resolver, `Get-TypesShadowRoot`.
- **Cache** — a `Cache@2` task caches that folder under a key made of the agent OS, the C# files of the types (`pwsh/**/types/**/*.cs`) and the project
  they compile with (`pwsh/.internal/assets/Catzc.Types.csproj`).

The combined types build is a per-machine cache keyed by its inputs ([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](../../../../drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)),
so any change to those files or the project makes a new key.

# pwsh/Base.Languages/configs/bcl.yml

The BCL language's config: the one build configuration and platform of every non-vendored `.sln` and `.csproj`, and the host bindings.

## Keys

- **`host_bindings`** — the type sources that bind to a host, each with its reason. Every other type source stays in the BCL reference set.
- The build configuration and platform are omitted here, so the defaults declared on `BclConfig` apply.

## How it is read

`Get-Config -Config bcl` loads the file into the typed `Catzc.Base.Languages.BclConfig` record (`BclConfig.cs`).

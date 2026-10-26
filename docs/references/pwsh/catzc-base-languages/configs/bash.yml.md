# pwsh/Base.Languages/configs/bash.yml

The Bash test settings: the pin of the vendored bats-core runner that `Invoke-BashTest` runs. The Bash tests are black-box tests of the
engine, written in Bash under `<root>/tests/<module-in-kebab>/*.bats` and run by the runner vendored at `<root>/.vendor/bats-core/`
([ADR-AUTO-BASH](../../../../drs/automation/bash/bash-test-artifacts.md)).

## Keys

- **`bats_version`** — the vendored bats-core release.
- **`bats_sha256`** — the SHA-256 of that release's source archive (github.com/bats-core/bats-core, tag `v<version>`). The vendored copy is
  reproducible from the two with `Update-BatsVendor`.
- **`root`** — the Bash root folder, repository-relative. It is not declared here, so it takes the default every test language's root takes:
  `bash` when the repository has a `bash/` folder (a Bash root track), else `.bash`, the dot-prefixed tooling folder.

## How it is read

`Get-Config -Config bash` loads the file into the typed `Catzc.Base.Languages.BashConfig` record, which validates the shape
(`BashConfig.cs`).

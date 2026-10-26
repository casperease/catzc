# .github/workflows/ci-pwsh.yml

The GitHub CI workflow of the module system. It runs the tests on Ubuntu, Windows and macOS, builds the full bundle on each of those and
compares the three content hashes.

## Triggers

- **Push to `main` and pull requests** — the `pwsh` globset projected into GitHub-native path filters (`Get-GlobSetTrigger`,
  [FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)). The track is its own root folder (`pwsh/**`), so the workflow fires exactly, and
  only, on a real change to the module system, with no committed marker to go stale across a squash merge. The negated paths drop files that
  are not module code.
- **`workflow_dispatch`** — an on-demand run. The push and pull request triggers fire only on `pwsh/**` changes, so a fix to the workflow
  itself, or to the tool pins it depends on, could not be validated without a manual run.

## Jobs

- **test** — on each OS: pins Node to 24, installs `cspell` and `markdownlint-cli2` with `Install-Cspell` and `Install-Markdownlint` so the
  L2 repository spelling and markdown integrity tests run instead of skipping themselves, then runs `Test-Automation -Level 2`. The Node pin
  matches the major `tools.yml` expects (`Assert-Tool node_js` enforces it before the npm installs); GitHub is migrating the runners'
  default Node from 20 to 24, and without the pin the version check fails intermittently depending on the runner image. Timings are reported
  in the run's summary but not enforced here, since hard per-test wall-clock limits flake on shared runners that vary two to five times in
  speed and run cold.
- **bundle-hash** — on each OS: checks out with `fetch-depth: 0`, because the calculated version counts first-parent commits, builds the
  full bundle with `Build-Modules -Bundle full`, and uploads the version and content hash as an artifact.
- **bundle-hash-compare** — downloads the three records and fails unless there are three and all hashes are equal. The same commit builds
  the same bundle on every OS
  ([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)). A Windows runner
  checks out with `core.autocrlf=true` and the others with LF, so equal hashes prove that the build ships the bytes git stores, not the
  bytes a checkout wrote.

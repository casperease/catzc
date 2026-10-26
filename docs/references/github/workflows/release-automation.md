# .github/workflows/release-automation.yml

The release workflow of the platform bundle. A release is a deliberate act, so the workflow runs on `workflow_dispatch` and nothing else:
the trigger is intentionally not wired to a push, a tag or a globset. See [ADR-GH-RELEASE](../../../drs/github/github-release.md).

## Inputs

Each publish step is opt-in through a boolean input, and a run with the publish inputs off still produces the package.

- **`github_release`** — attaches the `.nupkg` to a GitHub Release with `gh` and the built-in `GITHUB_TOKEN`. On by default.
- **`github_packages`** — pushes the package to GitHub Packages with `dotnet nuget push` and the built-in `GITHUB_TOKEN`. Off by default.
- **`psgallery`** — publishes to the PowerShell Gallery. Off by default; it needs the `PSGALLERY_API_KEY` secret and is skipped with a
  warning when the secret is empty.

## What every run does

1. **Builds** the NuGet package and the PSGallery module manifest with `Export-Catzc -To nuget`, and keeps the package path, version and
   module folder in the environment.
2. **Freezes the contracts** for that version under `contracts/catzc/<version>/`: the draft must hold, its copy becomes the released
   version folder with a `.frozen` record, and that folder must hold too
   ([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)).
3. **Commits the frozen folder to the trunk** and pushes it. The token needs bypass rights on the branch rule, and the workflow has
   `contents: write` for this push and for `gh release create`.
4. **Uploads the package** as an artifact, always, even when nothing is published. The path is the one `Export-Catzc` returned, so the
   workflow never restates where the package lands.
5. **Publishes** to each target whose input is on.

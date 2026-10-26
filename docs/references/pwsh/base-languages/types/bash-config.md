# pwsh/Base.Languages/types/BashConfig.cs

The typed record for `bash.yml`, the Bash test settings, and the single declaration of their sensible defaults. `Invoke-BashTest` runs the
`.bats` tests in `<root>/tests/<folder>/` with the bats-core runner vendored at `<root>/.vendor/bats-core/`, and `Update-BatsVendor`
refreshes that copy from the pinned release. It is registered in `Catzc.Base.Config/configs/configs.yml` (type
`Catzc.Base.Languages.BashConfig`), so `Get-Config -Config bash` returns it. Its property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- only the known keys, `root`, `bats_version` and `bats_sha256`, are allowed, so a typo fails at load;
- `root` is the Bash root folder, repository-relative: slash-separated segments of letters, digits, `.`, `_` and `-`, no leading or trailing
  slash, no `.` or `..` segment. Omitted, it resolves per repository: `bash` when the repository has a `bash/` folder, else `.bash`, the one
  convention every test language's root follows
  ([ADR-REPO-FOLDERS-NAMESARESETTINGS](../../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-namesaresettings));
- `bats_version` is the vendored bats-core release (X.Y.Z) and `bats_sha256` the SHA-256 of its source archive, both required, so the
  vendored copy is reproducible from them.

## ResolveRoot

`ResolveRoot(repositoryRoot)` returns the Bash root folder for a repository, repository-relative: the declared root, else `bash` when the
repository has a `bash/` folder, else `.bash`.

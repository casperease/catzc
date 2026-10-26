# pwsh/Base.Languages/types/PythonConfig.cs

The typed record for `python.yml`, the Python test-workspace settings, and the single declaration of their sensible defaults.
`New-PythonProject` renders the generated uv workspace from it, the workspace root `<root>/pyproject.toml` and one member
`<root>/tests/<folder>/pyproject.toml` per Python test folder, and `Invoke-PythonTest` runs the tests in `<root>/tests/<folder>/` inside the
workspace's one environment. It is registered in `Catzc.Base.Config/configs/configs.yml` (type `Catzc.Base.Languages.PythonConfig`), so
`Get-Config -Config python` returns it. Its property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
Python version is not a setting here: it is the python tool's pin in `tools.yml`, the one Python version.

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- only the known keys, `root` and `dependencies`, are allowed, so a typo fails at load;
- `root` is the Python root folder, repository-relative: slash-separated segments of letters, digits, `.`, `_` and `-`, no leading or
  trailing slash, no `.` or `..` segment. Omitted, it resolves per repository: `python` when the repository has a `python/` folder (a Python
  root track), else `.python`, the dot-prefixed tooling folder, the one convention every test language's root follows
  ([ADR-REPO-FOLDERS-NAMESARESETTINGS](../../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-namesaresettings));
- `dependencies` maps a normalised distribution name (lowercase letters, digits, `-`, `_`, `.`) to an exact version (digits and dots), kept
  in ordinal name order so a rendering never depends on the file's key order;
- the tools the bridge runs are required: `pytest` (the test runner) and `ruff` (the formatter and linter).

## Properties and defaults

- **`root`** — the declared Python root folder, repository-relative (`/`-separated). Null when the file declares none; `ResolveRoot` then
  applies the default.
- **`ResolveRoot(repositoryRoot)`** — the Python root folder for a repository: the declared root, else `python` when the repository has a
  `python/` folder, else `.python`.
- **`DefaultEditableMode`** — how the backend installs a package member for editing. `strict` links it into a tree a static `.pth` names,
  which pyright reads; the backend's own default hooks the import system at run time, which only Python follows.
- **`DefaultPackageData`** — a package's data is what its conventional folders hold, so a strict install links what the code reads beside
  itself. It is never a catch-all, which would take in the `build/` link tree the install writes under the package.

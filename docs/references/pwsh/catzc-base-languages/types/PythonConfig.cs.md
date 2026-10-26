# pwsh/Base.Languages/types/PythonConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Python test-workspace settings (configs/python.yml), and the single declaration of their sensible defaults.
New-PythonProject renders the generated uv workspace from it — the workspace root <root>/pyproject.toml and one member
<root>/tests/<folder>/pyproject.toml per Python test folder — and Invoke-PythonTest runs the tests in
<root>/tests/<folder>/ inside the workspace's one environment. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.Languages.PythonConfig), so Get-Config -Config python returns this typed record. Property names
mirror the YAML keys (snake_case, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
The Python version is not a setting here: it is the python tool's pin in tools.yml, the one Python version.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the known keys ('root', 'dependencies') — an unknown key (a typo) fails at load;
  - 'root' is the Python root folder, repository-relative: slash-separated segments of letters, digits, '.', '_' and
    '-', no leading or trailing slash, no '.' or '..' segment. Omitted, it resolves per repository (ResolveRoot):
    'python' when the repository has a python/ folder (a Python root track), else '.python', the dot-prefixed tooling
    folder — the one convention every test language's root follows
    ([ADR-REPO-FOLDERS-NAMESARESETTINGS](/docs/drs/repository/conventional-folders.md#rule-adr-repo-folders-namesaresettings));
  - 'dependencies' maps a normalised distribution name (lowercase letters, digits, '-', '_', '.') to an exact
    version (digits and dots), kept in ordinal name order so a rendering never depends on the file's key order;
  - the tools the bridge runs are required: 'pytest' (the test runner) and 'ruff' (the formatter and linter).
```

## comment:2

Above `public string root { get; }`, written with `//`.

```text
The declared Python root folder, repository-relative ('/'-separated). Null when the file declares none;
ResolveRoot then applies the default.
```

## comment:3

Above `public string ResolveRoot(string repositoryRoot)`, written with `//`.

```text
The Python root folder for a repository, repository-relative: the declared root, else 'python' when the repository
has a python/ folder, else '.python'.
```

## comment:4

Above `public const string DefaultEditableMode = "strict";`, written with `//`.

```text
How the backend installs a member for editing: strict builds a link tree a static .pth names, which pyright reads; the backend's
own default hooks the import system at run time, which only Python follows.
```

## comment:5

Above `public const string DefaultEditableMode = "strict";`, written with `//`.

```text
How the backend installs a package member for editing: strict links it into a tree a static .pth names, which pyright reads; the
backend's own default hooks the import system at run time, which only Python follows.
```

## comment:6

Above `public static readonly string[] DefaultPackageData = { "configs/**/*",...`, written with `//`.

```text
A package's data is what its conventional folders hold, so a strict install links what the code reads beside itself; never a
catch-all, which would take in the build/ link tree the install writes under the package.
```

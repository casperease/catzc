# docs/references/automation/catzc-base-languages/types/BashConfig.cs.md

`automation/Catzc.Base.Languages/types/BashConfig.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The Bash test settings (configs/bash.yml), and the single declaration of their sensible defaults. Invoke-BashTest runs
the .bats tests in <root>/tests/<folder>/ with the bats-core runner vendored at <root>/.vendor/bats-core/, and
Update-BatsVendor refreshes that copy from the pinned release. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.Languages.BashConfig), so Get-Config -Config bash returns this typed record. Property names mirror
the YAML keys (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the known keys ('root', 'bats_version', 'bats_sha256') — an unknown key (a typo) fails at load;
  - 'root' is the Bash root folder, repository-relative: slash-separated segments of letters, digits, '.', '_' and
    '-', no leading or trailing slash, no '.' or '..' segment. Omitted, it resolves per repository (ResolveRoot):
    'bash' when the repository has a bash/ folder, else '.bash' — the one convention every test language's root
    follows ([ADR-REPO-FOLDERS#7](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders7));
  - 'bats_version' is the vendored bats-core release (X.Y.Z), and 'bats_sha256' the SHA-256 of its source archive,
    both required: the vendored copy is reproducible from them.
```

## comment:2

Above `public string ResolveRoot(string repositoryRoot)`.

```text
The Bash root folder for a repository, repository-relative: the declared root, else 'bash' when the repository has a
bash/ folder, else '.bash'.
```

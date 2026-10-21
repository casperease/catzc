/*
---
catzc:
  immutable:
    with_body_sha: e11eef3e4d2f
  edges:
    test: pwsh/Catzc.Base.Languages/tests/types/GoWorkspaceFile.Tests.ps1
    docs: "[GoWorkspaceFile.cs.md](docs/references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-ROOTCFG
---
*/

using System;

namespace Catzc.Base.Languages;

public sealed class GoWorkspaceFile
{
    // The repository-relative, forward-slashed path of the file (go.work, go/tests/<folder>/go.mod).
    public string Target { get; }

    // The rendered content: LF line endings and one trailing newline.
    public string Content { get; }

    public GoWorkspaceFile(string target, string content)
    {
        if (string.IsNullOrWhiteSpace(target) || target.IndexOf('\\') >= 0 || target.StartsWith("/", StringComparison.Ordinal))
        {
            throw new ArgumentException("GoWorkspaceFile: Target must be a repository-relative, forward-slashed path, got '" + target + "'");
        }
        if (content == null || content.IndexOf('\r') >= 0 || !content.EndsWith("\n", StringComparison.Ordinal))
        {
            throw new ArgumentException("GoWorkspaceFile: Content for '" + target + "' must use LF line endings and end with one newline");
        }

        Target = target;
        Content = content;
    }

    public override string ToString()
    {
        return Target;
    }
}

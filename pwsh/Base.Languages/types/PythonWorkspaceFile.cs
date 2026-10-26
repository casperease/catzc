/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Base.Languages;

public sealed class PythonWorkspaceFile
{
    // The repository-relative, forward-slashed path of the file (python/pyproject.toml, python/tests/<folder>/pyproject.toml).
    public string Target { get; }

    // The rendered content: LF line endings and one trailing newline.
    public string Content { get; }

    public PythonWorkspaceFile(string target, string content)
    {
        if (string.IsNullOrWhiteSpace(target) || target.IndexOf('\\') >= 0 || target.StartsWith("/", StringComparison.Ordinal))
        {
            throw new ArgumentException("PythonWorkspaceFile: Target must be a repository-relative, forward-slashed path, got '" + target + "'");
        }
        if (content == null || content.IndexOf('\r') >= 0 || !content.EndsWith("\n", StringComparison.Ordinal))
        {
            throw new ArgumentException("PythonWorkspaceFile: Content for '" + target + "' must use LF line endings and end with one newline");
        }

        Target = target;
        Content = content;
    }

    public override string ToString()
    {
        return Target;
    }
}

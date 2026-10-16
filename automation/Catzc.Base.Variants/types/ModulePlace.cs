/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/ModulePlace.cs
    folder: types
    name: module-place
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-variants/types/ModulePlace.cs.md
    adrs:
      - ADR-DSGN-TRACK#3
---
*/

using System;
using System.Linq;

namespace Catzc.Base.Variants;

public sealed class ModulePlace
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string root { get; }
    public string name { get; }
    public string extension { get; }
    public string prefix { get; }

    public ModulePlace(string root, string name, string extension, string prefix)
    {
        this.root = root;
        this.name = name;
        this.extension = extension;
        this.prefix = prefix;
    }

    // The module name this place gives a '/'-separated repository-relative path, or null when the path is not in the place.
    public string NameOf(string path)
    {
        if (name == "root")
        {
            if (path != root && !path.StartsWith(root + "/", StringComparison.Ordinal)) { return null; }
            int slash = root.LastIndexOf('/');
            return slash < 0 ? root : root.Substring(slash + 1);
        }
        if (!path.StartsWith(root + "/", StringComparison.Ordinal)) { return null; }
        string rest = path.Substring(root.Length + 1);
        if (name == "file")
        {
            string suffix = "." + extension;
            if (rest.Contains('/') || !rest.EndsWith(suffix, StringComparison.Ordinal) || rest.Length == suffix.Length) { return null; }
            return rest.Substring(0, rest.Length - suffix.Length);
        }
        int firstSlash = rest.IndexOf('/');
        if (firstSlash <= 0) { return null; }
        string folder = rest.Substring(0, firstSlash);
        if (folder.StartsWith(".", StringComparison.Ordinal)) { return null; }
        return string.IsNullOrEmpty(prefix) ? folder : prefix + Pascal(folder);
    }

    // The '/'-separated path of the file under the module NameOf names for it; call it only for a path NameOf placed. A file place's
    // module is the file itself, so its tail is the file's name.
    public string TailOf(string path)
    {
        if (name == "root")
        {
            return path == root ? "" : path.Substring(root.Length + 1);
        }
        string rest = path.Substring(root.Length + 1);
        if (name == "file") { return rest; }
        return rest.Substring(rest.IndexOf('/') + 1);
    }

    static string Pascal(string folder) =>
        string.Concat(folder.Split('-').Where(part => part.Length > 0).Select(part => char.ToUpperInvariant(part[0]) + part.Substring(1)));
}

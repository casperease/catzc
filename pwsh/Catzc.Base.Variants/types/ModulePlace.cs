/*
---
catzc:
  immutable:
    with_body_sha: d96e59f9a644
  edges:
    docs: "[ModulePlace.cs.md](docs/references/pwsh/catzc-base-variants/types/ModulePlace.cs.md)"
    cites:
      - DDR-TRACK-ONETECHSTACK
---
*/

using System;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.Variants;

// Rests on [DDR-TRACK-ONETECHSTACK](/docs/adr/design/tracks.md#rule-ddr-track-onetechstack).
public sealed class ModulePlace
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A place is public unless its entry declares it internal.
    public const bool DefaultInternal = false;

    public string root { get; }
    public string name { get; }
    public string extension { get; }
    public string prefix { get; }
    public bool @internal { get; }

    // The folders directly under a folder place's root that are the track's own and never a module, such as its test holder.
    public IReadOnlyList<string> except { get; }

    public ModulePlace(string root, string name, string extension, string prefix, bool @internal, IReadOnlyList<string> except)
    {
        this.root = root;
        this.name = name;
        this.extension = extension;
        this.prefix = prefix;
        this.@internal = @internal;
        this.except = except ?? Array.Empty<string>();
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
        if (folder.StartsWith(".", StringComparison.Ordinal) || except.Contains(folder)) { return null; }
        return string.IsNullOrEmpty(prefix) ? folder : prefix + Pascal(folder);
    }

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

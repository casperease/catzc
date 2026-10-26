/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Variants;

public sealed class VariantTrack
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The track's name: its key in the `tracks` map (e.g. pwsh).
    public string name { get; }

    // The track's members, each a folder or a file with its generated and committed facts; the one declaration of what the track holds.
    public IReadOnlyList<VariantMember> members { get; }

    // The members' paths (e.g. pwsh, .github/workflows), computed for the callers that need only paths; never declared beside the members.
    public IReadOnlyList<string> places { get; }

    // The track's type: the id of a track type of the track-types registry ([DDR-TRACKTYPE-CLOSEDSETOFTYPES](/docs/drs/design/track-types.md#rule-ddr-tracktype-closedsetoftypes)).
    public string type { get; }

    // The vendor that reads the track's files, or null when the track has none.
    public string vendor { get; }

    public IReadOnlyList<string> languages { get; }

    // The execution engines the track's modules run under, a subset of the closed set; empty when the track leaves the choice open as auto.
    public IReadOnlyList<string> execution_engines { get; }

    // The modules whose engines differ from the track's: module name -> the engines it names. Empty when none differs.
    public IReadOnlyDictionary<string, IReadOnlyList<string>> module_execution_engines { get; }

    public IReadOnlyDictionary<string, string> kinds { get; }

    public VariantTrack(string name, VariantMember[] members, string type, string vendor, string[] languages, string[] executionEngines = null,
        IDictionary<string, string[]> moduleExecutionEngines = null, IDictionary<string, string> kinds = null)
    {
        this.kinds = kinds == null
            ? new Dictionary<string, string>(StringComparer.Ordinal)
            : new Dictionary<string, string>(kinds, StringComparer.Ordinal);
        this.execution_engines = executionEngines == null ? Array.Empty<string>() : (string[])executionEngines.Clone();
        Dictionary<string, IReadOnlyList<string>> overrides = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal);
        if (moduleExecutionEngines != null)
        {
            foreach (KeyValuePair<string, string[]> pair in moduleExecutionEngines) { overrides[pair.Key] = (string[])pair.Value.Clone(); }
        }
        this.module_execution_engines = overrides;
        this.name = name;
        VariantMember[] declared = members == null ? Array.Empty<VariantMember>() : (VariantMember[])members.Clone();
        this.members = declared;
        string[] paths = new string[declared.Length];
        for (int i = 0; i < declared.Length; i++) { paths[i] = declared[i].path; }
        this.places = paths;
        this.type = type;
        this.vendor = string.IsNullOrEmpty(vendor) ? null : vendor;
        this.languages = languages == null ? Array.Empty<string>() : (string[])languages.Clone();
    }

    // The engines a module of this track runs under: its own override when it names one, else the track's list (empty: auto).
    public IReadOnlyList<string> EnginesOf(string module)
    {
        IReadOnlyList<string> own;
        return module != null && module_execution_engines.TryGetValue(module, out own) ? own : execution_engines;
    }

    // The place pattern of a named kind, or null when the track does not name it.
    public string KindPlace(string kind)
    {
        string pattern;
        return kind != null && kinds.TryGetValue(kind, out pattern) ? pattern : null;
    }

    // The member whose place is the longest that contains a '/'-separated repository-relative path, or null when none does.
    public VariantMember MemberOf(string path)
    {
        VariantMember best = null;
        foreach (VariantMember member in members)
        {
            bool contains = path == member.path || path.StartsWith(member.path + "/", StringComparison.Ordinal);
            if (contains && (best == null || member.path.Length > best.path.Length)) { best = member; }
        }
        return best;
    }

    // The length of the longest place that contains a '/'-separated repository-relative path, or -1 when none does.
    public int PlaceLengthOf(string path)
    {
        int best = -1;
        foreach (string place in places)
        {
            bool contains = path == place || path.StartsWith(place + "/", StringComparison.Ordinal);
            if (contains && place.Length > best) { best = place.Length; }
        }
        return best;
    }
}

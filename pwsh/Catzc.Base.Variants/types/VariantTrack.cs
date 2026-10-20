/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/types/VariantTrack.cs
    folder: types
    name: variant-track
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[VariantTrack.cs.md](docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md)"
    cites:
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
      - ADR-DSGN-TRACK
      - ADR-DSGN-TRACKTYPE-CLOSEDSETOFTYPES
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

    // The places the track covers: repository-relative paths with '/' separators (e.g. pwsh, .github/workflows).
    public IReadOnlyList<string> places { get; }

    // The track's type: the id of a track type of the track-types registry ([ADR-DSGN-TRACKTYPE-CLOSEDSETOFTYPES](/docs/adr/design/track-types.md#rule-adr-dsgn-tracktype-closedsetoftypes)).
    public string type { get; }

    // The vendor that reads the track's files, or null when the track has none.
    public string vendor { get; }

    public IReadOnlyList<string> languages { get; }

    // The execution engines the track's modules run under, a subset of the closed set; empty when the track leaves the choice open as auto.
    public IReadOnlyList<string> execution_engines { get; }

    // The modules whose engines differ from the track's: module name -> the engines it names. Empty when none differs.
    public IReadOnlyDictionary<string, IReadOnlyList<string>> module_execution_engines { get; }

    public IReadOnlyDictionary<string, string> kinds { get; }

    public VariantTrack(string name, string[] places, string type, string vendor, string[] languages, string[] executionEngines = null,
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
        this.places = places == null ? Array.Empty<string>() : (string[])places.Clone();
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

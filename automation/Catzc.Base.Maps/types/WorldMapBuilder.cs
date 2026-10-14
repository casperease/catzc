// Builds the world map from plain inputs, so a logic test needs no disk: the tracks (variants.yml), the file languages
// (languages.yml), the tracked paths (the git index), the aspects per track (the live classification), the adrs index
// (ADR code -> domain), the text of the files that cite, the repository-root files' owners (files.yml: root file ->
// the owning module's folder), and the globsets (globs.yml). Get-WorldMap gathers them from the repository.
//
// Placement is exact: the root folder gives the track and the extension gives the file language
// ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
// [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). A file under no track goes to the NoTrack row
// and a file no file language names goes to the NoFileLanguage column, so every file has exactly one cell.
//
// The stack check ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)) reads the live aspect only. A
// file is live unless it is in a verification track, under a .vendor/ folder, or outside its track's live aspect. A
// track with an aspects entry classifies by it: the unit is the track root's first folder, a file directly under the
// root is its own unit, and the first aspect whose pattern matches the unit-relative path wins. A track without an
// entry is live throughout. A live file with an extension whose file language the track does not declare is a stack
// violation; a file without an extension is never one.
//
// The highlight relation follows a fixed order per artifact kind:
//   1. an ADR file (a .md under docs/adr/<domain>/) carries its domain;
//   2. a file under no track carries the citations of the files in its owner's folder (files.yml), else its own;
//   3. a file of the pipelines track carries its own citations, else those of the files of the globset whose
//      pipeline key names it;
//   4. every other file (module code included) carries its own citations.
// The registry types are named in full, so the module dependency gate sees each cross-module edge
// ([ADR-AUTO-TYPES#4](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types4)).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Management.Automation;

namespace Catzc.Base.Maps;

public static class WorldMapBuilder
{
    // The folder whose markdown files are ADRs: docs/adr/<domain>/...
    public const string AdrRoot = "docs/adr/";

    // The track whose files fall back to their globset's citations.
    public const string PipelinesTrack = "pipelines";

    public static WorldMap Build(IEnumerable tracks, IEnumerable fileLanguages, IEnumerable paths, IDictionary aspects, IDictionary adrIndex,
        IDictionary texts, IDictionary rootOwners, IEnumerable globSets)
    {
        List<Catzc.Base.Variants.VariantTrack> trackList = Items<Catzc.Base.Variants.VariantTrack>(tracks, "track");
        List<Catzc.Base.Languages.FileLanguage> languageList = Items<Catzc.Base.Languages.FileLanguage>(fileLanguages, "file language");
        List<Catzc.Base.Globs.GlobSet> globSetList = Items<Catzc.Base.Globs.GlobSet>(globSets, "globset");
        IReadOnlyDictionary<string, string> index = CitationScanner.Index(adrIndex);

        Dictionary<string, Catzc.Base.Variants.VariantTrack> trackByRoot =
            new Dictionary<string, Catzc.Base.Variants.VariantTrack>(StringComparer.Ordinal);
        List<string> trackNames = new List<string>();
        foreach (Catzc.Base.Variants.VariantTrack track in trackList)
        {
            trackByRoot[track.root] = track;
            trackNames.Add(track.name);
        }

        Dictionary<string, string> languageByExtension = new Dictionary<string, string>(StringComparer.Ordinal);
        List<string> languageNames = new List<string>();
        foreach (Catzc.Base.Languages.FileLanguage language in languageList)
        {
            languageNames.Add(language.name);
            foreach (string extension in language.extensions) { languageByExtension[extension.ToLowerInvariant()] = language.name; }
        }

        HashSet<string> domains = new HashSet<string>(index.Values, StringComparer.Ordinal);
        Dictionary<string, List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>>> aspectsByTrack = CompileAspects(aspects);
        Dictionary<string, string> ownerByRootFile = Strings(rootOwners);
        Dictionary<string, string> textByPath = Strings(texts);

        List<string> pathList = new List<string>();
        foreach (object item in paths ?? Array.Empty<string>())
        {
            string path = Convert.ToString(Unwrap(item), CultureInfo.InvariantCulture);
            if (!string.IsNullOrEmpty(path)) { pathList.Add(path.Replace('\\', '/')); }
        }

        Dictionary<string, string[]> ownCitations = new Dictionary<string, string[]>(StringComparer.Ordinal);
        foreach (string path in pathList)
        {
            string text;
            ownCitations[path] = CitationScanner.Cites(path) && textByPath.TryGetValue(path, out text)
                ? CitationScanner.Scan(text, index)
                : Array.Empty<string>();
        }

        List<MapPlacement> placements = new List<MapPlacement>();
        foreach (string path in pathList)
        {
            int slash = path.IndexOf('/');
            Catzc.Base.Variants.VariantTrack track = null;
            if (slash > 0) { trackByRoot.TryGetValue(path.Substring(0, slash), out track); }

            string extension = Catzc.Base.Languages.LanguagesConfig.ExtensionOf(path);
            string fileLanguage;
            if (extension == null || !languageByExtension.TryGetValue(extension, out fileLanguage)) { fileLanguage = WorldMap.NoFileLanguage; }

            bool live = track != null && IsLive(path, track, aspectsByTrack);
            bool violation = live && extension != null && !Declares(track, fileLanguage);

            string domain = AdrDomain(path, extension, domains);
            Catzc.Base.Globs.GlobSet pipelineSet = track != null && string.Equals(track.name, PipelinesTrack, StringComparison.Ordinal) &&
                ownCitations[path].Length == 0 ? PipelineSet(path, globSetList) : null;
            string basis;
            string[] citations;
            if (domain != null)
            {
                basis = MapPlacement.BasisAdrFile;
                citations = Array.Empty<string>();
            }
            else if (track == null && ownerByRootFile.ContainsKey(path))
            {
                basis = MapPlacement.BasisFilesYml;
                string prefix = ownerByRootFile[path].TrimEnd('/') + "/";
                citations = Union(pathList, ownCitations, p => p.StartsWith(prefix, StringComparison.Ordinal));
            }
            else if (pipelineSet != null)
            {
                basis = MapPlacement.BasisGlobSet;
                citations = Union(pathList, ownCitations, pipelineSet.Matches);
            }
            else
            {
                citations = ownCitations[path];
                basis = citations.Length > 0 ? MapPlacement.BasisCitations : MapPlacement.BasisNone;
            }

            placements.Add(new MapPlacement(path, track == null ? WorldMap.NoTrack : track.name, fileLanguage, live, violation, basis, domain,
                citations));
        }

        return new WorldMap(trackNames.ToArray(), languageNames.ToArray(), placements.ToArray(), index);
    }

    // Is a file of a track in the track's live aspect?
    private static bool IsLive(string path, Catzc.Base.Variants.VariantTrack track,
        Dictionary<string, List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>>> aspectsByTrack)
    {
        if (string.Equals(track.@class, "verification", StringComparison.Ordinal)) { return false; }
        string relative = path.Substring(track.root.Length + 1);
        if (relative.StartsWith(".vendor/", StringComparison.Ordinal) || relative.Contains("/.vendor/")) { return false; }
        List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>> trackAspects;
        if (!aspectsByTrack.TryGetValue(track.name, out trackAspects)) { return true; }
        int slash = relative.IndexOf('/');
        string unitRelative = slash < 0 ? relative : relative.Substring(slash + 1);
        foreach (KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]> aspect in trackAspects)
        {
            foreach (Catzc.Base.Globs.GlobPattern pattern in aspect.Value)
            {
                if (pattern.Matches(unitRelative)) { return string.Equals(aspect.Key, "live", StringComparison.Ordinal); }
            }
        }
        return false;
    }

    private static bool Declares(Catzc.Base.Variants.VariantTrack track, string fileLanguage)
    {
        foreach (string declared in track.languages)
        {
            if (string.Equals(declared, fileLanguage, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    // The domain of an ADR file: a .md under docs/adr/<domain>/ whose folder is a domain the index knows; else null.
    private static string AdrDomain(string path, string extension, HashSet<string> domains)
    {
        if (!string.Equals(extension, ".md", StringComparison.Ordinal) || !path.StartsWith(AdrRoot, StringComparison.Ordinal)) { return null; }
        string rest = path.Substring(AdrRoot.Length);
        int slash = rest.IndexOf('/');
        if (slash <= 0) { return null; }
        string folder = rest.Substring(0, slash);
        return domains.Contains(folder) ? folder : null;
    }

    // The globset whose pipeline key is the pipeline file's name without its extension, or null.
    private static Catzc.Base.Globs.GlobSet PipelineSet(string path, List<Catzc.Base.Globs.GlobSet> globSets)
    {
        string fileName = path.Substring(path.LastIndexOf('/') + 1);
        int dot = fileName.LastIndexOf('.');
        string pipeline = dot > 0 ? fileName.Substring(0, dot) : fileName;
        foreach (Catzc.Base.Globs.GlobSet set in globSets)
        {
            if (string.Equals(set.Pipeline, pipeline, StringComparison.Ordinal)) { return set; }
        }
        return null;
    }

    private static string[] Union(List<string> paths, Dictionary<string, string[]> ownCitations, Func<string, bool> member)
    {
        SortedSet<string> union = new SortedSet<string>(StringComparer.Ordinal);
        foreach (string path in paths)
        {
            if (member(path)) { union.UnionWith(ownCitations[path]); }
        }
        string[] result = new string[union.Count];
        union.CopyTo(result);
        return result;
    }

    private static Dictionary<string, List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>>> CompileAspects(IDictionary aspects)
    {
        Dictionary<string, List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>>> compiled =
            new Dictionary<string, List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>>>(StringComparer.Ordinal);
        if (aspects == null) { return compiled; }
        foreach (DictionaryEntry entry in aspects)
        {
            string trackName = Convert.ToString(Unwrap(entry.Key), CultureInfo.InvariantCulture);
            List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>> list = new List<KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>>();
            foreach (Catzc.Base.Variants.VariantAspect aspect in
                Items<Catzc.Base.Variants.VariantAspect>(Unwrap(entry.Value) as IEnumerable, "aspect of track " + trackName))
            {
                List<Catzc.Base.Globs.GlobPattern> patterns = new List<Catzc.Base.Globs.GlobPattern>();
                foreach (string pattern in aspect.Patterns ?? Array.Empty<string>()) { patterns.Add(new Catzc.Base.Globs.GlobPattern(pattern)); }
                list.Add(new KeyValuePair<string, Catzc.Base.Globs.GlobPattern[]>(aspect.Name, patterns.ToArray()));
            }
            compiled[trackName] = list;
        }
        return compiled;
    }

    private static Dictionary<string, string> Strings(IDictionary raw)
    {
        Dictionary<string, string> map = new Dictionary<string, string>(StringComparer.Ordinal);
        if (raw == null) { return map; }
        foreach (DictionaryEntry entry in raw)
        {
            string key = Convert.ToString(Unwrap(entry.Key), CultureInfo.InvariantCulture);
            object value = Unwrap(entry.Value);
            if (!string.IsNullOrEmpty(key) && value != null) { map[key.Replace('\\', '/')] = Convert.ToString(value, CultureInfo.InvariantCulture); }
        }
        return map;
    }

    private static List<T> Items<T>(IEnumerable raw, string what) where T : class
    {
        List<T> items = new List<T>();
        if (raw == null || raw is string) { return items; }
        foreach (object item in raw)
        {
            T typed = Unwrap(item) as T;
            if (typed == null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "world map: a {0} is not a {1}", what, typeof(T).FullName));
            }
            items.Add(typed);
        }
        return items;
    }

    private static object Unwrap(object value) => value is PSObject wrapped ? wrapped.BaseObject : value;
}

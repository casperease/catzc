/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
    folder: types
    name: world-map-builder
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
    test: automation/Catzc.Base.Maps/tests/types/WorldMapBuilder.Tests.ps1
    cites:
      - ADR-AUTO-TYPES#4
      - ADR-DSGN-TRACK#{1,3,6}
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Management.Automation;

namespace Catzc.Base.Maps;

public static class WorldMapBuilder
{
    // The track whose files fall back to their globset's citations.
    public const string PipelinesTrack = "pipelines";

    public static WorldMap Build(IEnumerable tracks, IEnumerable fileLanguages, IEnumerable paths, IDictionary aspects, IDictionary adrIndex,
        IDictionary adrFiles, IDictionary texts, IDictionary rootOwners, IEnumerable globSets, IEnumerable citationExclude = null)
    {
        List<Catzc.Base.Globs.GlobPattern> excluded = new List<Catzc.Base.Globs.GlobPattern>();
        foreach (object glob in citationExclude ?? Array.Empty<object>())
        {
            string pattern = Convert.ToString(Unwrap(glob), CultureInfo.InvariantCulture);
            if (!string.IsNullOrEmpty(pattern)) { excluded.Add(new Catzc.Base.Globs.GlobPattern(pattern)); }
        }
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

        // The ADR code of each ADR file; a file two codes name keeps the first in ordinal code order.
        Dictionary<string, string> adrByPath = new Dictionary<string, string>(StringComparer.Ordinal);
        List<string> codes = new List<string>(Strings(adrFiles).Keys);
        codes.Sort(StringComparer.Ordinal);
        Dictionary<string, string> fileByCode = Strings(adrFiles);
        foreach (string code in codes)
        {
            if (!adrByPath.ContainsKey(fileByCode[code])) { adrByPath[fileByCode[code]] = code; }
        }
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
        Dictionary<string, CitationSite[]> ownSites = new Dictionary<string, CitationSite[]>(StringComparer.Ordinal);
        foreach (string path in pathList)
        {
            string text;
            bool cites = CitationScanner.Cites(path) && !excluded.Exists(glob => glob.Matches(path)) && textByPath.TryGetValue(path, out text);
            ownCitations[path] = cites ? CitationScanner.Scan(textByPath[path], index) : Array.Empty<string>();
            ownSites[path] = cites ? CitationScanner.Sites(path, textByPath[path], index) : Array.Empty<CitationSite>();
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

            string adr;
            adrByPath.TryGetValue(path, out adr);
            Catzc.Base.Globs.GlobSet pipelineSet = track != null && string.Equals(track.name, PipelinesTrack, StringComparison.Ordinal) &&
                ownCitations[path].Length == 0 ? PipelineSet(path, globSetList) : null;
            string basis;
            string[] citations;
            CitationSite[] sites;
            if (adr != null)
            {
                basis = MapPlacement.BasisAdrFile;
                citations = Array.Empty<string>();
                sites = Array.Empty<CitationSite>();
            }
            else if (track == null && ownerByRootFile.ContainsKey(path))
            {
                basis = MapPlacement.BasisFilesYml;
                string prefix = ownerByRootFile[path].TrimEnd('/') + "/";
                Func<string, bool> owned = p => p.StartsWith(prefix, StringComparison.Ordinal);
                citations = Union(pathList, ownCitations, owned);
                sites = SitesOf(pathList, ownSites, owned);
            }
            else if (pipelineSet != null)
            {
                basis = MapPlacement.BasisGlobSet;
                citations = Union(pathList, ownCitations, pipelineSet.Matches);
                sites = SitesOf(pathList, ownSites, pipelineSet.Matches);
            }
            else
            {
                citations = ownCitations[path];
                sites = ownSites[path];
                basis = citations.Length > 0 ? MapPlacement.BasisCitations : MapPlacement.BasisNone;
            }

            placements.Add(new MapPlacement(path, track == null ? WorldMap.NoTrack : track.name, fileLanguage, live, violation, basis, adr,
                citations, sites));
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

    // The citation sites of the member files, in path order then line order.
    private static CitationSite[] SitesOf(List<string> paths, Dictionary<string, CitationSite[]> ownSites, Func<string, bool> member)
    {
        List<string> members = new List<string>();
        foreach (string path in paths)
        {
            if (member(path)) { members.Add(path); }
        }
        members.Sort(StringComparer.Ordinal);
        List<CitationSite> sites = new List<CitationSite>();
        foreach (string path in members) { sites.AddRange(ownSites[path]); }
        return sites.ToArray();
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

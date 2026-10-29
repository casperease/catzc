using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Variants;

// The repo-wide variants, fixed for the importer session; read through Get-Config -Config variants.
public sealed class VariantsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "naming", "git_workspace", "have_customers", "aspects", "tracks" };
    private static readonly string[] AllowedTrackKeys = { "members", "type", "vendor", "languages", "execution_engines", "module_execution_engines", "kinds", "namespace", "join", "namespace_exempt" };
    // A namespace in the casing its track's language spells: dotted PascalCase (Catzc) or one lower-case word (catzc).
    private static readonly System.Text.RegularExpressions.Regex NamespaceName = new System.Text.RegularExpressions.Regex(@"^(?:[A-Z][A-Za-z0-9]*(\.[A-Z][A-Za-z0-9]*)*|[a-z][a-z0-9]*)$");
    // The joins a track's language spells between its namespace and a folder name.
    private static readonly string[] AllowedJoins = { ".", "-", "_", "" };
    private static readonly Regex CustomerName = new Regex("^[a-z][a-z0-9]+$");
    private static readonly Regex AspectName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex PlacePath = new Regex("^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");
    private static readonly Regex TrackTypeName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    // The defaults, declared once; a getter never restates them.
    public const string DefaultNaming = "standard";

    // The named naming orders; the segments each spells are Get-AzureNameOrderSet's.
    public static readonly string[] NamingPresets = { "standard", "classic" };

    // The segments of an Azure resource name; an explicit naming list names each exactly once.
    public static readonly string[] NamingSegments = { "env", "slot", "region", "org", "short_name", "customer", "role", "type" };
    public const string DefaultGitWorkspace = "main-direct";
    public const bool DefaultHaveCustomers = false;

    // The built-in aspect convention of a track that declares none of its own: a deployment ships everything but an explicit tests/ folder.
    public static IReadOnlyDictionary<string, IReadOnlyList<VariantAspect>> DefaultAspects =>
        ReadAspects(new Hashtable { ["vendor_azure.bicep"] = new object[] { new Hashtable { ["tests"] = new object[] { "**/tests/**" } }, new Hashtable { ["live"] = new object[] { "**" } } } }, new List<string>());

    // The one Azure name segment order: a preset name (a string) or an explicit segment list (a string[]).
    public object naming { get; }

    // How changes reach main: 'main-direct' or 'main-via-pr'.
    public string git_workspace { get; }

    // A bool, 'all' or a name list as written; Get-EnabledCustomers interprets it.
    public object have_customers { get; }

    // Per-track ordered aspect classifications: the declared ones over the built-in ones, a declared track replacing its built-in.
    public IReadOnlyDictionary<string, IReadOnlyList<VariantAspect>> aspects { get; }

    // The repository's tracks, in declared order. Required: a repository with no tracks fails at construction.
    public IReadOnlyList<VariantTrack> tracks { get; }

    public VariantsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }

        naming = DefaultNaming;
        git_workspace = DefaultGitWorkspace;
        have_customers = DefaultHaveCustomers;

        if (Present(d, "naming")) { naming = ReadNaming(d["naming"], errors); }

        if (Present(d, "git_workspace"))
        {
            string value = Text(d["git_workspace"]);
            if (value == "main-direct" || value == "main-via-pr") { git_workspace = value; }
            else { errors.Add(string.Format("invalid git_workspace '{0}' (valid: main-direct, main-via-pr)", value)); }
        }

        if (Present(d, "have_customers")) { have_customers = ReadCustomers(d["have_customers"], errors); }

        Dictionary<string, IReadOnlyList<VariantAspect>> mergedAspects = new Dictionary<string, IReadOnlyList<VariantAspect>>(StringComparer.Ordinal);
        foreach (KeyValuePair<string, IReadOnlyList<VariantAspect>> builtIn in DefaultAspects) { mergedAspects[builtIn.Key] = builtIn.Value; }
        if (Present(d, "aspects"))
        {
            IReadOnlyDictionary<string, IReadOnlyList<VariantAspect>> declared = ReadAspects(d["aspects"], errors);
            if (declared != null) { foreach (KeyValuePair<string, IReadOnlyList<VariantAspect>> track in declared) { mergedAspects[track.Key] = track.Value; } }
        }
        aspects = mergedAspects;

        if (Present(d, "tracks")) { tracks = ReadTracks(d["tracks"], errors); }
        else
        {
            errors.Add("this repository declares no tracks; add tracks: to variants.yml or the repository's fragment of it");
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("variants configuration validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static bool Has(IDictionary d, string key) => d != null && d.Contains(key);

    // A key counts as stated when it is there and not null, so an omitted key and a null one take the same default.
    private static bool Present(IDictionary d, string key) => Has(d, key) && d[key] != null;

    private static string Text(object value) => value == null ? "" : value.ToString();

    // A YAML value as a list: a sequence is itself, null is empty, and a scalar or mapping is a one-item list.
    private static List<object> Items(object value)
    {
        List<object> items = new List<object>();
        if (value == null) { return items; }
        IList list = value as IList;
        if (list == null) { items.Add(value); return items; }
        foreach (object item in list) { items.Add(item); }
        return items;
    }

    // A preset name stays a string; a list must name every segment exactly once, type among them.
    private static object ReadNaming(object value, List<string> errors)
    {
        string text = value as string;
        if (text != null)
        {
            if (Array.IndexOf(NamingPresets, text) >= 0) { return text; }
            errors.Add(string.Format("invalid naming '{0}' (a preset: {1}; or a list naming each segment once: {2})", text, string.Join(", ", NamingPresets), string.Join(", ", NamingSegments)));
            return null;
        }
        if (!(value is IList))
        {
            errors.Add(string.Format("invalid naming '{0}' (a preset: {1}; or a list naming each segment once: {2})", Text(value), string.Join(", ", NamingPresets), string.Join(", ", NamingSegments)));
            return null;
        }
        List<string> segments = new List<string>();
        foreach (object item in Items(value))
        {
            string segment = Text(item);
            if (Array.IndexOf(NamingSegments, segment) < 0)
            {
                errors.Add(string.Format("invalid naming segment '{0}' (one of: {1})", segment, string.Join(", ", NamingSegments)));
            }
            else if (segments.Contains(segment))
            {
                errors.Add(string.Format("duplicate naming segment '{0}' (each segment once)", segment));
            }
            else { segments.Add(segment); }
        }
        if (!segments.Contains("type"))
        {
            errors.Add("naming list has no 'type' segment (every name carries its resource type)");
        }
        string[] missing = NamingSegments.Where(s => s != "type" && !segments.Contains(s)).ToArray();
        if (missing.Length > 0)
        {
            errors.Add(string.Format("naming list misses segment(s) {0} (each segment once)", string.Join(", ", missing)));
        }
        return segments.ToArray();
    }

    private static object ReadCustomers(object value, List<string> errors)
    {
        if (value is bool) { return value; }
        string text = value as string;
        if (text != null)
        {
            if (text == "all") { return text; }
            errors.Add(string.Format("invalid have_customers '{0}' (a string must be 'all'; use a list for specific customers)", text));
            return null;
        }
        IEnumerable seq = value as IEnumerable;
        if (seq == null || value is IDictionary)
        {
            errors.Add(string.Format("invalid have_customers '{0}' (must be false, 'all', or a list of customer names)", Text(value)));
            return null;
        }
        List<string> names = new List<string>();
        foreach (object item in seq)
        {
            string name = Text(item);
            if (!CustomerName.IsMatch(name))
            {
                errors.Add(string.Format("invalid have_customers customer name '{0}' (must be 2+ lowercase alphanumeric chars, leading letter)", name));
            }
            else if (names.Contains(name))
            {
                errors.Add(string.Format("duplicate have_customers customer name '{0}'", name));
            }
            else { names.Add(name); }
        }
        return names.ToArray();
    }

    private static IReadOnlyDictionary<string, IReadOnlyList<VariantAspect>> ReadAspects(object value, List<string> errors)
    {
        IDictionary tracks = value as IDictionary;
        if (tracks == null)
        {
            errors.Add("invalid aspects (must be a map of track -> ordered [ {name: [patterns]}, … ])");
            return null;
        }
        if (tracks.Count == 0)
        {
            errors.Add("aspects must define at least one track convention");
            return null;
        }

        Dictionary<string, IReadOnlyList<VariantAspect>> result = new Dictionary<string, IReadOnlyList<VariantAspect>>(StringComparer.Ordinal);
        foreach (object trackKey in tracks.Keys)
        {
            string track = Text(trackKey);
            List<object> items = Items(tracks[trackKey]);
            if (items.Count == 0)
            {
                errors.Add(string.Format("aspects['{0}'] must list at least one aspect (the last is the '**' catch-all)", track));
                continue;
            }

            List<VariantAspect> aspects = new List<VariantAspect>();
            HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
            for (int i = 0; i < items.Count; i++)
            {
                IDictionary item = items[i] as IDictionary;
                if (item == null || item.Count != 1)
                {
                    errors.Add(string.Format("aspects['{0}'][{1}] must be a single-key mapping {{name: [patterns]}}", track, i));
                    continue;
                }
                object nameKey = null;
                foreach (object k in item.Keys) { nameKey = k; }
                string name = Text(nameKey);
                if (!AspectName.IsMatch(name))
                {
                    errors.Add(string.Format("aspects['{0}']: invalid aspect name '{1}' (kebab-case)", track, name));
                }
                else if (!seen.Add(name))
                {
                    errors.Add(string.Format("aspects['{0}']: duplicate aspect '{1}'", track, name));
                }

                List<string> patterns = new List<string>();
                foreach (object p in Items(item[nameKey])) { patterns.Add(Text(p)); }
                if (patterns.Count == 0 || patterns.Exists(string.IsNullOrWhiteSpace))
                {
                    errors.Add(string.Format("aspects['{0}'].{1} needs at least one non-empty pattern", track, name));
                }
                bool isLast = i == items.Count - 1;
                if (isLast && (patterns.Count != 1 || patterns[0] != "**"))
                {
                    errors.Add(string.Format("aspects['{0}']: the last aspect ('{1}') must be the '**' catch-all remainder", track, name));
                }
                else if (!isLast && patterns.Contains("**"))
                {
                    errors.Add(string.Format("aspects['{0}'].{1} uses the bare '**' catch-all but is not last — only the final aspect is the remainder", track, name));
                }
                aspects.Add(new VariantAspect(name, patterns.ToArray()));
            }
            result[track] = aspects;
        }
        return result;
    }

    private static IReadOnlyList<VariantTrack> ReadTracks(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid tracks (must be a map of track -> { members, type, vendor, languages })");
            return null;
        }
        if (map.Count == 0)
        {
            errors.Add("tracks must declare at least one track");
            return null;
        }

        List<VariantTrack> result = new List<VariantTrack>();
        Dictionary<string, string> placeOwner = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (object nameKey in map.Keys)
        {
            // The gate checks a track name's normal form; this type holds no naming policy.
            string name = Text(nameKey);
            IDictionary entry = map[nameKey] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format("tracks['{0}'] must be a mapping {{ members, type, vendor, languages }}", name));
                continue;
            }
            foreach (object k in entry.Keys)
            {
                string key = Text(k);
                if (Array.IndexOf(AllowedTrackKeys, key) < 0)
                {
                    errors.Add(string.Format("tracks['{0}']: unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedTrackKeys)));
                }
            }

            List<VariantMember> members = new List<VariantMember>();
            List<string> places = new List<string>();
            foreach (object item in Items(Has(entry, "members") ? entry["members"] : null))
            {
                VariantMember member = ReadMember(name, item, errors);
                if (member == null) { continue; }
                string place = member.path;
                if ((!member.glob && !PlacePath.IsMatch(place)) || place.Split('/').Any(s => s == "." || s == ".."))
                {
                    errors.Add(string.Format("tracks['{0}']: invalid member '{1}' (a repository-relative path with '/' separators, e.g. pwsh or .github/workflows)", name, place));
                }
                else if (placeOwner.ContainsKey(place))
                {
                    errors.Add(string.Format("tracks['{0}']: member '{1}' is already a member of track '{2}' (a member belongs to one track)", name, place, placeOwner[place]));
                }
                else
                {
                    placeOwner[place] = name;
                    places.Add(place);
                    members.Add(member);
                }
            }
            if (members.Count == 0)
            {
                errors.Add(string.Format("tracks['{0}'] needs at least one member", name));
            }

            string trackType = Has(entry, "type") ? Text(entry["type"]) : "";
            if (!TrackTypeName.IsMatch(trackType))
            {
                errors.Add(string.Format("tracks['{0}']: invalid type '{1}' (the id of a track type of the track-types registry)", name, trackType));
            }

            string vendor = Has(entry, "vendor") ? Text(entry["vendor"]) : "";
            if (Has(entry, "vendor") && !TrackTypeName.IsMatch(vendor))
            {
                errors.Add(string.Format("tracks['{0}']: invalid vendor '{1}' (the id of a vendor of the track-types registry)", name, vendor));
            }

            List<string> languages = new List<string>();
            foreach (object item in Items(Has(entry, "languages") ? entry["languages"] : null))
            {
                string language = Text(item);
                if (!AspectName.IsMatch(language))
                {
                    errors.Add(string.Format("tracks['{0}']: invalid language name '{1}' (kebab-case)", name, language));
                }
                else if (languages.Contains(language))
                {
                    errors.Add(string.Format("tracks['{0}']: duplicate language '{1}'", name, language));
                }
                else { languages.Add(language); }
            }

            List<string> engines = ReadEngines(string.Format("tracks['{0}'].execution_engines", name), Has(entry, "execution_engines") ? entry["execution_engines"] : null, errors);

            Dictionary<string, string[]> moduleEngines = new Dictionary<string, string[]>(StringComparer.Ordinal);
            if (Has(entry, "module_execution_engines"))
            {
                IDictionary overrides = entry["module_execution_engines"] as IDictionary;
                if (overrides == null)
                {
                    errors.Add(string.Format("tracks['{0}']: module_execution_engines must be a map of module name -> list of execution engines", name));
                }
                else
                {
                    foreach (object moduleKey in overrides.Keys)
                    {
                        string module = Text(moduleKey);
                        List<string> own = ReadEngines(string.Format("tracks['{0}'].module_execution_engines['{1}']", name, module), overrides[moduleKey], errors);
                        if (own.Count == 0)
                        {
                            errors.Add(string.Format("tracks['{0}'].module_execution_engines['{1}'] must name at least one engine (drop the entry to take the track's)", name, module));
                        }
                        else if (engines.Count > 0 && own.SequenceEqual(engines))
                        {
                            errors.Add(string.Format("tracks['{0}'].module_execution_engines['{1}'] repeats the track's engines (an override differs from the track's list)", name, module));
                        }
                        else
                        {
                            moduleEngines[module] = own.ToArray();
                        }
                    }
                }
            }

            Dictionary<string, string> kinds = ReadKinds(name, Has(entry, "kinds") ? entry["kinds"] : null, places, errors);

            string moduleNamespace = Has(entry, "namespace") ? Text(entry["namespace"]) : "";
            if (Has(entry, "namespace") && !NamespaceName.IsMatch(moduleNamespace))
            {
                errors.Add(string.Format("tracks['{0}']: invalid namespace '{1}' (dotted PascalCase segments, e.g. Catzc, or one lower-case word, e.g. catzc)", name, moduleNamespace));
                moduleNamespace = "";
            }

            string moduleJoin = null;
            if (Has(entry, "join"))
            {
                moduleJoin = Text(entry["join"]);
                if (!AllowedJoins.Contains(moduleJoin))
                {
                    errors.Add(string.Format("tracks['{0}']: invalid join '{1}' (one of '.', '-', '_' or '')", name, moduleJoin));
                    moduleJoin = null;
                }
                else if (!Has(entry, "namespace"))
                {
                    errors.Add(string.Format("tracks['{0}']: a join needs a namespace to join", name));
                    moduleJoin = null;
                }
            }

            // The files that keep the namespace on disk: globs, read only beside a namespace they exempt from.
            List<string> exempt = new List<string>();
            foreach (object item in Items(Has(entry, "namespace_exempt") ? entry["namespace_exempt"] : null))
            {
                string glob = Text(item);
                try
                {
                    new Catzc.Base.Objects.GlobPattern(glob);
                    exempt.Add(glob);
                }
                catch (ArgumentException e)
                {
                    errors.Add(string.Format("tracks['{0}'].namespace_exempt: {1}", name, e.Message.Split(new[] { " (Parameter" }, StringSplitOptions.None)[0]));
                }
            }
            if (exempt.Count > 0 && moduleNamespace.Length == 0)
            {
                errors.Add(string.Format("tracks['{0}']: a namespace_exempt needs a namespace to exempt from", name));
                exempt.Clear();
            }

            result.Add(new VariantTrack(name, members.ToArray(), trackType, vendor, languages.ToArray(), engines.ToArray(), moduleEngines, kinds, moduleNamespace, moduleJoin, exempt.ToArray()));
        }
        return result;
    }

    private static readonly string[] AllowedMemberKeys = { "path", "generated", "committed" };

    // A member is a plain path (authored and committed) or a map { path, generated, committed } for a member whose facts differ.
    private static VariantMember ReadMember(string track, object item, List<string> errors)
    {
        IDictionary map = item as IDictionary;
        try
        {
            if (map == null)
            {
                return new VariantMember(Text(item));
            }
            foreach (object k in map.Keys)
            {
                string key = Text(k);
                if (Array.IndexOf(AllowedMemberKeys, key) < 0)
                {
                    errors.Add(string.Format("tracks['{0}']: member has unknown key '{1}' (allowed: {2})", track, key, string.Join(", ", AllowedMemberKeys)));
                }
            }
            bool generated = false;
            bool committed = true;
            if (Has(map, "generated") && !(map["generated"] is bool))
            {
                errors.Add(string.Format("tracks['{0}']: member '{1}' generated must be true or false", track, Text(map["path"])));
            }
            else if (Has(map, "generated")) { generated = (bool)map["generated"]; }
            if (Has(map, "committed") && !(map["committed"] is bool))
            {
                errors.Add(string.Format("tracks['{0}']: member '{1}' committed must be true or false", track, Text(map["path"])));
            }
            else if (Has(map, "committed")) { committed = (bool)map["committed"]; }
            return new VariantMember(Has(map, "path") ? Text(map["path"]) : null, generated, committed);
        }
        catch (ArgumentException e)
        {
            errors.Add(string.Format("tracks['{0}']: {1}", track, e.Message.Split(new[] { " (Parameter" }, StringSplitOptions.None)[0]));
            return null;
        }
    }

    // A track's named kinds: kind -> a place pattern inside one of its places, with at most one '*' segment.
    private static Dictionary<string, string> ReadKinds(string track, object value, List<string> places, List<string> errors)
    {
        Dictionary<string, string> kinds = new Dictionary<string, string>(StringComparer.Ordinal);
        if (value == null) { return kinds; }
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add(string.Format("tracks['{0}']: kinds must be a map of kind -> place pattern (e.g. configs: widgets/*/configuration)", track));
            return kinds;
        }
        foreach (object kindKey in map.Keys)
        {
            string kind = Text(kindKey);
            string pattern = Text(map[kindKey]);
            if (!AspectName.IsMatch(kind))
            {
                errors.Add(string.Format("tracks['{0}']: invalid kind name '{1}' (kebab-case)", track, kind));
                continue;
            }
            string[] segments = pattern.Split('/');
            int stars = segments.Count(s => s == "*");
            bool wellFormed = segments.All(s => s == "*" || (PlacePath.IsMatch(s) && s != "." && s != ".."));
            if (!wellFormed || stars > 1)
            {
                errors.Add(string.Format("tracks['{0}'].kinds['{1}']: invalid place pattern '{2}' (a repository-relative path with '/' separators and at most one '*' segment)", track, kind, pattern));
                continue;
            }
            // A place has no '*', so a pattern that is a place or extends one carries its '*' after that place.
            bool inside = places.Any(p => pattern == p || pattern.StartsWith(p + "/", StringComparison.Ordinal));
            if (!inside)
            {
                errors.Add(string.Format("tracks['{0}'].kinds['{1}']: place pattern '{2}' is not inside one of the track's places ({3})", track, kind, pattern, string.Join(", ", places)));
                continue;
            }
            kinds[kind] = pattern;
        }
        return kinds;
    }

    // A list of execution engines, each one of the closed set and named once. An absent list is empty: the choice is left open as auto.
    private static List<string> ReadEngines(string where, object value, List<string> errors)
    {
        List<string> engines = new List<string>();
        foreach (object item in Items(value))
        {
            string engine = Text(item);
            if (!Catzc.Base.Engines.ExecutionEngines.Names.Contains(engine))
            {
                errors.Add(string.Format("{0}: unknown execution engine '{1}' (one of: {2})", where, engine, string.Join(", ", Catzc.Base.Engines.ExecutionEngines.Names)));
            }
            else if (engines.Contains(engine))
            {
                errors.Add(string.Format("{0}: duplicate execution engine '{1}'", where, engine));
            }
            else { engines.Add(engine); }
        }
        return engines;
    }
}

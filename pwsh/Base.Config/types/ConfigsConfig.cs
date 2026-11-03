using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Catzc.Base.Config;

// The registry's shape is enforced at construction, so a malformed registry can never yield an instance for any config to resolve through.
public sealed class ConfigsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly IReadOnlyDictionary<string, string> Empty =
        new ReadOnlyDictionary<string, string>(new Dictionary<string, string>());

    public IReadOnlyDictionary<string, string> configs { get; } = Empty;

    // The configs a consumer overlay may not change (registered with scope: engine), in file order.
    public IReadOnlyList<string> sealedConfigs { get; } = Array.Empty<string>();

    // The configs that describe the repository and are read whole from the working root (registered with scope: working-root), in file order.
    public IReadOnlyList<string> workingRootConfigs { get; } = Array.Empty<string>();

    // Per config, the top-level keys whose shipped value may differ from the type's default, each with its one-sentence reason.
    public IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> differs { get; } =
        new ReadOnlyDictionary<string, IReadOnlyDictionary<string, string>>(new Dictionary<string, IReadOnlyDictionary<string, string>>());

    public ConfigsConfig(IDictionary registry)
    {
        if (registry == null) { return; }

        var errors = new List<string>();
        foreach (var key in registry.Keys)
        {
            var topKey = key == null ? string.Empty : key.ToString();
            if (topKey != "configs")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: configs)", topKey));
            }
        }

        var entries = registry.Contains("configs") ? registry["configs"] as IDictionary : null;
        var types = new Dictionary<string, string>(StringComparer.Ordinal);
        var sealedNames = new List<string>();
        var workingRootNames = new List<string>();
        var reasons = new Dictionary<string, IReadOnlyDictionary<string, string>>(StringComparer.Ordinal);
        if (entries == null)
        {
            if (registry.Contains("configs") && registry["configs"] != null)
            {
                errors.Add("'configs' must be a map of config name -> { type }");
            }
            entries = new Hashtable();
        }

        foreach (var key in entries.Keys)
        {
            var name = key == null ? string.Empty : key.ToString();
            var entry = entries[key] as IDictionary;
            if (entry == null || !entry.Contains("type") || IsBlank(entry["type"]))
            {
                errors.Add(string.Format("config '{0}': an entry must specify a 'type' (a C# type FQN)", name));
                continue;
            }

            foreach (var entryKey in entry.Keys)
            {
                var keyName = entryKey == null ? string.Empty : entryKey.ToString();
                if (keyName != "type" && keyName != "scope" && keyName != "differs")
                {
                    errors.Add(string.Format("config '{0}': unknown key '{1}' (allowed: type, scope, differs)", name, keyName));
                }
            }
            if (entry.Contains("differs") && entry["differs"] != null)
            {
                var map = entry["differs"] as IDictionary;
                var keyReasons = new Dictionary<string, string>(StringComparer.Ordinal);
                if (map == null)
                {
                    errors.Add(string.Format("config '{0}': differs must be a map of key -> the reason its shipped value differs from the type's default", name));
                }
                else
                {
                    foreach (DictionaryEntry reason in map)
                    {
                        var differing = reason.Key == null ? string.Empty : reason.Key.ToString();
                        if (IsBlank(reason.Value))
                        {
                            errors.Add(string.Format("config '{0}': differs '{1}' needs its reason, one sentence", name, differing));
                            continue;
                        }
                        keyReasons[differing] = reason.Value.ToString().Trim();
                    }
                }
                reasons[name] = new ReadOnlyDictionary<string, string>(keyReasons);
            }
            types[name] = entry["type"].ToString().Trim();
            if (entry.Contains("scope"))
            {
                var scope = entry["scope"] == null ? string.Empty : entry["scope"].ToString().Trim();
                if (scope == "engine")
                {
                    sealedNames.Add(name);
                }
                else if (scope == "working-root")
                {
                    workingRootNames.Add(name);
                }
                else if (scope != "module")
                {
                    errors.Add(string.Format("config '{0}': scope '{1}' is not one of engine, module, working-root", name, scope));
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("config registry validation failed:\n" + string.Join("\n", errors));
        }

        configs = new ReadOnlyDictionary<string, string>(types);
        sealedConfigs = sealedNames;
        workingRootConfigs = workingRootNames;
        differs = new ReadOnlyDictionary<string, IReadOnlyDictionary<string, string>>(reasons);
    }

    private static bool IsBlank(object value)
    {
        return value == null || string.IsNullOrWhiteSpace(value.ToString());
    }
}

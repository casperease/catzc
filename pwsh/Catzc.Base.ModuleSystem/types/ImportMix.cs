using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.ModuleSystem;

// Rests on [ADR-AUTO-IMPORTER-ONEMIXRECORD](/docs/adr/automation/importer.md#rule-adr-auto-importer-onemixrecord).
public sealed class ImportMix
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The languages the session loads, in the order the languages configuration declares them.
    public IReadOnlyList<string> languages { get; }

    // The execution engines the session serves, in the order of the engine model.
    public IReadOnlyList<string> engines { get; }

    // The modules the session loads, in ordinal order.
    public IReadOnlyList<string> modules { get; }

    // The engines auto left out because their executable is not present; empty for an explicit list.
    public IReadOnlyList<string> skipped_engines { get; }

    // The modules left out because one of their code languages is outside the mix, in ordinal order.
    public IReadOnlyList<string> skipped_modules { get; }

    public ImportMix(string[] languages, string[] engines, string[] modules, string[] skippedEngines, string[] skippedModules)
    {
        this.languages = Copy(languages);
        this.engines = Copy(engines);
        this.modules = Copy(modules);
        skipped_engines = Copy(skippedEngines);
        skipped_modules = Copy(skippedModules);
    }

    public static ImportMix Resolve(ImporterConfig config, string[] callerLanguages, string[] callerEngines, string[] presentEngines,
        IDictionary moduleLanguages, string[] knownLanguages, string[] executableLanguages, string[] handledLanguages)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        IReadOnlyList<string> engineAxis = callerEngines != null ? Array.AsReadOnly(callerEngines) : config.engines;
        IReadOnlyList<string> languageAxis = callerLanguages != null ? Array.AsReadOnly(callerLanguages) : config.languages;
        string[] present = presentEngines ?? Array.Empty<string>();
        string[] known = knownLanguages ?? Array.Empty<string>();
        string[] executable = executableLanguages ?? Array.Empty<string>();
        string[] handled = handledLanguages ?? Array.Empty<string>();

        List<string> engines = new List<string>();
        List<string> skipped = new List<string>();
        if (ImporterConfig.IsAuto(engineAxis))
        {
            foreach (string name in Catzc.Base.Engines.ExecutionEngines.Names)
            {
                if (Array.IndexOf(present, name) >= 0) { engines.Add(name); } else { skipped.Add(name); }
            }
        }
        else
        {
            foreach (string name in engineAxis)
            {
                Catzc.Base.Engines.ExecutionEngines.Get(name);
                if (Array.IndexOf(present, name) < 0)
                {
                    throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture,
                        "The mix names the engine '{0}', but its executable is not present.", name));
                }
            }
            foreach (string name in Catzc.Base.Engines.ExecutionEngines.Names)
            {
                if (Contains(engineAxis, name)) { engines.Add(name); }
            }
        }

        Dictionary<string, List<string>> live = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        HashSet<string> moduleLanguageNames = new HashSet<string>(StringComparer.Ordinal);
        if (moduleLanguages != null)
        {
            foreach (DictionaryEntry entry in moduleLanguages)
            {
                List<string> names = new List<string>();
                if (entry.Value is IEnumerable values && !(entry.Value is string))
                {
                    foreach (object value in values) { names.Add(Convert.ToString(value, CultureInfo.InvariantCulture)); }
                }
                live[Convert.ToString(entry.Key, CultureInfo.InvariantCulture)] = names;
                moduleLanguageNames.UnionWith(names);
            }
        }

        List<string> languages = new List<string>();
        if (ImporterConfig.IsAuto(languageAxis))
        {
            foreach (string name in executable)
            {
                if (moduleLanguageNames.Contains(name)) { languages.Add(name); }
            }
        }
        else
        {
            foreach (string name in languageAxis)
            {
                if (Array.IndexOf(known, name) < 0)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "'{0}' is not a language of the languages configuration (one of: {1})", name, string.Join(", ", known)));
                }
                if (Array.IndexOf(handled, name) < 0)
                {
                    throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture,
                        "The mix names the language '{0}', which the importer has no handler for (handled: {1}).", name, string.Join(", ", handled)));
                }
            }
            foreach (string name in known)
            {
                if (Contains(languageAxis, name)) { languages.Add(name); }
            }
        }

        List<string> modules = new List<string>();
        List<string> skippedModules = new List<string>();
        foreach (KeyValuePair<string, List<string>> module in live)
        {
            if (module.Value.TrueForAll(languages.Contains)) { modules.Add(module.Key); } else { skippedModules.Add(module.Key); }
        }
        modules.Sort(StringComparer.Ordinal);
        skippedModules.Sort(StringComparer.Ordinal);

        return new ImportMix(languages.ToArray(), engines.ToArray(), modules.ToArray(), skipped.ToArray(), skippedModules.ToArray());
    }

    private static bool Contains(IReadOnlyList<string> items, string item)
    {
        foreach (string candidate in items)
        {
            if (string.Equals(candidate, item, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    private static string[] Copy(string[] items) => items == null ? Array.Empty<string>() : (string[])items.Clone();
}

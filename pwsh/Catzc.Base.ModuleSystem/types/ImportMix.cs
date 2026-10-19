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

    public ImportMix(string[] languages, string[] engines, string[] modules, string[] skippedEngines)
    {
        this.languages = Copy(languages);
        this.engines = Copy(engines);
        this.modules = Copy(modules);
        skipped_engines = Copy(skippedEngines);
    }

    // Each axis is the caller's value when given, else the configuration's, where auto resolves from the session's facts:
    // presentEngines are the engines whose executable is located, moduleLanguages maps each module to its file languages, and
    // knownLanguages and executableLanguages are the language names of the languages configuration, in its order.
    public static ImportMix Resolve(ImporterConfig config, string[] callerLanguages, string[] callerEngines, string[] presentEngines,
        IDictionary moduleLanguages, string[] knownLanguages, string[] executableLanguages)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        IReadOnlyList<string> engineAxis = callerEngines != null ? Array.AsReadOnly(callerEngines) : config.engines;
        IReadOnlyList<string> languageAxis = callerLanguages != null ? Array.AsReadOnly(callerLanguages) : config.languages;
        string[] present = presentEngines ?? Array.Empty<string>();
        string[] known = knownLanguages ?? Array.Empty<string>();
        string[] executable = executableLanguages ?? Array.Empty<string>();

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

        List<string> modules = new List<string>();
        HashSet<string> moduleLanguageNames = new HashSet<string>(StringComparer.Ordinal);
        if (moduleLanguages != null)
        {
            foreach (DictionaryEntry entry in moduleLanguages)
            {
                modules.Add(Convert.ToString(entry.Key, CultureInfo.InvariantCulture));
                if (entry.Value is IEnumerable names && !(entry.Value is string))
                {
                    foreach (object name in names) { moduleLanguageNames.Add(Convert.ToString(name, CultureInfo.InvariantCulture)); }
                }
            }
        }
        modules.Sort(StringComparer.Ordinal);

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
            }
            foreach (string name in known)
            {
                if (Contains(languageAxis, name)) { languages.Add(name); }
            }
        }

        return new ImportMix(languages.ToArray(), engines.ToArray(), modules.ToArray(), skipped.ToArray());
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

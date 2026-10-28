using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Variants;

// One writer of generated files, as its module's generated.yml declares it; every default of a row is declared here once.
public sealed class GeneratedWriterRow : Catzc.Base.Objects.DictionaryRecord
{
    // What a roll-off may do with the writer's files
    // ([ADR-REPO-ROOTCFG-ONECLASSPERWRITER](/docs/drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-oneclassperwriter)).
    public static readonly string[] Classes = { "rollable", "import-critical", "snapshot", "untracked" };

    // The shape of the writer's report a drift check reads; 'none' for a writer no drift check reads.
    public static readonly string[] Checks = { "file", "english-dictionary", "root-config", "none" };

    public const string DefaultCheck = "file";

    public const string DefaultResultPath = "Path";

    private static readonly string[] AllowedKeys = { "class", "check", "result_path", "at_import", "inputs", "outputs", "expands", "regenerate", "remove" };

    // The writer's command or tool name.
    public string name { get; }

    // One of Classes; required, since a class taken by default could roll off a file the import needs.
    public string @class { get; }

    // One of Checks. Default: file.
    public string check { get; }

    // The property of a file result that names the stale file. Default: Path for the check file, null for any other.
    public string result_path { get; }

    // Whether the import re-renders the writer when it is due. Default: false.
    public bool at_import { get; }

    // Repository-relative globs of what the writer reads. Default: none.
    public string[] inputs { get; }

    // What the writer writes, each with the inputs it reads; at least one.
    public IReadOnlyList<GeneratedOutput> outputs { get; }

    // The config that expands the writer's instances (readme, rootconfig, comment-pages). Default: none, the outputs are the instances.
    public string expands { get; }

    // The command that renders a file again, where it differs from the generated-head.yml template. Default: the template.
    public string regenerate { get; }

    // The command that takes a file off the working copy, where it differs from the generated-head.yml template. Default: the template.
    public string remove { get; }

    public GeneratedWriterRow(string name, object raw)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("a writer row names no writer");
        }
        this.name = name;
        IDictionary entry = raw as IDictionary;
        if (entry == null)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "writer '{0}' must be a mapping with the keys: {1}", name, string.Join(", ", AllowedKeys)));
        }
        foreach (object k in entry.Keys)
        {
            string key = Convert.ToString(k, CultureInfo.InvariantCulture);
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}' carries unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedKeys)));
            }
        }

        @class = OptStr(entry, "class");
        if (@class == null || Array.IndexOf(Classes, @class) < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}' has class '{1}'; it must name one of: {2}", name, @class, string.Join(", ", Classes)));
        }

        check = OptStr(entry, "check") ?? DefaultCheck;
        if (Array.IndexOf(Checks, check) < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}' has unknown check '{1}' (allowed: {2})", name, check, string.Join(", ", Checks)));
        }
        string resultPath = OptStr(entry, "result_path");
        if (check != DefaultCheck && resultPath != null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}' sets result_path, which only the check '{1}' reads", name, DefaultCheck));
        }
        result_path = check == DefaultCheck ? (resultPath ?? DefaultResultPath) : null;

        at_import = Flag(entry, "at_import");
        inputs = StrArr(entry, "inputs");
        expands = OptStr(entry, "expands");
        regenerate = OptStr(entry, "regenerate");
        remove = OptStr(entry, "remove");

        List<GeneratedOutput> list = new List<GeneratedOutput>();
        object value = entry.Contains("outputs") ? entry["outputs"] : null;
        IList items = value as IList;
        if (items == null || value is string || items.Count == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}' declares no outputs; 'outputs' must be a non-empty list", name));
        }
        else
        {
            foreach (object item in items)
            {
                try { list.Add(new GeneratedOutput(name, item, inputs)); }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        outputs = list.AsReadOnly();
    }
}

// The allow-list lets a Windows-only function be skipped rather than throw; a blank function name is rejected at load.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerSupportedConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Tooling.KeyHandler;

public sealed class KeyHandlerSupportedConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "key-handler-supported.yml is malformed:\n  - ";

    // The supported function names, in file order.
    public string[] functions { get; }

    public KeyHandlerSupportedConfig(IDictionary raw)
    {
        if (raw == null) { throw new ArgumentException("key-handler-supported.yml must be a mapping with a functions: list."); }

        List<string> errors = new List<string>();
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "functions") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: functions)", key)); }
        }

        List<string> names = new List<string>();
        if (!raw.Contains("functions"))
        {
            errors.Add("key-handler-supported.yml has no 'functions' key.");
        }
        else
        {
            object value = raw["functions"];
            IList list = value as IList;
            if (value is string) { list = new object[] { value }; }
            if (list == null || list.Count == 0)
            {
                errors.Add("key-handler-supported.yml 'functions' is empty.");
            }
            else
            {
                bool blank = false;
                foreach (object item in list)
                {
                    if (item == null || item is IDictionary || item is IList || string.IsNullOrWhiteSpace(item.ToString())) { blank = true; continue; }
                    names.Add(item.ToString());
                }
                if (blank) { errors.Add("key-handler-supported.yml 'functions' contains a blank entry."); }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n  - ", errors)); }
        functions = names.ToArray();
    }
}

// One captured PSReadLine key binding of configs/key-handler-bindings.yml (`- key: <chord>` / `function: <name>`),
// written by Save-PSReadLineKeyHandlerSet and replayed by Import-PSReadLineKeyHandlerSet. Constructing one MAPS and
// VALIDATES the entry: a mapping carrying a non-empty 'key' and 'function' (the only two keys the capture writes);
// every violation is reported in one throw, prefixed with the entry's position. Mirrors the YAML mapping
// (snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Tooling.KeyHandler;

public sealed class KeyHandlerBinding : Catzc.Base.Objects.DictionaryRecord
{
    // The key chord (e.g. 'Ctrl+Backspace').
    public string key { get; }

    // The PSReadLine function bound to the chord (e.g. 'BackwardKillWord').
    public string function { get; }

    public KeyHandlerBinding(int index, object raw)
    {
        IDictionary entry = raw as IDictionary;
        if (entry == null) { throw new ArgumentException(string.Format("entry {0} is not a key/function mapping", index)); }

        List<string> errors = new List<string>();
        foreach (object k in entry.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (name != "key" && name != "function") { errors.Add(string.Format("entry {0} has unknown key '{1}' (allowed: key, function)", index, name)); }
        }

        key = OptStr(entry, "key");
        if (key == null) { errors.Add(string.Format("entry {0} has no 'key'", index)); }
        function = OptStr(entry, "function");
        if (function == null) { errors.Add(string.Format("entry {0} has no 'function'", index)); }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}

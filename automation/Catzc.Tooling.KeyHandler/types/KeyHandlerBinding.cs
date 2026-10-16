/*
---
catzc:
  derived:
    path: automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder-module
    bundle: full
    relatives:
      page: docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerBinding.cs.md
    adrs:
      - ADR-AUTO-TYPES#8
---
*/

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

// The YAML has no top-level key, so the sequence is exposed as bindings; a malformed capture fails at read, not mid-import.
// [comment:1](/docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerBindingsConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Tooling.KeyHandler;

public sealed class KeyHandlerBindingsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "key-handler-bindings.yml is malformed:\n  - ";

    // The captured bindings, in file order.
    public IReadOnlyList<KeyHandlerBinding> bindings { get; }

    // The parsed YAML: a sequence (a list) of { key, function } mappings.
    public KeyHandlerBindingsConfig(object raw)
    {
        if (raw == null || raw is string || raw is IDictionary || !(raw is IEnumerable))
        {
            throw new ArgumentException("key-handler-bindings.yml must be a sequence of { key, function } entries.");
        }

        List<string> errors = new List<string>();
        List<KeyHandlerBinding> list = new List<KeyHandlerBinding>();
        int index = 0;
        foreach (object item in (IEnumerable)raw)
        {
            try { list.Add(new KeyHandlerBinding(index, item)); }
            catch (ArgumentException ex) { errors.Add(ex.Message.Replace("\n", "\n  - ")); }
            index++;
        }
        if (index == 0)
        {
            throw new ArgumentException("key-handler-bindings.yml is empty — capture bindings with Save-PSReadLineKeyHandlerSet.");
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n  - ", errors)); }
        bindings = list.AsReadOnly();
    }
}

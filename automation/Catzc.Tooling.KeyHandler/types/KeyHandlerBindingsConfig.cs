// The captured Windows PSReadLine key bindings, configs/key-handler-bindings.yml: a top-level SEQUENCE of
// { key, function } entries (KeyHandlerBinding), written by Save-PSReadLineKeyHandlerSet and replayed on Linux by
// Import-PSReadLineKeyHandlerSet. The YAML has no top-level key, so the sequence is exposed as `bindings`.
// Constructing an instance MAPS and VALIDATES the parsed YAML — a non-empty sequence of well-formed entries —
// collecting every violation into one throw, so a malformed capture fails at read time rather than mid-import.
// Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig), so
// Get-Config -Config key-handler-bindings returns this typed model.

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

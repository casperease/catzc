/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/GuidsConfig.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/GuidsConfig.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/GuidsConfig.Tests.ps1
    adrs:
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.QualityGates;

public sealed class GuidsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "guids configuration validation failed:\n";

    // Denied entry name -> ManagedGuidEntry, in declaration order; read-only (empty when none).
    public OrderedDictionary denied { get; }

    // Registered entry name -> ManagedGuidEntry, in declaration order; read-only (empty when none).
    public OrderedDictionary guids { get; }

    public GuidsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        if (!raw.Contains("guids")) { errors.Add("Missing required top-level key: 'guids'"); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "denied" && key != "guids") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: denied, guids)", key)); }
        }

        Dictionary<string, int> valueCount = new Dictionary<string, int>(StringComparer.Ordinal);
        List<string> valueOrder = new List<string>();
        OrderedDictionary deniedMap = ReadSection(raw, "denied", errors, valueCount, valueOrder);
        OrderedDictionary guidsMap = ReadSection(raw, "guids", errors, valueCount, valueOrder);

        foreach (string value in valueOrder)
        {
            if (valueCount[value] > 1)
            {
                errors.Add(string.Format(
                    "Duplicate guid value: '{0}' (a GUID has exactly one entry — and a denied value can never also be registered)", value));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        denied = deniedMap.AsReadOnly();
        guids = guidsMap.AsReadOnly();
    }

    private static OrderedDictionary ReadSection(IDictionary raw, string section, List<string> errors, Dictionary<string, int> valueCount, List<string> valueOrder)
    {
        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        object sectionRaw = raw.Contains(section) ? raw[section] : null;
        if (sectionRaw == null) { return map; }

        IDictionary source = sectionRaw as IDictionary;
        if (source == null)
        {
            errors.Add(string.Format("'{0}' must be a map of <snake_case_name>: {{ guid, description [, sentence] }}", section));
            return map;
        }

        foreach (object k in source.Keys)
        {
            string name = k == null ? "" : k.ToString();
            ManagedGuidEntry entry;
            try { entry = new ManagedGuidEntry(section, name, source[k]); }
            catch (ArgumentException ex) { errors.Add(ex.Message); continue; }
            map[name] = entry;

            int count;
            if (!valueCount.TryGetValue(entry.guid, out count)) { valueOrder.Add(entry.guid); }
            valueCount[entry.guid] = count + 1;
        }
        return map;
    }
}

/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/types/DictionaryRecord.cs
    kind: csharp-type
    module: Catzc.Base.Objects
    adrs: []
---
*/

// A key counts as present only when its property exists and is non-null, so nulling an optional makes Contains false.
// [comment:1](/docs/references/automation/catzc-base-objects/types/DictionaryRecord.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace Catzc.Base.Objects;

public abstract class DictionaryRecord
{
    // ---- console rendering: one line in pwsh, `Record { a = 1, b = x }` (ConsoleText) ----

    public override string ToString() => this.ToConsoleString();

    // ---- dictionary view over this record's own public, readable, non-indexed properties ----

    public bool Contains(string key)
    {
        PropertyInfo p = GetProp(key);
        return p != null && p.GetValue(this) != null;
    }

    public object this[string key]
    {
        get { PropertyInfo p = GetProp(key); return p == null ? null : p.GetValue(this); }
    }

    public ICollection<string> Keys
    {
        get
        {
            List<string> keys = new List<string>();
            foreach (PropertyInfo p in DataProps()) { if (p.GetValue(this) != null) { keys.Add(p.Name); } }
            return keys;
        }
    }

    public Hashtable ToHashtable()
    {
        Hashtable h = new Hashtable();
        foreach (PropertyInfo p in DataProps()) { object v = p.GetValue(this); if (v != null) { h[p.Name] = v; } }
        return h;
    }

    private PropertyInfo GetProp(string key)
    {
        PropertyInfo p = GetType().GetProperty(key, BindingFlags.Public | BindingFlags.Instance);
        return IsDataProp(p) ? p : null;
    }

    private IEnumerable<PropertyInfo> DataProps()
    {
        foreach (PropertyInfo p in GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (IsDataProp(p)) { yield return p; }
        }
    }

    // Skipping the base's own view members is what stops Keys and ToHashtable from recursing into get_Keys forever.
    // [comment:2](/docs/references/automation/catzc-base-objects/types/DictionaryRecord.cs.md#comment2)
    private static bool IsDataProp(PropertyInfo p)
    {
        return p != null
            && p.CanRead
            && p.GetIndexParameters().Length == 0
            && p.DeclaringType != typeof(DictionaryRecord);
    }

    // ---- protected dictionary-extraction helpers for derived constructors ----

    protected static string Req(IDictionary d, string key)
    {
        object v = (d != null && d.Contains(key)) ? d[key] : null;
        if (v == null || string.IsNullOrWhiteSpace(v.ToString()))
        {
            throw new ArgumentException(key + " is required");
        }
        return v.ToString();
    }

    protected static string OptStr(IDictionary d, string key)
    {
        object v = (d != null && d.Contains(key)) ? d[key] : null;
        return (v == null || string.IsNullOrWhiteSpace(v.ToString())) ? null : v.ToString();
    }

    protected static string[] StrArr(IDictionary d, string key)
    {
        object v = (d != null && d.Contains(key)) ? d[key] : null;
        if (v == null) { return new string[0]; }
        if (v is string) { return new[] { (string)v }; }
        IEnumerable en = v as IEnumerable;
        if (en == null) { return new[] { v.ToString() }; }
        List<string> list = new List<string>();
        foreach (object item in en) { if (item != null) { list.Add(item.ToString()); } }
        return list.ToArray();
    }

    protected static bool Flag(IDictionary d, string key)
    {
        object v = (d != null && d.Contains(key)) ? d[key] : null;
        if (v == null) { return false; }
        if (v is bool) { return (bool)v; }
        bool parsed;
        return bool.TryParse(v.ToString(), out parsed) && parsed;
    }
}

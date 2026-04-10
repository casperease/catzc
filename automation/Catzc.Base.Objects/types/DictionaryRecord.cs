// The shared base for typed data records that mirror an [ordered]@{} / [pscustomobject] config shape. It
// is the single base every such record across the codebase derives from (there is no per-module copy), and
// it gives a record two capabilities a loose dictionary had for free:
//
//   1. A dictionary VIEW over the record's own public properties, so it still splats and serializes like a
//      dictionary (ConvertTo-Json/-Yaml): Contains(key), the [key] indexer, Keys, ToHashtable(). "Present"
//      means the public property exists AND its value is non-null — mirroring the omitted-key idiom of the
//      ordered dictionaries these records replace, so setting an absent optional to null makes
//      Contains(key) false.
//   2. protected static extraction helpers (Req / OptStr / StrArr / Flag) a derived constructor uses to read
//      its source IDictionary, so the read-and-validate logic is defined once here, not per record.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace Catzc.Base.Objects;

public abstract class DictionaryRecord
{
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

    // A "data" property is one the DERIVED record declares — not this base's own view members (Keys, the
    // indexer). Excluding them is also what stops Keys/ToHashtable from recursing into get_Keys() forever.
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

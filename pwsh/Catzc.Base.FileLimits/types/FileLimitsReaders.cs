using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.FileLimits;

// The readers FileLimitsConfig validates its YAML with, each adding to the one error list the constructor throws.
public static class FileLimitsReaders
{
    public static readonly string[] LimitKeys = { "length", "width" };
    public static readonly string[] BoundKeys = { "min", "max" };

    public static void CheckKeys(IDictionary map, string[] allowed, string where, List<string> errors)
    {
        foreach (object key in map.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (Array.IndexOf(allowed, name) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", where, name, string.Join(", ", allowed)));
            }
        }
    }

    public static IDictionary Section(IDictionary map, string key, List<string> errors)
    {
        if (!map.Contains(key) || map[key] == null)
        {
            return null;
        }

        if (map[key] is IDictionary section)
        {
            return section;
        }

        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a map", key));
        return null;
    }

    public static int? ReadWhole(IDictionary map, string key, string where, List<string> errors)
    {
        if (!map.Contains(key) || map[key] == null)
        {
            return null;
        }

        object value = map[key];
        if (value is int || value is long || value is short || value is byte)
        {
            long parsed = Convert.ToInt64(value, CultureInfo.InvariantCulture);
            if (parsed >= 1 && parsed <= int.MaxValue)
            {
                return (int)parsed;
            }
        }

        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}.{1} '{2}' must be a positive whole number", where, key, value));
        return null;
    }

    public static void ReadBound(IDictionary bounds, string key, ref int min, ref int max, List<string> errors)
    {
        IDictionary range = Section(bounds, key, errors);
        if (range == null)
        {
            return;
        }

        CheckKeys(range, BoundKeys, "bounds." + key, errors);
        min = ReadWhole(range, "min", "bounds." + key, errors) ?? min;
        max = ReadWhole(range, "max", "bounds." + key, errors) ?? max;
    }

    public static FileLimit ReadLimit(object value, string where, List<string> errors)
    {
        if (!(value is IDictionary map))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a map of length and width", where));
            return null;
        }

        CheckKeys(map, LimitKeys, where, errors);
        return new FileLimit(ReadWhole(map, "length", where, errors), ReadWhole(map, "width", where, errors));
    }

    public static void CheckInBounds(string where, FileLimit limit, int lengthMin, int lengthMax, int widthMin, int widthMax, List<string> errors)
    {
        if (limit.length.HasValue && (limit.length < lengthMin || limit.length > lengthMax))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}.length {1} is outside the bounds {2} to {3}", where, limit.length, lengthMin, lengthMax));
        }

        if (limit.width.HasValue && (limit.width < widthMin || limit.width > widthMax))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}.width {1} is outside the bounds {2} to {3}", where, limit.width, widthMin, widthMax));
        }
    }
}

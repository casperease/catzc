using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.FileLimits;

public sealed class FileLimitsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const int DefaultLengthMin = 100;
    public const int DefaultLengthMax = 500;
    public const int DefaultWidthMin = 80;
    public const int DefaultWidthMax = 200;

    public static readonly string[] Classes = { "code", "config", "prose" };

    private static readonly string[] AllowedKeys = { "bounds", "defaults", "languages" };
    private static readonly string[] LimitKeys = { "length", "width" };
    private static readonly string[] BoundKeys = { "min", "max" };

    private static readonly Dictionary<string, FileLimit> DefaultLimits = new Dictionary<string, FileLimit>(StringComparer.Ordinal)
    {
        ["code"] = new FileLimit(400, 120),
        ["config"] = new FileLimit(300, 140),
        ["prose"] = new FileLimit(400, 140),
    };

    public int length_min { get; }
    public int length_max { get; }
    public int width_min { get; }
    public int width_max { get; }
    public IReadOnlyDictionary<string, FileLimit> defaults { get; }
    public IReadOnlyDictionary<string, FileLimit> languages { get; }

    public FileLimitsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        int lengthMin = DefaultLengthMin, lengthMax = DefaultLengthMax, widthMin = DefaultWidthMin, widthMax = DefaultWidthMax;
        Dictionary<string, FileLimit> defaultsValue = new Dictionary<string, FileLimit>(DefaultLimits, StringComparer.Ordinal);
        Dictionary<string, FileLimit> languagesValue = new Dictionary<string, FileLimit>(StringComparer.Ordinal);

        if (raw != null)
        {
            CheckKeys(raw, AllowedKeys, "file-limits", errors);

            IDictionary bounds = Section(raw, "bounds", errors);
            if (bounds != null)
            {
                CheckKeys(bounds, LimitKeys, "bounds", errors);
                ReadBound(bounds, "length", ref lengthMin, ref lengthMax, errors);
                ReadBound(bounds, "width", ref widthMin, ref widthMax, errors);
            }

            IDictionary defaultsRaw = Section(raw, "defaults", errors);
            if (defaultsRaw != null)
            {
                CheckKeys(defaultsRaw, Classes, "defaults", errors);
                foreach (string name in Classes)
                {
                    if (defaultsRaw.Contains(name) && defaultsRaw[name] != null)
                    {
                        FileLimit given = ReadLimit(defaultsRaw[name], "defaults." + name, errors);
                        if (given != null)
                        {
                            FileLimit shipped = DefaultLimits[name];
                            defaultsValue[name] = new FileLimit(given.length ?? shipped.length, given.width ?? shipped.width);
                        }
                    }
                }
            }

            IDictionary languagesRaw = Section(raw, "languages", errors);
            if (languagesRaw != null)
            {
                foreach (object key in languagesRaw.Keys)
                {
                    string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(name))
                    {
                        errors.Add("languages: a language name must not be blank");
                        continue;
                    }

                    FileLimit given = ReadLimit(languagesRaw[key], "languages." + name, errors);
                    if (given != null)
                    {
                        languagesValue[name] = given;
                    }
                }
            }
        }

        if (lengthMin > lengthMax)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "bounds.length: min {0} is above max {1}", lengthMin, lengthMax));
        }

        if (widthMin > widthMax)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "bounds.width: min {0} is above max {1}", widthMin, widthMax));
        }

        foreach (KeyValuePair<string, FileLimit> pair in defaultsValue)
        {
            CheckInBounds("defaults." + pair.Key, pair.Value, lengthMin, lengthMax, widthMin, widthMax, errors);
        }

        foreach (KeyValuePair<string, FileLimit> pair in languagesValue)
        {
            CheckInBounds("languages." + pair.Key, pair.Value, lengthMin, lengthMax, widthMin, widthMax, errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("file-limits configuration validation failed:\n" + string.Join("\n", errors));
        }

        length_min = lengthMin;
        length_max = lengthMax;
        width_min = widthMin;
        width_max = widthMax;
        defaults = defaultsValue;
        languages = languagesValue;
    }

    private static void CheckKeys(IDictionary map, string[] allowed, string where, List<string> errors)
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

    private static IDictionary Section(IDictionary map, string key, List<string> errors)
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

    private static int? ReadWhole(IDictionary map, string key, string where, List<string> errors)
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

    private static void ReadBound(IDictionary bounds, string key, ref int min, ref int max, List<string> errors)
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

    private static FileLimit ReadLimit(object value, string where, List<string> errors)
    {
        if (!(value is IDictionary map))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a map of length and width", where));
            return null;
        }

        CheckKeys(map, LimitKeys, where, errors);
        return new FileLimit(ReadWhole(map, "length", where, errors), ReadWhole(map, "width", where, errors));
    }

    private static void CheckInBounds(string where, FileLimit limit, int lengthMin, int lengthMax, int widthMin, int widthMax, List<string> errors)
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

// A generated png's stamp: one tEXt chunk keyed catzc right after the IHDR chunk, written and stripped by hand in BCL, its CRC included.

using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.Languages;

public static class PngTextCarrier
{
    // The tEXt keyword of the stamp chunk.
    public const string Keyword = "catzc";

    private static readonly byte[] Signature = { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A };
    private static readonly uint[] CrcTable = BuildCrcTable();

    // True when the bytes open with the png signature.
    public static bool IsPng(byte[] bytes)
    {
        if (bytes == null || bytes.Length < Signature.Length) { return false; }
        for (int i = 0; i < Signature.Length; i++)
        {
            if (bytes[i] != Signature[i]) { return false; }
        }
        return true;
    }

    // The image without any catzc tEXt chunk, which the body hash hashes; every other byte is kept as it is.
    public static byte[] Body(byte[] png)
    {
        List<byte> body = new List<byte>(Signature);
        foreach (Chunk chunk in Chunks(png))
        {
            if (!IsStamp(png, chunk)) { body.AddRange(Slice(png, chunk.Start, chunk.End - chunk.Start)); }
        }
        return body.ToArray();
    }

    // The image with the stamp text as its one catzc tEXt chunk, right after IHDR; a stamp already there is replaced, so a second run changes nothing.
    public static byte[] With(byte[] png, string text)
    {
        byte[] data = ChunkData(text);
        byte[] body = Body(png);
        List<Chunk> chunks = Chunks(body);
        if (chunks.Count == 0 || chunks[0].Type != "IHDR") { throw new ArgumentException("a png opens with its IHDR chunk"); }
        List<byte> stamped = new List<byte>(Slice(body, 0, chunks[0].End));
        stamped.AddRange(Encode("tEXt", data));
        stamped.AddRange(Slice(body, chunks[0].End, body.Length - chunks[0].End));
        return stamped.ToArray();
    }

    // The text of the catzc tEXt chunk, or null when the image has none.
    public static string Text(byte[] png)
    {
        foreach (Chunk chunk in Chunks(png))
        {
            if (IsStamp(png, chunk))
            {
                int skip = Keyword.Length + 1;
                return Encoding.Latin1.GetString(png, chunk.DataStart + skip, chunk.Length - skip);
            }
        }
        return null;
    }

    // The 12 hex digits of the SHA-256 of the bytes, the same width as a text body hash.
    public static string HashOf(byte[] body)
    {
        byte[] hash = SHA256.HashData(body ?? Array.Empty<byte>());
        StringBuilder hex = new StringBuilder();
        for (int i = 0; i < 6; i++) { hex.Append(hash[i].ToString("x2")); }
        return hex.ToString();
    }

    // The CRC-32 a png chunk closes with, over its type and data.
    public static uint Crc(byte[] bytes, int start, int count)
    {
        uint crc = 0xFFFFFFFFu;
        for (int i = start; i < start + count; i++) { crc = CrcTable[(crc ^ bytes[i]) & 0xFF] ^ (crc >> 8); }
        return crc ^ 0xFFFFFFFFu;
    }

    // tEXt holds Latin-1 only, so a character past it is refused rather than written as a question mark.
    private static byte[] ChunkData(string text)
    {
        string value = text ?? string.Empty;
        foreach (char c in value)
        {
            if (c > 'ÿ') { throw new ArgumentException(string.Format("the png stamp holds Latin-1 only, and '{0}' is past it", c)); }
        }
        return Encoding.Latin1.GetBytes(Keyword + "\0" + value);
    }

    private static bool IsStamp(byte[] png, Chunk chunk)
    {
        if (chunk.Type != "tEXt" || chunk.Length <= Keyword.Length) { return false; }
        for (int i = 0; i < Keyword.Length; i++)
        {
            if (png[chunk.DataStart + i] != (byte)Keyword[i]) { return false; }
        }
        return png[chunk.DataStart + Keyword.Length] == 0;
    }

    private static List<Chunk> Chunks(byte[] png)
    {
        if (!IsPng(png)) { throw new ArgumentException("the bytes are no png: they do not open with its signature"); }
        List<Chunk> chunks = new List<Chunk>();
        int at = Signature.Length;
        while (at < png.Length)
        {
            if (at + 12 > png.Length) { throw new ArgumentException(string.Format("the png is cut short in the chunk at byte {0}", at)); }
            long length = ((long)png[at] << 24) | ((long)png[at + 1] << 16) | ((long)png[at + 2] << 8) | png[at + 3];
            if (at + 12 + length > png.Length) { throw new ArgumentException(string.Format("the png is cut short in the chunk at byte {0}", at)); }
            string type = Encoding.ASCII.GetString(png, at + 4, 4);
            chunks.Add(new Chunk(type, at, (int)length));
            at += 12 + (int)length;
        }
        return chunks;
    }

    private static byte[] Encode(string type, byte[] data)
    {
        byte[] chunk = new byte[12 + data.Length];
        WriteBigEndian(chunk, 0, (uint)data.Length);
        Encoding.ASCII.GetBytes(type, 0, 4, chunk, 4);
        Array.Copy(data, 0, chunk, 8, data.Length);
        WriteBigEndian(chunk, 8 + data.Length, Crc(chunk, 4, 4 + data.Length));
        return chunk;
    }

    private static void WriteBigEndian(byte[] bytes, int at, uint value)
    {
        bytes[at] = (byte)(value >> 24);
        bytes[at + 1] = (byte)(value >> 16);
        bytes[at + 2] = (byte)(value >> 8);
        bytes[at + 3] = (byte)value;
    }

    private static byte[] Slice(byte[] bytes, int start, int count)
    {
        byte[] slice = new byte[count];
        Array.Copy(bytes, start, slice, 0, count);
        return slice;
    }

    private static uint[] BuildCrcTable()
    {
        uint[] table = new uint[256];
        for (uint n = 0; n < 256; n++)
        {
            uint c = n;
            for (int k = 0; k < 8; k++) { c = (c & 1) != 0 ? 0xEDB88320u ^ (c >> 1) : c >> 1; }
            table[n] = c;
        }
        return table;
    }

    private readonly struct Chunk
    {
        public Chunk(string type, int start, int length)
        {
            Type = type;
            Start = start;
            Length = length;
        }

        public string Type { get; }

        public int Start { get; }

        public int Length { get; }

        public int DataStart => Start + 8;

        public int End => Start + 12 + Length;
    }
}

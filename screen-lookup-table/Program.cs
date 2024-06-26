﻿using System.Runtime.CompilerServices;

public class CreateScreenLookupTable
{
    private const ushort BASE_ADDRESS = 0xC000;
    private const int OUTPUT_ROW_SIZE = 8;

    private const string INCLUDE_FILENAME = "y_mem_row_lookup.asm";

    //  15 14 13 12 11 10 9  8    7  6  5  4  3  2  1  0
    // 0  1  0  Y7 Y6 Y2 Y1 Y0   Y5 Y4 Y3 X7 X6 X5 X4 X3
    private static void yLookupTable(string outputDirectory)
    {
        var fileOutput = new StreamWriter(Path.Combine(outputDirectory, INCLUDE_FILENAME));

        var addresses = new List<ushort>();
        fileOutput.WriteLine("_Y_MEM_ROW_LOOKUP:");
        for (ushort y = 0; y < 192; y++)
        {
            ushort y3to5 = (ushort)((y & 0b00111000) << 2);
            ushort y0to2 = (ushort)((y & 0b00000111) << 8);
            ushort y6to7 = (ushort)((y & 0b11000000) << 5);

            ushort yAddress = (ushort)(BASE_ADDRESS | y3to5 | y0to2 | y6to7);

            addresses.Add(yAddress);
            if (((y + 1) % (OUTPUT_ROW_SIZE)) == 0)
            {
                fileOutput.WriteLine($"\tWORD {String.Join(", ", addresses.Select(a => $"0x{a:X4}"))}");
                addresses.Clear();
            }
        }

        fileOutput.Close();
    }

    public static void Main(string[] args)
    {
        var outputDirectory = args[0];
        yLookupTable(outputDirectory);
    }
}

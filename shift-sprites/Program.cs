using System.Text;
class ShiftSprites
{
    public static void Main(string[] args)
    {
        var inputDirectory = args[0];
        var outputDirectory = (args.Length > 1) ? args[1] : "";
        var shiftStep = (args.Length > 2) ? int.Parse(args[2]) : 2;

        Console.WriteLine($"Processing sprites from: '{inputDirectory}'");
        Console.WriteLine($"Writing output to: '{outputDirectory}'");
        Console.WriteLine($"With shift steps of size: '{shiftStep}'");
        Console.WriteLine();

        if (!Directory.Exists(outputDirectory))
        {
            Directory.CreateDirectory(outputDirectory);
        }

        foreach (var inputFilename in Directory.GetFiles(inputDirectory))
        {
            ProcessSprite(inputFilename, outputDirectory, shiftStep);
            Console.WriteLine();
        }
    }

    public static void ProcessSprite(string inputFileName, string outputDirectory = "", int shiftStep = 1)
    {
        // Read the entire sprite file
        var spriteText = File.ReadAllLines(inputFileName).Select(x => x.Trim()).ToList();
        var spriteName = Path.GetFileNameWithoutExtension(inputFileName);

        // Output
        var outputFilename = Path.Combine(outputDirectory, $"{spriteName}.asm");
        var fileOutput = new StreamWriter(outputFilename);

        // How wide is the sprite (assumes all lines are consistent)
        var sourceBitWidth = spriteText.First().Length;
        var destByteWidth = sourceBitWidth / 8 + 1;

        Console.WriteLine($"Source filename: '{Path.GetFileName(inputFileName)}'");
        Console.WriteLine($"Source bit width: {sourceBitWidth}");
        Console.WriteLine($"Output byte width: {destByteWidth}");
        Console.WriteLine($"Output filename: '{Path.GetFileName(outputFilename)}'");

        for (var xOffset = 0; xOffset < 8; xOffset += shiftStep)
        {
            fileOutput.WriteLine($"{spriteName}_{xOffset}:\tWORD 0x{destByteWidth:X2}{spriteText.Count:X2}");
            foreach (var line in spriteText)
            {
                var buffer = new StringBuilder(new String('0', sourceBitWidth + 8));
                var fullOutputLine = buffer.Insert(xOffset, line).ToString().Substring(0, sourceBitWidth + 8);

                fileOutput.Write("\t\tBYTE ");
                for (var byteCount = 0; byteCount < destByteWidth; byteCount++)
                {
                    fileOutput.Write($"0b" + fullOutputLine.Substring(byteCount * 8, 8));
                    if (byteCount != sourceBitWidth / 8)
                    {
                        fileOutput.Write(", ");
                    }
                }
                fileOutput.WriteLine();
            }
            fileOutput.WriteLine();
        }

        fileOutput.Close();
    }
}

using System.Reflection.Metadata;
using System.Runtime.ConstrainedExecution;
using System.Text;
class ShiftSprites
{
    private const string INCLUDE_FILENAME = "all_sprites.asm";
    private const string HEADER_MESSAGE = "; This file was automatically generated, DO NOT MODIFY";
    private const string SPRITE_MODULE_NAME = "sprites";

    public static void Main(string[] args)
    {
        var inputDirectory = args[0];
        var outputDirectory = (args.Length > 1) ? args[1] : "";
        var shiftStep = (args.Length > 2) ? int.Parse(args[2]) : 1;

        Console.WriteLine($"Processing sprites from: '{inputDirectory}'");
        Console.WriteLine($"Writing output to: '{outputDirectory}'");
        Console.WriteLine($"With shift steps of size: '{shiftStep}'");
        Console.WriteLine();

        if (!Directory.Exists(outputDirectory))
        {
            Directory.CreateDirectory(outputDirectory);
        }

        var outputFiles = new List<string>();
        foreach (var inputFilename in Directory.GetFiles(inputDirectory))
        {
            var outputFilename = ProcessSprite(inputFilename, outputDirectory, shiftStep);
            outputFiles.Add(outputFilename);
            Console.WriteLine();
        }

        CreateIncludeFile(outputFiles, outputDirectory);
    }

    public static void CreateIncludeFile(List<string> outputFiles, string outputDirectory)
    {
        var fileOutput = new StreamWriter(Path.Combine(outputDirectory, INCLUDE_FILENAME));

        fileOutput.WriteLine(HEADER_MESSAGE);
        fileOutput.WriteLine();

        outputFiles.ForEach(filename =>
        {
            fileOutput.WriteLine($"\tINCLUDE \"{filename.Replace('\\', '/')}\"");
        });

        fileOutput.Close();
    }

    public static string ProcessSprite(string inputFileName, string outputDirectory = "", int shiftStep = 1)
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

        fileOutput.WriteLine(HEADER_MESSAGE);
        fileOutput.WriteLine();
        fileOutput.WriteLine($"\tMODULE {SPRITE_MODULE_NAME}");
        fileOutput.WriteLine();

        // Lookup table for shifted sprites
        var lookupTable = new List<string>();
        for (var xOffset = 0; xOffset < 8; xOffset += shiftStep)
        {
            var shiftedSpriteName = $"{spriteName}_{xOffset}";
            fileOutput.WriteLine($"{shiftedSpriteName}:");
            lookupTable.Add(shiftedSpriteName);

            foreach (var line in spriteText)
            {
                var buffer = new StringBuilder(new String('0', sourceBitWidth + 8));
                var fullOutputLine = buffer.Insert(xOffset, line).ToString().Substring(0, sourceBitWidth + 8);

                fileOutput.Write("\tBYTE ");
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
        fileOutput.WriteLine("; Dimensions x (bytes) y (pixels)");
        fileOutput.WriteLine($"{spriteName}_dims:\tWORD 0x{destByteWidth:X2}{spriteText.Count:X2}");
        fileOutput.WriteLine();

        fileOutput.WriteLine("; Lookup table");
        fileOutput.WriteLine($"{spriteName}:\n\tWORD {String.Join(", ", lookupTable)}");

        fileOutput.WriteLine();
        fileOutput.WriteLine($"\tENDMODULE");

        fileOutput.Close();

        return outputFilename;
    }
}

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
            var spriteFilename = ProcessSprite(inputFilename, outputDirectory, shiftStep, false);
            var blankFilename = ProcessSprite(inputFilename, outputDirectory, shiftStep, true);
            outputFiles.Add(spriteFilename);
            outputFiles.Add(blankFilename);
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


    public static string ProcessSprite(string inputFileName, string outputDirectory = "", int shiftStep = 1, bool isBlank = false)
    {
        // Read the entire sprite file
        var allText = File.ReadAllLines(inputFileName).Select(x => x.Trim()).ToList();

        // Swap out characters that make the text more readable for binary values
        for (int lineIndex = 0; lineIndex < allText.Count; lineIndex++)
        {
            allText[lineIndex] = allText[lineIndex].Replace('-', '0').Replace('X', '1');
        }

        // Slice the file into the mask text and the sprite text
        var blankLineIndex = allText.FindIndex(x => x.Trim().Length == 0);

        var maskText = allText.GetRange(0, blankLineIndex);
        var spriteText = allText.GetRange(blankLineIndex + 1, allText.Count() - blankLineIndex - 1);

        var spriteName = Path.GetFileNameWithoutExtension(inputFileName);
        if (isBlank)
        {
            spriteName = $"{spriteName}_blank";
        }

        // Output
        var spriteOutputFilename = Path.Combine(outputDirectory, $"{spriteName}.asm");
        var spriteFileOutput = new StreamWriter(spriteOutputFilename);

        // How wide is the sprite (assumes all lines are consistent)
        var sourceBitWidth = spriteText.First().Length;
        var destByteWidth = sourceBitWidth / 8 + 1;

        Console.WriteLine($"Source filename: '{Path.GetFileName(inputFileName)}'");
        Console.WriteLine($"Source bit width: {sourceBitWidth}");
        Console.WriteLine($"Output byte width: {destByteWidth}");
        Console.WriteLine($"Spite rows: {spriteText.Count()}");
        Console.WriteLine($"Output filename: '{Path.GetFileName(spriteOutputFilename)}'");

        spriteFileOutput.WriteLine(HEADER_MESSAGE);
        spriteFileOutput.WriteLine();
        spriteFileOutput.WriteLine($"\tMODULE {SPRITE_MODULE_NAME}");
        spriteFileOutput.WriteLine();

        // Lookup table for shifted sprites
        var spriteLookupTable = new List<string>();
        var blankLookupTable = new List<string>();

        // One block of data for each shifted position
        for (var xOffset = 0; xOffset < 8; xOffset += shiftStep)
        {
            var shiftedSpriteName = $"{spriteName}_{xOffset}";
            spriteFileOutput.WriteLine($"{shiftedSpriteName}:");
            spriteLookupTable.Add(shiftedSpriteName);

            // Each line in the sprite data
            for (var index = 0; index < maskText.Count(); index++)
            {
                var maskLine = maskText[index];
                var maskBuffer = new StringBuilder(new String('1', sourceBitWidth + 8));
                var maskOutputLine = maskBuffer.Insert(xOffset, maskLine).ToString().Substring(0, sourceBitWidth + 8);

                var spriteLine = spriteText[index];
                var spriteBuffer = new StringBuilder(new String('0', sourceBitWidth + 8));
                var spriteOutputLine = spriteBuffer.Insert(xOffset, spriteLine).ToString().Substring(0, sourceBitWidth + 8);

                spriteFileOutput.WriteLine($"\t; Line {index}");
                for (var byteCount = 0; byteCount < destByteWidth; byteCount++)
                {
                    spriteFileOutput.WriteLine($"\tBYTE 0b" + maskOutputLine.Substring(byteCount * 8, 8));

                    if (!isBlank)
                    {
                        spriteFileOutput.WriteLine($"\tBYTE 0b" + spriteOutputLine.Substring(byteCount * 8, 8));
                    }
                    else
                    {
                        spriteFileOutput.WriteLine($"\tBYTE 0b00000000");
                    }
                }
                spriteFileOutput.WriteLine();
            }
            spriteFileOutput.WriteLine();
        }
        spriteFileOutput.WriteLine("; Dimensions x (bytes) y (pixels)");
        spriteFileOutput.WriteLine($"{spriteName}_dims:\tEQU 0x{destByteWidth:X2}{spriteText.Count:X2}");
        spriteFileOutput.WriteLine($"{spriteName}_dim_x_bytes:\tEQU 0x{destByteWidth:X2}");
        spriteFileOutput.WriteLine($"{spriteName}_dim_y_pixels:\tEQU 0x{spriteText.Count:X2}");

        spriteFileOutput.WriteLine();

        spriteFileOutput.WriteLine("; Lookup table");
        spriteFileOutput.WriteLine($"{spriteName}:\n\tWORD {String.Join(", ", spriteLookupTable)}");

        spriteFileOutput.WriteLine();
        spriteFileOutput.WriteLine($"\tENDMODULE");

        spriteFileOutput.Close();

        return spriteOutputFilename;
    }
}

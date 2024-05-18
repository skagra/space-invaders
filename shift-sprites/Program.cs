using System.Text;
class ShiftSprites
{
    private const string INCLUDE_FILENAME = "module.asm";
    private const string HEADER_MESSAGE = "; This file was automatically generated, DO NOT MODIFY";
    private const string SPRITE_MODULE_NAME = "sprites";
    private const string MEM_USAGE_LABEL = "_module_start";

    public static void Main(string[] args)
    {
        var inputDirectory = args[0];
        var outputDirectory = (args.Length > 1) ? args[1] : "";

        Console.WriteLine($"Processing sprites from: '{inputDirectory}'");
        Console.WriteLine($"Writing output to: '{outputDirectory}'");
        Console.WriteLine();

        if (!Directory.Exists(outputDirectory))
        {
            Directory.CreateDirectory(outputDirectory);
        }

        var outputFiles = new List<string>();
        foreach (var inputFilename in Directory.GetFiles(inputDirectory))
        {
            var spriteFilename = ProcessSprite(inputFilename, outputDirectory); // , false);
            // var blankFilename = ProcessSprite(inputFilename, outputDirectory, true);
            outputFiles.Add(spriteFilename);
            //    outputFiles.Add(blankFilename);
            Console.WriteLine();
        }

        CreateIncludeFile(outputFiles, outputDirectory);
    }

    public static void CreateIncludeFile(List<string> outputFiles, string outputDirectory)
    {
        var fileOutput = new StreamWriter(Path.Combine(outputDirectory, INCLUDE_FILENAME));

        fileOutput.WriteLine(HEADER_MESSAGE);
        fileOutput.WriteLine();

        fileOutput.WriteLine($"\tMODULE {SPRITE_MODULE_NAME}");
        fileOutput.WriteLine();

        fileOutput.WriteLine($"{MEM_USAGE_LABEL}:");
        fileOutput.WriteLine();

        outputFiles.ForEach(filename =>
        {
            fileOutput.WriteLine($"\tINCLUDE \"{filename.Replace('\\', '/')}\"");
        });

        fileOutput.WriteLine();
        fileOutput.WriteLine($"\tMEMORY_USAGE \"sprites         \",{MEM_USAGE_LABEL}");

        fileOutput.WriteLine();
        fileOutput.WriteLine($"\tENDMODULE");

        fileOutput.Close();
    }

    public static string ProcessSprite(string inputFileName, string outputDirectory = "") //, bool isBlank = false)
    {
        // Read the entire sprite file
        var allText = File.ReadAllLines(inputFileName).Select(x => x.Trim()).ToList();

        // Read the offset setting
        var dataStartIndex = 0;
        while (!allText[dataStartIndex].StartsWith("offset:"))
        {
            dataStartIndex++;
        }
        var shiftStep = int.Parse(allText[dataStartIndex].Split(':')[1]);

        dataStartIndex += 2;

        // Swap out characters that make the text more readable for binary values
        for (int lineIndex = dataStartIndex; lineIndex < allText.Count; lineIndex++)
        {
            allText[lineIndex] = allText[lineIndex].Replace('-', '0').Replace('X', '1');
        }

        // Slice the file into the mask text and the sprite text
        var blankLineIndex = allText.FindIndex(dataStartIndex, x => x.Trim().Length == 0);

        var maskText = allText.GetRange(dataStartIndex, blankLineIndex - 2);
        var spriteText = allText.GetRange(blankLineIndex + 1, allText.Count() - blankLineIndex - 1);

        var spriteName = Path.GetFileNameWithoutExtension(inputFileName);
        // if (isBlank)
        // {
        //     spriteName = $"{spriteName}_blank";
        // }

        // Output
        var spriteOutputFilename = Path.Combine(outputDirectory, $"{spriteName}.asm");
        var spriteFileOutput = new StreamWriter(spriteOutputFilename);

        // All labels should be uppercase
        spriteName = spriteName.ToUpper();

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

        // Lookup table for shifted sprites
        var spriteLookupTable = new List<string>();
        //var blankLookupTable = new List<string>();

        // One block of data for each shifted position
        for (var xOffset = 0; xOffset < 8; xOffset += shiftStep)
        {
            var shiftedSpriteName = $"{spriteName}_{xOffset}";
            spriteFileOutput.WriteLine($"{shiftedSpriteName}:");

            for (int i = 0; i < shiftStep; i++)
            {
                spriteLookupTable.Add(shiftedSpriteName);
            }

            spriteFileOutput.Write("\t     ;");
            for (var byteCount = 0; byteCount < destByteWidth; byteCount++)
            {
                spriteFileOutput.Write("  Mask       Sprite     ");
            }
            spriteFileOutput.WriteLine();

            // Each line in the sprite data
            for (var index = 0; index < maskText.Count(); index++)
            {
                var maskLine = maskText[index];
                var maskBuffer = new StringBuilder(new String('1', sourceBitWidth + 8));
                var maskOutputLine = maskBuffer.Insert(xOffset, maskLine).ToString().Substring(0, sourceBitWidth + 8);

                var spriteLine = spriteText[index];
                var spriteBuffer = new StringBuilder(new String('0', sourceBitWidth + 8));
                var spriteOutputLine = spriteBuffer.Insert(xOffset, spriteLine).ToString().Substring(0, sourceBitWidth + 8);

                spriteFileOutput.Write("\tBYTE ");
                for (var byteCount = 0; byteCount < destByteWidth; byteCount++)
                {
                    spriteFileOutput.Write($"0b{maskOutputLine.Substring(byteCount * 8, 8)}, ");

                    // if (!isBlank)
                    // {
                    spriteFileOutput.Write($"0b{spriteOutputLine.Substring(byteCount * 8, 8)}");
                    // }
                    // else
                    // {
                    //     spriteFileOutput.Write($"0b00000000");
                    // }
                    if (byteCount != destByteWidth - 1)
                    {
                        spriteFileOutput.Write(", ");
                    }
                    else
                    {
                        spriteFileOutput.Write($" ; Row {index}");
                    }

                }
                spriteFileOutput.WriteLine();
            }
            spriteFileOutput.WriteLine();
        }
        spriteFileOutput.WriteLine("; Dimensions x (bytes) y (pixels)");
        spriteFileOutput.WriteLine($"{spriteName}_DIMS:\tEQU 0x{destByteWidth:X2}{spriteText.Count:X2}");
        spriteFileOutput.WriteLine($"{spriteName}_DIM_X_BYTES:\tEQU 0x{destByteWidth:X2}");
        spriteFileOutput.WriteLine($"{spriteName}_DIM_Y_PIXELS:\tEQU 0x{spriteText.Count:X2}");

        spriteFileOutput.WriteLine();

        spriteFileOutput.WriteLine("; Lookup table");
        spriteFileOutput.WriteLine($"{spriteName}:\n\tWORD {String.Join(", ", spriteLookupTable)}");

        spriteFileOutput.Close();

        return spriteOutputFilename;
    }
}

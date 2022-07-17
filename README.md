# Merlin32-to-Merlin8-16-Converter-Apple-II-
Delphi program to transform Merlin 32 source filles to Merlin8/16 source files, directly usable with Ciderpress

Usage :
Works with Windows

Compile project using Delphi (Project file = SourceConvertor.dpr). I used Delphi 10.4 Community Edition
Or use pre compiled application in : Win32/Debug/SourceConvertor.exe
Launch application
Drag a Mercin32 source file on application. This action set de input file, and define the output file.
You can edit output file name.
Use "Convert" button.

If no error, a now file (output file) is created.

What the applcation does :
Replace all CRLF (carriage linefeed chars) by CR
Suppress all uncessary spaces.
Add 'A2' to file name, before extension.
Add #040000 at the end of file name, so it can be used by Cidepress to import file in an image disk. The file will have TEXT type, no need to manually modify type.


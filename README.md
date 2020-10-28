# DXVersion
DXVersion is a command-line tool that extracts the version info from a given file and offers several options:
- copy : copy the file into the same directory following this pattern:
         file.exe -> file_1.2.3.4.exe (where 1.2.3.4 is the file's version number)
- rename : same as copy, but only renames the original file.
- echo : just echo the file's version number to the command line.
- git : reads the file's version number and assumes that the current directory is a Git working directory and tries to tag using the version number.
- verbose : Print some more details.

## Usage

DXVersion.exe {File to process} {-copy|-echo|-rename|-git} [-verbose]

## Using in Delphi's Post Build Event

To automatically produce a versioned exe file of your application after compiling it, Delphi offers a so-called "Post Build Event", which can be utilized for that purpose. There, you can add command-line tools that will post-process the just compiled/built binary.

The following example assumes that there is a dxversion.exe in c:\tools. It utilizes $(OUTPUTPATH), one of Delphi's built-in variables that holds the full path of the binary that Delphi just produced.

`c:\tools\dxversion.exe $(OUTPUTPATH) -copy`

Note that in this example, the post-build event is set on a "Release" level configuration. This means that the command(s) will not be executed while you are still debugging your application (which I would recommend).

![alt text](https://github.com/omonien/DXVersion/blob/master/docs/Screenshot1.png?raw=true)


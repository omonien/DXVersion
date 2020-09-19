# DXVersion
DXVersion is a command line tool, that extracts the version info from a given file and offers several options:
- copy : copy the file into the same directory following this pattern:
         file.exe -> file_1.2.3.4.exe (1.2.3.4 being the version number
- rename : same as copy, but only renames the original file.
- echo : just echo the file's version number to the command line.
- git : reads the file's version number and assumes that the current directory is agit working directory and tries to tag using the version number.
- verbose : Print some more details.

##Usage
DXVersion.exe {File to process} {-copy|-echo|-rename|-git} [-verbose]

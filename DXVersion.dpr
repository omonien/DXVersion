program DXVersion;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  Classes.Version in 'Classes.Version.pas';

begin
  try
    var
    LFileToProcess := ParamStr(1).Trim;
    var
    LCopy := ParamStr(2).ToLower.Trim = '-copy';
    var
    LRename := ParamStr(2).ToLower.Trim = '-rename';
    var
    LEcho := ParamStr(2).ToLower.Trim = '-echo';
    var
    LVerbose := ParamStr(3).ToLower.Trim = '-verbose';

    if (LFileToProcess = '') or (not LCopy and not LRename and not LEcho) then
    begin
      Writeln('DXVersion 1.1 - (c) 2020, Developer Experts');
      Writeln('-------------------------------------------');
      Writeln('DXVersion processes the given file by extracting its version info (if exists)');
      Writeln('and, depending on selected mode, it will copy or rename the file to match its ');
      Writeln('version number.');
      Writeln('Example: foo.exe with version 1.2.3.4 will be renamed to foo_1.2.3.4.exe.');

      Writeln;
      Writeln('Usage:');
      Writeln('DXVersion.exe {File to process} {-copy|-echo|-rename} [-verbose]');
      Writeln('Modes:');
      Writeln('copy    : The file will be copied into the same directory. The original file is kept.');
      Writeln('echo    : The file''s version info will be echoed.');
      Writeln('rename  : The file will be renamed.');
      Writeln('verbose : Print some details.');
    end
    else
    begin
      var
      LNewFilename := TVersion.Process(LFileToProcess, LCopy, LEcho, LRename);

      if LEcho then
      begin
        if LVerbose then
          Write('Version: ');
        Writeln(LNewFilename);
      end
      else if LVerbose then
      begin
        var
          LMessage: string;
        if LCopy then
        begin
          LMessage := '%s copied to %s';
        end
        else if LRename then
        begin
          LMessage := '%s renamed to %s';
        end;
        Writeln(Format(LMessage, [LFileToProcess, LNewFilename]));
      end;
    end;
  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;

end.

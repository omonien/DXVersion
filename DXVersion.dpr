program DXVersion;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils, DX.Utils.Windows,
  Classes.Version in 'Classes.Version.pas';

begin
  try
    var
    LFileToProcess := ParamStr(1).Trim;
    var
    LCopy := ParamStr(2).ToLower.Trim = '-copy';
    var
    LGit := ParamStr(2).ToLower.Trim = '-git';
    var
    LRename := ParamStr(2).ToLower.Trim = '-rename';
    var
    LEcho := ParamStr(2).ToLower.Trim = '-echo';
    var
    LVerbose := ParamStr(3).ToLower.Trim = '-verbose';

    var
    LVersion := DX.Utils.Windows.GetExeVersion('%d.%d');
    if (LFileToProcess = '') or (not LCopy and not LRename and not LEcho and not LGit) then
    begin
      Writeln('DXVersion ' + LVersion + ' - (c) 2000, Developer Experts');
      Writeln('-------------------------------------------');
      Writeln('DXVersion processes the given file by extracting its version info (if exists)');
      Writeln('and, depending on selected mode, it will copy or rename the file to match its');
      Writeln('version number.');
      Writeln('In git mode the directory of the file is assumed to be a git working directory,');
      Writeln('And will be tagged (git tag) with the file''s version number');
      Writeln('Example: foo.exe with version 1.2.3.4 will be copied/renamed to foo_1.2.3.4.exe.');
      Writeln;
      Writeln('Usage:');
      Writeln('DXVersion.exe {File to process} {-copy|-echo|-rename|-git} [-verbose]');
      Writeln('Modes:');
      Writeln('copy    : The file will be copied into the same directory. The original file is kept.');
      Writeln('echo    : The file''s version info will be echoed.');
      Writeln('rename  : The file will be renamed.');
      Writeln('git     : Create a "tag" using the version number in the current working directory.');
      Writeln('verbose : Print some details.');
      ExitCode := 1;
    end
    else
    begin
      var
      LNewFilename := TVersion.Process(LFileToProcess, LCopy, LEcho, LRename, LGit);

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
        if LGit then
        begin
          LMessage := 'Working directory tagged!';
        end;
        Writeln(Format(LMessage, [LFileToProcess, LNewFilename]));
      end;
    end;
  except
    on E: Exception do
    begin
      Writeln('Error: ', E.Message);
      ExitCode := 1;
    end;
  end;
  if DebugHook <> 0 then
    readln;
end.

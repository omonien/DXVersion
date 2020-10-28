unit Classes.Version;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  TVersion = class(TObject)
  protected
    class procedure GitCheckDirty(const AWorkingDirectory: string);
    class procedure GitTag(const AWorkingDirectory: string; AVersion: string);
  public
    class function Process(const AFilename: string; ACopy, AEcho, ARename, AGit: boolean): string;
  end;

implementation

uses
  System.RegularExpressions,
  DX.Utils.Windows;
{ TRename }

class procedure TVersion.GitCheckDirty(const AWorkingDirectory: string);
var
  LParams: string;
  LResult: string;
begin
  LParams := '-C ' + AWorkingDirectory + ' diff --shortstat';
  LResult := ExecuteCommand('git ' + LParams);
  if LResult.ToLower.Contains('changed') then
    raise Exception.CreateFmt('%s is dirty!'#13#10 + LResult, [AWorkingDirectory]);
end;

class procedure TVersion.GitTag(const AWorkingDirectory: string; AVersion: string);
var
  LVersion: string;
  LParams: string;
  LResult: string;
begin
  LVersion := AVersion.Trim;
  if TDirectory.Exists(AWorkingDirectory) and (LVersion > '') then
  begin
    GitCheckDirty(AWorkingDirectory);
    // git -C %directory% tag -a "%tag%" -m "%message%"
    LParams := '-C "' + AWorkingDirectory + '" tag -a v' + AVersion + ' -m ' + '"Build: ' + AVersion + '"';
    LResult := ExecuteCommand('git ' + LParams);
    if LResult.ToLower.Contains('fatal') then
      raise Exception.CreateFmt('Tagging %s failed!'#13#10 + LResult, [AWorkingDirectory]);
  end;
end;

class function TVersion.Process(const AFilename: string; ACopy, AEcho, ARename, AGit: boolean): string;
var
  LVersion: string;
  LNewFilename: string;
  LFilename: string;
begin
  LFilename := AFilename.Trim;
  if not TFile.Exists(LFilename) then
    raise EFileNotFoundException.CreateFmt('%s not found!', [LFilename])
  else
  begin
    LVersion := GetExeVersion(LFilename);
    // A version number is required obviously
    if LVersion = '' then
      raise Exception.CreateFmt('%s has no version information!', [LFilename]);

    // Do nothing if this file was already renamed
    if not LFilename.EndsWith(LVersion) then
    begin
      // Remove any pre-existing versioning
      // https://regex101.com/r/jVuuJM/1
      LFilename := TRegEx.Replace(LFilename, '(.*)(_\d*\.\d*\.\d*\.\d*)', '\1');

      LNewFilename := Format('%s_%s%s', [
        TPath.GetFileNameWithoutExtension(LFilename),
        LVersion,
        TPath.GetExtension(LFilename) // extension includes "."
        ]);

      LNewFilename := TPath.Combine(TPath.GetDirectoryName(LFilename), LNewFilename);
      result := LNewFilename;
      if ACopy then
      begin
        TFile.Copy(AFilename, LNewFilename, true);
      end
      else if AEcho then
      begin
        result := LVersion;
      end
      else if ARename then
      begin
        if TFile.Exists(LNewFilename) then
        begin
          TFile.Delete(LNewFilename);
        end;
        TFile.Move(AFilename, LNewFilename);
      end
      else if AGit then
      begin
        GitTag(TPath.GetDirectoryName(LFilename), LVersion);
      end;
    end;
  end;
end;

end.

unit Classes.Rename;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  TRename = class(TObject)
  public
    class function RenameToVersion(const AFilename: string; ACopy: boolean = false): string;
  end;

implementation

uses
  System.RegularExpressions,
  DX.Utils.Windows;
{ TRename }

class function TRename.RenameToVersion(const AFilename: string; ACopy: boolean = false): string;
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
    // Do nothing if file has no version information
    if LVersion > '' then
    begin
      // Do nothing if this file was already renamed
      if not LFilename.EndsWith(LVersion) then
      begin
        // Remove any pre-existin versioning
        // https://regex101.com/r/jVuuJM/1
        LFilename := TRegEx.Replace(LFilename, '(.*)(_\d*\.\d*\.\d*\.\d*)', '\1');

        LNewFilename := Format('%s_%s%s', [
          TPath.GetFileNameWithoutExtension(LFilename),
          LVersion,
          TPath.GetExtension(LFilename) // extension includes "."
          ]);

        LNewFilename := TPath.Combine(TPath.GetDirectoryName(LFilename), LNewFilename);
        if ACopy then
        begin
          TFile.Copy(AFilename, LNewFilename, true);
        end
        else
        begin
          TFile.Move(AFilename, LNewFilename);
        end;
        result := LNewFilename;
      end;
    end;
  end;
end;

end.

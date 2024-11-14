unit Database.Enums;
interface
type
  TDatabaseDriver = (ddFiredac, ddDBExpress);
  TDatabaseDriverHelper = record helper for TDatabaseDriver
    function ToString: String;
  end;
  TDatabaseDriverAtual = class
    class function GetTDatabaseDriverAtual: TDatabaseDriver;
  end;

implementation
function TDatabaseDriverHelper.ToString: String;
begin
  if Self = ddFiredac then
    Result := 'Firebird'
  else
    Result := 'FB'
end;

{ TDatabaseDriverAtual }

class function TDatabaseDriverAtual.GetTDatabaseDriverAtual: TDatabaseDriver;
begin
  Result := ddFiredac;
end;

end.

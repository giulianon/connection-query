unit Database.Connection.Firedac;
interface
uses
  Data.DB,
  Database.Connection.Interfaces,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.FB,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat,  
  FireDAC.DApt,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.Classes,
  System.SysUtils,  
  FireDAC.Comp.UI,
  Variants;
type
  TConnectionFiredac = class(TInterfacedObject, IConnection)
  private
      FConnection: TFDConnection;
      FConnectionFree: Boolean;
      FDataSource: TDataSource;
      FQuery: TFDQuery;
      function GetConnection: TFDConnection;
  public
      constructor Create(const Params: IConnectionParams); overload;
      constructor Create; overload;
      constructor Create(const Connection: IConnection); overload;
      destructor Destroy; override;
      function Close: IConnection;
      function CommitTransaction: IConnection;
      function DataSet: TDataSet; overload;
      function DataSet(const Value: TDataSource):IConnection; overload;
      function ExecSQL: Integer;
      class function New(const Params: IConnectionParams): IConnection; overload;
      class function New(const Connection: IConnection): IConnection; overload;
      function Open: IConnection;
      function ParamValue(Param: String; const Value: TPersistent): IConnection; overload;
      function ParamValue(Param: String; const Value: Variant): IConnection; overload;
      function ParamAssign(Param: String; const Value: TStream): IConnection;
      function RollbackTransaction: IConnection;
      function SQL(Value: String): IConnection;
      function SQLClear: IConnection;
      function StartTransaction: IConnection;
  end;
implementation
constructor TConnectionFiredac.Create(const Connection: IConnection);
begin
  FConnection := TConnectionFiredac(Connection).GetConnection;
  Create;
end;
constructor TConnectionFiredac.Create;
begin
  FConnectionFree := False;
  if not Assigned(FConnection) then
  begin
    FConnection := TFDConnection.Create(nil);
    FConnectionFree := True;
  end;
  FConnection.LoginPrompt := false;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;
class function TConnectionFiredac.New(const Connection: IConnection): IConnection;
begin
  Result := Self.Create(Connection);
end;
constructor TConnectionFiredac.Create(const Params: IConnectionParams);
begin
  Create;
  if Assigned(Params) then
  begin
    FConnection.Params.DriverID := Params.GetDriver;
    FConnection.Params.Database := Params.GetDatabase;
    if Length(Trim(Params.GetHost)) > 0 then
      FConnection.Params.Add('server=' + Params.GetHost);
    if Length(Trim(Params.GetPort)) > 0 then
      FConnection.Params.Add('port=' + Params.GetPort);
    if Length(Trim(Params.GetUser)) > 0 then
      FConnection.Params.UserName := Params.GetUser;
    if Length(Trim(Params.GetPassword)) > 0 then
      FConnection.Params.Password := Params.GetPassword;
    if Length(Trim(Params.GetPassword)) > 0 then
      FConnection.Params.Add('CharacterSet=utf8');
  end;
end;
destructor TConnectionFiredac.Destroy;
begin
  FQuery.Free;
  if FConnectionFree then
  begin
    FConnection.Connected := false;
    FConnection.Free;
  end;
  inherited;
end;
function TConnectionFiredac.Close: IConnection;
begin
  Result := Self;
  FQuery.Close;
end;
function TConnectionFiredac.CommitTransaction: IConnection;
begin
  Result := Self;
  FConnection.Commit;
end;
function TConnectionFiredac.DataSet: TDataSet;
begin
  Result := FQuery;
end;
function TConnectionFiredac.DataSet(const Value: TDataSource): IConnection;
begin
  Result := Self;
  FDataSource := Value;
  FDataSource.DataSet := FQuery;
end;
function TConnectionFiredac.ExecSQL: Integer;
begin
  FQuery.ExecSQL;
  Result := FQuery.RowsAffected;
end;
function TConnectionFiredac.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;
class function TConnectionFiredac.New(const Params: IConnectionParams): IConnection;
begin
  Result := Self.Create(Params);
end;
function TConnectionFiredac.Open: IConnection;
begin
  Result := Self;
  FQuery.Open;
end;
function TConnectionFiredac.ParamValue(Param: String; const Value: TPersistent): IConnection;
begin
  Result := Self;
  FQuery.ParamByName(Param).Assign(Value);
end;
function TConnectionFiredac.ParamAssign(Param: String; const Value: TStream): IConnection;
begin
  Result := Self;
  if Value.Size > 0 then
    FQuery.ParamByName(Param).LoadFromStream(Value, ftBlob)
  else
  begin
    FQuery.ParamByName(Param).DataType := ftBlob;
    FQuery.ParamByName(Param).Clear;
  end;
end;

function TConnectionFiredac.ParamValue(Param: String; const Value: Variant): IConnection;
begin
  Result := Self;
  if VarIsNull(Value) then
  begin
    FQuery.ParamByName(Param).AsString := '';
    FQuery.ParamByName(Param).Clear;
  end
  else
  begin
    FQuery.ParamByName(Param).Clear;
    FQuery.ParamByName(Param).Value := Value;
  end;
end;
function TConnectionFiredac.RollbackTransaction: IConnection;
begin
  Result := Self;
  FConnection.Rollback;
end;
function TConnectionFiredac.SQL(Value: String): IConnection;
begin
  Result := Self;
  FQuery.SQL.Add(Value);
end;
function TConnectionFiredac.SQLClear: IConnection;
begin
  Result := Self;
  FQuery.SQL.Clear;
end;
function TConnectionFiredac.StartTransaction: IConnection;
begin
  FConnection.StartTransaction;
end;
end.

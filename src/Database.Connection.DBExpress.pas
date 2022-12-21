unit Database.Connection.DBExpress;
interface
uses
  DB,
  SqlExpr,
  DBXCommon,
  Database.Connection.Interfaces,
  Classes,
  System.Variants;
type
  TConnectionDBExpress = class(TInterfacedObject, IConnection)
  private
      FConnection: TSQLConnection;
      FConnectionFree: Boolean;
      FDataSource: TDataSource;
      FQuery: TSQLQuery;
      FTransaction: TDBXTransaction;
      function GetConnection: TSQLConnection;
  public
      constructor Create(const Params: IConnectionParams); overload;
      constructor Create; overload;
      constructor Create(const Connection: IConnection); overload;
      destructor Destroy; override;
      function Close: IConnection;
      function CommitTransaction: IConnection;
      function DataSet: TDataSet; overload;
      function DataSet(const Value: TDataSource):IConnection; overload;
      function ExecSQL: IConnection;
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
uses
  System.SysUtils;
constructor TConnectionDBExpress.Create(const Params: IConnectionParams);
begin
  Create;
  if Assigned(Params) then
  begin
    FConnection.DriverName := Params.GetDriver;
    FConnection.Params.Clear;
    FConnection.Params.Add('database=' + Params.GetDatabase);
    if Length(Trim(Params.GetHost)) > 0 then
      FConnection.Params.Add('server=' + Params.GetHost);
    if Length(Trim(Params.GetPort)) > 0 then
      FConnection.Params.Add('port=' + Params.GetPort);
    if Length(Trim(Params.GetUser)) > 0 then
      FConnection.Params.Add('user_name=' + Params.GetUser);
    if Length(Trim(Params.GetPassword)) > 0 then
      FConnection.Params.Add('password=' + Params.GetPassword);
  end;
end;
constructor TConnectionDBExpress.Create(const Connection: IConnection);
begin
  FConnection := TConnectionDBExpress(Connection).GetConnection;
  Create;
end;
constructor TConnectionDBExpress.Create;
begin
  FConnectionFree := False;
  if not Assigned(FConnection) then
  begin
    FConnection := TSQLConnection.Create(nil);
    FConnectionFree := True;
  end;
  FConnection.LoginPrompt := false;
  FQuery := TSQLQuery.Create(nil);
  FQuery.SQLConnection := FConnection;
end;
destructor TConnectionDBExpress.Destroy;
begin
  FQuery.Free;
  if FConnectionFree then
  begin
    FConnection.Connected := false;
    FConnection.Free;
  end;
  inherited;
end;
function TConnectionDBExpress.Close: IConnection;
begin
  Result := Self;
  FQuery.Close;
end;
function TConnectionDBExpress.CommitTransaction: IConnection;
begin
  Result := Self;
  FConnection.CommitFreeAndNil(FTransaction);
end;
function TConnectionDBExpress.DataSet: TDataSet;
begin
  Result := FQuery;
end;
function TConnectionDBExpress.DataSet(const Value: TDataSource): IConnection;
begin
  Result := Self;
  FDataSource := Value;
  FDataSource.DataSet := FQuery;
end;
function TConnectionDBExpress.ExecSQL: IConnection;
begin
  Result := Self;
  FQuery.ExecSQL;
end;
function TConnectionDBExpress.GetConnection: TSQLConnection;
begin
  Result := FConnection;
end;
class function TConnectionDBExpress.New(const Params: IConnectionParams): IConnection;
begin
  Result := Self.Create(Params);
end;
class function TConnectionDBExpress.New(const Connection: IConnection): IConnection;
begin
  Result := Self.Create(Connection);
end;
function TConnectionDBExpress.Open: IConnection;
begin
  Result := Self;
  FQuery.Open;
end;
function TConnectionDBExpress.ParamValue(Param: String; const Value: TPersistent): IConnection;
begin
  Result := Self;
  FQuery.ParamByName(Param).Assign(Value);
end;
function TConnectionDBExpress.ParamAssign(Param: String; const Value: TStream): IConnection;
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

function TConnectionDBExpress.ParamValue(Param: String; const Value: Variant): IConnection;
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
function TConnectionDBExpress.RollbackTransaction: IConnection;
begin
  Result := Self;
  FConnection.RollbackIncompleteFreeAndNil(FTransaction);
end;
function TConnectionDBExpress.SQL(Value: String): IConnection;
begin
  Result := Self;
  FQuery.SQL.Add(Value);
end;
function TConnectionDBExpress.SQLClear: IConnection;
begin
  Result := Self;
  FQuery.SQL.Clear;
end;
function TConnectionDBExpress.StartTransaction: IConnection;
begin
  Result := Self;
  FTransaction := FConnection.BeginTransaction(TDBXIsolations.ReadCommitted);
end;
end.

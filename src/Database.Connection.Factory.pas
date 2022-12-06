unit Database.Connection.Factory;
interface
uses
  Database.Connection.Interfaces, Database.Enums;
type
  TConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
      FConnection: IConnection;
      FDatabaseDriver: TDatabaseDriver;
  public
      constructor Create(DatabaseDriver: TDatabaseDriver);
      destructor Destroy; override;
      function GetConnection(Params: IConnectionParams): IConnection; overload;
      function GetConnection(const Connection: IConnection): IConnection; overload;
      class function New(DatabaseDriver: TDatabaseDriver = ddFiredac): IConnectionFactory;
  end;
implementation

uses
  Database.Connection.Firedac, Database.Connection.DBExpress;

constructor TConnectionFactory.Create(DatabaseDriver: TDatabaseDriver);
begin
  FDatabaseDriver := DatabaseDriver;
end;

destructor TConnectionFactory.Destroy;
begin
  inherited;
end;

function TConnectionFactory.GetConnection(const Connection: IConnection): IConnection;
begin
    if not Assigned(FConnection) then
  begin
    if FDatabaseDriver = TDatabaseDriver.ddFiredac then
      FConnection := TConnectionFiredac.New(Connection);
    if FDatabaseDriver = TDatabaseDriver.ddDBExpress then
      FConnection := TConnectionDBExpress.New(Connection);
  end;
  Result := FConnection;
end;

function TConnectionFactory.GetConnection(Params: IConnectionParams): IConnection;
begin
  if not Assigned(FConnection) then
  begin
    if FDatabaseDriver = TDatabaseDriver.ddFiredac then
      FConnection := TConnectionFiredac.New(Params);
    if FDatabaseDriver = TDatabaseDriver.ddDBExpress then
      FConnection := TConnectionDBExpress.New(Params);
  end;
  Result := FConnection;
end;

class function TConnectionFactory.New(DatabaseDriver: TDatabaseDriver = ddFiredac): IConnectionFactory;
begin
  Result := Self.Create(DatabaseDriver);
end;

end.

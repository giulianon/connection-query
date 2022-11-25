unit Database.Connection.Params;
interface
uses Database.Connection.Interfaces;
type
  TConnectionParams = class(TInterfacedObject, IConnectionParams)
    strict private
      FUser: String;
      FPassword: String;
      FDatabase: String;
      FHost: String;
      FPort: String;
      FDriver: String;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: IConnectionParams;
      function SetUser(Value: String): IConnectionParams;
      function GetUser: String;
      function SetPassword(Value: String): IConnectionParams;
      function GetPassword: String;
      function SetDatabase(Value: String): IConnectionParams;
      function GetDatabase: String;
      function SetDriver(Value: String): IConnectionParams;
      function GetDriver: String;
      function SetHost(Value: String): IConnectionParams;
      function GetHost: String;
      function SetPort(Value: String): IConnectionParams;
      function GetPort: String;
  end;
implementation
{ TConnectionParams }
constructor TConnectionParams.Create;
begin
end;
destructor TConnectionParams.Destroy;
begin
  inherited;
end;
function TConnectionParams.GetDatabase: String;
begin
  Result := FDatabase;
end;
function TConnectionParams.GetDriver: String;
begin
  Result := FDriver;
end;

function TConnectionParams.GetHost: String;
begin
  Result := FHost;
end;

function TConnectionParams.GetPassword: String;
begin
  Result := FPassword;
end;
function TConnectionParams.GetPort: String;
begin
  Result := FPort;
end;

function TConnectionParams.GetUser: String;
begin
  Result := FUser;
end;
class function TConnectionParams.New: IConnectionParams;
begin
  Result := Self.Create;
end;
function TConnectionParams.SetDatabase(Value: String): IConnectionParams;
begin
  Result := Self;
  FDatabase := Value;
end;
function TConnectionParams.SetDriver(Value: String): IConnectionParams;
begin
  Result := Self;
  FDriver := Value;
end;

function TConnectionParams.SetHost(Value: String): IConnectionParams;
begin
  Result := Self;
  FHost := Value;
end;

function TConnectionParams.SetPassword(Value: String): IConnectionParams;
begin
  Result := Self;
  FPassword := Value;
end;
function TConnectionParams.SetPort(Value: String): IConnectionParams;
begin
  Result := Self;
  FPort := Value;
end;

function TConnectionParams.SetUser(Value: String): IConnectionParams;
begin
  Result := Self;
  FUser := Value;
end;
end.

unit Database.Connection.Interfaces;

interface

uses
  DB,
  Classes;

type
  IConnection = interface
    ['{C0B06135-820C-4B6F-9CB0-D9984D512E92}']
    function Close: IConnection;
    function ParamValue(Param: String; Value: Variant): IConnection; overload;
    function ParamValue(Param: String; Value: TPersistent): IConnection; overload;
    function DataSet: TDataSet; overload;
    function DataSet(Value: TDataSource):IConnection; overload;
    function ExecSQL: IConnection;
    function Open: IConnection;
    function SQL(Value: String): IConnection;
    function SQLClear: IConnection;
    function StartTransaction: IConnection;
    function CommitTransaction: IConnection;
    function RollbackTransaction: IConnection;
  end;

  IConnectionParams = interface
    ['{75EE0696-7507-4624-89EE-D18DB4F9C9E8}']
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
	function SetCharset(Value: String): IConnectionParams;
    function GetCharset: String;
  end;

  IConnectionFactory = interface
    ['{A85BBC02-9511-4425-887B-02948409A880}']
    function GetConnection(const Connection: IConnection): IConnection; overload;
    function GetConnection(Params: IConnectionParams): IConnection; overload;
  end;

implementation

end.

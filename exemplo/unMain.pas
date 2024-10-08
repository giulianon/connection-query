unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Database.Connection.Interfaces, Vcl.StdCtrls, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, Data.DB, Vcl.Grids, Vcl.DBGrids, Data.DBXFirebird,
  Data.SqlExpr, MidasLib;

type
  TfmMain = class(TForm)
    ConsultarButton: TButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ConsultaDataSource: TDataSource;
    ConsultaDBGrid: TDBGrid;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ConsultarButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FConnectionParams: IConnectionParams;
    FQuery: IConnection;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  Database.Connection.Params, Database.Connection.Factory, Database.Enums;

{$R *.dfm}

procedure TfmMain.Button1Click(Sender: TObject);
begin
  FQuery
    .Close
    .SQLClear
    .SQL('insert into produto (nome, observacao, preco_venda, preco_custo, data_hora_inclusao, data_validade, disponivel)' +
         'values (:nome, :observacao, :preco_venda, :preco_custo, :data_hora_inclusao, :data_validade, :disponivel)')
    .ParamString('nome', 'Produto ' + FormatDateTime('hhmmsss', now))
    .ParamString('observacao', 'Vai inserir nulo', True)
    .ParamDouble('preco_venda', 2.00)
    .ParamDouble('preco_custo', 1.00)
    .ParamDatetime('data_hora_inclusao', Now)
    .ParamDatetime('data_validade', Date)
    .ParamBoolean('disponivel', true)
    .ExecSQL;
  ConsultarButton.Click;
end;

procedure TfmMain.ConsultarButtonClick(Sender: TObject);
begin
  FQuery
    .Close
    .SQLClear
    .SQL('select * from produto')
    .Open
    .DataSet(ConsultaDataSource);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FConnectionParams :=
    TConnectionParams
      .New
      .SetDriver('Firebird')
      .SetCharset('CharacterSet=utf8')
      .SetDatabase('../../exemplo.fdb')
      .SetUser('SYSDBA')
      .SetPassword('masterkey');
  FQuery := TConnectionFactory
    .New(ddDBExpress)
    .GetConnection(FConnectionParams);
end;

end.

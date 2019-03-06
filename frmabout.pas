unit frmAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private

  public

  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }

procedure TFormAbout.FormCreate(Sender: TObject);
begin

end;

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFormAbout.Label7Click(Sender: TObject);
begin

end;

end.


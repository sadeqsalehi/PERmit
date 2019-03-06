unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons, ExtCtrls, process;

type

  { TFormMain }

  TFormMain = class(TForm)
    btCreateFile: TButton;
    btBrowse: TButton;
    chG1: TCheckBox;
    chG2: TCheckBox;
    chG3: TCheckBox;
    chHistory: TCheckBox;
    chO1: TCheckBox;
    chO2: TCheckBox;
    chO3: TCheckBox;
    chRoot: TCheckBox;
    chU1: TCheckBox;
    chU2: TCheckBox;
    chU3: TCheckBox;
    edFile: TEdit;
    edpath: TEdit;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    ImageList2: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbGroup: TLabel;
    lbGroup1: TLabel;
    lbGroup2: TLabel;
    lbGroup3: TLabel;
    lbOther: TLabel;
    lbOther1: TLabel;
    lbOther2: TLabel;
    lbOther3: TLabel;
    lbUser: TLabel;
    lbUser1: TLabel;
    lbUser2: TLabel;
    lbUser3: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    rdDec: TRadioButton;
    rdSmbl: TRadioButton;
    dlDirSelect: TSelectDirectoryDialog;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure btBrowseClick(Sender: TObject);
    procedure btCreateFileClick(Sender: TObject);
    procedure chHistoryChange(Sender: TObject);
    procedure chRootChange(Sender: TObject);
    procedure GetStateUser(Sender: TObject);
    procedure GetStateGroup(Sender: TObject);
    procedure GetStateOther(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function GetSymbolic(bin1, smbl: string): string;
    function GetPrompt(): string;
    procedure SetPermission();
    procedure AppDeactivate(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure rdDecChange(Sender: TObject);
    procedure rdSmblChange(Sender: TObject);
    procedure CheckDecOrSmbl;
    procedure GetStateAll;
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
  private

    { private declarations }
  public
    { public declarations }
  end;

var
  FormMain: TFormMain;
  userNum, groupNum, otherNum: integer;
  prompt: string;
  strRoot: string;
  blHistory: boolean;
  strOctNum: string;
  cmdPrompt: string;
  blBrowse: boolean;
  txtMemo: string;

implementation

{$R *.lfm}
uses
  frmAbout;

{ TFormMain }

function TFormMain.GetSymbolic(bin1, smbl: string): string;
begin
  if bin1[1] = '1' then
    smbl[1] := 'r'
  else
    smbl[1] := '-';
  if bin1[2] = '1' then
    smbl[2] := 'w'
  else
    smbl[2] := '-';
  if bin1[3] = '1' then
    smbl[3] := 'x'
  else
    smbl[3] := '-';
  Result := smbl;
end;

procedure TFormMain.Label10Click(Sender: TObject);

begin
  lbUser2.Visible := not (lbUser2.Visible);
  lbGroup2.Visible := not (lbGroup2.Visible);
  lbOther2.Visible := not (lbOther2.Visible);
  if rdSmbl.Checked = True then
  begin
    if lbUser2.Visible = False then
    begin
      txtMemo := Memo1.Text;
      Memo1.Text := cmdPrompt;
    end
    else
    begin
      Memo1.Text := txtMemo;
      txtMemo := '';
    end;

  end;
end;

procedure TFormMain.Label9Click(Sender: TObject);
var
  strNum: string;
begin
  lbUser1.Visible := not (lbUser1.Visible);
  lbGroup1.Visible := not (lbGroup1.Visible);
  lbOther1.Visible := not (lbOther1.Visible);
  if lbUser1.Visible = False then
  begin
    txtMemo := Memo1.Text;
    Memo1.Text := cmdPrompt;

  end
  else
  begin
    strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
    prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
    if blHistory = True then
    begin
      Memo1.Text := txtMemo;
      txtMemo := '';

    end
    else
      Memo1.Text := prompt;
  end;
  CheckDecOrSmbl;
end;

procedure TFormMain.Label8Click(Sender: TObject);
begin
  lbUser.Visible := not (lbUser.Visible);
  lbGroup.Visible := not (lbGroup.Visible);
  lbOther.Visible := not (lbOther.Visible);
end;

procedure TFormMain.rdDecChange(Sender: TObject);
var
  strNum: string;
begin
  if rdDec.Checked = True then
  begin
    strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
    prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
    Memo1.Text := prompt;
  end;
end;

procedure TFormMain.rdSmblChange(Sender: TObject);
var
  strNum: string;

begin
  CheckDecOrSmbl;
  if rdDec.Checked = True then
  begin
    strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
    prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
    Memo1.Text := prompt;
  end;
end;

procedure TFormMain.CheckDecOrSmbl();
var
  strNum: string;
  u2, g2, o2: string;
  lbU3, lbG3, lbO3: string;//label user caption
  cu, cg: string;//comma for user and group
begin
  if rdSmbl.Checked = True then
  begin
    // s:='-12-34--56-789-10---';
    u2 := StringReplace(lbUser2.Caption, '-', '', [rfReplaceAll, rfIgnoreCase]);
    g2 := StringReplace(lbGroup2.Caption, '-', '', [rfReplaceAll, rfIgnoreCase]);
    o2 := StringReplace(lbOther2.Caption, '-', '', [rfReplaceAll, rfIgnoreCase]);
    lbu3 := lbUser3.Caption;
    lbG3 := lbGroup3.Caption;
    lbO3 := lbOther3.Caption;
    if u2 = '' then
    begin
      lbU3 := '';
      cu := '';

    end
    else
      cu := ',';

    if g2 = '' then
    begin
      lbG3 := '';
      cg := '';
      cu := '';
    end;

    if o2 = '' then
    begin
      lbO3 := '';
      cg := '';
    end
    else
    if (u2 = '') and (g2 = '') then
      cg := ''
    else
      cg := ',';


    strNum := lbu3 + u2 + cu + lbG3 + g2 + cg + lbO3 + o2;
    if (lbUser1.Caption = '0') and (lbGroup1.Caption = '0') and
      (lbOther1.Caption = '0') then
      strNum := 'a=---';
    prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
    if blHistory = True then
      Memo1.Lines.Add(prompt)
    else
      Memo1.Text := prompt;
  end;
  // SetPermission();
end;

procedure TFormMain.GetStateAll();
begin
  if rdSmbl.Checked = True then
  begin
    if (lbUser1.Caption = '0') and (lbGroup1.Caption = '0') and
      (lbOther1.Caption = '0') then
      prompt := cmdPrompt + strRoot + ' chmod ' + 'a=---' + ' ' + edFile.Text;
    if blHistory = True then
      Memo1.Lines.Add(prompt)
    else
      Memo1.Text := prompt;
  end;
  CheckDecOrSmbl;
end;

procedure TFormMain.ToolButton2Click(Sender: TObject);
begin

  FormAbout.ShowModal;
end;

procedure TFormMain.ToolButton3Click(Sender: TObject);
var
  s: ansistring;

begin
  if RunCommand('/bin/bash', ['-c', 'gnome-terminal --working-directory=' +
    Trim(edpath.Text)], s) = False then
    if RunCommand('/bin/bash', ['-c', 'konsole'], s) = False then
      if RunCommand('/bin/bash', ['-c', 'xterm'], s) = False then
        ShowMessage('نرم افزار ترمینال یافت نشد');
end;

procedure TFormMain.ToolButton4Click(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.ToolButton5Click(Sender: TObject);
var
  s: ansistring;
  path: string;
begin
  path := Trim(edpath.Text) + '/' + Trim(edFile.Text);
  if RunCommand('/bin/bash', ['-c', 'chmod  ' + strOctNum + '  ' + path], s) then
    // if RunCommand('/bin/bash', ['-c', 'ls -l ' + path], s) then

    //  Memo1.Lines.Add(s);
    s := 'Success';
end;

procedure TFormMain.SetPermission();
var
  s: ansistring;
  path: string;
begin
  path := Trim(edpath.Text) + '/' + Trim(edFile.Text);
  if RunCommand('/bin/bash', ['-c', 'chmod  ' + strOctNum + '  ' + path], s) then
    s := 'Success';
end;

procedure TFormMain.GetStateUser(Sender: TObject);
var
  s: string;
  oct: integer;
  strNum: string;
begin
  s := lbUser.Caption;
  s[StrToInt((Sender as TcheckBox).Name[4])] :=
    (Sender as TcheckBox).Checked.toInteger.toString[1];
  lbUser.Caption := s;
  oct := StrToInt(s[3]) * 1 + StrToInt(s[2]) * 2 + StrToInt(s[1]) * 4;
  lbUser1.Caption := oct.ToString;
  lbUser2.Caption := GetSymbolic(s, lbUser2.Caption);
  strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
  strOctNum := strNum;
  prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
  if rdSmbl.Checked = False then
  begin
    if (blHistory = True) then
      Memo1.Lines.Add(prompt)
    else
      Memo1.Text := prompt;
  end;

  CheckDecOrSmbl;
  //GetStateAll;
end;

procedure TFormMain.chRootChange(Sender: TObject);
var
  strNum: string;
begin
  if chRoot.Checked = True then
    strRoot := ' sudo'
  else
    strRoot := '';
  strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
  prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
  Memo1.Text := prompt;
end;


procedure TFormMain.chHistoryChange(Sender: TObject);
begin
  if chHistory.Checked = True then
    blHistory := True
  else
    blHistory := False;
end;

procedure TFormMain.btBrowseClick(Sender: TObject);
begin

  if dlDirSelect.Execute = True then
  begin
    blBrowse := True;
    edpath.Text := dlDirSelect.FileName;
    cmdPrompt := GetPrompt();
    blBrowse := False;
  end;
end;

procedure TFormMain.btCreateFileClick(Sender: TObject);
var
  s: ansistring;
  path: string;
begin
  path := Trim(edpath.Text) + '/' + Trim(edFile.Text);
  if RunCommand('/bin/bash', ['-c', 'touch ' + path + ';ls -l ' + path], s) then
  begin
    Memo1.Lines.Add(s);
    chU1.Checked := True;
    chU2.Checked := True;
    chU3.Checked := False;
    chG1.Checked := True;
    chG2.Checked := True;
    chG3.Checked := False;
    chO1.Checked := True;
    chO2.Checked := False;
    chO3.Checked := False;

  end;
end;

procedure TFormMain.GetStateGroup(Sender: TObject);

var
  s: string;
  oct: integer;
  strNum: string;
begin
  s := lbGroup.Caption;
  s[StrToInt((Sender as TcheckBox).Name[4])] :=
    (Sender as TcheckBox).Checked.toInteger.toString[1];
  lbGroup.Caption := s;
  oct := StrToInt(s[3]) * 1 + StrToInt(s[2]) * 2 + StrToInt(s[1]) * 4;
  lbGroup1.Caption := oct.ToString;
  lbGroup2.Caption := GetSymbolic(s, lbGroup2.Caption);
  strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
  strOctNum := strNum;
  prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
  if rdSmbl.Checked = False then
  begin
    if (blHistory = True) then
      Memo1.Lines.Add(prompt)
    else
      Memo1.Text := prompt;
  end;

  CheckDecOrSmbl;
  //GetStateAll;
end;

procedure TFormMain.GetStateOther(Sender: TObject);
var
  s: string;
  oct: integer;
  strNum: string;
begin
  s := lbOther.Caption;
  s[StrToInt((Sender as TcheckBox).Name[4])] :=
    (Sender as TcheckBox).Checked.toInteger.toString[1];
  lbOther.Caption := s;
  oct := StrToInt(s[3]) * 1 + StrToInt(s[2]) * 2 + StrToInt(s[1]) * 4;
  lbOther1.Caption := oct.ToString;
  lbOther2.Caption := GetSymbolic(s, lbOther2.Caption);
  strNum := lbUser1.Caption + lbGroup1.Caption + lbOther1.Caption;
  strOctNum := strNum;
  prompt := cmdPrompt + strRoot + ' chmod ' + strNum + ' ' + edFile.Text;
  if rdSmbl.Checked = False then
  begin
    if (blHistory = True) then
      Memo1.Lines.Add(prompt)
    else
      Memo1.Text := prompt;
  end;

  CheckDecOrSmbl;
  // GetStateAll;

end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  os: string;
begin
  userNum := 0;
  groupNum := 0;
  otherNum := 0;
  blBrowse := False;

  os := 'OS:Linux';
  StatusBar1.Panels.Items[2].Text := os;
  cmdPrompt := GetPrompt();
  Application.OnDeactivate := @AppDeactivate;
end;

procedure TFormMain.AppDeactivate(Sender: TObject);
begin
  SetPermission();
end;

function TFormMain.GetPrompt(): string;
var
  s: string;
  user, host: string;
  pmt: string;
  path: string;
begin
  pmt := 'salehi@ubuntu:~$';
  if RunCommand('/bin/bash', ['-c', 'echo $HOME'], s) then
  begin
    if RightStr(s, 1) = chr(10) then
      s := LeftStr(s, Length(s) - 1);
    if blBrowse = False then
      edpath.Text := s;
  end;
  if edpath.Text = s then
    path := '~'
  else
    path := edpath.Text;
  if RunCommand('/bin/bash', ['-c', 'echo $USER'], user) then
  begin
    if RunCommand('/bin/bash', ['-c', 'echo $HOSTNAME'], host) then
      pmt := LeftStr(user, Length(user) - 1) + '@' +
        LeftStr(host, Length(host) - 1) + ':' + path + '$';
  end;
  Result := pmt;
end;

function getOctal(): string;
var
  s: string;
begin
  s := ' gfhjtg';

  //if chU3.checked=true then
  //  s= '';
  Result := s;
end;

end.

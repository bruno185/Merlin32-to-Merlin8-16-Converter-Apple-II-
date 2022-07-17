// Convert Merlin32 source files
// to Merlin8/16 source fils
// ready to be assembled on an Apple II using Merlin Assembler

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, Vcl.ComCtrls ;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { D�clarations priv�es }
       procedure WMDropFiles(var msg : TMessage); message WM_DROPFILES;
       procedure SetOutput;
  public
    { D�clarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TextfileSize(const name: string): LongInt;
var
  SRec: TSearchRec;
begin
  if FindFirst(name, faAnyfile, SRec) = 0 then
  begin
    Result := SRec.Size;
    FindClose(SRec);
  end
  else
    Result := 0;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  filin, filout : file of byte;
  space : boolean;
  c : byte;
  inputlength, readbytes : longint;

begin
  try
  try
  // init. action
  button1.Enabled := false;
  // get input file size
  inputlength :=  TextfileSize(Edit1.Text);
  // file size = 0 : exit
  if inputlength=0 then
  raise Exception.Create('File size = 0');

  assignfile(filin,Edit1.Text);
  reset(filin);
  assignfile(filout,Edit2.Text);
  rewrite(filout);

  space := false;
  ProgressBar1.Position := 0;
  readbytes := 0;

  while not(eof(filin))  do
  begin
  // read one byte from input file
    read(filin,c);
  // update counter
    readbytes := readbytes + 1;

    // update progreebar
    if (readbytes mod 100 =0) then
    begin
      ProgressBar1.Position :=  (readbytes * 100) div  inputlength;
      Application.ProcessMessages;
    end;

    // cas byte = ' '
    if c = 32 then
    begin
      if space = false then
      begin   // previous byte wan not ' '
        write(filout,c);
        space := true;
      end;
    end
    else  // previous byte wan ' '
    begin
      if c <> 10 then write(filout,c);
      space := false;
    end;
  end;

  ProgressBar1.Position := 100;
  closefile(filin);
  closefile(filout);
  Application.MessageBox('Job''s done.','',0);

  except
    begin
      Application.MessageBox('Error !!','',0);
    end;

  end;
  finally
    begin
     button1.Enabled := true;
     ProgressBar1.Position := 0;
    end;

  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, true);
end;


// set output file name, from input file name :
// add 'A2' to input file name (before extention, typically  before : '.s')
// add  '#040000' at the end, for Ciderpress ( $04 : text file type, 0000 : aux type).
procedure TForm1.SetOutput;
var
  tempo : string;
  i, index : longint;
  found : boolean;
begin
  tempo := Edit1.Text;
  i := length(tempo);
  found := false;
  index := 0;
  repeat
    if tempo[i] = '.' then
    begin
      found := true;
      index := i;
    end;
    i:= i-1;
  until (i =0) or (found = true);

  Edit2.Text := '';

  if index=0 then  // if no '.' found
  begin
    Edit2.Text := Edit1.Text +'A2.s#040000';
  end
  else
  begin
    for i:= 1 to index-1 do
      Edit2.Text := Edit2.Text + tempo[i];
    // siffixe = A2 for output file
    Edit2.Text := Edit2.Text + 'A2';
    for i:= index to length(tempo) do
      Edit2.Text := Edit2.Text + tempo[i] ;
      // extension for Ciderpress
    Edit2.Text := Edit2.Text + '#040000';
  end;
end;


// drag n drop file
procedure TForm1.WMDropFiles(var msg : TMessage);
var
  hand: THandle;
  nbFich, i : integer;
  buf:array[0..254] of Char;
  begin
    hand:=msg.wParam;
    nbFich:= DragQueryFile(hand, 4294967295, buf, 254);
    for i:= 0 to nbFich - 1 do
    begin
      DragQueryFile(hand, i, buf, 254);
      Edit1.Text := (buf);
    end;
    DragFinish(hand);
    SetOutput;
end;


end.

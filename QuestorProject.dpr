program QuestorProject;

uses
  Vcl.Forms,
  nFrmMain_U in 'src\presentation\nFrmMain_U.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

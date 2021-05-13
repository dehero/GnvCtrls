program GnvCtrlsDemo;

{$R 'Manifest.res' 'Manifest.rc'}

uses
  Forms,
  WndDemo in 'WndDemo.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'GnvCtrls Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

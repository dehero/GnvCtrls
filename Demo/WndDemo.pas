unit WndDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Buttons, GnvCtrls, StdCtrls, ExtCtrls, Menus;

type
  TMainForm = class(TForm)
    ImageList1: TImageList;
    ImageList2: TImageList;
    GnvToolBar3: TGnvToolBar;
    GnvToolBar1: TGnvToolBar;
    GnvToolBar2: TGnvToolBar;
    GnvToolBar4: TGnvToolBar;
    GnvTabBar1_1: TGnvTabBar;
    ToolBarGlyphs: TGnvToolBar;
    PopupMenuTest: TPopupMenu;
    ComboBoxScale: TComboBox;
    ComboBoxTheme: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ComboBoxScaleSelect(Sender: TObject);
    procedure ComboBoxThemeSelect(Sender: TObject);
  private
    { Private declarations }
    FWndFrameSize: Integer;
    function GetSysIconRect: TRect;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure InvalidateTitleBar;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure Load;
    procedure PaintWindow(DC: HDC); override;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCRButtonUp(var Message: TWMNCRButtonUp); message WM_NCRBUTTONUP;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainForm: TMainForm;

function SystemScaleToStr(Scale: TGnvSystemScale): string;
function SystemThemeToStr(Theme: TGnvSystemTheme): string;

procedure ShowSystemMenu(Form: TForm; const Message: TWMNCRButtonUp);

implementation

uses
  DwmApi, CommCtrl, Themes, UxTheme;

{$R *.dfm}

{$IF not Declared(UnicodeString)}
type
  UnicodeString = WideString;
{$IFEND}

procedure DrawGlassCaption(Form: TForm; const Text: UnicodeString;
  Color: TColor; var R: TRect; HorzAlignment: TAlignment = taLeftJustify;
  VertAlignment: TTextLayout = tlCenter; ShowAccel: Boolean = False); overload;
const
  BasicFormat = DT_SINGLELINE or DT_END_ELLIPSIS;
  HorzFormat: array[TAlignment] of UINT = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VertFormat: array[TTextLayout] of UINT = (DT_TOP, DT_VCENTER, DT_BOTTOM);
  AccelFormat: array[Boolean] of UINT = (DT_NOPREFIX, 0);
var
  DTTOpts: TDTTOpts;            { This routine doesn't use GetThemeSysFont and          }
  Element: TThemedWindow;       { GetThemeSysColor because they just return theme       }
  IsVistaAndMaximized: Boolean; { defaults that will be overridden by the 'traditional' }
  NCM: TNonClientMetrics;       { settings as and when the latter are set by the user.  }
  ThemeData: HTHEME;

  procedure DoTextOut;
  begin
    with ThemeServices.GetElementDetails(Element) do
      DrawThemeTextEx(ThemeData, Form.Canvas.Handle, Part, State, PWideChar(Text),
        Length(Text), BasicFormat or AccelFormat[ShowAccel] or
        HorzFormat[HorzAlignment] or VertFormat[VertAlignment], @R, DTTOpts);
  end;
begin
  if Color = clNone then Exit;
  IsVistaAndMaximized := (Form.WindowState = wsMaximized) and
    (Win32MajorVersion = 6) and (Win32MinorVersion = 0);
  ThemeData := OpenThemeData(0, 'CompositedWindow::Window');
  Assert(ThemeData <> 0, SysErrorMessage(GetLastError));
  try
    NCM.cbSize := SizeOf(NCM);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NCM, 0) then
      if Form.BorderStyle in [bsToolWindow, bsSizeToolWin] then
        Form.Canvas.Font.Handle := CreateFontIndirect(NCM.lfSmCaptionFont)
      else
        Form.Canvas.Font.Handle := CreateFontIndirect(NCM.lfCaptionFont);
    ZeroMemory(@DTTOpts, SizeOf(DTTOpts));
    DTTOpts.dwSize := SizeOf(DTTOpts);
    DTTOpts.dwFlags := DTT_COMPOSITED or DTT_TEXTCOLOR;
    if Color <> clDefault then
      DTTOpts.crText := ColorToRGB(Color)
    else if IsVistaAndMaximized then
      DTTOpts.dwFlags := DTTOpts.dwFlags and not DTT_TEXTCOLOR
    else if Form.Active then
      DTTOpts.crText := GetSysColor(COLOR_CAPTIONTEXT)
    else
      DTTOpts.crText := GetSysColor(COLOR_INACTIVECAPTIONTEXT);
    if not IsVistaAndMaximized then
    begin
      DTTOpts.dwFlags := DTTOpts.dwFlags or DTT_GLOWSIZE;
      DTTOpts.iGlowSize := 15;
    end;
    if Form.WindowState = wsMaximized then
      if Form.Active then
        Element := twMaxCaptionActive
      else
        Element := twMaxCaptionInactive
    else if Form.BorderStyle in [bsToolWindow, bsSizeToolWin] then
      if Form.Active then
        Element := twSmallCaptionActive
      else
        Element := twSmallCaptionInactive
    else
      if Form.Active then
        Element := twCaptionActive
      else
        Element := twCaptionInactive;
    DoTextOut;
    if IsVistaAndMaximized then DoTextOut;
  finally
    CloseThemeData(ThemeData);
  end;
end;

procedure DrawGlassCaption(Form: TForm; var R: TRect;
  HorzAlignment: TAlignment = taLeftJustify; VertAlignment: TTextLayout = tlCenter;
  ShowAccel: Boolean = False); overload;
begin
  DrawGlassCaption(Form, Form.Caption, clDefault, R,
    HorzAlignment, VertAlignment, ShowAccel);
end;

function GetDwmBorderIconsRect(Form: TForm): TRect;
begin
  if DwmGetWindowAttribute(Form.Handle, DWMWA_CAPTION_BUTTON_BOUNDS, @Result,
    SizeOf(Result)) <> S_OK then SetRectEmpty(Result);
end;

procedure ShowSystemMenu(Form: TForm; const Message: TWMNCRButtonUp);
var
  Cmd: WPARAM;
  Menu: HMENU;

  procedure UpdateItem(ID: UINT; Enable: Boolean; MakeDefaultIfEnabled: Boolean = False);
  const
    Flags: array[Boolean] of UINT = (MF_GRAYED, MF_ENABLED);
  begin
    EnableMenuItem(Menu, ID, MF_BYCOMMAND or Flags[Enable]);
    if MakeDefaultIfEnabled and Enable then
      SetMenuDefaultItem(Menu, ID, MF_BYCOMMAND);
  end;
begin
  Menu := GetSystemMenu(Form.Handle, False);
  if Form.BorderStyle in [bsSingle, bsSizeable, bsToolWindow, bsSizeToolWin] then
  begin
    SetMenuDefaultItem(Menu, UINT(-1), 0);
    UpdateItem(SC_RESTORE, Form.WindowState <> wsNormal, True);
    UpdateItem(SC_MOVE, Form.WindowState <> wsMaximized);
    UpdateItem(SC_SIZE, (Form.WindowState <> wsMaximized) and
      (Form.BorderStyle in [bsSizeable, bsSizeToolWin]));
    UpdateItem(SC_MINIMIZE, (biMinimize in Form.BorderIcons) and
      (Form.BorderStyle in [bsSingle, bsSizeable]));
    UpdateItem(SC_MAXIMIZE, (biMaximize in Form.BorderIcons) and
      (Form.BorderStyle in [bsSingle, bsSizeable]) and
      (Form.WindowState <> wsMaximized), True);
  end;
  if Message.HitTest = HTSYSMENU then
    SetMenuDefaultItem(Menu, SC_CLOSE, MF_BYCOMMAND);
  Cmd := WPARAM(TrackPopupMenu(Menu, TPM_RETURNCMD or
    GetSystemMetrics(SM_MENUDROPALIGNMENT), Message.XCursor,
    Message.YCursor, 0, Form.Handle, nil));
  PostMessage(Form.Handle, WM_SYSCOMMAND, Cmd, 0)
end;

function SystemScaleToStr(Scale: TGnvSystemScale): string;
begin
  case Scale of
    gssAuto:  Result := 'Auto';
    gss100:   Result := '100';
    gss125:   Result := '125';
    gss150:   Result := '150';
    gss175:   Result := '175';
    gss200:   Result := '200';
  end;
end;

function SystemThemeToStr(Theme: TGnvSystemTheme): string;
begin
  case Theme of
    gstAuto:    Result := 'Auto';
    gstClassic: Result := 'Classic';
    gstPlastic: Result := 'Plastic';
    gstFlat:    Result := 'Flat';
  end;
end;

procedure TMainForm.CMTextChanged(var Message: TMessage);
begin
  inherited;
  InvalidateTitleBar;
end;

procedure TMainForm.ComboBoxScaleSelect(Sender: TObject);
begin
  ToolBarGlyphs.Scale := TGnvSystemScale(ComboBoxScale.Items.Objects[ComboBoxScale.ItemIndex]);
end;

procedure TMainForm.ComboBoxThemeSelect(Sender: TObject);
begin
  ToolBarGlyphs.Theme := TGnvSystemTheme(ComboBoxTheme.Items.Objects[ComboBoxTheme.ItemIndex]);
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
//  Padding.Right := getSysIconRect.Right;
  Caption := Application.Title;
  Load;
end;

procedure TMainForm.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  R: TRect;
begin
//  GnvTabBar1.Transparent := True;
{
	if DwmCompositionEnabled then
	begin
		SetRectEmpty(R);
		AdjustWindowRectEx(R, GetWindowLong(Handle, GWL_STYLE), False,
			GetWindowLong(Handle, GWL_EXSTYLE));
		FWndFrameSize := R.Right;
		GlassFrame.Top := -R.Top;
		GlassFrame.Enabled := True;
		SetWindowPos(Handle, 0, Left, Top, Width, Height, SWP_FRAMECHANGED);
		DoubleBuffered := True;
	end;
}
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  IconHandle: HICON;
  R: TRect;
begin
(*
  // Drawing icon
  if ImageList1.Count = 0 then
  begin
    ImageList1.Width := GetSystemMetrics(SM_CXSMICON);
    ImageList1.Height := GetSystemMetrics(SM_CYSMICON);
    {$IF NOT DECLARED(TColorDepth)}
    ImageList1.Handle := ImageList_Create(ImageList1.Width,
      ImageList1.Height, ILC_COLOR32 or ILC_MASK, 1, 1);
    {$IFEND}
    IconHandle := Icon.Handle;
    if IconHandle = 0 then IconHandle := Application.Icon.Handle;
    ImageList_AddIcon(ImageList1.Handle, IconHandle);
  end;
  R := GetSysIconRect;
  ImageList1.Draw(Canvas, R.Left, R.Top, 0);
{
  // Drawing title
  R.Left := R.Right + FWndFrameSize - 3;
  if WindowState = wsMaximized then
    R.Top := FWndFrameSize
  else
    R.Top := 0;
  R.Right := GetDwmBorderIconsRect(Self).Left - FWndFrameSize - 1;
  R.Bottom := GlassFrame.Top;
}

	DrawGlassCaption(Self, R);

*)
end;

function TMainForm.GetSysIconRect: TRect;
begin
  if not (biSystemMenu in BorderIcons) or not (BorderStyle in [bsSingle, bsSizeable]) then
    SetRectEmpty(Result)
  else
  begin
    Result.Left := 0;
    Result.Right := GetSystemMetrics(SM_CXSMICON);
    Result.Bottom := GetSystemMetrics(SM_CYSMICON);
    if WindowState = wsMaximized then
      Result.Top := GlassFrame.Top - Result.Bottom - 2
    else
      Result.Top := 6; //is the 'right' value for both normal and large fonts on my machine
    Inc(Result.Bottom, Result.Top);
  end;
end;

procedure TMainForm.InvalidateTitleBar;
var
  R: TRect;
begin
  if not HandleAllocated then Exit;
  R.Left := 0;
  R.Top := 0;
  R.Right := Width;
  R.Bottom := GlassFrame.Top;
  InvalidateRect(Handle, @R, False);
end;

procedure TMainForm.Load;
var
  Scale: TGnvSystemScale;
  Theme: TGnvSystemTheme;
begin
  ComboBoxScale.Items.BeginUpdate;
  for Scale := Low(TGnvSystemScale) to High(TGnvSystemScale) do
    ComboBoxScale.Items.AddObject(SystemScaleToStr(Scale), TObject(Scale));
  ComboBoxScale.ItemIndex := 0;
  ComboBoxScale.Items.EndUpdate;

  ComboBoxTheme.Items.BeginUpdate;
  for Theme := Low(TGnvSystemTheme) to High(TGnvSystemTheme) do
    ComboBoxTheme.Items.AddObject(SystemThemeToStr(Theme), TObject(Theme));
  ComboBoxTheme.ItemIndex := 0;
  ComboBoxTheme.Items.EndUpdate;
end;

procedure TMainForm.PaintWindow(DC: HDC);
begin
  with GetClientRect do
    ExcludeClipRect(DC, 0, GlassFrame.Top, Right, Bottom);
  inherited;
end;

procedure TMainForm.WMActivate(var Message: TWMActivate);
begin
  inherited;
  InvalidateTitleBar;
end;

procedure TMainForm.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  if not GlassFrame.Enabled then
    inherited
  else
    with Message.CalcSize_Params.rgrc[0] do
    begin
      Inc(Left, FWndFrameSize);
      Dec(Right, FWndFrameSize);
      Dec(Bottom, FWndFrameSize);
    end;
end;

procedure TMainForm.WMNCHitTest(var Message: TWMNCHitTest);
var
  ClientPos: TPoint;
  IconRect: TRect;
begin
  inherited;
  if not GlassFrame.Enabled then Exit;
  case Message.Result of
    HTCLIENT: {to be dealt with below};
    HTMINBUTTON, HTMAXBUTTON, HTCLOSE:
    begin
      Message.Result := HTCAPTION; //slay ghost btns when running on Win64
      Exit;
    end;
  else Exit;
  end;
  ClientPos := ScreenToClient(Point(Message.XPos, Message.YPos));
  if ClientPos.Y > GlassFrame.Top then Exit;
  if ControlAtPos(ClientPos, True) <> nil then Exit;
  IconRect := GetSysIconRect;
  if (ClientPos.X < IconRect.Right) and ((WindowState = wsMaximized) or
     ((ClientPos.Y >= IconRect.Top) and (ClientPos.Y < IconRect.Bottom))) then
    Message.Result := HTSYSMENU
  else if ClientPos.Y < FWndFrameSize then
    Message.Result := HTTOP
  else
    Message.Result := HTCAPTION;
end;

procedure TMainForm.WMNCRButtonUp(var Message: TWMNCRButtonUp);
begin
  if not GlassFrame.Enabled or not (biSystemMenu in BorderIcons) then
    inherited
  else
    case Message.HitTest of
      HTCAPTION, HTSYSMENU: ShowSystemMenu(Self, Message);
    else inherited;
    end;
end;

procedure TMainForm.WMWindowPosChanging(var Message: TWMWindowPosChanging);
const
  SWP_STATECHANGED = $8000; //see TCustomForm.WMWindowPosChanging in Forms.pas
begin
  if GlassFrame.Enabled then
    if (Message.WindowPos.flags and SWP_STATECHANGED) = SWP_STATECHANGED then
      Invalidate
    else
      InvalidateTitleBar;
  inherited;
end;

procedure TMainForm.WndProc(var Message: TMessage);
begin
  if GlassFrame.Enabled and HandleAllocated and DwmDefWindowProc(Handle,
    Message.Msg, Message.WParam, Message.LParam, Message.Result) then Exit;
  inherited;
end;

end.

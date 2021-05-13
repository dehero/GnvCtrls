unit GnvStdCtrls;

interface

uses
	Windows, StdCtrls, Graphics, Messages, Classes, Controls, SysUtils, ExtCtrls,
	CommCtrl, ComCtrls, ComStrs, Forms;

const
	UDM_SETPOS32 = WM_USER + 113;
	UDM_GETPOS32 = WM_USER + 114;

type

  { TGnvUpDown }

  TGnvUDAlignButton = (udLeft, udRight);
  TGnvUDOrientation = (udHorizontal, udVertical);
  TGnvUDBtnType = (btNext, btPrev);
  TGnvUpDownDirection = (updNone, updUp, updDown);
  TGnvUDClickEvent = procedure (Sender: TObject; Button: TGnvUDBtnType) of object;
  TGnvUDChangingEvent = procedure (Sender: TObject; var AllowChange: Boolean) of object;
  TGnvUDChangingEventEx = procedure (Sender: TObject; var AllowChange: Boolean; NewValue: LongInt; Direction: TGnvUpDownDirection) of object;

  TGnvUpDown = class(TWinControl)
  private
    FArrowKeys: Boolean;
    FAssociate: TWinControl;
    FMin: LongInt;
    FMax: LongInt;
    FIncrement: Integer;
    FNewValue: LongInt;
    FNewValueDelta: LongInt;
    FPosition: LongInt;
    FThousands: Boolean;
    FWrap: Boolean;
    FOnClick: TGnvUDClickEvent;
    FAlignButton: TGnvUDAlignButton;
    FOrientation: TGnvUDOrientation;
    FOnChanging: TGnvUDChangingEvent;
		FOnChangingEx: TGnvUDChangingEventEx;
    procedure UndoAutoResizing(Value: TWinControl);
		procedure SetAssociate(Value: TWinControl);
		function GetPosition: LongInt;
		procedure SetMin(Value: LongInt);
		procedure SetMax(Value: LongInt);
		procedure SetIncrement(Value: Integer);
		procedure SetPosition(Value: LongInt);
		procedure SetAlignButton(Value: TGnvUDAlignButton);
		procedure SetOrientation(Value: TGnvUDOrientation);
		procedure SetArrowKeys(Value: Boolean);
		procedure SetThousands(Value: Boolean);
		procedure SetWrap(Value: Boolean);
    procedure CMAllChildrenFlipped(var Message: TMessage); message CM_ALLCHILDRENFLIPPED;
		procedure CNNotify(var Message: TWMNotifyUD); message CN_NOTIFY;
    procedure WMHScroll(var Message: TWMHScroll); message CN_HSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message CN_VSCROLL;
  protected
    function DoCanChange(NewVal: LongInt; Delta: LongInt): Boolean;
    function CanChange: Boolean; dynamic;
		procedure CreateParams(var Params: TCreateParams); override;
		procedure CreateWnd; override;
		procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Click(Button: TGnvUDBtnType); reintroduce; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
		property AlignButton: TGnvUDAlignButton read FAlignButton write SetAlignButton default udRight;
    property ArrowKeys: Boolean read FArrowKeys write SetArrowKeys default True;
    property Associate: TWinControl read FAssociate write SetAssociate;
    property DoubleBuffered;
    property Enabled;
    property Hint;
    property Min: LongInt read FMin write SetMin default 0;
    property Max: LongInt read FMax write SetMax default 100;
    property Increment: Integer read FIncrement write SetIncrement default 1;
    property Constraints;
    property Orientation: TGnvUDOrientation read FOrientation write SetOrientation default udVertical;
    property ParentDoubleBuffered;
    property ParentShowHint;
    property PopupMenu;
		property Position: LongInt read GetPosition write SetPosition default 0;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Thousands: Boolean read FThousands write SetThousands default True;
    property Visible;
    property Wrap: Boolean read FWrap write SetWrap default False;
    property OnChanging: TGnvUDChangingEvent read FOnChanging write FOnChanging;
    property OnChangingEx: TGnvUDChangingEventEx read FOnChangingEx write FOnChangingEx;
    property OnContextPopup;
    property OnClick: TGnvUDClickEvent read FOnClick write FOnClick;
    property OnEnter;
    property OnExit;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
		property OnMouseUp;
	end;

	{ TGnvEdit }

	TGnvCustomEdit = class(TCustomEdit)
	private
  	FCanvas: TCanvas;
		FMaxText: string;
		procedure AdjustWidth;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
	protected
  	function GetMaxTextWidth: Integer; virtual;
		procedure SetMaxText(const Value: string); virtual;
		procedure SetParent(AParent: TWinControl); override;
	public
		constructor Create(AOwner: TComponent); override;
  	destructor Destroy; override;
    property MaxText: string read FMaxText write SetMaxText;
  end;

	TGnvEdit = class(TGnvCustomEdit)
  published
    property Align;
    property Alignment;
		property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
		property MaxLength;
    property MaxText;
    property NumbersOnly;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property TextHint;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
	end;

	{ TGnvSpinEdit }

	TGnvSpinEdit = class(TGnvCustomEdit)
	private
		FButton: TGnvUpDown;
    FOnUpDownMouseUp: TMouseEvent;
    FOnUpDownKeyUp: TKeyEvent;
		function GetMinHeight: Integer;
		function GetValue: LongInt;
    procedure SetValue (NewValue: LongInt);
		procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
		procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMPaste(var Message: TWMPaste); message WM_PASTE;
    procedure WMCut(var Message: TWMCut); message WM_CUT;
    function GetIncrement: LongInt;
    function GetMaxValue: LongInt;
    function GetMinValue: LongInt;
    procedure SetIncrement(const Value: LongInt);
    procedure SetMaxValue(const Value: LongInt);
    procedure SetMinValue(const Value: LongInt);
    function GetThousands: Boolean;
    procedure SetThousands(const Value: Boolean);
    function GetWrap: Boolean;
    procedure SetWrap(const Value: Boolean);
    procedure SetArrowKeys(const Value: Boolean);
    function GetArrowKeys: Boolean;
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
		procedure CreateParams(var Params: TCreateParams); override;
		procedure CreateWnd; override;
		function GetMaxTextWidth: Integer; override;
  public
		constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
		property Button: TGnvUpDown read FButton;
  published
    property Align;
		property Anchors;
    property ArrowKeys: Boolean read GetArrowKeys write SetArrowKeys default True;
		property AutoSelect;
		property AutoSize;
		property Color;
    property Constraints;
		property Ctl3D;
		property DragCursor;
    property DragMode;
    property Enabled;
		property Font;
		property Increment: LongInt read GetIncrement write SetIncrement default 1;
    property MaxLength;
		property MaxValue: LongInt read GetMaxValue write SetMaxValue;
		property MinValue: LongInt read GetMinValue write SetMinValue;
		property ParentColor;
    property ParentCtl3D;
		property ParentFont;
    property ParentShowHint;
		property PopupMenu;
    property ReadOnly;
		property ShowHint;
    property TabOrder;
		property TabStop;
    property TextHint;
    property Thousands: Boolean read GetThousands write SetThousands default True;
    property Value: LongInt read GetValue write SetValue;
		property Visible;
    property Wrap: Boolean read GetWrap write SetWrap default False;
    property OnChange;
		property OnClick;
		property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
		property OnEndDrag;
		property OnEnter;
    property OnExit;
		property OnKeyDown;
    property OnKeyPress;
		property OnKeyUp;
    property OnMouseDown;
		property OnMouseMove;
		property OnMouseUp;
		property OnStartDrag;
    property OnUpDownKeyUp: TKeyEvent read FOnUpDownKeyUp write FOnUpDownKeyUp;
    property OnUpDownMouseUp: TMouseEvent read FOnUpDownMouseUp write FOnUpDownMouseUp;
	end;

  TGnvButton = class(TButton)
  private
    FAlignment: TAlignment;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure SetAlignment(const Value: TAlignment);
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property AutoSize;
  end;

  TGnvCheckBox = class(TCheckBox)
  private
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSize;
  end;

  TGnvRadioButton = class(TRadioButton)
  private
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSize;
	end;

	TGnvMemo = class(TMemo)
	private
  	FCanvas: TCanvas;
		FTextHint: string;
    procedure SetTextHint(const Value: string);
	protected
		procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
	public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
	published
  	property TextHint: string read FTextHint write SetTextHint;
  end;

	TGnvScrollBox = class(TScrollBox)
	protected
		function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
		procedure WndProc(var Message: TMessage); override;
	end;

procedure Register;

implementation

uses
  StrUtils, Themes;

procedure Register;
begin
	RegisterComponents('GnvCtrls', [TGnvSpinEdit, TGnvEdit,
		TGnvUpDown, TGnvButton, TGnvCheckBox, TGnvRadioButton, TGnvScrollBox,
		TGnvMemo]);
end;

{ TGnvUpDown }

constructor TGnvUpDown.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := GetSystemMetrics(SM_CXVSCROLL);
  Height := GetSystemMetrics(SM_CYVSCROLL);
  Height := Height + (Height div 2);
  FArrowKeys := True;
  FWrap := false;
  FPosition := 0;
  FMin := 0;
  FMax := 100;
  FIncrement := 1;
  FAlignButton := udRight;
  FOrientation := udVertical;
  FThousands := True;
  ControlStyle := ControlStyle - [csDoubleClicks];
end;

procedure TGnvUpDown.CreateParams(var Params: TCreateParams);
begin
  InitCommonControl(ICC_UPDOWN_CLASS);
  inherited CreateParams(Params);
  with Params do
  begin
		Style := Style or UDS_SETBUDDYINT;
		if FAssociate <> Self.Parent then
		begin
			if FAlignButton = udRight then
				Style := Style or UDS_ALIGNRIGHT
			else
				Style := Style or UDS_ALIGNLEFT;
		end;
    if FOrientation = udHorizontal then Style := Style or UDS_HORZ;
    if FArrowKeys then Style := Style or UDS_ARROWKEYS;
    if not FThousands then Style := Style or UDS_NOTHOUSANDS;
    if FWrap then Style := Style or UDS_WRAP;
  end;
  CreateSubClass(Params, UPDOWN_CLASS);
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW) or CS_DBLCLKS;
end;

procedure TGnvUpDown.CreateWnd;
var
  OrigWidth: Integer;
  AccelArray: array [0..0] of TUDAccel;
begin
  OrigWidth := Width;  { control resizes width - disallowing user to set width }
  inherited CreateWnd;
  if FAssociate <> nil then
  begin
		UndoAutoResizing(FAssociate);
		SendMessage(Handle, UDM_SETBUDDY, FAssociate.Handle, 0);
  end;
	Width := OrigWidth;
	SendMessage(Handle, UDM_SETRANGE32, FMin, FMax);
	SendMessage(Handle, UDM_SETPOS32, 0, FPosition);
	SendGetStructMessage(Handle, UDM_GETACCEL, 1, AccelArray[0]);
  AccelArray[0].nInc := FIncrement;
  SendStructMessage(Handle, UDM_SETACCEL, 1, AccelArray[0]);
end;

procedure TGnvUpDown.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  if Message.ScrollCode = SB_THUMBPOSITION then
  begin
    if Message.Pos > FPosition then
      Click(btNext)
    else if Message.Pos < FPosition then
      Click(btPrev);

    FPosition := Message.Pos;
  end;
end;

procedure TGnvUpDown.WMSize(var Message: TWMSize);
var
  R: TRect;
begin
  inherited;
  R := ClientRect;
  InvalidateRect(Handle, R, False);
end;

procedure TGnvUpDown.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  if Message.ScrollCode = SB_THUMBPOSITION then
  begin
    if Message.Pos > FPosition then
      Click(btNext)
    else if Message.Pos < FPosition then
      Click(btPrev);

    FPosition := Message.Pos;
  end;
end;

function TGnvUpDown.DoCanChange(NewVal: LongInt; Delta: LongInt): Boolean;
begin
  FNewValue := NewVal;
  FNewValueDelta := Delta;

  Result := CanChange;
end;

function TGnvUpDown.CanChange: Boolean;
var
  Direction: TGnvUpDownDirection;
begin
  Result := True;
  Direction := updNone;

	if (FNewValue < Min) and (FNewValueDelta < 0) or
		(FNewValue > Max) and (FNewValueDelta > 0) then
		Direction := updNone
	else if FNewValueDelta < 0 then
    Direction := updDown
  else if FNewValueDelta > 0 then
    Direction := updUp;

  if Assigned(FOnChanging) then
    FOnChanging(Self, Result);
  if Assigned(FOnChangingEx) then
		FOnChangingEx(Self, Result, FNewValue, Direction);
end;

procedure TGnvUpDown.CMAllChildrenFlipped(var Message: TMessage);
begin
	if FAlignButton = udRight then
    SetAlignButton(udLeft)
  else
    SetAlignButton(udRight);
end;

procedure TGnvUpDown.CNNotify(var Message: TWMNotifyUD);
begin
	with Message.NMUpDown{$IFNDEF CLR}^{$ENDIF} do
    if Hdr.code = UDN_DELTAPOS then
    begin
			Message.Result := Integer(not DoCanChange(iPos + iDelta, iDelta));
    end;
end;

procedure TGnvUpDown.Click(Button: TGnvUDBtnType);
begin
	if Assigned(FOnClick) then FOnClick(Self, Button);
	// Fixes buddy window not recieving text change event on updown click
	if Assigned(FAssociate) then
    FAssociate.Perform(CM_TEXTCHANGED, 0, 0);
end;

procedure TGnvUpDown.SetAssociate(Value: TWinControl);
var
	I: Integer;

  function IsClass(ClassType: TClass; const Name: string): Boolean;
  begin
    Result := True;
    while ClassType <> nil do
    begin
      if ClassType.ClassNameIs(Name) then Exit;
      ClassType := ClassType.ClassParent;
    end;
    Result := False;
  end;

begin
  if (Value <> nil) and (Value <> Self.Parent) then
    for I := 0 to Parent.ControlCount - 1 do // is control already associated
      if (Parent.Controls[I] is TGnvUpDown) then
        if TGnvUpDown(Parent.Controls[I]).Associate = Value then
          raise Exception.CreateResFmt({$IFNDEF CLR}@{$ENDIF}SUDAssociated,
            [Value.Name, Parent.Controls[I].Name]);

  if FAssociate <> nil then { undo the current associate control }
  begin
    if HandleAllocated then
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
    FAssociate := nil;
  end;

	if (Value <> nil) and ((Value.Parent = Self.Parent) or (Value = Self.Parent)) and
    not (Value is TGnvUpDown) and
    not (Value is TCustomTreeView) and not (Value is TCustomListView) and
    not IsClass(Value.ClassType, 'TDBEdit') and
		not IsClass(Value.ClassType, 'TDBMemo') then
  begin
    if HandleAllocated then
    begin
			UndoAutoResizing(Value);
			SendMessage(Handle, UDM_SETBUDDY, Value.Handle, 0);
    end;
    FAssociate := Value;
    if Value is TCustomEdit then
      TCustomEdit(Value).Text := IntToStr(FPosition);
  end;
end;

procedure TGnvUpDown.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAssociate) then
    if HandleAllocated then
    begin
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
      FAssociate := nil;
    end;
end;

function TGnvUpDown.GetPosition: LongInt;
begin
	if HandleAllocated then
  begin
		Result := SendMessage(Handle, UDM_GETPOS32, 0, 0);
    FPosition := Result;
  end
  else
    Result := FPosition;
end;

procedure TGnvUpDown.SetMin(Value: LongInt);
begin
  if Value <> FMin then
  begin
    FMin := Value;
    if HandleAllocated then
      SendMessage(Handle, UDM_SETRANGE32, FMin, FMax);
  end;
end;

procedure TGnvUpDown.SetMax(Value: LongInt);
begin
  if Value <> FMax then
  begin
    FMax := Value;
    if HandleAllocated then
      SendMessage(Handle, UDM_SETRANGE32, FMin, FMax);
  end;
end;

procedure TGnvUpDown.SetIncrement(Value: Integer);
var
  AccelArray: array [0..0] of TUDAccel;
begin
  if Value <> FIncrement then
  begin
    FIncrement := Value;
    if HandleAllocated then
    begin
			SendGetStructMessage(Handle, UDM_GETACCEL, 1, AccelArray[0]);
      AccelArray[0].nInc := Value;
      SendStructMessage(Handle, UDM_SETACCEL, 1, AccelArray[0]);
    end;
  end;
end;

procedure TGnvUpDown.SetPosition(Value: LongInt);
begin
  if Value <> Position then
  begin
    if not (csDesigning in ComponentState) then
      if not DoCanChange(Value, Value-FPosition) then Exit;
    FPosition := Value;
    if (csDesigning in ComponentState) and (FAssociate <> nil) then
      if FAssociate is TCustomEdit then
        TCustomEdit(FAssociate).Text := IntToStr(FPosition);
		if HandleAllocated then
			SendMessage(Handle, UDM_SETPOS32, 0, FPosition);
		// Fixes buddy window not recieving text change event on manual position change
		if Assigned(FAssociate) then FAssociate.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TGnvUpDown.SetOrientation(Value: TGnvUDOrientation);
begin
  if Value <> FOrientation then
  begin
    FOrientation := Value;
    if ComponentState * [csLoading, csUpdating] = [] then
      SetBounds(Left, Top, Height, Width);
    if HandleAllocated then
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
    RecreateWnd;
  end;
end;

procedure TGnvUpDown.SetAlignButton(Value: TGnvUDAlignButton);
begin
  if Value <> FAlignButton then
  begin
    FAlignButton := Value;
    if HandleAllocated then
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
    RecreateWnd;
  end;
end;

procedure TGnvUpDown.SetArrowKeys(Value: Boolean);
begin
  if Value <> FArrowKeys then
  begin
    FArrowKeys := Value;
    if HandleAllocated then
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
    RecreateWnd;
  end;
end;

procedure TGnvUpDown.SetThousands(Value: Boolean);
begin
  if Value <> FThousands then
  begin
    FThousands := Value;
    if HandleAllocated then
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
    RecreateWnd;
  end;
end;

procedure TGnvUpDown.SetWrap(Value: Boolean);
begin
  if Value <> FWrap then
  begin
    FWrap := Value;
    if HandleAllocated then
      SendMessage(Handle, UDM_SETBUDDY, 0, 0);
    RecreateWnd;
  end;
end;

procedure TGnvUpDown.UndoAutoResizing(Value: TWinControl);
var
	OrigWidth, NewWidth, DeltaWidth: Integer;
	OrigLeft, NewLeft, DeltaLeft: Integer;
begin
	if Value = Self.Parent then Exit;

  { undo Window's auto-resizing }
  OrigWidth := Value.Width;
  OrigLeft := Value.Left;
  SendMessage(Handle, UDM_SETBUDDY, Value.Handle, 0);
  NewWidth := Value.Width;
  NewLeft := Value.Left;
  DeltaWidth := OrigWidth - NewWidth;
  DeltaLeft := NewLeft - OrigLeft;
  Value.Width := OrigWidth + DeltaWidth;
	Value.Left := OrigLeft - DeltaLeft;
end;

{ TGnvCustomEdit }

procedure TGnvCustomEdit.AdjustWidth;
begin
	if Assigned(Parent) and AutoSize and (FMaxText <> '') and Assigned(FCanvas) then
	begin
		ClientWidth := GetMaxTextWidth;
		ControlStyle := ControlStyle - [csFixedWidth];
	end
	else
		ControlStyle := ControlStyle + [csFixedWidth];
end;

procedure TGnvCustomEdit.CMFontChanged(var Message: TMessage);
begin
	inherited;
	AdjustWidth;
end;

constructor TGnvCustomEdit.Create(AOwner: TComponent);
begin
	inherited;
	FMaxText := '';
	FCanvas := TControlCanvas.Create;
	TControlCanvas(FCanvas).Control := Self;
end;

destructor TGnvCustomEdit.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

function TGnvCustomEdit.GetMaxTextWidth: Integer;
begin
	FCanvas.Font := Self.Font;
	Result := FCanvas.TextWidth(FMaxText + '|') + Padding.Left + Padding.Right;
end;

procedure TGnvCustomEdit.SetMaxText(const Value: string);
begin
	FMaxText := Value;
	AdjustWidth;
end;

procedure TGnvCustomEdit.SetParent(AParent: TWinControl);
begin
  inherited;
	AdjustWidth;
end;

{ TGnvSpinEdit }

constructor TGnvSpinEdit.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

  FButton := TGnvUpDown.Create(Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.Associate := Self;
  FButton.OnMouseUp := ButtonMouseUp;
  FButton.OnKeyUp := ButtonKeyUp;
//  Text := '0';
  ControlStyle := ControlStyle - [csSetCaption];
	ParentBackground := False;
end;

destructor TGnvSpinEdit.Destroy;
begin
	FButton := nil;
	inherited;
end;

function TGnvSpinEdit.GetArrowKeys: Boolean;
begin
	Result := FButton.FArrowKeys;
end;

procedure TGnvSpinEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

function TGnvSpinEdit.GetIncrement: LongInt;
begin
	Result := FButton.FIncrement;
end;

procedure TGnvSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
{  Params.Style := Params.Style and not WS_BORDER;  }
  Params.Style := Params.Style or WS_CLIPCHILDREN;//ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TGnvSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TGnvSpinEdit.SetArrowKeys(const Value: Boolean);
begin
  FButton.SetArrowKeys(Value);
end;

procedure TGnvSpinEdit.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
end;

procedure TGnvSpinEdit.SetIncrement(const Value: LongInt);
begin
	FButton.SetIncrement(Value);
end;

procedure TGnvSpinEdit.SetMaxValue(const Value: LongInt);
begin
	FButton.SetMax(Value);
end;

procedure TGnvSpinEdit.SetMinValue(const Value: LongInt);
begin
	FButton.SetMin(Value);
end;

procedure TGnvSpinEdit.SetThousands(const Value: Boolean);
begin
  FButton.SetThousands(Value);
end;

procedure TGnvSpinEdit.WMCut(var Message: TWMCut);
begin
  if ReadOnly then Exit;
  inherited;
end;

procedure TGnvSpinEdit.WMPaste(var Message: TWMPaste);
begin
  if ReadOnly then Exit;
  inherited;
end;

procedure TGnvSpinEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }
  if Height < MinHeight then
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
			FButton.SetBounds(Width - FButton.Width - 4, 0, FButton.Width, Height - 4)
		else
			FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TGnvSpinEdit.GetMaxTextWidth: Integer;
begin
	Result := inherited + FButton.Width + 2;
end;

function TGnvSpinEdit.GetMaxValue: LongInt;
begin
	Result := FButton.FMax;
end;

function TGnvSpinEdit.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
	if I > Metrics.tmHeight then I := Metrics.tmHeight;
	Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
end;

function TGnvSpinEdit.GetMinValue: LongInt;
begin
	Result := FButton.FMin;
end;

function TGnvSpinEdit.GetThousands: Boolean;
begin
	Result := FButton.FThousands;
end;

function TGnvSpinEdit.GetValue: LongInt;
begin
  Result := FButton.GetPosition;
end;

function TGnvSpinEdit.GetWrap: Boolean;
begin
	Result := FButton.FWrap;
end;

procedure TGnvSpinEdit.SetValue(NewValue: LongInt);
begin
	FButton.SetPosition(NewValue);
end;

procedure TGnvSpinEdit.SetWrap(const Value: Boolean);
begin
	FButton.SetWrap(Value);
end;

procedure TGnvSpinEdit.ButtonKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FOnUpDownKeyUp) then
    FOnUpDownKeyUp(Self, Key, Shift);
end;

procedure TGnvSpinEdit.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnUpDownMouseUp) then
    FOnUpDownMouseUp(Self, Button, Shift, X, Y);
end;

procedure TGnvSpinEdit.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited;
end;

procedure TGnvSpinEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  Text := IntToStr(GetValue);
end;

{ TGnvButton }

function TGnvButton.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
const
  WordBreak: array[Boolean] of Cardinal = (0, DT_WORDBREAK);
var
  DC: HDC;
  Margin: Integer;
  R: TRect;
  SaveFont: HFONT;
  DrawFlags: Cardinal;
begin
  DC := GetDC(Handle);
  try
    NewWidth := 0;
    NewHeight := 0;
    Margin := 6;

    if Caption <> '' then
    begin
      Margin := Margin + Abs(Font.Height) div 5;
      SetRect(R, 0, 0, NewWidth - Margin, NewHeight - Margin);
      SaveFont := SelectObject(DC, Font.Handle);
      DrawFlags := DT_LEFT or DT_CALCRECT or WordBreak[WordWrap];
      DrawText(DC, PChar(' ' + Caption + ' '), -1, R, DrawFlags);
      SelectObject(DC, SaveFont);
      NewWidth := R.Right;
      NewHeight := R.Bottom;
    end;

    if Assigned(Images) and (ImageIndex > -1) then
    begin
      NewWidth := NewWidth + Images.Width;
      if Images.Height > NewHeight then
        NewHeight := Images.Height;
    end;

    NewHeight := NewHeight + Margin;
    NewWidth := NewWidth + Margin;
  finally
    ReleaseDC(Handle, DC);
  end;
  Result := True;
end;

procedure TGnvButton.CMFontchanged(var Message: TMessage);
begin
  inherited;
  AdjustSize;
end;

procedure TGnvButton.CMTextchanged(var Message: TMessage);
begin
  inherited;
  AdjustSize;
end;

constructor TGnvButton.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taCenter;
end;

procedure TGnvButton.CreateParams(var Params: TCreateParams);
begin
	inherited;

  case FAlignment of
    taLeftJustify:  Params.Style := Params.Style or BS_LEFT;
    taRightJustify: Params.Style := Params.Style or BS_RIGHT;
    taCenter:       Params.Style := Params.Style or BS_CENTER;
  end;
end;

procedure TGnvButton.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

{ TGnvCheckBox }

function TGnvCheckBox.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  Canvas: TCanvas;
  Size: Integer;
begin
//  inherited;

  Canvas := TCanvas.Create;
  try
    Canvas.Handle := GetDC(Handle);
    try
      Canvas.Font := Self.Font;
      NewWidth := GetSystemMetrics(SM_CXMENUCHECK) + 4 + Canvas.TextWidth(Caption);
      NewHeight := GetSystemMetrics(SM_CYMENUCHECK);
      Size := Canvas.TextHeight(Caption);
      if Size > NewHeight then NewHeight := Size;
    finally
      ReleaseDC(Handle, Canvas.Handle);
    end;
  finally
    Canvas.Free;
  end;
  Result := True;
end;

procedure TGnvCheckBox.CMFontchanged(var Message: TMessage);
begin
  inherited;
  AdjustSize;
end;

procedure TGnvCheckBox.CMTextChanged(var Message: TMessage);
begin
  inherited;
  AdjustSize;
end;

constructor TGnvCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  AdjustSize;
end;

{ TGnvRadioButton }

function TGnvRadioButton.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  Canvas: TCanvas;
  Size: Integer;
begin
//  inherited;

  Canvas := TCanvas.Create;
  try
    Canvas.Handle := GetDC(Handle);
    try
      Canvas.Font := Self.Font;
      NewWidth := GetSystemMetrics(SM_CXMENUCHECK) + 4 + Canvas.TextWidth(Caption);
      NewHeight := GetSystemMetrics(SM_CYMENUCHECK);
      Size := Canvas.TextHeight(Caption);
      if Size > NewHeight then NewHeight := Size;
    finally
      ReleaseDC(Handle, Canvas.Handle);
    end;
  finally
    Canvas.Free;
  end;
  Result := True;
end;

procedure TGnvRadioButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustSize;
end;

procedure TGnvRadioButton.CMTextChanged(var Message: TMessage);
begin
  inherited;
  AdjustSize;
end;

constructor TGnvRadioButton.Create(AOwner: TComponent);
begin
  inherited;
  AdjustSize;
end;

{ TGnvScollBox }

function TGnvScrollBox.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if not Result then begin
    if Shift*[ssShift..ssCtrl]=[] then begin
      VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
      Result := True;
    end;
  end;
end;

procedure TGnvScrollBox.WndProc(var Message: TMessage);
const
  WM_MOUSEHWHEEL = $020E;
begin
  if Message.Msg = WM_MOUSEHWHEEL then begin
    (* For some reason using a message handler for WM_MOUSEHWHEEL doesn't work. The messages
       don't always arrive. It seems to occur when both scroll bars are active. Strangely,
       if we handle the message here, then the messages all get through. Go figure! *)
    if TWMMouseWheel(Message).Keys=0 then
    begin
      HorzScrollBar.Position := HorzScrollBar.Position + TWMMouseWheel(Message).WheelDelta;
      Message.Result := 0;
    end
    else
      Message.Result := 1;
  end
  else
    inherited;
end;

{ TGnvMemo }

constructor TGnvMemo.Create(AOwner: TComponent);
begin
  inherited;
	FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TGnvMemo.Destroy;
begin
	FCanvas.Free;
  inherited;
end;

procedure TGnvMemo.SetTextHint(const Value: string);
begin
	FTextHint := Value;
	Repaint;
end;

procedure TGnvMemo.WMPaint(var Message: TWMPaint);
begin
	inherited;
	if (Text = '') and not Focused then
	begin
		FCanvas.Font := Font;
		FCanvas.Font.Color := clGrayText;
		FCanvas.TextOut(1, 1, FTextHint);
  end;
end;

end.

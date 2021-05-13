unit GnvCtrls;

interface

uses
  Classes, Controls, ComCtrls, Messages, Windows, StdCtrls, ExtCtrls,
  ActnList, Graphics, Menus, GDIPlus, Dialogs, ImgList;

const
  GNV_ITEM_ELEMENT_GUTTER = 4;
  GNV_ITEM_PADDING = 2;

type
	TGnvDirection = (gdUp, gdDown, gdLeft, gdRight);
	TGnvDirections = set of TGnvDirection;
  TGnvOrientation = (goBackward, goForward);

	TGnvGlyph = (
    glNone,
    glClose,
    glCaret,
    glChevron,
    glArrow,
    glPlus,
    glMinus,
    glMenu,
    glPane,
    glUpdate,
    glSync,
    glSearch,
    glRound
	);

  TGnvGlyphState = (
    glsNormal,
    glsDisabled,
    glsPressed,
    glsSelected,
    glsLink
  );

  TGnvSystemColor = (
    gscCtrlLight,
    gscCtrlLight0875,
    gscCtrlLight0750,
    gscCtrlLight0625,
    gscCtrlLight0500,
    gscCtrlLight0375,
    gscCtrlLight0250,
    gscCtrlLight0125,
    gscCtrl,
    gscCtrlShade0125,
    gscCtrlShade0250,
    gscCtrlShade0375,
    gscCtrlShade0500,
    gscCtrlShade0625,
    gscCtrlShade0750,
    gscCtrlShade0875,
    gscCtrlShade,
    gscCtrlText,
    gscLinkText,
    gscWindow,
    gscWindowText
  );
	TGnvSystemTheme = (gstAuto, gstClassic, gstPlastic, gstFlat);
	TGnvSystemScale = (gssAuto, gss100, gss125, gss150, gss175, gss200);

  TGnvBorder = (gbTop, gbBottom, gbLeft, gbRight);
  TGnvBorders = set of TGnvBorder;

  TGnvControl = class;

  TGnvControlColors = class(TPersistent)
  private
    FControl: TGnvControl;
    FPlasticColor1: TGnvSystemColor;
    FFlatColor: TGnvSystemColor;
    FPlasticColor2: TGnvSystemColor;
    FClassicColor: TGnvSystemColor;
    procedure SetFlatColor(const Value: TGnvSystemColor);
    procedure SetPlasticColor1(const Value: TGnvSystemColor);
    procedure SetPlasticColor2(const Value: TGnvSystemColor);
    procedure SetClassicColor(const Value: TGnvSystemColor);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AControl: TGnvControl); reintroduce;
  published
    property ClassicColor: TGnvSystemColor read FClassicColor write SetClassicColor default gscCtrl;
    property FlatColor: TGnvSystemColor read FFlatColor write SetFlatColor default gscCtrlLight0250;
    property PlasticColor1: TGnvSystemColor read FPlasticColor1 write SetPlasticColor1 default gscCtrlLight0750;
    property PlasticColor2: TGnvSystemColor read FPlasticColor2 write SetPlasticColor2 default gscCtrl;
  end;

  TGnvControlStyle = class(TGnvControlColors)
  private
    FFlatRadius: Cardinal;
    FPlasticRadius: Cardinal;
    FFlatShowBorders: Boolean;
    FPlasticShowBorders: Boolean;
    FClassicShowBorders: Boolean;
    procedure SetFlatRadius(const Value: Cardinal);
    procedure SetPlasticRadius(const Value: Cardinal);
    procedure SetFlatShowBorders(const Value: Boolean);
    procedure SetClassicShowBorders(const Value: Boolean);
    procedure SetPlasticShowBorders(const Value: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AControl: TGnvControl); reintroduce;
    function GetRadius(Theme: TGnvSystemTheme = gstAuto): Cardinal;
    function GetShowBorders(Theme: TGnvSystemTheme = gstAuto): Boolean;
  published
    property ClassicShowBorders: Boolean read FClassicShowBorders write SetClassicShowBorders default True;
    property FlatShowBorders: Boolean read FFlatShowBorders write SetFlatShowBorders default True;
		property FlatRadius: Cardinal read FFlatRadius write SetFlatRadius default 0;
		property PlasticRadius: Cardinal read FPlasticRadius write SetPlasticRadius default 4;
    property PlasticShowBorders: Boolean read FPlasticShowBorders write SetPlasticShowBorders default True;
  end;

  TGnvControl = class(TCustomControl)
  private
    FBorderSticking: TGnvDirections;
    FUpdateCount: Integer;
    FBorders: TGnvBorders;
    FScale: TGnvSystemScale;
    FTheme: TGnvSystemTheme;
    FStyle: TGnvControlStyle;
    FTransparent: Boolean;
    procedure SafeRepaint;
    function SafeTextExtent(const Text: string; AFont: TFont = nil): TSize;
		procedure SetBorderSticking(const Value: TGnvDirections);
		procedure SetBorders(const Value: TGnvBorders);
		function GetHideBorders: TGnvDirections;
		procedure SetScale(const Value: TGnvSystemScale);
		procedure SetTheme(const Value: TGnvSystemTheme);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
		procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
		procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetStyle(const Value: TGnvControlStyle);
    procedure SetTransparent(const Value: Boolean);
	protected
    procedure Paint; override;
		procedure Rebuild; virtual;
	public
		constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
		procedure EndUpdate;
		property Borders: TGnvBorders read FBorders write SetBorders default [gbTop, gbBottom, gbLeft, gbRight];
		property BorderSticking: TGnvDirections read FBorderSticking write SetBorderSticking default [];
		property Height default 21;
		property Scale: TGnvSystemScale read FScale write SetScale default gssAuto;
    property Style: TGnvControlStyle read FStyle write SetStyle;
		property Theme: TGnvSystemTheme read FTheme write SetTheme default gstAuto;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
		property Width default 185;
  end;

  TGnvProcessControl = class;

  TGnvProcessItem = class(TCollectionItem)
  private
    FProcessing: Boolean;
    FProcIndex: Integer;
		FStart: TTime;
    procedure SetProcessing(const Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    property Processing: Boolean read FProcessing write SetProcessing default False;
  end;

  TGnvProcessItems = class(TCollection)
  private
    FOwner: TGnvProcessControl;
  protected
    function GetOwner: TPersistent; override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TGnvProcessControl); overload;
  end;

  TGnvProcessControl = class(TGnvControl)
  private
    FProcDelay: Integer;
    FProcImages: TImageList;
    FProcInterval: Integer;
    FProcList: TList;
    procedure AddProc(Item: TGnvProcessItem);
    procedure DeleteProc(Item: TGnvProcessItem);
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure StartTimer; virtual;
    procedure StopTimer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ProcessDelay: Integer read FProcDelay write FProcDelay default 1000;
    property ProcessImages: TImageList read FProcImages write FProcImages;
    property ProcessInterval: Integer read FProcInterval write FProcInterval default 10;
  end;

  TGnvAnimate = class(TGnvControl)
  private
    FImageIndex: Integer;
    FImages: TImageList;
    FAnimating: Boolean;
    FInterval: Integer;
    FDelay: Integer;
    FStart: TTime;
    procedure SetAnimating(const Value: Boolean);
    procedure SetInterval(const Value: Integer);
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure Paint; override;
  published
    constructor Create(AOwner: TComponent); override;
    property Align;
    property Anchors;
    property Animating: Boolean read FAnimating write SetAnimating default False;
    property Color;
    property Delay: Integer read FDelay write FDelay default 1000;
    property Height;
    property Images: TImageList read FImages write FImages;
    property Interval: Integer read FInterval write SetInterval default 10;
    property BorderSticking;
    property Width;
		property Visible;
  end;

  TGnvPanel = class(TCustomPanel)
  private
    FHideBorders: TGnvDirections;
    FColorRow: Integer;
    FColorFlow: Boolean;
    FShowBorder: Boolean;
    FProcessing: Boolean;
    FProcInterval: Integer;
    FProcDelay: Integer;
    FProcImages: TImageList;
    procedure SafeRepaint;
    procedure SetHideBorders(const Value: TGnvDirections);
    procedure SetColorRow(const Value: Integer);
    procedure SetColorFlow(const Value: Boolean);
    procedure SetShowBorder(const Value: Boolean);
    procedure SetProcessing(const Value: Boolean);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
//    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property DockManager;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property ColorFlow: Boolean read FColorFlow write SetColorFlow default False;
    property ColorRow: Integer read FColorRow write SetColorRow default 0;
    property Constraints;
    property Ctl3D;
		property HideBorders: TGnvDirections read FHideBorders write SetHideBorders;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
	property Font;
    property FullRepaint;
    property Locked;
    property Padding;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ProcessDelay: Integer read FProcDelay write FProcDelay default 1000;
    property ProcessImages: TImageList read FProcImages write FProcImages;
    property ProcessInterval: Integer read FProcInterval write FProcInterval default 10;
    property Processing: Boolean read FProcessing write SetProcessing default False;
    property ShowBorder: Boolean read FShowBorder write SetShowBorder default True;
    property ShowCaption;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property VerticalAlignment;
    property Visible;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TGnvSplitter = class(TSplitter)
  private
    FResizeStyle: TResizeStyle;
    FHideBorders: TGnvDirections;
    procedure SetResizeStyle(const Value: TResizeStyle);
    procedure SetHideBorders(const Value: TGnvDirections);
  protected
		procedure Paint; override;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
  published
		property HideBorders: TGnvDirections read FHideBorders write SetHideBorders default [gdLeft,
			gdRight, gdUp, gdDown];
    property OnDblClick;
  end;

  TGnvToolBar = class;
  TGnvToolButton = class;

  TGnvToolButtonActionLink = class(TActionLink)
  protected
    FClient: TGnvToolButton;
    procedure AssignClient(AClient: TObject); override;
    function IsCaptionLinked: Boolean; override;
    function IsCheckedLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsNameLinked: Boolean;
    function IsImageIndexLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetName(const Value: string);
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TGnvToolButtonActionLinkClass = class of TGnvToolButtonActionLink;

	TGnvToolButtonKind = (gtkButton, gtkSwitch, gtkSeparator, gtkLabel, gtkEdit,
		gtkLink);
  TGnvToolButtonStyle = (gtsImage, gtsText, gtsImageText, gtsNone);
  TGnvToolButtonSelection = (gtlIndividual, gtlSwitchGroup);

	TGnvItemSizing = (
		gisValue,
		gisContent,
		gisContentToSize,
		gisMaxContent,
		gisMaxContentToSize,
		gisSpring,
		gisSpringToSize
	);

	TGnvItemElement = (
		gieIcon	= 0,
		gieText		= 1,
		gieButton = 2
	);
	TGnvItemElements = set of TGnvItemElement;

	TGnvIconKind = (gikNone, gikGlyph, gikImage, gikProcessGlyph, gikProcessImage);

	TGnvToolButton = class(TGnvProcessItem)
	private
		FKind: TGnvToolButtonKind;
    FActionLink: TGnvToolButtonActionLink;
    FStyle: TGnvToolButtonStyle;
    FEnabled: Boolean;
    FHint: string;
    FVisible: Boolean;
    FCaption: string;
    FChecked: Boolean;
    FImageIndex: Integer;
    FOnClick: TNotifyEvent;
    FDropdownMenu: TPopupMenu;
    FLeft: Integer;
    FWidth: Integer;
    FTag: Integer;
    FHidden: Boolean;
    FGroupIndex: Integer;
    FDirection: TGnvDirection;
    FShowArrow: Boolean;
    FBorderSticking: TGnvDirections;
    FSwitchGroup: Integer;
    FSelection: TGnvToolButtonSelection;
    FName: string;
    FTextWidth: Integer;
    FShowChecked: Boolean;
    FFont: TFont;
    FParentFont: Boolean;
    FEdit: TEdit;
    FOnChange: TNotifyEvent;
		FSizing: TGnvItemSizing;
    FSize: Integer;
    FPopupMenu: TPopupMenu;
    FCursor: TCursor;
    FParentCursor: Boolean;
    FImages: TCustomImageList;
    FParentImages: Boolean;
    FGlyph: TGnvGlyph;
    FGlyphDirection: TGnvDirection;
    FShowBorders: Boolean;
    FGlyphOrientation: TGnvOrientation;
    procedure DoActionChange(Sender: TObject);
    procedure SetKind(const Value: TGnvToolButtonKind);
    procedure SetAction(Value: TBasicAction);
    procedure SetStyle(const Value: TGnvToolButtonStyle);
    function GetSelected: Boolean;
    procedure SetSelected(const Value: Boolean);
    function GetToolBar: TGnvToolBar;
    function GetAction: TBasicAction;
    function IsCaptionStored: Boolean;
    function IsCheckedStored: Boolean;
    function IsEnabledStored: Boolean;
    function IsHintStored: Boolean;
    function IsImageIndexStored: Boolean;
    function IsOnClickStored: Boolean;
    function IsVisibleStored: Boolean;
    function IsHelpContextStored: Boolean;
    function IsShortCutStored: Boolean;
    procedure SetCaption(const Value: string);
    procedure SetChecked(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetImageIndex(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    function GetDown: Boolean;
    procedure SetDropdownMenu(const Value: TPopupMenu);
		procedure SetDown(const Value: Boolean);
    procedure SetDirection(const Value: TGnvDirection);
    procedure SetShowArrow(const Value: Boolean);
    procedure SetSelection(const Value: TGnvToolButtonSelection);
    function IsNameStored: Boolean;
    function GetGroupHidden: Boolean;
    procedure SetShowChecked(const Value: Boolean);
    function IsFontStored: Boolean;
    procedure SetFont(const Value: TFont);
    procedure SetParentFont(const Value: Boolean);
    procedure FontChanged(Sender: TObject);
    function GetCaption: string;
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetSizing(const Value: TGnvItemSizing);
    procedure SetSize(const Value: Integer);
    function IsCursorStored: Boolean;
    procedure SetCursor(const Value: TCursor);
		procedure SetParentCursor(const Value: Boolean);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetParentImages(const Value: Boolean);
    function IsImagesStored: Boolean;
		function GetImages: TCustomImageList;
		function GetIconSize: TSize;
    function GetIconKind: TGnvIconKind;
    procedure SetGlyph(const Value: TGnvGlyph);
    procedure SetGlyphDirection(const Value: TGnvDirection);
    procedure SetShowBorders(const Value: Boolean);
    function GetGlyphState: TGnvGlyphState;
    procedure SetGlyphOrientation(const Value: TGnvOrientation);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    property ActionLink: TGnvToolButtonActionLink read FActionLink write FActionLink;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;
    function GetActionLinkClass: TGnvToolButtonActionLinkClass; dynamic;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
		destructor Destroy; override;
		function CanShowBorders: Boolean;
		function Elements: TGnvItemElements;
		function IsHidden: Boolean;
		procedure Click;
		property Down: Boolean read GetDown write SetDown;
		property GroupHidden: Boolean read GetGroupHidden;
    property Selected: Boolean read GetSelected write SetSelected;
  published
    property Action: TBasicAction read GetAction write SetAction;
		property Caption: string read GetCaption write SetCaption stored IsCaptionStored;
    property Checked: Boolean read FChecked write SetChecked stored IsCheckedStored default False;
    property Direction: TGnvDirection read FDirection write SetDirection default gdDown;
		property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property Glyph: TGnvGlyph read FGlyph write SetGlyph default glNone;
    property GlyphDirection: TGnvDirection read FGlyphDirection write SetGlyphDirection default gdDown;
    property GlyphOrientation: TGnvOrientation read FGlyphOrientation write SetGlyphOrientation default goForward;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex default 0;
	property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    // ParentImages should be read before Images to load images correctly
		property ParentImages: Boolean read FParentImages write SetParentImages default True;
		property Images: TCustomImageList read GetImages write SetImages stored IsImagesStored;
    property Hint: string read FHint write FHint stored IsHintStored;
    property Name: string read FName write FName stored IsNameStored;
    property Kind: TGnvToolButtonKind read FKind write SetKind default gtkButton;
    // ParentCursor should be read before Cursor to load proper cursor
    property ParentCursor: Boolean read FParentCursor write SetParentCursor default True;
    property Cursor: TCursor read FCursor write SetCursor stored IsCursorStored;
    // ParentFont should be read before Font to load font correctly
		property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property Font: TFont read FFont write SetFont stored IsFontStored;
		property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Processing;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property Selection: TGnvToolButtonSelection read FSelection write SetSelection default gtlIndividual;
    property ShowArrow: Boolean read FShowArrow write SetShowArrow default False;
		property ShowChecked: Boolean read FShowChecked write SetShowChecked default True;
		property ShowBorders: Boolean read FShowBorders write SetShowBorders default True;
    property Size: Integer read FSize write SetSize default 175;
		property Sizing: TGnvItemSizing read FSizing write SetSizing default gisContentToSize;
    property Style: TGnvToolButtonStyle read FStyle write SetStyle default gtsImageText;
    property Tag: Integer read FTag write FTag default 0;
    property ImageIndex: Integer read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
		property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored default True;
		property Width: Integer read FWidth;
  end;

  TGnvToolButtons = class(TGnvProcessItems)
  private
    FToolBar: TGnvToolBar;
    function GetButton(Index: Integer): TGnvToolButton;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ToolBar: TGnvToolBar);
    function ButtonByCaption(const Caption: string): TGnvToolButton;
    function ButtonByName(const Name: string): TGnvToolButton;
    property Buttons[Index: Integer]: TGnvToolButton read GetButton; default;
  end;
{
  TGnvButtonPadding = class(TMargins)
  public
    constructor Create(Control: TControl); override;
  published
    property Left default 3;
		property Top default 2;
    property Right default 3;
    property Bottom default 2;
  end;
}

  TGnvToolBar = class(TGnvProcessControl)
  private
    FButtons: TGnvToolButtons;
    FImages: TImageList;
    FDisabledImages: TImageList;
		FContentMinHeight: Integer;
		FContentMinWidth: Integer;
		FItemIndex: Integer;
		FDownIndex: Integer;
		FAutoHint: Boolean;
		FSwitchGroup: Integer;
//		FButtonPadding: TGnvButtonPadding;
		FGroupIndex: Integer;
    function GetSwitchGroup: Integer;
		function GetButtonRect(const Index: Integer): TRect;
		function GetButtonContentRect(const Index: Integer): TRect;
    procedure PaintButton(const Index: Integer);
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
		procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
		procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
		procedure WMSize(var Message: TWMSize); message WM_SIZE;
		procedure SetButtons(const Value: TGnvToolButtons);
		procedure SetDisabledImages(const Value: TImageList);
		procedure SetDownIndex(const Value: Integer);
		procedure SetHint(const Value: string);
		procedure SetImages(const Value: TImageList);
		procedure SetItemIndex(const Value: Integer);
		procedure SetSwitchGroup(const Value: Integer);
//		procedure SetButtonPadding(const Value: TGnvButtonPadding);
		procedure SetGroupIndex(const Value: Integer);
	protected
		procedure AlignControls(AControl: TControl; var Rect: TRect); override;
		function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
		procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
			X, Y: Integer); override;
		procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
		procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Rebuild; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function IndexOfAction(Action: TBasicAction): Integer;
    function IndexOfButtonAt(X, Y: Integer): Integer;
    procedure InitiateAction; override;
    property DownIndex: Integer read FDownIndex write SetDownIndex;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
		procedure Paint; override;
    procedure UpdateActions;
  published
    property Align;
    property Anchors;
    property AutoHint: Boolean read FAutoHint write FAutoHint default False;
		property AutoSize;
		property Borders;
    property BorderSticking;
//    property ButtonPadding: TGnvButtonPadding read FButtonPadding write SetButtonPadding;
		property Buttons: TGnvToolButtons read FButtons write SetButtons;
		property ParentColor;
    property Style;
    property Cursor;
		property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
		property GroupIndex: Integer read FGroupIndex write SetGroupIndex default -1;
		property Images: TImageList read FImages write SetImages;
		property OnClick;
		property Padding;
		property ParentFont;
		property Font;
		property ParentShowHint;
    property PopupMenu;
    property ProcessDelay;
    property ProcessImages;
		property ProcessInterval;
		property Scale;
		property ShowHint;
		property Theme;
    property Transparent;
    property Visible;
  end;

  TGnvTabBar = class;

  TGnvTab = class(TGnvProcessItem)
  private
    FLeft: Integer;
    FWidth: Integer;
    FMinWidth: Integer;
    FTextWidth: Integer;
    FCatWidth: Integer;
    FCaption: string;
    FImageIndex: Integer;
    FTag: Integer;
    FVisible: Boolean;
    FControl: TControl;
    FFont: TFont;
    FParentFont: Boolean;
    FFlickering: Boolean;
    FCategory: string;
    FGroupIndex: Integer;
    FCategoryIndex: Integer;
    FHint: string;
    FPopupMenu: TPopupMenu;
    FGhosted: Boolean;
    function GetSelected: Boolean;
    procedure FontChanged(Sender: TObject);
    procedure HideControl;
    procedure SetSelected(const Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetImageIndex(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetControl(const Value: TControl);
    procedure ShowControl;
    function IsFontStored: Boolean;
    procedure SetFont(const Value: TFont);
    procedure SetParentFont(const Value: Boolean);
    procedure SetFlickering(const Value: Boolean);
    procedure SetCategory(const Value: string);
    procedure SetGroupIndex(const Value: Integer);
    procedure SetCategoryIndex(const Value: Integer);
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure SetGhosted(const Value: Boolean);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure SetIndex(Value: Integer); override;
    property Selected: Boolean read GetSelected write SetSelected;
  published
    property Ghosted: Boolean read FGhosted write SetGhosted default False;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Category: string read FCategory write SetCategory;
    property CategoryIndex: Integer read FCategoryIndex write SetCategoryIndex default -1;
    property Caption: string read FCaption write SetCaption;
    property Control: TControl read FControl write SetControl;
    // Свойство ParentFont должно считываться раньше свойства Font,
    // чтобы осуществить корректную загрузку шрифта
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property Flickering: Boolean read FFlickering write SetFlickering default False;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property Hint: string read FHint write FHint;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property Processing;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;
  TGnvTabClass = class of TGnvTab;

  TGnvTabs = class(TGnvProcessItems)
  private
    function GetTabBar: TGnvTabBar;
    function GetTab(Index: Integer): TGnvTab;
  protected
    function GetOwner: TPersistent; override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(TabBar: TGnvTabBar);
    function Add: TGnvTab; reintroduce;
//    procedure MoveGroup(GroupIndex: Integer; Tab: TGnvTab);
    procedure ShowGroupItem(GroupIndex: Integer; Item: TGnvTab);
    property Tabs[Index: Integer]: TGnvTab read GetTab; default;
  end;

  TGnvTabBarButton = (
    gtbShift,
    gtbClose,
    gtbDropdown,
    gtbMenu,
    gtbPlus,
    gtbPrevious,
    gtbNext,
    gtbCategory,
    gtbHome
  );
  TGnvTabBarButtons = set of TGnvTabBarButton;

  TGnvTabBarButtonKind = (
    gtkNone,
    gtkShift1,
    gtkShift2,
    gtkClose,
    gtkDropdown,
    gtkMenu,
    gtkPlus,
    gtkPrevious,
    gtkNext,
    gtkCategory,
    gtkHome
  );
  // GnvTabBarButtonKindCount keeps button kind count
  TGnvTabBarButtonKinds = set of TGnvTabBarButtonKind;

  TGnvTabBarCloseKind = (
    gckPersonal,
    gckCommon
  );

  TGnvTabBarStyle = (
    gtsTabs,
    gtsTitle,
    gtsTitleTabs
  );

  TGnvTabBarMinSizing = (
    gtmValue,
    gtmContent,
    gtmMaxContent
  );

  TGnvTabBarOverflow = (
    gtoClip,
    gtoDisplayTitle
  );

  TGnvTabBarTabMoveEvent = procedure(Sender: TGnvTabBar; OldIndex, NewIndex: Integer) of object;
  TGnvTabBarTabActionEvent = procedure(Sender: TGnvTabBar; TabIndex: Integer; Action: TCollectionNotification) of object;
  TGnvTabBarButtonClickEvent = procedure (Sender: TGnvTabBar; Button: TGnvTabBarButton; TabIndex: Integer) of object;

  TGnvTabBar = class(TGnvProcessControl)
  private
    FAlignLeft: Integer;
    FMoveLeft: Integer;
    FMoveOffset: Integer;
    FShift: Integer;
    FShifting: Boolean;
    FStripSize: Integer;
    FTabIndex: Integer;
    FDownIndex: Integer;
    FDownKind: TGnvTabBarButtonKind;
    FOverIndex: Integer;
    FOverKind: TGnvTabBarButtonKind;
    FCloseLeft: Integer;
    FClipWidth: Integer;
    FMenuLeft: Integer;
    FPlusLeft: Integer;
    FOffset: Integer;
    FShift1Left: Integer;
    FShift2Left: Integer;
    FNoneWidth: Integer;
    FMargin1: Integer;
    FMargin2: Integer;
    FWantWidth: Integer;
    FWidth: Integer;
    FButtonKinds: TGnvTabBarButtonKinds;
    FTabs: TGnvTabs;
    FOnChange: TNotifyEvent;
    FImages: TImageList;
    FOnGetImageIndex: TTabGetImageEvent;
    FOnDblClick: TNotifyEvent;
    FButtonWidth: Integer;
    FButtons: TGnvTabBarButtons;
    FNoneTab: Boolean;
    FOnButtonClick: TGnvTabBarButtonClickEvent;
    FDirection: TGnvDirection;
    FTabSize: Integer;
    FTabIndent: Integer;
    FDropdownMenu: TPopupMenu;
    FOnTabMove: TGnvTabBarTabMoveEvent;
    FMoveTabs: Boolean;
    FTabStyle: TGnvToolButtonStyle;
    FAlignment: TAlignment;
    FTabRadius: Integer;
    FIndent: Integer;
    FCloseKind: TGnvTabBarCloseKind;
    FFlickList: TList;
    FFlickShift: Integer;
    FFlickDirection: Integer;
    FFlickCount: Integer;
    FFlickStart: TTime;
    FFlickTab: TGnvTab;
    FTabAlignment: TAlignment;
    FSizing: TGnvItemSizing;
    FTabMinSize: Integer;
    FDropdownControl: TWinControl;
    FOldWndProc: TWndMethod;
    FDropIndex: Integer;
    FDropAlignment: TAlignment;
    FMinSizing: TGnvTabBarMinSizing;
    FOverflow: TGnvTabBarOverflow;
    FTitleMode: Boolean;
    FUpdateCount: Integer;
    FMovedTabs: Boolean;
    FStyle: TGnvTabBarStyle;
    FFirstVisibleIndex: Integer;
    FLastVisibleIndex: Integer;
    FTransparent: Boolean;
    FOnTabAction: TGnvTabBarTabActionEvent;
    FTabActiveColors: TGnvControlColors;
    FTabInactiveColors: TGnvControlColors;
    procedure AddFlick(Item: TGnvTab);
    procedure DeleteFlick(Item: TGnvTab);
    procedure DropdownControlWndProc(var Message: TMessage);
    function GetButtonEnabled(Kind: TGnvTabBarButtonKind): Boolean;
    function GetButtonGlyphState(const Kind: TGnvTabBarButtonKind): TGnvGlyphState;
    function GetButtonRect(const Kind: TGnvTabBarButtonKind): TRect;
    function GetClipRect: TRect;
    function GetTabLeft(const Index: Integer): Integer;
    function GetTabRect(const Index: Integer; Visible: Boolean = False): TRect;
    function GetTabWidth(const Index: Integer): Integer;
    procedure MoveTab(OldIndex, NewIndex: Integer);
    procedure PaintStrip;
    procedure PaintTab(const Index: Integer);
    procedure TabDropdown;
    procedure TabMenu;
    procedure TabNext;
    procedure TabPrevious;
    procedure TabShift(const Value: Integer);
		procedure UpdateControls;
    procedure UpdateShift;
    procedure ValidateShift;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure SetTabIndex(const Value: Integer);
    procedure SetBorderSticking(const Value: TGnvDirections);
    procedure SetImages(const Value: TImageList);
    procedure SetDirection(const Value: TGnvDirection);
    procedure SetTabs(const Value: TGnvTabs);
    procedure SetTabSize(const Value: Integer);
    procedure SetTabIndent(const Value: Integer);
    procedure SetDropdownMenu(const Value: TPopupMenu);
    procedure SetButtons(const Value: TGnvTabBarButtons);
    procedure SetTabStyle(const Value: TGnvToolButtonStyle);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetStripSize(const Value: Integer);
    procedure SetTabRadius(const Value: Integer);
    procedure SetIndent(const Value: Integer);
    procedure SetCloseKind(const Value: TGnvTabBarCloseKind);
    procedure SetTabAlignment(const Value: TAlignment);
    procedure SetSizing(const Value: TGnvItemSizing);
    procedure SetTabMinSize(const Value: Integer);
    procedure SetDropdownControl(const Value: TWinControl);
    procedure SetDropAlignment(const Value: TAlignment);
    procedure SetMinSizing(const Value: TGnvTabBarMinSizing);
    procedure SetOverflow(const Value: TGnvTabBarOverflow);
    procedure SetNoneTab(const Value: Boolean);
    procedure SetStyle(const Value: TGnvTabBarStyle);
    procedure SetTransparent(const Value: Boolean);
    procedure SetTabActiveColors(const Value: TGnvControlColors);
    procedure SetTabInactiveColors(const Value: TGnvControlColors);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
		procedure Rebuild; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure StartTimer; override;
    procedure StopTimer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    function IndexOfTabAt(X, Y: Integer): Integer;
    function KindOfButtonAt(X, Y: Integer): TGnvTabBarButtonKind;
  published
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property AutoSize;
    property Buttons: TGnvTabBarButtons read FButtons write SetButtons default [gtbShift, gtbPrevious, gtbNext];
    property ButtonWidth: Integer read FButtonWidth write FButtonWidth default 21;
    property CloseKind: TGnvTabBarCloseKind read FCloseKind write SetCloseKind default gckPersonal;
    property Direction: TGnvDirection read FDirection write SetDirection default gdDown;
    property DropAlignment: TAlignment read FDropAlignment write SetDropAlignment default taLeftJustify;
    property DropdownControl: TWinControl read FDropdownControl write SetDropdownControl;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property Enabled;
    property Font;
    property Indent: Integer read FIndent write SetIndent default 0;
    property Images: TImageList read FImages write SetImages;
    property BorderSticking;
    property MinSizing: TGnvTabBarMinSizing read FMinSizing write SetMinSizing default gtmValue;
    property MoveTabs: Boolean read FMoveTabs write FMoveTabs default False;
    property NoneTab: Boolean read FNoneTab write SetNoneTab default False;
    property TabStyle: TGnvToolButtonStyle read FTabStyle write SetTabStyle default gtsImageText;
    property TabIndex: Integer read FTabIndex write SetTabIndex default -1;
    property Tabs: TGnvTabs read FTabs write SetTabs;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnButtonClick: TGnvTabBarButtonClickEvent read FOnButtonClick write FOnButtonClick;
    property OnGetImageIndex: TTabGetImageEvent read FOnGetImageIndex write FOnGetImageIndex;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnTabMove: TGnvTabBarTabMoveEvent read FOnTabMove write FOnTabMove;
    property OnTabAction: TGnvTabBarTabActionEvent read FOnTabAction write FOnTabAction;
    property Overflow: TGnvTabBarOverflow read FOverflow write SetOverflow default gtoClip;
    property ParentFont;
    property PopupMenu;
    property ProcessDelay;
    property ProcessImages;
    property ProcessInterval;
    property ShowHint;
    property Sizing: TGnvItemSizing read FSizing write SetSizing default gisContent;
    property StripSize: Integer read FStripSize write SetStripSize default 2;
    property Style;
    property Theme;
    property Kind: TGnvTabBarStyle read FStyle write SetStyle default gtsTabs;
    property TabAlignment: TAlignment read FTabAlignment write SetTabAlignment default taLeftJustify;
    property TabColorsActive: TGnvControlColors read FTabActiveColors write SetTabActiveColors;
    property TabColorsInactive: TGnvControlColors read FTabInactiveColors write SetTabInactiveColors;
    property TabIndent: Integer read FTabIndent write SetTabIndent default -1;
    property TabRadius: Integer read FTabRadius write SetTabRadius default 4;
    property TabMinSize: Integer read FTabMinSize write SetTabMinSize default 0;
    property TabSize: Integer read FTabSize write SetTabSize default 150;
    property TabStop;
    property Transparent;
    property Visible;
  end;

  TGnvLabel = class(TLabel)
  private
    FShowArrow: Boolean;
    FArrowDirection: TGnvDirection;
    procedure SafeRepaint;
    procedure SetShowArrow(const Value: Boolean);
    procedure SetArrowDirection(const Value: TGnvDirection);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ArrowDirection: TGnvDirection read FArrowDirection write
      SetArrowDirection default gdDown;
    property ShowArrow: Boolean read FShowArrow write SetShowArrow default False;
  end;


  { TGnvComboBox }

  TGnvComboBoxGetImageIndex = procedure(Sender: TObject; ItemIndex: Integer;
    var ImageIndex: Integer) of object;
  TGnvComboBoxItemPaint = procedure(const TargetCanvas: TCanvas;
    State: TOwnerDrawState; Index: Integer; var Indent: Integer) of object;
  TGnvComboBoxItemSelected = function(var Index: Integer): Boolean of object;

  TGnvComboBox = class(TComboBox)
  private
    FGroupObject: TObject;
    FShowGroups: Boolean;
    FListInstance: Pointer;
    FListHandle: HWnd;
    FDefListProc: Pointer;
    FItemPaintProc: TGnvComboBoxItemPaint;
    FItemSelectedProc: TGnvComboBoxItemSelected;
    FLastIndex: Integer;
    FUpdating: Boolean;
    FGetImageIndexProc: TGnvComboBoxGetImageIndex;
    FImages: TImageList;
    function ItemSelected(var Index: Integer): Boolean;
    procedure ListWndProc(var Message: TMessage);
    procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
    procedure CMRelease(var Message: TMessage); message CM_RELEASE;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure SetImages(const Value: TImageList);
    procedure SetShowGroups(const Value: Boolean);
  protected
    procedure Select; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property GroupObject: TObject read FGroupObject;
  published
    property OnBeforeItemPaint: TGnvComboBoxItemPaint read FItemPaintProc write FItemPaintProc;
    property OnGetImageIndex: TGnvComboBoxGetImageIndex read FGetImageIndexProc write FGetImageIndexProc;
    property OnItemSelected: TGnvComboBoxItemSelected read FItemSelectedProc write FItemSelectedProc;
    property Images: TImageList read FImages write SetImages;
    property ShowGroups: Boolean read FShowGroups write SetShowGroups;
  end;

var
  ToolMenuHook: HHOOK;
	MenuToolButton: TGnvToolButton;

const
  GNV_BORDERS_LRTB = [gbTop, gbBottom, gbLeft, gbRight];
	GnvDesignPPI = 96;

  GnvTabBarButtonKindCount = 11;

procedure Register;

function GnvBlendColors(Color1, Color2: TColor; Value: Byte = 127): TColor;
function GnvGPColor(Color: TColor; Alpha: Byte = 255): TGPColor; inline;
function GnvGPFontStyle(Styles: TFontStyles): TGPFontStyle;

procedure GnvDrawImage(Canvas: TCanvas; Rect: TRect; Images: TCustomImageList;
	Index: Integer);
procedure GnvDrawText(Canvas: TCanvas; Rect: TRect; Text: string; Format: UINT;
	Enabled: Boolean = True; Ghosted: Boolean = False);
procedure GnvDrawClassicPanel(Canvas: TCanvas; Rect: TRect; HideBorders: TGnvDirections = [];
	Down: Boolean = False; Color: TColor = clBtnFace); overload;

procedure GnvFrameCreateGPPathOld(Path: IGPGraphicsPath; Rect: TGPRect;
	BorderRadius: Integer; BorderSize: Integer; const BorderSticking: TGnvDirections = [];
	const HideBorders: TGnvDirections = []; Filled: Boolean = False); overload;

procedure GnvFrameAddGPPath(Path: IGPGraphicsPath; Rect: TGPRect;
	BorderRadius: Integer; BorderSize: Integer;
  const Borders: TGnvBorders = GNV_BORDERS_LRTB;
 	const BorderSticking: TGnvDirections = []; Filled: Boolean = False); overload;

procedure GnvFrameCreateGPPathOld(Path: IGPGraphicsPath; Rect: TGPRectF;
	BorderRadius: Integer; BorderSize: Integer; const BorderSticking: TGnvDirections = [];
	const HideBorders: TGnvDirections = []; Filled: Boolean = False); overload;

procedure GnvFrameDrawClassic(Canvas: TCanvas; Rect: TRect; Borders: TGnvBorders = [];
	Down: Boolean = False; Color: TColor = clBtnFace; Scale: TGnvSystemScale = gssAuto);

function GnvBorderGetColor(Theme: TGnvSystemTheme = gstAuto): TColor;
function GnvBorderGetSize(Scale: TGnvSystemScale = gssAuto; ShowBorders: Boolean = True): LongWord;

function GnvColorsCreateGPBrush(Colors: TGnvControlColors; Rect: TGPRect; Theme: TGnvSystemTheme = gstAuto): IGPBrush;

function GnvSystemColor(Color: TGnvSystemColor): TColor;
function GnvSystemGPColor(Color: TGnvSystemColor): TGPColor;
function GnvSystemThemeDetect(Theme: TGnvSystemTheme = gstAuto): TGnvSystemTheme;
function GnvSystemScaleDetect(Scale: TGnvSystemScale = gssAuto): TGnvSystemScale;
function GnvSystemScaledSize(Size: Integer; Scale: TGnvSystemScale = gssAuto): Integer;

procedure GnvGlyphDraw(Canvas: TCanvas; Rect: TRect; Glyph: TGnvGlyph;
	Direction: TGnvDirection = gdDown; Orientation: TGnvOrientation = goForward;
  State: TGnvGlyphState = glsNormal; Theme: TGnvSystemTheme = gstAuto;
  Scale: TGnvSystemScale = gssAuto);
function GnvGlyphGetSize(Glyph: TGnvGlyph; Direction: TGnvDirection = gdDown;
	Theme: TGnvSystemTheme = gstAuto; Scale: TGnvSystemScale = gssAuto): TSize;

procedure GnvProcessGlyphDraw(Canvas: TCanvas; Rect: TRect; Progress: Single = 1;
  Theme: TGnvSystemTheme = gstAuto; Scale: TGnvSystemScale = gssAuto);
function GnvProgressGlyphGetSize(Theme: TGnvSystemTheme = gstAuto;
  Scale: TGnvSystemScale = gssAuto): TSize;

procedure GnvTextDraw(Canvas: TCanvas; Rect: TRect; Text: string; Font: TFont = nil;
	Enabled: Boolean = True);
function GnvTextGetSize(Canvas: TCanvas; Text: string; Font: TFont = nil): TSize;

procedure GnvDrawGlyphTriangle(Canvas: TCanvas; Rect: TRect; Direction: TGnvDirection;
	Enabled: Boolean = True);
procedure GnvDrawGlyphClose(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
procedure GnvDrawGlyphChevron(Canvas: TCanvas; Rect: TRect; Direction: TGnvDirection;
	Enabled: Boolean = True);
procedure GnvDrawGlyphMenu(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);

function GnvGetOppositeAnchor(Direction: TGnvDirection): TGnvDirection;

function GnvGetColorFlowColor(Row: Integer): TColor;

function ToolMenuGetMsgHook(Code: Integer; WParam: LongInt; LParam: LongInt): LongInt; stdcall;

implementation

uses
  Types, SysUtils, UxTheme, Themes, Math, DateUtils, Forms, StdActns, StrUtils;

procedure Register;
begin
  RegisterComponents('GnvCtrls', [TGnvComboBox, TGnvToolBar, TGnvTabBar, TGnvPanel,
    TGnvSplitter, TGnvAnimate, TGnvLabel]);
end;

function GnvBlendColors(Color1, Color2: TColor; Value: Byte = 127): TColor;
var
  C1, C2: LongInt;
  R, R1, R2, G, G1, G2, B, B1, B2: Byte;
begin
  // Cast colors to numbers
  C1 := ColorToRGB(Color1);
  C2 := ColorToRGB(Color2);

  // Get key components of both colors
  R1 := GetRValue(C1);
  G1 := GetGValue(C1);
  B1 := GetBValue(C1);
  R2 := GetRValue(C2);
  G2 := GetGValue(C2);
  B2 := GetBValue(C2);

  // Create key components of resulting color
  R := R2 + (R1 - R2)*Value div 256;
  G := G2 + (G1 - G2)*Value div 256;
  B := B2 + (B1 - B2)*Value div 256;

  // Create resulting color from components
  Result := RGB(R, G, B);
end;

function GnvGPColor(Color: TColor; Alpha: Byte = 255): TGPColor;
begin
	Result := TGPColor.CreateFromColorRef(ColorToRGB(Color));
	Result.A := Alpha;
end;

function GnvGPFontStyle(Styles: TFontStyles): TGPFontStyle;
begin
  Result := [];
  if fsBold in Styles       then Include(Result, FontStyleBold);
  if fsItalic in Styles     then Include(Result, FontStyleItalic);
  if fsUnderline in Styles  then Include(Result, FontStyleUnderline);
  if fsStrikeOut in Styles  then Include(Result, FontStyleStrikeOut);
end;

procedure GnvFrameDrawClassic(Canvas: TCanvas; Rect: TRect;
	Borders: TGnvBorders = []; Down: Boolean = False; Color: TColor = clBtnFace;
	Scale: TGnvSystemScale = gssAuto);
var
	Points: array[0..3] of TPoint;
begin
	with Canvas do
  begin
		Brush.Color := Color;
		FillRect(Rect);

		if Down then
      Pen.Color := clBtnShadow
    else
			Pen.Color := clBtnHighlight;

		MoveTo(Rect.Left, Rect.Bottom - 2);

		if gbLeft in Borders then
			LineTo(Rect.Left, Rect.Top)
		else
			MoveTo(Rect.Left, Rect.Top);

		if gbTop in Borders then
			LineTo(Rect.Right - 1, Rect.Top)
		else
			MoveTo(Rect.Right - 1, Rect.Top);

		if Down then
			Pen.Color := clBtnHighlight
		else
			Pen.Color := clBtnShadow;

		if gbRight in Borders then
			LineTo(Rect.Right - 1, Rect.Bottom - 1)
		else
			MoveTo(Rect.Right - 1, Rect.Bottom - 1);

		if gbBottom in Borders then
			LineTo(Rect.Left - 1, Rect.Bottom - 1);

		if Scale = gss200 then
		begin
			if Down then
				Pen.Color := clBtnShadow
			else
				Pen.Color := clBtnHighlight;

			MoveTo(Rect.Left + 1, Rect.Bottom - 3);

			if gbLeft in Borders then
				LineTo(Rect.Left + 1, Rect.Top + 1)
			else
				MoveTo(Rect.Left + 1, Rect.Top + 1);

			if gbTop in Borders then
				LineTo(Rect.Right - 2, Rect.Top + 1)
			else
				MoveTo(Rect.Right - 2, Rect.Top + 1);

			if Down then
				Pen.Color := clBtnHighlight
			else
				Pen.Color := clBtnShadow;

			if gbRight in Borders then
				LineTo(Rect.Right - 2, Rect.Bottom - 2)
			else
				MoveTo(Rect.Right - 2, Rect.Bottom - 2);

			if gbBottom in Borders then
				LineTo(Rect.Left, Rect.Bottom - 2);
    end;
	end;
end;

function GnvSystemScaledSize(Size: Integer; Scale: TGnvSystemScale = gssAuto): Integer;
begin
	Scale := GnvSystemScaleDetect(Scale);

	case Scale of
		gss100: Result := Size;
		gss125: Result := Round(Size*1.25);
    gss150: Result := Round(Size*1.5);
    gss175: Result := Round(Size*1.75);
    gss200: Result := Size*2;
	end;
end;

procedure GnvFrameCreateGPPathOld(Path: IGPGraphicsPath; Rect: TGPRectF;
	BorderRadius: Integer; BorderSize: Integer;
	const BorderSticking: TGnvDirections = [];
	const HideBorders: TGnvDirections = []; Filled: Boolean = False);
begin
	GnvFrameCreateGPPathOld(Path, TGPRectF.Create(Rect.X, Rect.Y,
		Rect.Width, Rect.Height), BorderRadius, BorderSize,
		BorderSticking, HideBorders, Filled);
end;

procedure GnvFrameCreateGPPathOld(Path: IGPGraphicsPath; Rect: TGPRect;
	BorderRadius: Integer; BorderSize: Integer;
	const BorderSticking: TGnvDirections = [];
	const HideBorders: TGnvDirections = []; Filled: Boolean = False);
var
	L, R, T, B, Offset, Inset: Single;
begin
	L := Rect.X;
	T := Rect.Y;
	if not Filled then
	begin
		R := Rect.X + Rect.Width - 1;
		B := Rect.Y + Rect.Height - 1;
	end;

	// Grip frame drawing position according to border size
	Inset := BorderSize/2 - 0.5;
	L := L + Inset;
	T := T + Inset;
	R := R - Inset;
	B := B - Inset;

	if (gdDown in BorderSticking) or (gdLeft in BorderSticking) or (BorderRadius <= 0) then
		Offset := 0
	else
		Offset := BorderRadius + 1;

	if (gdLeft in BorderSticking) or (gdUp in BorderSticking) or (BorderRadius <= 0) then
	begin
		if not ((Offset = 0) and (gdLeft in HideBorders)) or Filled then
			Path.AddLine(L, B - Offset, L, T)
		else
			Path.StartFigure;
		Offset := 0;
	end
	else
	begin
		Path.AddLine(L, B - Offset, L, T + BorderRadius + 1);
		Path.AddArc(L, T, BorderRadius*2, BorderRadius*2, 180, 90);
		Offset := BorderRadius + 1;
	end;

	if (gdUp in BorderSticking) or (gdRight in BorderSticking) or (BorderRadius <= 0) then
	begin
		if not ((Offset = 0) and (gdUp in HideBorders)) or Filled then
			Path.AddLine(L + Offset, T, R, T)
		else
			Path.StartFigure;
		Offset := 0;
	end
	else
	begin
		Path.AddLine(L + Offset, T, R - BorderRadius - 1, T);
		Path.AddArc(R - BorderRadius*2, T, BorderRadius*2, BorderRadius*2, 270, 90);
		Offset := BorderRadius + 1;
	end;

	if (gdRight in BorderSticking) or (gdDown in BorderSticking) or (BorderRadius <= 0) then
	begin
		if not ((Offset = 0) and (gdRight in HideBorders)) or Filled then
			Path.AddLine(R, T + Offset, R, B)
		else
			Path.StartFigure;
		Offset := 0;
  end
	else
	begin
		Path.AddLine(R, T + Offset, R, B - BorderRadius - 1);
		Path.AddArc(R - BorderRadius*2, B - BorderRadius*2, BorderRadius*2, BorderRadius*2, 0, 90);
    Offset := BorderRadius + 1;
	end;

	if (gdDown in BorderSticking) or (gdLeft in BorderSticking) or (BorderRadius <= 0) then
	begin
		if not ((Offset = 0) and (gdDown in HideBorders)) or Filled then
			Path.AddLine(R - Offset, B, L, B)
		else
			Path.StartFigure;
	end
	else
	begin
		Path.AddLine(R - Offset, B, L + BorderRadius + 1, B);
		Path.AddArc(L, B - BorderRadius*2, BorderRadius*2, BorderRadius*2, 90, 90);
	end;
end;

procedure GnvFrameAddGPPath(Path: IGPGraphicsPath; Rect: TGPRect;
	BorderRadius: Integer; BorderSize: Integer;
  const Borders: TGnvBorders = GNV_BORDERS_LRTB;
 	const BorderSticking: TGnvDirections = []; Filled: Boolean = False);
var
  ArcTL, ArcTR, ArcBR, ArcBL: Boolean;
	L, R, T, B, Offset, Inset: Single;
  Dummy: Integer;
begin
	L := Rect.X;
	T := Rect.Y;
  R := Rect.X + Rect.Width - 1;
  B := Rect.Y + Rect.Height - 1;

  Dummy := Rect.Width div 2;
  if BorderRadius > Dummy then  BorderRadius := Dummy;
  Dummy := Rect.Height div 2;
  if BorderRadius > Dummy then  BorderRadius := Dummy;

	// Grip frame drawing position according to border size
	Inset := BorderSize/2 - 0.5;
  if Filled then Inset := Inset - 0.5;
	L := L + Inset;
	T := T + Inset;
	R := R - Inset;
	B := B - Inset;

  ArcTL := False;
  ArcTR := False;
  ArcBR := False;
  ArcBL := False;
  if BorderRadius > 0 then
  begin
    ArcTL := (gbTop in Borders) and (gbLeft in Borders) and not (gdUp in BorderSticking) and not (gdLeft in BorderSticking);
    ArcTR := (gbTop in Borders) and (gbRight in Borders) and not (gdUp in BorderSticking) and not (gdRight in BorderSticking);
    ArcBR := (gbBottom in Borders) and (gbRight in Borders) and not (gdDown in BorderSticking) and not (gdRight in BorderSticking);
    ArcBL := (gbBottom in Borders) and (gbLeft in Borders) and not (gdDown in BorderSticking) and not (gdLeft in BorderSticking);
  end;

	Offset := IfThen(ArcBL, BorderRadius, 0);

  if (gbLeft in Borders) or Filled then
  begin
    if ArcTL then
    begin
  		Path.AddLine(L, B - Offset, L, T + BorderRadius + 1);
  		Path.AddArc(L, T, BorderRadius*2, BorderRadius*2, 180, 90);
    end
    else
      Path.AddLine(L, B - Offset, L, T);
  end
  else
		Path.StartFigure;

	Offset := IfThen(ArcTL, BorderRadius + 1, 0);

  if (gbTop in Borders) or Filled then
  begin
    if ArcTR then
    begin
  		Path.AddLine(L + Offset, T, R - BorderRadius - 1, T);
  		Path.AddArc(R - BorderRadius*2, T, BorderRadius*2, BorderRadius*2, 270, 90);
    end
    else
			Path.AddLine(L + Offset, T, R, T);
  end
  else
		Path.StartFigure;

	Offset := IfThen(ArcTR, BorderRadius + 1, 0);

  if (gbRight in Borders) or Filled then
  begin
    if ArcBR then
    begin
  		Path.AddLine(R, T + Offset, R, B - BorderRadius - 1);
  		Path.AddArc(R - BorderRadius*2, B - BorderRadius*2, BorderRadius*2, BorderRadius*2, 0, 90);
    end
    else
			Path.AddLine(R, T + Offset, R, B);
  end
  else
		Path.StartFigure;

	Offset := IfThen(ArcBR, BorderRadius + 1, 0);

  if (gbBottom in Borders) or Filled then
  begin
    if ArcBL then
    begin
  		Path.AddLine(R - Offset, B, L + BorderRadius + 1, B);
  		Path.AddArc(L, B - BorderRadius*2, BorderRadius*2, BorderRadius*2, 90, 90);
    end
    else
			Path.AddLine(R - Offset, B, L, B);
  end
  else
		Path.StartFigure;
end;

function GnvBorderGetSize(Scale: TGnvSystemScale = gssAuto; ShowBorders: Boolean = True): LongWord;
begin
	Result := 0;

  if ShowBorders then
	begin
		Result := 1;
//  	Scale := GnvSystemScaleDetect(Scale);
//		if Scale = gss200 then Result := 2;
  end;
end;

function GnvColorsCreateGPBrush(Colors: TGnvControlColors; Rect: TGPRect; Theme: TGnvSystemTheme = gstAuto): IGPBrush;
begin
	Theme := GnvSystemThemeDetect(Theme);

  case Theme of
//    gstClassic: ;
    gstPlastic:
      Result := TGPLinearGradientBrush.Create(Rect, GnvSystemGPColor(Colors.PlasticColor1),
        GnvSystemGPColor(Colors.PlasticColor2), LinearGradientModeVertical);
    gstFlat:
      Result := TGPSolidBrush.Create(GnvSystemGPColor(Colors.FlatColor));
  end;
end;

function GnvSystemColor(Color: TGnvSystemColor): TColor;
begin
  case Color of
    gscCtrlLight:       Result := clBtnHighlight;
    gscCtrlLight0875:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 32);
    gscCtrlLight0750:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 64);
    gscCtrlLight0625:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 96);
    gscCtrlLight0500:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 128);
    gscCtrlLight0375:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 159);
    gscCtrlLight0250:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 191);
    gscCtrlLight0125:   Result := GnvBlendColors(clBtnFace, clBtnHighlight, 223);
    gscCtrl:            Result := clBtnFace;
    gscCtrlShade0125:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 223);
    gscCtrlShade0250:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 191);
    gscCtrlShade0375:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 159);
    gscCtrlShade0500:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 128);
    gscCtrlShade0625:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 96);
    gscCtrlShade0750:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 64);
    gscCtrlShade0875:   Result := GnvBlendColors(clBtnFace, clBtnShadow, 32);
    gscCtrlShade:       Result := clBtnShadow;
    gscCtrlText:        Result := clBtnText;
    gscLinkText:        Result := clHotLight;
    gscWindow:          Result := clWindow;
    gscWindowText:      Result := clWindowText;
  end;
end;

function GnvSystemGPColor(Color: TGnvSystemColor): TGPColor;
begin
  Result := GnvGPColor(GnvSystemColor(Color));
end;

function GnvSystemThemeDetect(Theme: TGnvSystemTheme = gstAuto): TGnvSystemTheme;
begin
	Result := Theme;

	if Result = gstAuto then
	begin
		Result := gstClassic;
		if InitThemeLibrary then
			if IsAppThemed and IsThemeActive then
			begin
				if (Win32MajorVersion >= 5) then Result := gstPlastic;
				if (Win32MajorVersion >= 6) and (Win32MinorVersion >= 2) then Result := gstFlat;
			end;
	end;
end;

function GnvSystemScaleDetect(Scale: TGnvSystemScale = gssAuto): TGnvSystemScale;
begin
	Result := Scale;

	if Scale = gssAuto then
	begin
  	Result := gss100;
		if Screen.PixelsPerInch >= 120 then Result := gss125;
		if Screen.PixelsPerInch >= 144 then Result := gss150;
		if Screen.PixelsPerInch >= 168 then Result := gss175;
		if Screen.PixelsPerInch >= 192 then Result := gss200;
	end;
end;

procedure GnvGlyphDraw(Canvas: TCanvas; Rect: TRect; Glyph: TGnvGlyph;
	Direction: TGnvDirection = gdDown; Orientation: TGnvOrientation = goForward;
  State: TGnvGlyphState = glsNormal; Theme: TGnvSystemTheme = gstAuto;
  Scale: TGnvSystemScale = gssAuto);
var
  OldPenColor: TColor;
  OldBrushStyle: TBrushStyle;
  OldBrushColor: TColor;
  C1, C2, C3, Colorize: TColor;
  X, Y, I, Count, Alpha, Sign: Integer;
  GPX, GPY, FlatOffset: Extended;
  Extends: array of Integer;
  Points: array of TPoint;
  Offsets: array of TPoint;
  GPPoints: array of TGPPointF;
  GP: IGPGraphics;
  GPBrush1, GPBrush, GPBrush3: IGPBrush;
  GPPen, GPPen0, GPPen1, GPPen2, GPPen3, GPPen4, GPPen5: IGPPen;
  GPPath: IGPGraphicsPath;
  GPR1, GPR2, GPR3: TGPRectF;

  procedure PlasticHighlight(Point1, Point2: TGPPointF);
  begin
    GP.DrawLine(GPPen5, TGPPointF.Create(Point1.X, Point1.Y + 1), TGPPointF.Create(Point2.X, Point2.Y + 1));
  end;

  procedure ThickArc(X, Y: Extended; Radius, Thickness, StartAngle, SweepAngle: Integer);
  var
    GPPath: IGPGraphicsPath;
    GPBrush: IGPBrush;
    GPPen: IGPPen;
    GPR1, GPR2, GPR3: TGPRectF;
  begin
    GPPath := TGPGraphicsPath.Create;

    // Outer radius
    GPR1 := TGPRectF.Create(X - Radius, Y - Radius, Radius*2, Radius*2);
    // Inner radius
    GPR2 := TGPRectF.Create(X - Radius + Thickness, Y - Radius + Thickness, (Radius - Thickness)*2, (Radius - Thickness)*2);

    GPPath.AddArc(GPR1, StartAngle, SweepAngle);
    GPPath.AddArc(GPR2, StartAngle + SweepAngle, -SweepAngle);

    GP.FillPath(GPBrush1, GPPath);

    if Theme = gstPlastic then
    begin
      GPR3 := GPR1;
      GPR3.Height := GPR3.Height + 1;
      GPBrush := TGPLinearGradientBrush.Create(GPR3, GPPen1.Color, GPPen4.Color, LinearGradientModeVertical);
      GPPen := TGPPen.Create(GPBrush);
      GP.DrawArc(GPPen, GPR1, StartAngle, SweepAngle);

      GPR3 := GPR2;
      GPR3.Y := GPR3.Y - 1;
      GPR3.Height := GPR3.Height + 2;
      GPBrush := TGPLinearGradientBrush.Create(GPR3, GPPen4.Color, GPPen1.Color, LinearGradientModeVertical);
      GPPen := TGPPen.Create(GPBrush);
      GP.DrawArc(GPPen, GPR2, StartAngle, SweepAngle);

      GPR3 := GPR1;
      GPR3.Height := GPR3.Height + 2;
      GPBrush := TGPLinearGradientBrush.Create(GPR3, GnvGPColor(GnvBlendColors(C3, clWhite, 127), 0), GnvGPColor(GnvBlendColors(C3, clWhite, 127), Alpha), LinearGradientModeVertical);
      GPPen := TGPPen.Create(GPBrush);
      GPR3 := GPR1;
      GPR3.Y := GPR3.Y + 1;
      GP.DrawArc(GPPen, GPR3, StartAngle, SweepAngle);

      GPR3 := GPR2;
      GPR3.Height := GPR3.Height + 2;
      GPBrush := TGPLinearGradientBrush.Create(GPR3, GnvGPColor(GnvBlendColors(C3, clWhite, 127), Alpha), GnvGPColor(GnvBlendColors(C3, clWhite, 127), 0), LinearGradientModeVertical);
      GPPen := TGPPen.Create(GPBrush);
      GPR3 := GPR2;
      GPR3.Y := GPR3.Y + 1;
      GP.DrawArc(GPPen, GPR3, StartAngle, SweepAngle);
    end;
  end;

begin
	Theme := GnvSystemThemeDetect(Theme);
	Scale := GnvSystemScaleDetect(Scale);

  X := Rect.Left + (Rect.Right - Rect.Left) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2;

  SetLength(Extends, 0);
  SetLength(Offsets, 0);
  SetLength(GPPoints, 0);

  Sign := 1;
  FlatOffset := 0.5;

  // Defining drawing points
  case Glyph of
    glArrow:    ;
    glChevron:
      GnvDrawGlyphChevron(Canvas, Rect, Direction, State <> glsDisabled);
    glClose:
    begin
//      GnvDrawGlyphClose(Canvas, Rect, State <> glsDisabled);
      SetLength(Extends, 2);
      SetLength(Offsets, 12);

      case Scale of
        gss100:
        begin
          Extends[0] := 3;  // Horizontal offset from center to cross end point 1
          Extends[1] := 1;  // Horizontal offset from cross end point 1 to point 2
        end;
        gss125:
        begin
          Extends[0] := 4;
          Extends[1] := 1;
        end;
        gss150:
        begin
          Extends[0] := 5;
          Extends[1] := 2;
        end;
        gss175:
        begin
          Extends[0] := 6;
          Extends[1] := 3;
        end;
        gss200:
        begin
          Extends[0] := 7;
          Extends[1] := 3;
        end;
      end;

      Offsets[0]   := Point(- Extends[0], - Extends[0] - Extends[1]);
      Offsets[1]   := Point(0, - Extends[1]);
      Offsets[2]   := Point(Extends[0], - Extends[0] - Extends[1]);
      Offsets[3]   := Point(Extends[0] + Extends[1], - Extends[0]);
      Offsets[4]   := Point(Extends[1], 0);
      Offsets[5]   := Point(Extends[0] + Extends[1], Extends[0]);
      Offsets[6]   := Point(Extends[0], Extends[0] + Extends[1]);
      Offsets[7]   := Point(0, Extends[1]);
      Offsets[8]   := Point(- Extends[0], Extends[0] + Extends[1]);
      Offsets[9]   := Point(- Extends[0] - Extends[1], Extends[0]);
      Offsets[10]  := Point(- Extends[1], 0);
      Offsets[11]  := Point(- Extends[0] - Extends[1], - Extends[0]);

      FlatOffset := 0;    // No flat drawing offset for Close sign
      Direction := gdUp;  // Default direction - no points direction reorder
    end;
    glPlus:
    begin
      SetLength(Extends, 2);
      SetLength(Offsets, 12);

      case Scale of
        gss100:
        begin
          Extends[0] := 1;  // Thickness offsets from center point
          Extends[1] := 4;  // Cross offsets from center point
        end;
        gss125:
        begin
          Extends[0] := 1;
          Extends[1] := 5;
        end;
        gss150:
        begin
          Extends[0] := 1;
          Extends[1] := 6;
        end;
        gss175:
        begin
          Extends[0] := 2;
          Extends[1] := 7;
        end;
        gss200:
        begin
          Extends[0] := 2;
          Extends[1] := 8;
        end;
      end;

      Offsets[0]   := Point(- Extends[1], Extends[0]);
      Offsets[1]   := Point(- Extends[1], - Extends[0]);
      Offsets[2]   := Point(- Extends[0], - Extends[0]);
      Offsets[3]   := Point(- Extends[0], - Extends[1]);
      Offsets[4]   := Point(Extends[0], - Extends[1]);
      Offsets[5]   := Point(Extends[0], - Extends[0]);
      Offsets[6]   := Point(Extends[1], - Extends[0]);
      Offsets[7]   := Point(Extends[1], Extends[0]);
      Offsets[8]   := Point(Extends[0], Extends[0]);
      Offsets[9]   := Point(Extends[0], Extends[1]);
      Offsets[10]  := Point(- Extends[0], Extends[1]);
      Offsets[11]  := Point(- Extends[0], Extends[0]);

      Direction := gdUp;  // Default direction - no points direction reorder
    end;
    glMenu:
    begin
      SetLength(Extends, 3);
      SetLength(Offsets, 4);

      case Scale of
        gss100:
        begin
          Extends[0] := 1;  // Thickness offsets from center point
          Extends[1] := 7;  // Cross offsets from center point
          Extends[2] := 5;  // Vertical step between hamburger line centers
        end;
        gss125:
        begin
          Extends[0] := 1;
          Extends[1] := 8;
          Extends[2] := 6;
        end;
        gss150:
        begin
          Extends[0] := 1;
          Extends[1] := 9;
          Extends[2] := 7;
        end;
        gss175:
        begin
          Extends[0] := 2;
          Extends[1] := 12;
          Extends[2] := 8;
        end;
        gss200:
        begin
          Extends[0] := 2;
          Extends[1] := 13;
          Extends[2] := 9;
        end;
      end;

      Offsets[0]   := Point(- Extends[1], Extends[0] - Extends[2]);
      Offsets[1]   := Point(- Extends[1], - Extends[0] - Extends[2]);
      Offsets[2]   := Point(Extends[1], - Extends[0] - Extends[2]);
      Offsets[3]   := Point(Extends[1], Extends[0] - Extends[2]);

      Direction := gdUp;  // Default direction - no points direction reorder
    end;
    glMinus:
    begin
      SetLength(Extends, 2);
      SetLength(Offsets, 4);

      case Scale of
        gss100:
        begin
          Extends[0] := 1;  // Thickness offsets from center point
          Extends[1] := 4;  // Cross offsets from center point
        end;
        gss125:
        begin
          Extends[0] := 1;
          Extends[1] := 5;
        end;
        gss150:
        begin
          Extends[0] := 1;
          Extends[1] := 6;
        end;
        gss175:
        begin
          Extends[0] := 2;
          Extends[1] := 7;
        end;
        gss200:
        begin
          Extends[0] := 2;
          Extends[1] := 8;
        end;
      end;

      Offsets[0]   := Point(- Extends[1], Extends[0]);
      Offsets[1]   := Point(- Extends[1], - Extends[0]);
      Offsets[2]   := Point(Extends[1], - Extends[0]);
      Offsets[3]   := Point(Extends[1], Extends[0]);

      Direction := gdUp;  // Default direction - no points direction reorder
    end;
    glPane:
    begin
      SetLength(Extends, 2);
      SetLength(Offsets, 8);

      case Scale of
        gss100:
        begin
          Extends[0] := 7;  // Square left/right/up/bottom offset from center
          Extends[1] := 2;  // Square thickness
        end;
        gss125:
        begin
          Extends[0] := 8;
          Extends[1] := 2;
        end;
        gss150:
        begin
          Extends[0] := 10;
          Extends[1] := 3;
        end;
        gss175:
        begin
          Extends[0] := 12;
          Extends[1] := 3;
        end;
        gss200:
        begin
          Extends[0] := 14;
          Extends[1] := 4;
        end;
      end;

      // Outer bounds
      Offsets[0]   := Point(- Extends[0], - Extends[0]);
      Offsets[1]   := Point(Extends[0], - Extends[0]);
      Offsets[2]   := Point(Extends[0], Extends[0]);
      Offsets[3]   := Point(- Extends[0], Extends[0]);

      // Inner hole
      Offsets[4]   := Point(- Extends[0] + Extends[1], - Extends[1]);
      Offsets[5]   := Point(Extends[0] - Extends[1], - Extends[1]);
      Offsets[6]   := Point(Extends[0] - Extends[1], Extends[0] - Extends[1]);
      Offsets[7]   := Point(- Extends[0] + Extends[1], Extends[0] - Extends[1]);
    end;
    glRound:
    begin
      SetLength(Extends, 2);

      case Scale of
        gss100:
        begin
          Extends[0] := 7;  // Circle radius
          Extends[1] := 2;  // Thickness
        end;
        gss125:
        begin
          Extends[0] := 8;
          Extends[1] := 2;
        end;
        gss150:
        begin
          Extends[0] := 10;
          Extends[1] := 3;
        end;
        gss175:
        begin
          Extends[0] := 12;
          Extends[1] := 3;
        end;
        gss200:
        begin
          Extends[0] := 14;
          Extends[1] := 4;
        end;
      end;
    end;
    glSync:     ;
    glCaret:
    begin
      SetLength(Extends, 3);
      SetLength(Offsets, 3);

      case Scale of
        gss100:
        begin
          Extends[0] := 1;  // Hypotenuse offset back from center
          Extends[1] := 2;  // Arrow length forward from center
          Extends[2] := 3;  // Hypotenuse width
        end;
        gss125:
        begin
          Extends[0] := 2;
          Extends[1] := 2;
          Extends[2] := 4;
        end;
        gss150:
        begin
          Extends[0] := 3;
          Extends[1] := 2;
          Extends[2] := 5;
        end;
        gss175:
        begin
          Extends[0] := 2;
          Extends[1] := 4;
          Extends[2] := 6;
        end;
        gss200:
        begin
          Extends[0] := 2;
          Extends[1] := 4;
          Extends[2] := 6;
        end;
      end;

      Offsets[0] := Point(- Extends[2], Extends[0]);
      Offsets[1] := Point(Extends[2], Extends[0]);
      Offsets[2] := Point(0, - Extends[1]);
    end;
    glUpdate:
    begin
//      SetLength(Points, 9);
      SetLength(Offsets, 9);
      SetLength(Extends, 5);

      case Scale of
        gss100:
        begin
          Extends[0] := 7;  // Circle radius
          Extends[1] := 6;  // Arrow wing length
          Extends[2] := 2;  // Thickness
        end;
        gss125:
        begin
          Extends[0] := 9;
          Extends[1] := 8;
          Extends[2] := 2;
        end;
        gss150:
        begin
          Extends[0] := 14;
          Extends[1] := 10;
          Extends[2] := 3;
        end;
        gss175:
        begin
          Extends[0] := 16;
          Extends[1] := 11;
          Extends[2] := 4;
        end;
        gss200:
        begin
          Extends[0] := 18;
          Extends[1] := 12;
          Extends[2] := 4;
        end;
      end;

      Extends[3] := 270;  // Circle arc angle

      case Direction of
        gdUp:     Extends[4] := 0;    // Circle arc start
        gdDown:   Extends[4] := 180;
        gdLeft:   Extends[4] := 270;
        gdRight:  Extends[4] := 90;
      end;

      // Flip arc orientation
      if Orientation = goBackward then
      begin
        Sign := -1;
        Extends[3] := Extends[3] * Sign;
        Extends[4] := Extends[4] + 180;
      end;

      // Circle start cap
      Offsets[0] := Point(Extends[0] - Extends[2], 0);
      Offsets[1] := Point(Extends[0], 0);

      // Arrow wings
      Offsets[2] := Point(- Extends[2] - 1, - Extends[0]);
      Offsets[3] := Point(- Extends[1] - 1, - Extends[0]);
      Offsets[4] := Point(- Extends[1] - 1, - Extends[0] - Extends[2]);
      Offsets[5] := Point(Extends[2] - 1, - Extends[0] - Extends[2]);
      Offsets[6] := Point(Extends[2] - 1, - Extends[0] + Extends[1]);
      Offsets[7] := Point(-1, - Extends[0] + Extends[1]);
      Offsets[8] := Point(-1, - Extends[0] + Extends[2]);
    end;
  end;

  // Creating points
  SetLength(Points, Length(Offsets));
  for I := 0 to Length(Offsets) - 1 do
    case Orientation of
      goForward:
        case Direction of
          gdUp:     Points[I] := Point(X + Offsets[I].X, Y + Offsets[I].Y);
          gdDown:   Points[I] := Point(X - Offsets[I].X, Y - Offsets[I].Y);
          gdLeft:   Points[I] := Point(X + Offsets[I].Y, Y - Offsets[I].X);
          gdRight:  Points[I] := Point(X - Offsets[I].Y, Y + Offsets[I].X);
        end;
      goBackward:
        case Direction of
          gdUp:     Points[I] := Point(X - Offsets[I].X, Y + Offsets[I].Y);
          gdDown:   Points[I] := Point(X + Offsets[I].X, Y - Offsets[I].Y);
          gdLeft:   Points[I] := Point(X + Offsets[I].Y, Y + Offsets[I].X);
          gdRight:  Points[I] := Point(X - Offsets[I].Y, Y - Offsets[I].X);
        end;
    end;

  // Drawing
  case Theme of
    gstClassic:
    begin
      OldBrushStyle := Canvas.Brush.Style;
      OldBrushColor := Canvas.Brush.Color;
      OldPenColor := Canvas.Pen.Color;

      Canvas.Brush.Style := bsSolid;
      if State = glsNormal then
      begin
        Canvas.Brush.Color := clBtnText;
        Canvas.Pen.Color := clBtnText;
      end
      else
      begin
        Canvas.Brush.Color := clGrayText;
        Canvas.Pen.Color := clGrayText;
      end;

      case Glyph of
        glArrow:    ;
        glChevron:  ;
        glClose,
        glMinus,
        glMenu,
        glPane,
        glPlus,
        glCaret: Canvas.Polygon(Points);
      end;

      Canvas.Brush.Style := OldBrushStyle;
      Canvas.Pen.Color := OldPenColor;
      Canvas.Brush.Color := OldBrushColor;
    end;
    gstPlastic, gstFlat:
    begin
      SetLength(GPPoints, Length(Points));

      if Theme <> gstFlat then FlatOffset := 0;

      GPX := X + FlatOffset;
      GPY := Y + FlatOffset;
      for I := 0 to Length(Points) - 1 do
        GPPoints[I] := TGPPointF.Create(Points[I].X + FlatOffset, Points[I].Y + FlatOffset);

      if State = glsDisabled then
        Alpha := 95
      else
        Alpha := 255;

      Colorize := clNone;
{      case State of
        glsDisabled:  ;
        glsPressed:   Colorize := GnvBlendColors(clBtnText, clBtnFace);//clBtnText;
//        glsSelected:  Colorize := clHighlight;//GnvBlendColors(clBtnText, clBtnFace);
        glsLink:      Colorize := clHotLight;
      end;
}
      C1 := clBtnShadow;
      C2 := clBtnFace;
      C3 := clBtnHighlight;
      if Colorize <> clNone then
      begin
        C1 := GnvBlendColors(C1, Colorize, 127);
        C2 := GnvBlendColors(C2, Colorize, 127);
        C3 := GnvBlendColors(C3, Colorize, 127);
      end;

      GP := TGPGraphics.Create(Canvas.Handle);
      GP.SmoothingMode := SmoothingModeAntiAlias;

      GPPen := TGPPen.Create(GnvGPColor(clBlack), 1);
//      GPPen.Alignment := PenAlignmentInset;
//      GPPen.LineJoin := LineJoinBevel;
//      GPPen.StartCap := LineCapSquare;
//      GPPen.EndCap := LineCapSquare;
{
      if Theme in [gstFlat, gstClassic] then
      begin
        GPBrush := TGPSolidBrush.Create(GnvGPColor(clBtnShadow, Alpha));
        GPPen0 := TGPPen.Create(GnvGPColor(clBlack, 0));
        GPPen1 := GPPen0;
        GPPen2 := GPPen0;
        GPPen3 := GPPen0;
        GPPen4 := GPPen0;

      for I := 0 to Length(Points) - 1 do
        GPPoints[I] := TGPPointF.Create(Points[I].X - 0.5, Points[I].Y + 0.5);
      end
      else
      begin


}
      if Theme = gstPlastic then
        GPBrush1 := TGPSolidBrush.Create(GnvGPColor(GnvBlendColors(C2, C1, 180), Alpha))
      else
        GPBrush1 := TGPSolidBrush.Create(GnvGPColor(C1, Alpha));

      GPPen0 := TGPPen.Create(GnvGPColor(GnvBlendColors(C1, clBlack, 193), Alpha));
      GPPen1 := TGPPen.Create(GnvGPColor(GnvBlendColors(C1, clBlack, 223), Alpha));
      GPPen2 := TGPPen.Create(GnvGPColor(GnvBlendColors(C1, C2, 193), Alpha));
      GPPen3 := TGPPen.Create(GnvGPColor(GnvBlendColors(C1, C2, 143), Alpha));
      GPPen4 := TGPPen.Create(GnvGPColor(GnvBlendColors(C1, C2, 63), Alpha));

      GPPen5 := TGPPen.Create(GnvGPColor(GnvBlendColors(C3, clWhite, 127), Alpha));

      case Glyph of
        glArrow: ;
        glChevron: ;
        glClose:
        begin
          GP.FillPolygon(GPBrush1, GPPoints);

          if Theme = gstPlastic then
          begin
            PlasticHighlight(GPPoints[3], GPPoints[4]);
            PlasticHighlight(GPPoints[5], GPPoints[6]);
            PlasticHighlight(GPPoints[6], GPPoints[7]);
            PlasticHighlight(GPPoints[7], GPPoints[8]);
            PlasticHighlight(GPPoints[8], GPPoints[9]);
            PlasticHighlight(GPPoints[10], GPPoints[11]);

            GP.DrawLine(GPPen3, GPPoints[3], GPPoints[4]);
            GP.DrawLine(GPPen3, GPPoints[5], GPPoints[6]);
            GP.DrawLine(GPPen3, GPPoints[6], GPPoints[7]);
            GP.DrawLine(GPPen3, GPPoints[7], GPPoints[8]);
            GP.DrawLine(GPPen3, GPPoints[8], GPPoints[9]);
            GP.DrawLine(GPPen3, GPPoints[10], GPPoints[11]);

            GP.DrawLine(GPPen1, GPPoints[11], GPPoints[0]);
            GP.DrawLine(GPPen1, GPPoints[0], GPPoints[1]);
            GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
            GP.DrawLine(GPPen1, GPPoints[2], GPPoints[3]);
            GP.DrawLine(GPPen1, GPPoints[4], GPPoints[5]);
            GP.DrawLine(GPPen1, GPPoints[9], GPPoints[10]);
          end;
        end;
        glCaret:
        begin
          GP.FillPolygon(GPBrush1, GPPoints);

          if Theme = gstPlastic then
            case Direction of
              gdLeft:
              begin
                GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen4, GPPoints[2], GPPoints[0]);
                GP.DrawLine(GPPen0, GPPoints[1], GPPoints[2]);

                PlasticHighlight(GPPoints[2], GPPoints[0]);
              end;
              gdUp:
              begin
                GP.DrawLine(GPPen4, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
                GP.DrawLine(GPPen1, GPPoints[2], GPPoints[0]);

                PlasticHighlight(GPPoints[0], GPPoints[1]);
              end;
              gdRight:
              begin
                GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen4, GPPoints[1], GPPoints[2]);
                GP.DrawLine(GPPen0, GPPoints[2], GPPoints[0]);

                PlasticHighlight(GPPoints[1], GPPoints[2]);
              end;
              gdDown:
              begin
                GP.DrawLine(GPPen1, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen2, GPPoints[1], GPPoints[2]);
                GP.DrawLine(GPPen2, GPPoints[2], GPPoints[0]);

                PlasticHighlight(GPPoints[1], GPPoints[2]);
                PlasticHighlight(GPPoints[2], GPPoints[0]);
              end;
            end;
        end;
        glPlus:
        begin
          GP.FillPolygon(GPBrush1, GPPoints);

          if Theme = gstPlastic then
          begin
            PlasticHighlight(GPPoints[11], GPPoints[0]);
            PlasticHighlight(GPPoints[7], GPPoints[8]);
            PlasticHighlight(GPPoints[9], GPPoints[10]);

            GP.DrawLine(GPPen4, GPPoints[7], GPPoints[8]);
            GP.DrawLine(GPPen4, GPPoints[9], GPPoints[10]);
            GP.DrawLine(GPPen4, GPPoints[11], GPPoints[0]);

            GP.DrawLine(GPPen3, GPPoints[0], GPPoints[1]);
            GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
            GP.DrawLine(GPPen3, GPPoints[3], GPPoints[2]);

            GP.DrawLine(GPPen3, GPPoints[6], GPPoints[7]);
            GP.DrawLine(GPPen1, GPPoints[5], GPPoints[6]);
            GP.DrawLine(GPPen3, GPPoints[4], GPPoints[5]);

            GP.DrawLine(GPPen1, GPPoints[3], GPPoints[4]);

            GP.DrawLine(GPPen3, GPPoints[8], GPPoints[9]);
            GP.DrawLine(GPPen3, GPPoints[10], GPPoints[11]);
          end;
        end;
        glMinus:
        begin
          GP.FillPolygon(GPBrush1, GPPoints);

          if Theme = gstPlastic then
          begin
            PlasticHighlight(GPPoints[3], GPPoints[0]);

            GP.DrawLine(GPPen4, GPPoints[3], GPPoints[0]);
            GP.DrawLine(GPPen3, GPPoints[0], GPPoints[1]);
            GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);
            GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
          end;
        end;
        glMenu:
        begin
          Count := 0;
          repeat
            GP.FillPolygon(GPBrush1, GPPoints);

            if Theme = gstPlastic then
            begin
              PlasticHighlight(GPPoints[3], GPPoints[0]);

              GP.DrawLine(GPPen4, GPPoints[3], GPPoints[0]);
              GP.DrawLine(GPPen3, GPPoints[0], GPPoints[1]);
              GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);
              GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
            end;

            for I := 0 to Length(GPPoints) - 1 do
              GPPoints[I].Y := GPPoints[I].Y + Extends[2];

            Inc(Count);
          until Count > 2;
        end;
        glPane:
        begin
    			GPPath := TGPGraphicsPath.Create;

          GPPath.AddLine(GPPoints[0], GPPoints[1]);
          GPPath.AddLine(GPPoints[1], GPPoints[2]);
          GPPath.AddLine(GPPoints[2], GPPoints[3]);
          GPPath.CloseFigure;

          GPPath.AddLine(GPPoints[4], GPPoints[5]);
          GPPath.AddLine(GPPoints[5], GPPoints[6]);
          GPPath.AddLine(GPPoints[6], GPPoints[7]);
          GPPath.CloseFigure;

          GP.FillPath(GPBrush1, GPPath);

          if Theme = gstPlastic then
            case Direction of
              gdUp:
              begin
                PlasticHighlight(GPPoints[2], GPPoints[3]);

                GP.DrawLine(GPPen4, GPPoints[2], GPPoints[3]);
                GP.DrawLine(GPPen3, GPPoints[1], GPPoints[2]);
                GP.DrawLine(GPPen3, GPPoints[3], GPPoints[0]);
                GP.DrawLine(GPPen1, GPPoints[0], GPPoints[1]);

                PlasticHighlight(GPPoints[4], GPPoints[5]);

                GP.DrawLine(GPPen4, GPPoints[4], GPPoints[5]);
                GP.DrawLine(GPPen3, GPPoints[5], GPPoints[6]);
                GP.DrawLine(GPPen3, GPPoints[7], GPPoints[4]);
                GP.DrawLine(GPPen1, GPPoints[6], GPPoints[7]);
              end;
              gdDown:
              begin
                PlasticHighlight(GPPoints[0], GPPoints[1]);

                GP.DrawLine(GPPen4, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen3, GPPoints[1], GPPoints[2]);
                GP.DrawLine(GPPen3, GPPoints[3], GPPoints[0]);
                GP.DrawLine(GPPen1, GPPoints[2], GPPoints[3]);

                PlasticHighlight(GPPoints[6], GPPoints[7]);

                GP.DrawLine(GPPen4, GPPoints[6], GPPoints[7]);
                GP.DrawLine(GPPen3, GPPoints[5], GPPoints[6]);
                GP.DrawLine(GPPen3, GPPoints[7], GPPoints[4]);
                GP.DrawLine(GPPen1, GPPoints[4], GPPoints[5]);
              end;
              gdLeft:
              begin
                PlasticHighlight(GPPoints[3], GPPoints[0]);

                GP.DrawLine(GPPen4, GPPoints[3], GPPoints[0]);
                GP.DrawLine(GPPen3, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);
                GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);

                PlasticHighlight(GPPoints[5], GPPoints[6]);

                GP.DrawLine(GPPen4, GPPoints[5], GPPoints[6]);
                GP.DrawLine(GPPen3, GPPoints[6], GPPoints[7]);
                GP.DrawLine(GPPen3, GPPoints[4], GPPoints[5]);
                GP.DrawLine(GPPen1, GPPoints[7], GPPoints[4]);
              end;
              gdRight:
              begin
                PlasticHighlight(GPPoints[1], GPPoints[2]);

                GP.DrawLine(GPPen4, GPPoints[1], GPPoints[2]);
                GP.DrawLine(GPPen3, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);
                GP.DrawLine(GPPen1, GPPoints[3], GPPoints[0]);

                PlasticHighlight(GPPoints[7], GPPoints[4]);

                GP.DrawLine(GPPen4, GPPoints[7], GPPoints[4]);
                GP.DrawLine(GPPen3, GPPoints[6], GPPoints[7]);
                GP.DrawLine(GPPen3, GPPoints[4], GPPoints[5]);
                GP.DrawLine(GPPen1, GPPoints[5], GPPoints[6]);
              end;
            end;
        end;
        glRound:
          ThickArc(GPX, GPY, Extends[0], Extends[1], 0, 360);
        glUpdate:
        begin
    			GPPath := TGPGraphicsPath.Create;

          GPPath.AddLine(GPPoints[2], GPPoints[3]);
          GPPath.AddLine(GPPoints[3], GPPoints[4]);
          GPPath.AddLine(GPPoints[4], GPPoints[5]);
          GPPath.AddLine(GPPoints[5], GPPoints[6]);
          GPPath.AddLine(GPPoints[6], GPPoints[7]);
          GPPath.AddLine(GPPoints[7], GPPoints[8]);

          case Direction of
            gdUp:
            begin
              if Theme = gstPlastic then
              begin
                PlasticHighlight(GPPoints[2], GPPoints[3]);
                PlasticHighlight(GPPoints[6], GPPoints[7]);
              end;

              ThickArc(GPX, GPY, Extends[0], Extends[2], Extends[4], Extends[3]);
              GP.FillPath(GPBrush1, GPPath);

              if Theme = gstPlastic then
              begin
                GP.DrawLine(GPPen3, GPPoints[6], GPPoints[7]);
                GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);

                GP.DrawLine(GPPen2, GPPoints[3], GPPoints[4]);
                GP.DrawLine(GPPen2, GPPoints[5], GPPoints[6]);
                GP.DrawLine(GPPen3, GPPoints[7], GPPoints[8]);

                GP.DrawLine(GPPen1, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen1, GPPoints[4], GPPoints[5]);
              end;
            end;
            gdDown:
            begin
              if Theme = gstPlastic then
              begin
                PlasticHighlight(GPPoints[0], GPPoints[1]);
                PlasticHighlight(GPPoints[4], GPPoints[5]);
              end;

              ThickArc(GPX, GPY, Extends[0], Extends[2], Extends[4], Extends[3]);
              GP.FillPath(GPBrush1, GPPath);

              if Theme = gstPlastic then
              begin
                GP.DrawLine(GPPen3, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen3, GPPoints[4], GPPoints[5]);

                GP.DrawLine(GPPen2, GPPoints[3], GPPoints[4]);
                GP.DrawLine(GPPen2, GPPoints[5], GPPoints[6]);
                GP.DrawLine(GPPen3, GPPoints[7], GPPoints[8]);

                GP.DrawLine(GPPen0, GPPoints[6], GPPoints[7]);
                GP.DrawLine(GPPen2, GPPoints[2], GPPoints[3]);
              end;
            end
            else if ((Direction = gdLeft) and (Orientation = goForward)) or
              ((Direction = gdRight) and (Orientation = goBackward)) then
            begin

              if Theme = gstPlastic then
              begin
                PlasticHighlight(GPPoints[3], GPPoints[4]);
                PlasticHighlight(GPPoints[7], GPPoints[8]);
              end;

              ThickArc(GPX, GPY, Extends[0], Extends[2], Extends[4], Extends[3]);
              GP.FillPath(GPBrush1, GPPath);

              if Theme = gstPlastic then
              begin
                GP.DrawLine(GPPen3, GPPoints[6], GPPoints[7]);
                GP.DrawLine(GPPen3, GPPoints[3], GPPoints[4]);
                GP.DrawLine(GPPen3, GPPoints[7], GPPoints[8]);
                GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);

                GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen2, GPPoints[4], GPPoints[5]);

                GP.DrawLine(GPPen1, GPPoints[5], GPPoints[6]);
              end;
            end
            else
            begin
              if Theme = gstPlastic then
                PlasticHighlight(GPPoints[5], GPPoints[6]);

              ThickArc(GPX, GPY, Extends[0], Extends[2], Extends[4], Extends[3]);
              GP.FillPath(GPBrush1, GPPath);

              if Theme = gstPlastic then
              begin
                GP.DrawLine(GPPen3, GPPoints[5], GPPoints[6]);
                GP.DrawLine(GPPen3, GPPoints[2], GPPoints[3]);

                GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
                GP.DrawLine(GPPen2, GPPoints[4], GPPoints[5]);
                GP.DrawLine(GPPen2, GPPoints[6], GPPoints[7]);

                GP.DrawLine(GPPen1, GPPoints[3], GPPoints[4]);
                GP.DrawLine(GPPen2, GPPoints[7], GPPoints[8]);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  SetLength(Offsets, 0);
  SetLength(Extends, 0);
  SetLength(Points, 0);
  SetLength(GPPoints, 0);
end;

function GnvGlyphGetSize(Glyph: TGnvGlyph; Direction: TGnvDirection = gdDown;
	Theme: TGnvSystemTheme = gstAuto; Scale: TGnvSystemScale = gssAuto): TSize;

	function Size(X, Y: Integer): TSize; overload;
	begin
		Result.cx := X;
		Result.cy := Y;
  end;

  function Size(X: Integer): TSize; overload;
  begin
    Result.cx := X;
    Result.cy := X;
  end;

  function Rotate(Size: TSize): TSize;
  begin
    Result.cx := Size.cy;
    Result.cy := Size.cx;
  end;

begin
	Result := Size(0, 0);
	Theme := GnvSystemThemeDetect(Theme);
	Scale := GnvSystemScaleDetect(Scale);

	case Theme of
		gstClassic, gstFlat:
    begin
			case Glyph of
				glClose:
					case Scale of
						gss100:  	Result := Size(8, 7);
						gss125:		Result := Size(11, 9);
					end;
				glCaret:
        begin
					case Scale of
						gss100: Result := Size(7, 4);
						gss125: Result := Size(9, 5);
            gss150:	Result := Size(11, 6);
            gss175:	Result := Size(12, 7);
            gss200:	Result := Size(14, 8);
					end;
          if Direction in [gdLeft, gdRight] then Result := Rotate(Result);
        end;
				glChevron:
					case Scale of
						gss100:
							case Direction of
								gdUp, gdDown:			Result := Size(8);
								gdLeft, gdRight:  Result := Size(8);
							end;
					end;
				glPlus:
					case Scale of
						gss100:  	Result := Size(8);
						gss125:		Result := Size(10);
            gss150:   Result := Size(13);
            gss175:   Result := Size(15);
						gss200:		Result := Size(17);
					end;
				glMinus:
					case Scale of
						gss100:  	Result := Size(8, 3);
						gss125:		Result := Size(10, 3);
            gss150:   Result := Size(13, 3);
            gss175:   Result := Size(15, 5);
						gss200:		Result := Size(17, 5);
					end;
				glArrow: 		;
				glMenu:
          case Scale of
            gss100:   Result := Size(14);
            gss125:   Result := Size(16);
            gss150:   Result := Size(18);
            gss175:   Result := Size(24, 22);
            gss200:   Result := Size(26, 24);
          end;
				glPane:
					case Scale of
						gss100:  	Result := Size(14);
						gss125:		Result := Size(16);
            gss150:   Result := Size(18);
            gss175:   Result := Size(24);
						gss200:		Result := Size(26);
					end;
        glRound:
          case Scale of
            gss100:   Result := Size(13);
            gss125:   Result := Size(15);
            gss150:   Result := Size(19);
            gss175:   Result := Size(23);
            gss200:   Result := Size(27);
          end;
        glUpdate:
        begin
					case Scale of
						gss100: Result := Size(18, 21);
            gss125: Result := Size(23, 26);
            gss150: Result := Size(28, 31);
            gss175: Result := Size(33, 36);
            gss200: Result := Size(37, 42);
					end;
          if Direction in [gdLeft, gdRight] then Result := Rotate(Result);
        end;
			end;
    end;
		gstPlastic:
		begin
			Result := GnvGlyphGetSize(Glyph, Direction, gstFlat, Scale);

      // Add plastic drawing offset
      Inc(Result.cx);
      Inc(Result.cy);

			// Add horizontal border highlights
      Inc(Result.cy);
		end;
	end;
end;

procedure GnvProcessGlyphDraw(Canvas: TCanvas; Rect: TRect; Progress: Single = 1;
  Theme: TGnvSystemTheme = gstAuto; Scale: TGnvSystemScale = gssAuto);
begin

end;

function GnvProgressGlyphGetSize(Theme: TGnvSystemTheme = gstAuto;
  Scale: TGnvSystemScale = gssAuto): TSize;
begin
	Result.cx := 0;
  Result.cy := 0;

	Theme := GnvSystemThemeDetect(Theme);
	Scale := GnvSystemScaleDetect(Scale);

  case Theme of
    gstClassic: ;
    gstPlastic: ;
    gstFlat:    ;
  end;
end;

procedure GnvTextDraw(Canvas: TCanvas; Rect: TRect; Text: string; Font: TFont = nil;
	Enabled: Boolean = True);
var
  NativeHandle: GpStringFormat;
	Color: TColor;
	GP: IGPGraphics;
	GPR: TGPRectF;
	GPFontFamily: IGPFontFamily;
	GPFont: IGPFont;
	GPBrush: IGPBrush;
	GPStringFormat: IGPStringFormat;
begin
  // Get GenericTypographic string format to remove MeasureString and DrawString drawing pads
  // Check NativeHandle is received to avoid Access Violation on application exit
  if GdipStringFormatGetGenericTypographic(NativeHandle) <> Ok then Exit;
	GPStringFormat := TGPStringFormat.Create;
  GPStringFormat.NativeHandle := NativeHandle;
	GPStringFormat.Alignment := StringAlignmentNear;
	GPStringFormat.LineAlignment := StringAlignmentCenter;
  GPStringFormat.HotkeyPrefix := HotkeyPrefixShow;

	GP := TGPGraphics.Create(Canvas.Handle);
	GP.TextRenderingHint := TextRenderingHintSystemDefault;

  if not Assigned(Font) then Font := Canvas.Font;
	GPFontFamily := TGPFontFamily.Create(Font.Name);
	GPFont := TGPFont.Create(GPFontFamily, Font.Size, GnvGPFontStyle(Font.Style), UnitPoint);

	if Enabled then Color := Font.Color else Color := clGrayText;
	GPBrush := TGPSolidBrush.Create(GnvGPColor(Color));

	GPR.InitializeFromLTRB(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
	GP.DrawString(Text, GPFont, GPR, GPStringFormat, GPBrush);
end;

function GnvTextGetSize(Canvas: TCanvas; Text: string; Font: TFont = nil): TSize;
var
  NativeHandle: GpStringFormat;
	Color: TColor;
	GP: IGPGraphics;
	GPR: TGPRectF;
	GPFontFamily: IGPFontFamily;
	GPFont: IGPFont;
	GPBrush: IGPBrush;
	GPStringFormat: IGPStringFormat;
begin
  Result.cx := 0;
  Result.cy := 0;

  // Get GenericTypographic string format to remove MeasureString and DrawString drawing pads
  // Check NativeHandle is received to avoid Access Violation on application exit
  if GdipStringFormatGetGenericTypographic(NativeHandle) <> Ok then Exit;
	GPStringFormat := TGPStringFormat.Create;
  GPStringFormat.NativeHandle := NativeHandle;
	GPStringFormat.Alignment := StringAlignmentNear;
	GPStringFormat.LineAlignment := StringAlignmentCenter;
  GPStringFormat.HotkeyPrefix := HotkeyPrefixShow;

	GP := TGPGraphics.Create(Canvas.Handle);
	GP.TextRenderingHint := TextRenderingHintSystemDefault;

  if not Assigned(Font) then Font := Canvas.Font;
	GPFontFamily := TGPFontFamily.Create(Font.Name);
	GPFont := TGPFont.Create(GPFontFamily, Font.Size, GnvGPFontStyle(Font.Style), UnitPoint);

  GPR := GP.MeasureString(Text, GPFont, TGPPointF.Create(0, 0), GPStringFormat);
  Result.cx := Ceil(GPR.Width);
  Result.cy := Ceil(GPR.Height);
end;

procedure GnvDrawGlyphTriangle(Canvas: TCanvas; Rect: TRect; Direction: TGnvDirection;
  Enabled: Boolean = True);
var
  X, Y, I: Integer;
  OldPenColor: TColor;
  OldBrushStyle: TBrushStyle;
  OldBrushColor: TColor;
  Alpha: Byte;
  Points: array [0..2] of TPoint;
  GP: IGPGraphics;
  GPBrush: IGPBrush;
  GPPen0, GPPen1, GPPen2, GPPen3, GPPen4, GPPen5: IGPPen;
  GPPoints: array [0..2] of TGPPoint;
begin
  X := Rect.Left + (Rect.Right - Rect.Left) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2;

  if GnvSystemScaleDetect = gss125 then
  begin
    case Direction of
      gdLeft:
      begin
        Points[0] := Point(X + 2, Y - 4);
        Points[1] := Point(X + 2, Y + 4);
        Points[2] := Point(X - 2, Y);
      end;
			gdUp:
      begin
        Points[0] := Point(X - 4, Y + 2);
        Points[1] := Point(X + 4, Y + 2);
        Points[2] := Point(X, Y - 2);
      end;
			gdRight:
      begin
        Points[0] := Point(X - 2, Y - 4);
        Points[1] := Point(X - 2, Y + 4);
        Points[2] := Point(X + 2, Y);
      end;
      gdDown:
      begin
        Points[0] := Point(X - 4, Y - 2);
        Points[1] := Point(X + 4, Y - 2);
        Points[2] := Point(X, Y + 2);
      end;
    end;
  end
  else
  begin
    case Direction of
			gdLeft:
      begin
        Points[0] := Point(X + 1, Y - 3);
        Points[1] := Point(X + 1, Y + 3);
        Points[2] := Point(X - 2, Y);
      end;
			gdUp:
			begin
				Points[0] := Point(X - 3, Y + 1);
				Points[1] := Point(X + 3, Y + 1);
				Points[2] := Point(X, Y - 2);
			end;
			gdRight:
			begin
				Points[0] := Point(X - 1, Y - 3);
				Points[1] := Point(X - 1, Y + 3);
				Points[2] := Point(X + 2, Y);
			end;
      gdDown:
      begin
        Points[0] := Point(X - 3, Y - 1);
        Points[1] := Point(X + 3, Y - 1);
        Points[2] := Point(X, Y + 2);
      end;
    end;
  end;

  if (Win32MajorVersion >= 5) and IsAppThemed and
    not ((Win32MajorVersion >= 6) and (Win32MinorVersion >= 2)) then
  begin
    GP := TGPGraphics.Create(Canvas.Handle);
    GP.SmoothingMode := SmoothingModeAntiAlias;

    {
    if (Win32MajorVersion >= 6) and (Win32MinorVersion >= 2) then
    begin
      case Direction of
        akLeft, gdRight:
        begin
          GPPoints[0] := TGPPointF.Create(Points[0].X + 0.5, Points[0].Y);
          GPPoints[1] := TGPPointF.Create(Points[1].X + 0.5, Points[1].Y);
          GPPoints[2] := TGPPointF.Create(Points[2].X + 0.5, Points[2].Y);
        end;
				akTop, akBottom:
        begin
          GPPoints[0] := TGPPointF.Create(Points[0].X, Points[0].Y + 0.5);
          GPPoints[1] := TGPPointF.Create(Points[1].X, Points[1].Y + 0.5);
          GPPoints[2] := TGPPointF.Create(Points[2].X, Points[2].Y + 0.5);
				end;
      end;


      if Enabled then
        GPBrush := TGPSolidBrush.Create(ColorToGPColor(clBtnText))
      else
        GPBrush := TGPSolidBrush.Create(ColorToGPColor(clGrayText));

      GP.FillPolygon(GPBrush, GPPoints);
    end
    else
    }
    begin
      for I := 0 to Length(Points) - 1 do
        GPPoints[I] := TGPPoint.Create(Points[I].X, Points[I].Y);

      if Enabled then
        Alpha := 255
      else
        Alpha := 95;

      GPBrush := TGPSolidBrush.Create(GnvGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 180), Alpha));

      GPPen0 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBlack, 193), Alpha));
      GPPen1 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBlack, 223), Alpha));
      GPPen2 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 193), Alpha));
      GPPen3 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
      GPPen4 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 63), Alpha));
      GPPen5 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnHighlight, clWhite, 127), Alpha));

      GP.FillPolygon(GPBrush, GPPoints);
      case Direction of
				gdLeft:
        begin
          GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
          GP.DrawLine(GPPen4, GPPoints[1], GPPoints[2]);
          GP.DrawLine(GPPen0, GPPoints[2], GPPoints[0]);

          GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1),
  					TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1));
        end;
				gdUp:
				begin
					GP.DrawLine(GPPen4, GPPoints[0], GPPoints[1]);
					GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
					GP.DrawLine(GPPen1, GPPoints[2], GPPoints[0]);
					GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[0].X, GPPoints[0].Y + 1),
						TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1));
				end;
				gdRight:
				begin
					GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
					GP.DrawLine(GPPen4, GPPoints[1], GPPoints[2]);
					GP.DrawLine(GPPen0, GPPoints[2], GPPoints[0]);

					GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1),
						TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1));
				end;
        gdDown:
        begin
          GP.DrawLine(GPPen1, GPPoints[0], GPPoints[1]);
          GP.DrawLine(GPPen2, GPPoints[1], GPPoints[2]);
          GP.DrawLine(GPPen2, GPPoints[2], GPPoints[0]);
          GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1),
            TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1));
          GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1),
            TGPPointF.Create(GPPoints[0].X, GPPoints[0].Y + 1));
        end;
      end;
    end;
  end
  else
    with Canvas do
    begin
      OldBrushStyle := Brush.Style;
      OldBrushColor := Brush.Color;
      OldPenColor := Pen.Color;

      Brush.Style := bsSolid;
      if Enabled then
      begin
        Brush.Color := clBtnText;
        Pen.Color := clBtnText;
      end
      else
      begin
        Brush.Color := clGrayText;
        Pen.Color := clGrayText;
      end;
      Polygon(Points);

      Brush.Style := OldBrushStyle;
      Pen.Color := OldPenColor;
      Brush.Color := OldBrushColor;
    end;
end;

procedure GnvDrawGlyphClose(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
var
  M: Double;
  X, Y, I: Integer;
  Alpha: Byte;
  Points1, Points2: array [0..3] of TPoint;
  OldPenStyle: TPenStyle;
  OldBrushStyle: TBrushStyle;
  OldBrushColor: TColor;
  GP: IGPGraphics;
  GPBrush: IGPBrush;
  GPPen0, GPPen1, GPPen2, GPPen3, GPPen4, GPPen5: IGPPen;
  GPPoints1, GPPoints2: array [0..3] of TGPPoint;
  GPPointsF1, GPPointsF2: array [0..3] of TGPPointF;
begin
  X := Rect.Left + (Rect.Right - Rect.Left) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2;
  Y := Y - 1;

  if (Win32MajorVersion >= 5) and IsAppThemed then
  begin
    GP := TGPGraphics.Create(Canvas.Handle);
    GP.SmoothingMode := SmoothingModeAntiAlias;

    if (Win32MajorVersion >= 6) and (Win32MinorVersion >= 2) then
    begin
      if GnvSystemScaleDetect = gss125 then
      begin
        GPPointsF1[0] := TGPPointF.Create(X - 5.5, Y - 3.5);
        GPPointsF1[1] := TGPPointF.Create(X - 3.5, Y - 3.5);
        GPPointsF1[2] := TGPPointF.Create(X + 5.5, Y + 5.5);
        GPPointsF1[3] := TGPPointF.Create(X + 3.5, Y + 5.5);

        GPPointsF2[0] := TGPPointF.Create(X + 3.5, Y - 3.5);
        GPPointsF2[1] := TGPPointF.Create(X + 5.5, Y - 3.5);
        GPPointsF2[2] := TGPPointF.Create(X - 3.5, Y + 5.5);
        GPPointsF2[3] := TGPPointF.Create(X - 5.5, Y + 5.5);
      end
      else
      begin
        GPPointsF1[0] := TGPPointF.Create(X - 4.5, Y - 2.5);
        GPPointsF1[1] := TGPPointF.Create(X - 2.5, Y - 2.5);
        GPPointsF1[2] := TGPPointF.Create(X + 4.5, Y + 4.5);
        GPPointsF1[3] := TGPPointF.Create(X + 2.5, Y + 4.5);

        GPPointsF2[0] := TGPPointF.Create(X + 2.5, Y - 2.5);
        GPPointsF2[1] := TGPPointF.Create(X + 4.5, Y - 2.5);
        GPPointsF2[2] := TGPPointF.Create(X - 2.5, Y + 4.5);
        GPPointsF2[3] := TGPPointF.Create(X - 4.5, Y + 4.5);
      end;

      if Enabled then
        GPBrush := TGPSolidBrush.Create(GnvGPColor(clBtnText))
      else
        GPBrush := TGPSolidBrush.Create(GnvGPColor(clGrayText));

      GP.FillPolygon(GPBrush, GPPointsF1);
      GP.FillPolygon(GPBrush, GPPointsF2);
    end
    else
    begin
      if GnvSystemScaleDetect = gss125 then
      begin
        GPPoints1[0] := TGPPoint.Create(X - 5, Y - 3);
        GPPoints1[1] := TGPPoint.Create(X - 3, Y - 3);
        GPPoints1[2] := TGPPoint.Create(X + 5, Y + 5);
        GPPoints1[3] := TGPPoint.Create(X + 3, Y + 5);

        GPPoints2[0] := TGPPoint.Create(X + 3, Y - 3);
        GPPoints2[1] := TGPPoint.Create(X + 5, Y - 3);
        GPPoints2[2] := TGPPoint.Create(X - 3, Y + 5);
        GPPoints2[3] := TGPPoint.Create(X - 5, Y + 5);
      end
      else
      begin
        GPPoints1[0] := TGPPoint.Create(X - 4, Y - 2);
        GPPoints1[1] := TGPPoint.Create(X - 2, Y - 2);
        GPPoints1[2] := TGPPoint.Create(X + 4, Y + 4);
        GPPoints1[3] := TGPPoint.Create(X + 2, Y + 4);

        GPPoints2[0] := TGPPoint.Create(X + 2, Y - 2);
        GPPoints2[1] := TGPPoint.Create(X + 4, Y - 2);
        GPPoints2[2] := TGPPoint.Create(X - 2, Y + 4);
        GPPoints2[3] := TGPPoint.Create(X - 4, Y + 4);
      end;

      if Enabled then
        Alpha := 255
      else
        Alpha := 95;

      GPBrush := TGPSolidBrush.Create(GnvGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 180), Alpha));

      GPPen0 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBlack, 193), Alpha));
      GPPen1 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBlack, 223), Alpha));
      GPPen2 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 193), Alpha));
      GPPen3 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
      GPPen4 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 63), Alpha));
      GPPen5 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnHighlight, clWhite, 127), Alpha));

      GP.FillPolygon(GPBrush, GPPoints1);
      GP.FillPolygon(GPBrush, GPPoints2);

      GP.DrawLine(GPPen1, GPPoints1[1], TGPPoint.Create(GPPoints1[1].X + 2, GPPoints1[1].Y + 2));
      GP.DrawLine(GPPen1, GPPoints2[0], TGPPoint.Create(GPPoints2[0].X - 2, GPPoints2[0].Y + 2));
      GP.DrawLine(GPPen1, GPPoints1[2], TGPPoint.Create(GPPoints1[2].X - 2, GPPoints1[2].Y - 2));
      GP.DrawLine(GPPen1, GPPoints2[3], TGPPoint.Create(GPPoints2[3].X + 2, GPPoints2[3].Y - 2));

      GP.DrawLine(GPPen2, GPPoints1[3], TGPPoint.Create(GPPoints1[3].X - 2, GPPoints1[3].Y - 2));
      GP.DrawLine(GPPen2, GPPoints2[2], TGPPoint.Create(GPPoints2[2].X + 2, GPPoints2[2].Y - 2));
      GP.DrawLine(GPPen3, GPPoints1[0], TGPPoint.Create(GPPoints1[0].X + 2, GPPoints1[0].Y + 2));
      GP.DrawLine(GPPen3, GPPoints2[1], TGPPoint.Create(GPPoints2[1].X - 2, GPPoints2[1].Y + 2));

      GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints1[3].X, GPPoints1[3].Y + 1),
        TGPPoint.Create(GPPoints1[3].X - 2, GPPoints1[3].Y - 1));
      GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints2[2].X, GPPoints2[2].Y + 1),
        TGPPoint.Create(GPPoints2[2].X + 2, GPPoints2[2].Y - 1));

      GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints1[0].X, GPPoints1[0].Y + 1),
        TGPPoint.Create(GPPoints1[0].X + 2, GPPoints1[0].Y + 3));
      GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints2[1].X, GPPoints2[1].Y + 1),
        TGPPoint.Create(GPPoints2[1].X - 2, GPPoints2[1].Y + 3));

      GP.DrawLine(GPPen1, GPPoints1[0], GPPoints1[1]);
      GP.DrawLine(GPPen1, GPPoints2[0], GPPoints2[1]);

      GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints1[2].X, GPPoints1[2].Y + 1),
        TGPPoint.Create(GPPoints1[3].X, GPPoints1[3].Y + 1));
      GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints2[2].X, GPPoints2[2].Y + 1),
        TGPPoint.Create(GPPoints2[3].X, GPPoints2[3].Y + 1));
    end;
  end
  else
    with Canvas do
    begin
      if GnvSystemScaleDetect = gss125 then
      begin
        Points1[0] := Point(X - 4, Y - 3);
        Points1[1] := Point(X - 2, Y - 3);
        Points1[2] := Point(X + 5, Y + 5);
        Points1[3] := Point(X + 3, Y + 5);

        Points2[0] := Point(X + 3, Y - 3);
        Points2[1] := Point(X + 5, Y - 3);
        Points2[2] := Point(X - 3, Y + 5);
        Points2[3] := Point(X - 5, Y + 5);
      end
      else
      begin
        Points1[0] := Point(X - 3, Y - 2);
        Points1[1] := Point(X - 1, Y - 2);
        Points1[2] := Point(X + 4, Y + 4);
        Points1[3] := Point(X + 2, Y + 4);

        Points2[0] := Point(X + 2, Y - 2);
        Points2[1] := Point(X + 4, Y - 2);
        Points2[2] := Point(X - 2, Y + 4);
        Points2[3] := Point(X - 4, Y + 4);
      end;

      OldBrushStyle := Brush.Style;
      OldPenStyle := Pen.Style;
      OldBrushColor := Brush.Color;

      Brush.Style := bsSolid;
      Pen.Style := psClear;
      if Enabled then
        Brush.Color := clBtnText
      else
        Brush.Color := clGrayText;

      Polygon(Points1);
      Polygon(Points2);

      Brush.Style := OldBrushStyle;
      Pen.Style := OldPenStyle;
      Brush.Color := OldBrushColor;
    end;
end;

procedure GnvDrawImage(Canvas: TCanvas; Rect: TRect; Images: TCustomImageList;
  Index: Integer);
var
  X, Y: Integer;
begin
	if (Index < 0) or (Index >= Images.Count) then Exit;

  X := Rect.Left + (Rect.Right - Rect.Left - Images.Width) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top - Images.Height) div 2;
  Images.Draw(Canvas, X, Y, Index);
end;

procedure GnvDrawClassicPanel(Canvas: TCanvas; Rect: TRect; HideBorders: TGnvDirections = [];
  Down: Boolean = False; Color: TColor = clBtnFace);
begin
  with Canvas do
  begin
		if gdUp in HideBorders then Rect.Top := Rect.Top - 1;
		if gdLeft in HideBorders then Rect.Left := Rect.Left - 1;
		if gdDown in HideBorders then Rect.Bottom := Rect.Bottom + 1;
		if gdRight in HideBorders then Rect.Right := Rect.Right + 1;

    Brush.Color := Color;
    FillRect(Rect);

    if Down then
      Pen.Color := clBtnShadow
    else
      Pen.Color := clBtnHighlight;
    MoveTo(Rect.Left, Rect.Bottom - 1);
    LineTo(Rect.Left, Rect.Top);
    LineTo(Rect.Right - 1, Rect.Top);

    if Down then
      Pen.Color := clBtnHighlight
    else
      Pen.Color := clBtnShadow;
    LineTo(Rect.Right - 1, Rect.Bottom - 1);
    LineTo(Rect.Left - 1, Rect.Bottom - 1)
  end;
end;

procedure GnvDrawGlyphChevron(Canvas: TCanvas; Rect: TRect; Direction: TGnvDirection;
  Enabled: Boolean = True);
var
  X, Y, I: Integer;
  Alpha: Byte;
  Points: array [0..5] of TPoint;
  OldPenStyle: TPenStyle;
  OldBrushStyle: TBrushStyle;
  OldBrushColor: TColor;
  GP: IGPGraphics;
  GPBrush: IGPBrush;
  GPPen0, GPPen1, GPPen2, GPPen3, GPPen4, GPPen5: IGPPen;
  GPPoints: array [0..5] of TGPPointF;
begin
	X := Rect.Left + (Rect.Right - Rect.Left) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2;

  if (Win32MajorVersion >= 5) and IsAppThemed and
    not ((Win32MajorVersion >= 6) and (Win32MinorVersion >= 2)) then
  begin
    GP := TGPGraphics.Create(Canvas.Handle);
    GP.SmoothingMode := SmoothingModeAntiAlias;

    case Direction of
			gdLeft:
			begin
				GPPoints[0] := TGPPointF.Create(X + 2, Y - 3);
				GPPoints[1] := TGPPointF.Create(X - 1, Y);
				GPPoints[2] := TGPPointF.Create(X + 2, Y + 3);
				GPPoints[3] := TGPPointF.Create(X, Y + 3);
				GPPoints[4] := TGPPointF.Create(X - 3, Y);
				GPPoints[5] := TGPPointF.Create(X, Y - 3);
			end;
			gdUp:
			begin
				GPPoints[0] := TGPPointF.Create(X - 3, Y + 2);
				GPPoints[1] := TGPPointF.Create(X, Y - 1);
				GPPoints[2] := TGPPointF.Create(X + 3, Y + 2);
				GPPoints[3] := TGPPointF.Create(X + 3, Y);
				GPPoints[4] := TGPPointF.Create(X, Y - 3);
				GPPoints[5] := TGPPointF.Create(X - 3, Y);
			end;
			gdRight:
			begin
				GPPoints[0] := TGPPointF.Create(X - 2, Y - 3);
				GPPoints[1] := TGPPointF.Create(X + 1, Y);
				GPPoints[2] := TGPPointF.Create(X - 2, Y + 3);
				GPPoints[3] := TGPPointF.Create(X, Y + 3);
				GPPoints[4] := TGPPointF.Create(X + 3, Y);
				GPPoints[5] := TGPPointF.Create(X, Y - 3);
			end;
			gdDown:
			begin
				GPPoints[0] := TGPPointF.Create(X - 3, Y - 1);
				GPPoints[1] := TGPPointF.Create(X, Y + 2);
				GPPoints[2] := TGPPointF.Create(X + 3, Y - 1);
				GPPoints[3] := TGPPointF.Create(X + 3, Y + 1);
        GPPoints[4] := TGPPointF.Create(X, Y + 4);
        GPPoints[5] := TGPPointF.Create(X - 3, Y + 1);
      end;
    end;

    if Enabled then
      Alpha := 255
    else
      Alpha := 95;

    GPBrush := TGPSolidBrush.Create(GnvGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 193), Alpha));

    GPPen0 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBlack, 207), Alpha));
    GPPen1 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 223), Alpha));
    GPPen2 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 255), Alpha));
    GPPen3 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
    GPPen4 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 63), Alpha));
    GPPen5 := TGPPen.Create(GnvGPColor(GnvBlendColors(clBtnHighlight, clWhite, 143), Alpha));

    GP.FillPolygon(GPBrush, GPPoints);

    case Direction of
			gdLeft:
      begin
        GP.DrawLine(GPPen2, GPPoints[2], GPPoints[3]);

        GP.DrawLine(GPPen0, GPPoints[1], GPPoints[2]);
        GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);

        GP.DrawLine(GPPen2, GPPoints[3], GPPoints[4]);
        GP.DrawLine(GPPen0, GPPoints[4], GPPoints[5]);

        GP.DrawLine(GPPen0, GPPoints[5], GPPoints[0]);

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[0].X + 1, GPPoints[0].Y),
          TGPPointF.Create(GPPoints[1].X + 1, GPPoints[1].Y));

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1),
          TGPPointF.Create(GPPoints[3].X, GPPoints[3].Y + 1));

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[3].X - 1, GPPoints[3].Y),
          TGPPointF.Create(GPPoints[4].X - 1, GPPoints[4].Y));
      end;
			gdUp:
			begin
				GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
				GP.DrawLine(GPPen2, GPPoints[1], GPPoints[2]);

				GP.DrawLine(GPPen1, GPPoints[2], GPPoints[3]);
				GP.DrawLine(GPPen1, GPPoints[5], GPPoints[0]);

				GP.DrawLine(GPPen0, GPPoints[3], GPPoints[4]);
				GP.DrawLine(GPPen0, GPPoints[4], GPPoints[5]);

				GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[0].X, GPPoints[0].Y + 1),
					TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1));
				GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1),
					TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1));
			end;
			gdRight:
			begin
				GP.DrawLine(GPPen2, GPPoints[2], GPPoints[3]);

        GP.DrawLine(GPPen0, GPPoints[1], GPPoints[2]);
        GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);

        GP.DrawLine(GPPen2, GPPoints[3], GPPoints[4]);
        GP.DrawLine(GPPen0, GPPoints[4], GPPoints[5]);

        GP.DrawLine(GPPen0, GPPoints[5], GPPoints[0]);

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[0].X - 1, GPPoints[0].Y),
          TGPPointF.Create(GPPoints[1].X - 1, GPPoints[1].Y));

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1),
          TGPPointF.Create(GPPoints[3].X, GPPoints[3].Y + 1));

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[3].X + 1, GPPoints[3].Y),
          TGPPointF.Create(GPPoints[4].X + 1, GPPoints[4].Y));
      end;
      gdDown:
      begin
        GP.DrawLine(GPPen2, GPPoints[3], GPPoints[4]);
        GP.DrawLine(GPPen2, GPPoints[4], GPPoints[5]);

        GP.DrawLine(GPPen2, GPPoints[2], GPPoints[3]);
        GP.DrawLine(GPPen2, GPPoints[5], GPPoints[0]);

        GP.DrawLine(GPPen0, GPPoints[0], GPPoints[1]);
        GP.DrawLine(GPPen0, GPPoints[1], GPPoints[2]);

        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[3].X, GPPoints[3].Y + 1),
          TGPPointF.Create(GPPoints[4].X, GPPoints[4].Y + 1));
        GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[4].X, GPPoints[4].Y + 1),
          TGPPointF.Create(GPPoints[5].X, GPPoints[5].Y + 1));
      end;
    end;

{
    GP.DrawLine(GPPen1, GPPoints1[1], TGPPoint.Create(GPPoints1[1].X + 2, GPPoints1[1].Y + 2));
    GP.DrawLine(GPPen1, GPPoints2[0], TGPPoint.Create(GPPoints2[0].X - 2, GPPoints2[0].Y + 2));
    GP.DrawLine(GPPen1, GPPoints1[2], TGPPoint.Create(GPPoints1[2].X - 2, GPPoints1[2].Y - 2));
    GP.DrawLine(GPPen1, GPPoints2[3], TGPPoint.Create(GPPoints2[3].X + 2, GPPoints2[3].Y - 2));

    GP.DrawLine(GPPen2, GPPoints1[3], TGPPoint.Create(GPPoints1[3].X - 2, GPPoints1[3].Y - 2));
    GP.DrawLine(GPPen2, GPPoints2[2], TGPPoint.Create(GPPoints2[2].X + 2, GPPoints2[2].Y - 2));
    GP.DrawLine(GPPen3, GPPoints1[0], TGPPoint.Create(GPPoints1[0].X + 2, GPPoints1[0].Y + 2));
    GP.DrawLine(GPPen3, GPPoints2[1], TGPPoint.Create(GPPoints2[1].X - 2, GPPoints2[1].Y + 2));

    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints1[3].X, GPPoints1[3].Y + 1),
      TGPPoint.Create(GPPoints1[3].X - 2, GPPoints1[3].Y - 1));
    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints2[2].X, GPPoints2[2].Y + 1),
      TGPPoint.Create(GPPoints2[2].X + 2, GPPoints2[2].Y - 1));

    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints1[0].X, GPPoints1[0].Y + 1),
      TGPPoint.Create(GPPoints1[0].X + 2, GPPoints1[0].Y + 3));
    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints2[1].X, GPPoints2[1].Y + 1),
      TGPPoint.Create(GPPoints2[1].X - 2, GPPoints2[1].Y + 3));

    GP.DrawLine(GPPen1, GPPoints1[0], GPPoints1[1]);
    GP.DrawLine(GPPen1, GPPoints2[0], GPPoints2[1]);

    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints1[2].X, GPPoints1[2].Y + 1),
      TGPPoint.Create(GPPoints1[3].X, GPPoints1[3].Y + 1));
    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints2[2].X, GPPoints2[2].Y + 1),
      TGPPoint.Create(GPPoints2[3].X, GPPoints2[3].Y + 1));
       }
  end
  else

    with Canvas do
    begin
      case Direction of
				gdLeft:
				begin
					Points[0] := Point(X - 3, Y);
					Points[1] := Point(X, Y - 3);
					Points[2] := Point(X + 3, Y - 3);
					Points[3] := Point(X, Y);
					Points[4] := Point(X + 3, Y + 4);
					Points[5] := Point(X, Y + 4);
				end;
				gdUp:
				begin
					Points[0] := Point(X - 3, Y + 1);
					Points[1] := Point(X, Y - 3);
					Points[2] := Point(X + 4, Y + 1);
					Points[3] := Point(X + 4, Y + 4);
					Points[4] := Point(X, Y);
					Points[5] := Point(X - 3, Y + 4);
				end;
				gdRight:
				begin
					Points[0] := Point(X + 4, Y);
					Points[1] := Point(X + 1, Y - 3);
					Points[2] := Point(X - 2, Y - 3);
					Points[3] := Point(X + 1, Y);
					Points[4] := Point(X - 3, Y + 4);
					Points[5] := Point(X, Y + 4);
				end;
        gdDown:
        begin
          Points[0] := Point(X - 3, Y - 3);
          Points[1] := Point(X, Y + 1);
          Points[2] := Point(X + 4, Y - 3);
          Points[3] := Point(X + 4, Y);
          Points[4] := Point(X, Y + 4);
          Points[5] := Point(X - 3, Y);
        end;
      end;

      OldBrushStyle := Brush.Style;
      OldPenStyle := Pen.Style;
      OldBrushColor := Brush.Color;

      Brush.Style := bsSolid;
      Pen.Style := psClear;
      if Enabled then
        Brush.Color := clBtnText
      else
        Brush.Color := clGrayText;

      Polygon(Points);

      Brush.Style := OldBrushStyle;
      Pen.Style := OldPenStyle;
      Brush.Color := OldBrushColor;
    end;
end;

procedure GnvDrawGlyphMenu(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
begin

end;

procedure GnvDrawText(Canvas: TCanvas; Rect: TRect; Text: string; Format: UINT;
  Enabled: Boolean = True; Ghosted: Boolean = False);
var
  OldStyle: TBrushStyle;
	OldColor: TColor;
	OldSize: Integer;
	DDTOpts: TDTTOpts;
	GP: IGPGraphics;
	GPR: TGPRectF;
	GPFontFamily: IGPFontFamily;
	GPFont: IGPFont;
	GPBrush: IGPBrush;
	GPStringFormat: IGPStringFormat;
begin
//  OldStyle := Canvas.Brush.Style;
	OldColor := Canvas.Font.Color;
//	OldSize := Canvas.Font.Size;
//  Canvas.Brush.Style := bsSolid;
	SetBkMode(Canvas.Handle, TRANSPARENT);
	if Enabled then
	begin
		if Ghosted then
			Canvas.Font.Color := GnvBlendColors(Canvas.Font.Color, clBtnFace, 127)
		else
			Canvas.Font.Color := Canvas.Font.Color
	end
	else
	begin
		if Ghosted then
			Canvas.Font.Color := GnvBlendColors(Canvas.Font.Color, clBtnFace, 63)
		else
			Canvas.Font.Color := clGrayText;
	end;

//	DrawText(Canvas.Handle, PWideChar(Text), Length(Text), Rect, Format);
{
	DDTOpts.dwSize := SizeOf(TDTTOpts);
	ddtOpts.dwFlags := DTT_COMPOSITED or DTT_TEXTCOLOR;

	DrawThemeTextEx(ThemeServices.Theme[teWindow], Canvas.Handle, WP_CAPTION,
		CS_ACTIVE, PWideChar(Text), Length(Text), Format, Rect, DDTOpts);
}
	GP := TGPGraphics.Create(Canvas.Handle);
	GP.TextRenderingHint := TextRenderingHintClearTypeGridFit;

	GPFontFamily := TGPFontFamily.Create(Canvas.Font.Name);
	GPFont := TGPFont.Create(GPFontFamily, Canvas.Font.Size, FontStyleRegular, UnitPoint);
	GPR.InitializeFromLTRB(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
	GPStringFormat := TGPStringFormat.Create([StringFormatFlagsNoWrap, StringFormatFlagsDisplayFormatControl]);
	GPStringFormat.Alignment := StringAlignmentNear;
	GPStringFormat.LineAlignment := StringAlignmentNear;//Center;
	GPBrush := TGPSolidBrush.Create(GnvGPColor(Canvas.Font.Color));

	GP.DrawString(Text, GPFont, GPR, GPStringFormat, GPBrush);

	SetBkMode(Canvas.Handle, BKMODE_LAST);
	Canvas.Font.Color := OldColor;
//	Canvas.Font.Size := OldSize;
end;

function ToolMenuGetMsgHook(Code: Integer; WParam: LongInt; LParam: LongInt): LongInt; stdcall;
begin
  if PCWPStruct(Pointer(LParam)).Message  = WM_EXITMENULOOP then
  begin
    if Assigned(MenuToolButton) then
      MenuToolButton.SetDown(False);
    MenuToolButton := nil;
    if ToolMenuHook <> 0 then
      UnhookWindowsHookEx(ToolMenuHook);
    ToolMenuHook := 0;
  end
  else
    Result := CallNextHookEx(ToolMenuHook, Code, WParam, LParam);
end;

function GnvGetOppositeAnchor(Direction: TGnvDirection): TGnvDirection;
begin
	case Direction of
		gdLeft:   Result := gdRight;
		gdUp:    	Result := gdDown;
		gdRight:  Result := gdLeft;
		gdDown: 	Result := gdUp;
  end;
end;

function GnvGetColorFlowColor(Row: Integer): TColor;
begin
  case Row of
    0:    Result := clBtnHighlight;
    1:    Result := GnvBlendColors(clBtnHighlight, clBtnFace, 191);
    2:    Result := clBtnFace;
    else  Result := GnvBlendColors(clBtnFace, clBtnShadow, 241);
  end;
end;

function GnvBorderGetColor(Theme: TGnvSystemTheme = gstAuto): TColor;
begin
	Theme := GnvSystemThemeDetect(Theme);
	case Theme of
		gstClassic: Result := clNone;
		gstPlastic: 		Result := clBtnShadow;
		gstFlat: 		Result := GnvBlendColors(clBtnFace, clBtnShadow, 63);
	end;
end;

{ TGnvControl }

procedure TGnvControl.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TGnvControl.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  Rebuild;
end;

constructor TGnvControl.Create(AOwner: TComponent);
begin
	inherited;
	// All GnvControls are double buffered by default
	DoubleBuffered := True;
	Height := 21;
	Width := 185;
	ControlStyle := ControlStyle + [csOpaque];

  FStyle := TGnvControlStyle.Create(Self);
	FBorders := [gbTop, gbBottom, gbLeft, gbRight];
	FBorderSticking := [];
	FScale := gssAuto;
	FTheme := gstAuto;
  FTransparent := False;
end;

destructor TGnvControl.Destroy;
begin
  FStyle.Free;
  inherited;
end;

procedure TGnvControl.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then
  begin
    Rebuild;
    SafeRepaint;
  end;
end;

function TGnvControl.GetHideBorders: TGnvDirections;
begin
	Result := [];
	if not (gbTop in FBorders) 		then Include(Result, gdUp);
	if not (gbBottom in FBorders) then Include(Result, gdDown);
	if not (gbLeft in FBorders) 	then Include(Result, gdLeft);
	if not (gbRight in FBorders) 	then Include(Result, gdRight);
end;

procedure TGnvControl.Paint;
var
	Theme: TGnvSystemTheme;
	I: Integer;
	R: TRect;
	GP: IGPGraphics;
	Path: IGPGraphicsPath;
	Pen: IGPPen;
	Brush: IGPBrush;
	GPR: TGPRect;
  BorderSize: LongWord;
  ShowBorders: Boolean;
begin
 	inherited;

//	if FTransparent or (Width <= 0) or (Height <= 0) then Exit;
	if (Width <= 0) or (Height <= 0) then Exit;

	R := ClientRect;

	Theme := GnvSystemThemeDetect(FTheme);
  ShowBorders := FStyle.GetShowBorders(Theme);

	case Theme of
		gstClassic:
    begin
      if ShowBorders then
        GnvFrameDrawClassic(Canvas, R, FBorders, False, Color, FScale)
      else
        GnvFrameDrawClassic(Canvas, R, [], False, Color, FScale);
    end;
		gstPlastic, gstFlat:
		begin
			GP := TGPGraphics.Create(Canvas.Handle);
 			GP.SmoothingMode := SmoothingModeAntiAlias;

			GPR.Initialize(R);
			Brush := GnvColorsCreateGPBrush(FStyle, GPR, Theme);
			Path := TGPGraphicsPath.Create;
			BorderSize := GnvBorderGetSize(FScale, ShowBorders);

			GnvFrameAddGPPath(Path, GPR, GnvSystemScaledSize(FStyle.GetRadius(Theme), FScale),
				BorderSize, FBorders, FBorderSticking, True);

			GP.FillPath(Brush, Path);

			if ShowBorders and (BorderSize > 0) then
			begin
				Pen := TGPPen.Create(GnvGPColor(GnvBorderGetColor(Theme)), BorderSize);

  			Path := TGPGraphicsPath.Create;
  			GnvFrameAddGPPath(Path, GPR, GnvSystemScaledSize(FStyle.GetRadius(Theme), FScale),
  				BorderSize, FBorders, FBorderSticking, False);
				GP.DrawPath(Pen, Path);
			end;
		end
	end;
end;

procedure TGnvControl.Rebuild;
begin
  if FUpdateCount > 0 then Exit;
end;

procedure TGnvControl.SafeRepaint;
begin
  if Showing and (FUpdateCount <= 0) then Repaint;
end;

function TGnvControl.SafeTextExtent(const Text: string; AFont: TFont = nil): TSize;
begin
  if Assigned(Parent) then
  try
    if Assigned(AFont) then
      Canvas.Font := AFont
    else
			Canvas.Font := Self.Font;
    Result := Canvas.TextExtent(Text);
  finally
  end;
end;

procedure TGnvControl.SetStyle(const Value: TGnvControlStyle);
begin
  FStyle.Assign(Value);
  SafeRepaint;
end;

procedure TGnvControl.SetScale(const Value: TGnvSystemScale);
begin
	if FScale <> Value then
	begin
		FScale := Value;
    Rebuild;
    AdjustSize;
		SafeRepaint;
	end;
end;

procedure TGnvControl.SetTheme(const Value: TGnvSystemTheme);
begin
	if FTheme <> Value then
	begin
		FTheme := Value;
    Rebuild;
    AdjustSize;
		SafeRepaint;
	end;
end;

procedure TGnvControl.SetTransparent(const Value: Boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
{
    if Value then
      ControlStyle := ControlStyle - [csOpaque] else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
}
  end;
end;

procedure TGnvControl.SetBorders(const Value: TGnvBorders);
begin
	if FBorders <> Value then
	begin
		FBorders := Value;
		SafeRepaint;
	end;
end;

procedure TGnvControl.SetBorderSticking(const Value: TGnvDirections);
begin
  if FBorderSticking <> Value then
  begin
    FBorderSticking := Value;
    SafeRepaint;
  end;
end;

procedure TGnvControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
	// Remove flicker
	Message.Result := 1;
end;

procedure TGnvControl.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  PS: TPaintStruct;
	R: TRect;
begin
	if not FDoubleBuffered or (Message.DC <> 0) then
	begin
		if not (csCustomPaint in ControlState) and (ControlCount = 0) then
			inherited
		else
			PaintHandler(Message);
	end
	else
	begin
		DC := BeginPaint(Handle, PS);

		R := ClientRect;
		MemBitmap := CreateCompatibleBitmap(DC, R.Right - R.Left, R.Bottom - R.Top);
		try
			MemDC := CreateCompatibleDC(DC);

			OldBitmap := SelectObject(MemDC, MemBitmap);
			try
				SetWindowOrgEx(MemDC, R.Left, R.Top, nil);
				Perform(WM_ERASEBKGND, MemDC, MemDC);
				Message.DC := MemDC;
//				if FBorderRadius > 0 then //FTransparent then
          ThemeServices.DrawParentBackground(Handle, MemDC, nil, True, R);
				WMPaint(Message);
				Message.DC := 0;
				BitBlt(DC, R.Left, R.Top,
					R.Right - R.Left,
					R.Bottom - R.Top,
					MemDC,
					R.Left, R.Top,
					SRCCOPY);
			finally
				SelectObject(MemDC, OldBitmap);
			end;
		finally
			EndPaint(Handle, PS);
			DeleteDC(MemDC);
			DeleteObject(MemBitmap);
		end;
	end;
end;

{ TGnvProcessItem }

constructor TGnvProcessItem.Create(Collection: TCollection);
begin
  inherited;
  FProcessing := False;
  FProcIndex := -1;
end;

procedure TGnvProcessItem.SetProcessing(const Value: Boolean);
begin
  if FProcessing <> Value then
  begin
    FProcessing := Value;
    if FProcessing then
      (Collection as TGnvProcessItems).FOwner.AddProc(Self)
    else
      (Collection as TGnvProcessItems).FOwner.DeleteProc(Self);
  end;
end;

{ TGnvProcessItems }

constructor TGnvProcessItems.Create(AOwner: TGnvProcessControl);
begin
  inherited Create(TGnvProcessItem);
  FOwner := AOwner;
end;

function TGnvProcessItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TGnvProcessItems.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  if Action = cnDeleting then
    FOwner.DeleteProc(Item as TGnvProcessItem);
end;

{ TGnvProcessControl }

procedure TGnvProcessControl.AddProc(Item: TGnvProcessItem);
begin
  FProcList.Add(Item);
  Item.FProcIndex := -1;
  Item.FStart := GetTime;
  StartTimer;
end;

constructor TGnvProcessControl.Create(AOwner: TComponent);
begin
  inherited;
  FProcDelay := 1000;
  FProcList := TList.Create;
  FProcInterval := 10;
end;

procedure TGnvProcessControl.DeleteProc(Item: TGnvProcessItem);
begin
  Item.FProcIndex := -1;
  Item.FStart := 0;
  FProcList.Remove(Item);
  StopTimer;
  Rebuild;
  SafeRepaint;
end;

destructor TGnvProcessControl.Destroy;
begin
  FProcList.Free;
  inherited;
end;

procedure TGnvProcessControl.StartTimer;
begin
  if FProcList.Count = 1 then
    SetTimer(Handle, 0, 10, nil);
end;

procedure TGnvProcessControl.StopTimer;
begin
  if FProcList.Count = 0 then
    KillTimer(Handle, 0);
end;

procedure TGnvProcessControl.WMTimer(var Message: TWMTimer);
var
  I: Integer;
  Painting: Boolean;
begin
  Painting := False;

  for I := 0 to FProcList.Count - 1 do
    with TGnvProcessItem(FProcList[I]) do
      case FProcIndex of
        -1:
          if MilliSecondsBetween(GetTime, FStart) >= FProcDelay then
          begin
            FStart := GetTime;
            FProcIndex := 0;
            // Rebuild control to fit
            Rebuild;
            Painting := True;
          end;
        else
          if MilliSecondsBetween(GetTime, FStart) >= FProcInterval then
          begin
            Inc(FProcIndex);
            if FProcIndex > FProcImages.Count - 1 then
              FProcIndex := 0;
            FStart := GetTime;
            Painting := True;
          end;
      end;

  if Painting then SafeRepaint;
end;

{ TGnvPanel }

procedure TGnvPanel.AlignControls(AControl: TControl; var Rect: TRect);
begin
	if gdLeft in FHideBorders then Rect.Left := Rect.Left - 1;
	if gdUp in FHideBorders then Rect.Top := Rect.Top - 1;
	if gdRight in FHideBorders then Rect.Right := Rect.Right + 1;
  if gdDown in FHideBorders then Rect.Bottom := Rect.Bottom + 1;
  inherited AlignControls(AControl, Rect);
end;

constructor TGnvPanel.Create(AOwner: TComponent);
begin
  inherited;
  FullRepaint := False;
  FColorRow := 0;
  FColorFlow := False;
  FShowBorder := True;
  // This should be done for appropriate border cuttoff offset
  BorderStyle := bsNone;
  BevelOuter := bvNone;
  BevelInner := bvNone;
end;

procedure TGnvPanel.Paint;
var
  I: Integer;
  R: TRect;
  GP: IGPGraphics;
  BorderPath, HighlightPath: IGPGraphicsPath;
  BorderPen, HighlightPen: IGPPen;
  Brush, HighlightBrush: IGPBrush;
  GPR: TGPRect;
begin
  R := ClientRect;

  if (Win32MajorVersion >= 5) and IsAppThemed then
  begin
    GP := TGPGraphics.Create(Canvas.Handle);

    GPR.Initialize(R);

    if FColorFlow and (FColorRow > -1) then
      Brush := TGPLinearGradientBrush.Create(GPR,
        GnvGPColor(GnvGetColorFlowColor(FColorRow)),
        GnvGPColor(GnvGetColorFlowColor(FColorRow + 1)), LinearGradientModeVertical)
    else
      Brush := TGPSolidBrush.Create(GnvGPColor(Color));

    GP.FillRectangle(Brush, GPR);

    if FShowBorder then
    begin
      BorderPen := TGPPen.Create(GnvGPColor(GnvBorderGetColor));

      BorderPath := TGPGraphicsPath.Create;
      GnvFrameCreateGPPathOld(BorderPath, GPR, 0, 1, FHideBorders, FHideBorders);

      GP.DrawPath(BorderPen, BorderPath);
    end;
  end
  else if FShowBorder then
    GnvDrawClassicPanel(Canvas, R, FHideBorders)
  else
    inherited;

  if ShowCaption and (Caption <> '') then
  begin
    Canvas.Font := Self.Font;
    GnvDrawText(Canvas, ClientRect, Caption, DT_SINGLELINE or DT_VCENTER or DT_CENTER);
  end;
end;

procedure TGnvPanel.SetHideBorders(const Value: TGnvDirections);
begin
	if FHideBorders <> Value then
  begin
    FHideBorders := Value;
    SafeRepaint;
    Realign;
  end;
end;

procedure TGnvPanel.SetProcessing(const Value: Boolean);
begin
  FProcessing := Value;
end;

procedure TGnvPanel.SetShowBorder(const Value: Boolean);
begin
  if FShowBorder <> Value then
  begin
    FShowBorder := Value;
    SafeRepaint;
  end;
end;

procedure TGnvPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if csDesigning in ComponentState then inherited;
  Message.Result := 1;
end;

procedure TGnvPanel.SafeRepaint;
begin
  if Showing then Repaint;
end;

procedure TGnvPanel.SetColorFlow(const Value: Boolean);
begin
  if FColorFlow <> Value then
  begin
    FColorFlow := Value;
    SafeRepaint;
  end;
end;

procedure TGnvPanel.SetColorRow(const Value: Integer);
begin
  if FColorRow <> Value then
  begin
    FColorRow := Value;
    SafeRepaint;
  end;
end;

{ TGnvToolButtonActionLink }

procedure TGnvToolButtonActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TGnvToolButton;
end;

function TGnvToolButtonActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    SameText(FClient.Caption, (Action as TCustomAction).Caption);
end;

function TGnvToolButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    (FClient.Checked = (Action as TCustomAction).Checked);
end;

function TGnvToolButtonActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TGnvToolButtonActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TGnvToolButtonActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TGnvToolButtonActionLink.IsNameLinked: Boolean;
begin
  Result := (Action is TCustomAction) and
    (FClient.Name = (Action as TCustomAction).Name);
end;

function TGnvToolButtonActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

function TGnvToolButtonActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
{$IF DEFINED(CLR)}
    (((not Assigned(FClient.OnClick)) and (not Assigned(Action.OnExecute))) or
     (Assigned(FClient.OnClick) and
      DelegatesEqual(@FClient.OnClick, @Action.OnExecute)));
{$ELSE}
    (@FClient.OnClick = @Action.OnExecute);
{$IFEND}
end;

procedure TGnvToolButtonActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TGnvToolButtonActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Checked := Value;
end;

procedure TGnvToolButtonActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TGnvToolButtonActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TGnvToolButtonActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TGnvToolButtonActionLink.SetName(const Value: string);
begin
  if IsNameLinked then FClient.Name := Value;
end;

procedure TGnvToolButtonActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

procedure TGnvToolButtonActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

{ TGnvToolButton }

procedure TGnvToolButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Caption = '') then
        Self.Caption := Caption;
      if not CheckDefaults or (Self.Checked = False) then
        Self.Checked := Checked;
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.Hint = '') then
        Self.Hint := Hint;
      if Self.Name = '' then
        Self.Name := Name;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

constructor TGnvToolButton.Create(Collection: TCollection);
begin
  inherited;
  FDirection := gdDown;
	FEdit := nil;
  FEnabled := True;
  FFont := TFont.Create;
  FFont.Assign((Collection as TGnvToolButtons).FToolBar.Font);
  FFont.OnChange := FontChanged;
  FGlyph := glNone;
	FGlyphDirection := gdDown;
  FGlyphOrientation := goForward;
  FGroupIndex := 0;
  FHidden := False;
  FHint := '';
  FImageIndex := -1;
	FImages := nil;
	FKind := gtkButton;
  FBorderSticking := [];
  FName := '';
	FParentCursor := True;
  FParentFont := True;
	FParentImages := True;
	FPopupMenu := nil;
  FSelection := gtlIndividual;
	FShowArrow := False;
	FShowBorders := True;
  FShowChecked := True;
	FSize := 175;
	FSizing := gisContentToSize;
	FStyle := gtsImageText;
  FSwitchGroup := -1;
  FTag := 0;
  FVisible := True;
end;

destructor TGnvToolButton.Destroy;
begin
  FFont.Free;
  if Assigned(FActionLink) then
    FActionLink.Free;
  if Assigned(FEdit) then
    FEdit.Free;
  inherited;
end;

procedure TGnvToolButton.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

function TGnvToolButton.Elements: TGnvItemElements;
begin
	Result := [];

	if FKind = gtkSeparator then Exit;

	if (FStyle in [gtsImage, gtsImageText]) and
		((FGlyph <> glNone) or ((GetImages <> nil) and (FImageIndex > -1)) or (FProcIndex > -1)) then
		Include(Result, gieIcon);

	if (FStyle in [gtsText, gtsImageText]) and (FCaption <> '') then
		Include(Result, gieText);

	if FShowArrow then
  	Include(Result, gieButton);
end;

procedure TGnvToolButton.FontChanged(Sender: TObject);
begin
  FParentFont := False;
  if (Collection as TGnvToolButtons).FToolBar.FUpdateCount <= 0 then
  begin
    (Collection as TGnvToolButtons).FToolBar.Rebuild;
    (Collection as TGnvToolButtons).FToolBar.SafeRepaint;
    (Collection as TGnvToolButtons).FToolBar.AdjustSize;
  end;
end;

function TGnvToolButton.CanShowBorders: Boolean;
begin
	Result := (FKind in [gtkButton, gtkSwitch, gtkEdit]) and FShowBorders;
end;

procedure TGnvToolButton.Click;
var
  R: TRect;
  P: TPoint;
begin
  if Assigned(FOnClick) and (Action <> nil) and
    not DelegatesEqual(@FOnClick, @Action.OnExecute) then
    FOnClick(Self)
  else if (ActionLink <> nil) then
    ActionLink.Execute(nil)
  else if Assigned(FOnClick) then
    FOnClick(Self);

  if Assigned(FDropdownMenu) then
  begin
    R := GetToolbar.GetButtonRect(Index);
    case FDropDownMenu.Alignment of
      paLeft:   P := Point(R.Left, R.Bottom);
      paCenter: P := Point((R.Right - R.Left) div 2, R.Bottom);
      paRight:  P := Point(R.Right, R.Bottom);
    end;
    P := GetToolBar.ClientToScreen(P);
    if ToolMenuHook = 0 then
      ToolMenuHook := SetWindowsHookEx(WH_CALLWNDPROC, @ToolMenuGetMsgHook, 0,
        GetCurrentThreadID);
    MenuToolButton := Self;
    SetDown(True);
    FDropdownMenu.Popup(P.X, P.Y);
  end;
end;

procedure TGnvToolButton.AssignTo(Dest: TPersistent);
var
	Button: TGnvToolButton;
begin
	Button := nil;
	if Dest is TGnvToolButton then
		Button := Dest as TGnvToolButton;

	if Assigned(Button) then
	begin
  	Button.SetAction(GetAction);
		Button.FKind					:= FKind;
		Button.FStyle					:= FStyle;
		Button.FEnabled				:= FEnabled;
		Button.FHint					:= FHint;
		Button.FVisible				:= FVisible;
		Button.FCaption				:= FCaption;
		Button.FChecked				:= FChecked;
		Button.FImageIndex		:= FImageIndex;
		Button.FOnClick				:= FOnClick;
		Button.FDropdownMenu	:= FDropdownMenu;
		Button.FTag						:= FTag;
		Button.FGroupIndex		:= FGroupIndex;
		Button.FDirection			:= FDirection;
		Button.FShowArrow			:= FShowArrow;
		Button.FSelection			:= FSelection;
		Button.FName					:= FName;
		Button.FShowChecked		:= FShowChecked;
		Button.FFont.Assign(FFont);
		Button.FParentFont		:= FParentFont;
		Button.FOnChange			:= FOnChange;
		Button.FSizing				:= FSizing;
		Button.FSize 					:= FSize;
		Button.FPopupMenu 		:= FPopupMenu;
		Button.FCursor 				:= FCursor;
		Button.FParentCursor 	:= FParentCursor;
	end
	else
		inherited;
end;

function TGnvToolButton.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action
  else
    Result := nil;
end;

function TGnvToolButton.GetActionLinkClass: TGnvToolButtonActionLinkClass;
begin
  Result := TGnvToolButtonActionLink;
end;

function TGnvToolButton.GetCaption: string;
begin
  if FKind = gtkEdit then
    Result := FEdit.Text
  else
    Result := FCaption
end;

function TGnvToolButton.GetDisplayName: string;
begin
  case FKind of
    gtkButton, gtkSwitch, gtkLabel, gtkLink:
      if FName <> '' then
        Result := FName
      else if FCaption <> '' then
        Result := FCaption
      else
        Result := inherited;
    gtkSeparator: Result := 'Separator';
    gtkEdit:      Result := 'Edit';
  end;
end;

function TGnvToolButton.GetDown: Boolean;
begin
  Result := FChecked and FShowChecked;
  if not Result and Assigned(FDropdownMenu) then
    Result := MenuToolButton = Self;
  if not Result then
    Result := Index = GetToolBar.FDownIndex;
end;

function TGnvToolButton.GetGlyphState: TGnvGlyphState;
var
	Button: TGnvToolButton;
begin
  Result := glsNormal;

  if not FEnabled then
    Result := glsDisabled
  else if GetDown then
    Result := glsPressed
  else if GetSelected then
    Result := glsSelected;
end;

function TGnvToolButton.GetGroupHidden: Boolean;
begin
  Result := (FGroupIndex <> GetToolBar.FGroupIndex) and
    (GetToolBar.FGroupIndex > -1) and (FGroupIndex > -1);
end;

function TGnvToolButton.IsHidden: Boolean;
begin
  Result := FHidden or GetGroupHidden or not FVisible;
end;

function TGnvToolButton.GetImages: TCustomImageList;
begin
	if FParentImages then
		Result := GetToolBar.FImages
	else
		Result := FImages;
end;

function TGnvToolButton.GetIconKind: TGnvIconKind;
begin
  Result := gikNone;
  if FProcIndex > -1 then
  begin
    Result := gikProcessGlyph;

    if Assigned(GetToolBar.FProcImages) then
      Result := gikProcessImage;
  end
  else if (GetImages <> nil) and (FImageIndex > -1) then
    Result := gikImage
  else if FGlyph <> glNone then
    Result := gikGlyph
end;

function TGnvToolButton.GetIconSize: TSize;
begin
	Result := GnvGlyphGetSize(FGlyph, FGlyphDirection, GetToolBar.FTheme, GetToolBar.FScale);

	if (GetImages <> nil) and (FImageIndex > -1) then
	begin
		Result.cx := GetImages.Width;
		Result.cy := GetImages.Height;
	end;
end;

function TGnvToolButton.GetSelected: Boolean;
begin
	Result := Index = GetToolBar.FItemIndex;
end;

function TGnvToolButton.GetToolBar: TGnvToolBar;
begin
  Result := (Collection as TGnvToolButtons).FToolBar;
end;

function TGnvToolButton.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCaptionLinked;
end;

function TGnvToolButton.IsCheckedStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCheckedLinked;
end;

function TGnvToolButton.IsCursorStored: Boolean;
begin
  Result := not FParentCursor;
end;

function TGnvToolButton.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsEnabledLinked;
end;

function TGnvToolButton.IsFontStored: Boolean;
begin
  Result := not FParentFont;
end;

function TGnvToolButton.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHintLinked;
end;

function TGnvToolButton.IsHelpContextStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHelpContextLinked;
end;

function TGnvToolButton.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsImageIndexLinked;
end;

function TGnvToolButton.IsImagesStored: Boolean;
begin
  Result := not FParentImages;
end;

function TGnvToolButton.IsNameStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsNameLinked;
end;

function TGnvToolButton.IsShortCutStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsShortCutLinked;
end;

function TGnvToolButton.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsVisibleLinked;
end;

function TGnvToolButton.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsOnExecuteLinked;
end;

procedure TGnvToolButton.SetAction(Value: TBasicAction);
begin
  if Value = nil then
  begin
    FActionLink.Free;
    FActionLink := nil;
  end
  else
  begin
    GetToolBar.ControlStyle := GetToolBar.ControlStyle + [csActionClient];
    if FActionLink = nil then
      FActionLink := GetActionLinkClass.Create(Self);
    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
    Value.FreeNotification(GetToolBar);
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetCaption(const Value: string);
begin
  if GetCaption <> Value then
	begin
		FCaption := Value;
		if Assigned(FEdit) then
			FEdit.Text := FCaption
		else
		begin
			GetToolBar.Rebuild;
			GetToolBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvToolButton.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetCursor(const Value: TCursor);
begin
  if FCursor <> Value then
  begin
    FCursor := Value;
    FParentCursor := False;
  end;
end;

procedure TGnvToolButton.SetDirection(const Value: TGnvDirection);
begin
  if FDirection <> Value then
  begin
    FDirection := Value;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetDown(const Value: Boolean);
begin
  if not FChecked then
    GetToolBar.SetDownIndex(Index);
end;

procedure TGnvToolButton.SetDropdownMenu(const Value: TPopupMenu);
var
  Rebuild: Boolean;
begin
  if FDropdownMenu <> Value then
  begin
    Rebuild := (FDropdownMenu = nil) or (Value = nil);
    FDropdownMenu := Value;
    if Rebuild then
    begin
      GetToolBar.Rebuild;
      GetToolBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvToolButton.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TGnvToolButton.SetGlyph(const Value: TGnvGlyph);
begin
  if FGlyph <> Value then
  begin
    FGlyph := Value;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetGlyphDirection(const Value: TGnvDirection);
begin
  if FGlyphDirection <> Value then
  begin
    FGlyphDirection := Value;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetGlyphOrientation(const Value: TGnvOrientation);
begin
  if FGlyphOrientation <> Value then
  begin
    FGlyphOrientation := Value;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetImageIndex(const Value: Integer);
var
  Rebuild: Boolean;
begin
  if FImageIndex <> Value then
  begin
    Rebuild := (FImageIndex = -1) or (Value = -1);
    FImageIndex := Value;
    if Rebuild then
      GetToolBar.Rebuild;

    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
		FImages := Value;
		FParentImages := False;
    GetToolBar.Rebuild;
    GetToolBar.AdjustSize;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetKind(const Value: TGnvToolButtonKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
  if Assigned(FEdit) then FEdit.OnChange := FOnChange;
end;

procedure TGnvToolButton.SetParentCursor(const Value: Boolean);
begin
  FParentCursor := Value;
end;

procedure TGnvToolButton.SetParentFont(const Value: Boolean);
begin
  if FParentFont <> Value then
  begin
    FParentFont := Value;
    if (Collection as TGnvToolButtons).FToolBar.FUpdateCount <= 0 then
    begin
      (Collection as TGnvToolButtons).FToolBar.Rebuild;
      (Collection as TGnvToolButtons).FToolBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvToolButton.SetParentImages(const Value: Boolean);
begin
	if FParentImages <> Value then
	begin
    FParentImages := Value;
    if (Collection as TGnvToolButtons).FToolBar.FUpdateCount <= 0 then
    begin
      (Collection as TGnvToolButtons).FToolBar.Rebuild;
      (Collection as TGnvToolButtons).FToolBar.SafeRepaint;
    end;
	end;
end;

procedure TGnvToolButton.SetSelected(const Value: Boolean);
begin
  GetToolBar.SetItemIndex(Index);
end;

procedure TGnvToolButton.SetSelection(const Value: TGnvToolButtonSelection);
begin
  if FSelection <> Value then
  begin
    FSelection := Value;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetShowArrow(const Value: Boolean);
begin
  if FShowArrow <> Value then
  begin
    FShowArrow := Value;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetShowBorders(const Value: Boolean);
begin
	if FShowBorders <> Value then
	begin
		FShowBorders := Value;
		GetToolBar.SafeRepaint;
	end;
end;

procedure TGnvToolButton.SetShowChecked(const Value: Boolean);
begin
	if FShowChecked <> Value then
	begin
		FShowChecked := Value;
		GetToolBar.SafeRepaint;
	end;
end;

procedure TGnvToolButton.SetSize(const Value: Integer);
begin
	if FSize <> Value then
	begin
		FSize := Value;
		GetToolBar.Rebuild;
		GetToolBar.SafeRepaint;
	end;
end;

procedure TGnvToolButton.SetSizing(const Value: TGnvItemSizing);
begin
	if FSizing <> Value then
	begin
		FSizing := Value;
		GetToolBar.Rebuild;
		GetToolBar.SafeRepaint;
	end;
end;

procedure TGnvToolButton.SetStyle(const Value: TGnvToolButtonStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

procedure TGnvToolButton.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    if Assigned(FEdit) then FEdit.Visible := FVisible;
    GetToolBar.Rebuild;
    GetToolBar.SafeRepaint;
  end;
end;

{ TGnvToolButtons }

function TGnvToolButtons.ButtonByCaption(const Caption: string): TGnvToolButton;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if SameText(GetButton(I).Caption, Caption) then
    begin
      Result := GetButton(I);
      Exit;
    end;
end;

function TGnvToolButtons.ButtonByName(const Name: string): TGnvToolButton;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if SameText(GetButton(I).Name, Name) then
    begin
      Result := GetButton(I);
      Exit;
    end;
end;

constructor TGnvToolButtons.Create(ToolBar: TGnvToolBar);
begin
  inherited Create(TGnvToolButton);
  FToolBar := ToolBar;
  FOwner := ToolBar;
end;

function TGnvToolButtons.GetButton(Index: Integer): TGnvToolButton;
begin
  Result := Items[Index] as TGnvToolButton;
end;

function TGnvToolButtons.GetOwner: TPersistent;
begin
  Result := FToolBar;
end;

procedure TGnvToolButtons.Update(Item: TCollectionItem);
begin
  inherited;
  FToolBar.Rebuild;
  FToolbar.SafeRepaint;
end;

{ TGnvToolBar }

procedure TGnvToolBar.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited;
	Rebuild;
  AdjustSize;
	SafeRepaint;
end;

function TGnvToolBar.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  Paddings: TSize;
begin
	Result := True;

	Paddings.cy := GnvSystemScaledSize(Padding.Top, FScale) + GnvSystemScaledSize(Padding.Bottom, FScale);
	Paddings.cx := GnvSystemScaledSize(Padding.Left, FScale) + GnvSystemScaledSize(Padding.Right, FScale);

	// Adding borders to paddings
	if FStyle.GetShowBorders(FTheme) then
	begin
		if gbTop in FBorders then    	Paddings.cy := Paddings.cy + GnvBorderGetSize(FScale);
		if gbBottom in FBorders then 	Paddings.cy := Paddings.cy + GnvBorderGetSize(FScale);
		if gbLeft in FBorders then 		Paddings.cx := Paddings.cx + GnvBorderGetSize(FScale);
		if gbRight in FBorders then 	Paddings.cx := Paddings.cx + GnvBorderGetSize(FScale);
  end;

//  if Assigned(FImages) and (FImages.Height + 10 > FButtonHeight + Paddings.cy) then
//    NewHeight := FImages.Height + 10
//  else
	NewHeight := FContentMinHeight + Paddings.cy;

	NewWidth := FContentMinWidth + Paddings.cx;
end;

procedure TGnvToolBar.CMCursorChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;

  for I := 0 to FButtons.Count - 1 do
    if FButtons[I].FParentCursor then
      FButtons[I].FCursor := Cursor;
end;

procedure TGnvToolBar.CMFontChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  // Update font of all buttons with ParentFont setting
  for I := 0 to FButtons.Count - 1 do
    if FButtons[I].FParentFont then
    begin
      FButtons[I].FFont.Assign(Font);
      FButtons[I].FParentFont := True;
    end;
	Rebuild;
  AdjustSize;
	SafeRepaint;
end;

procedure TGnvToolBar.CMMouseLeave(var Message: TMessage);
begin
  Screen.Cursor := crDefault;
  SetSwitchGroup(-1);
  SetDownIndex(-1);
  SetItemIndex(-1);
end;

constructor TGnvToolBar.Create(AOwner: TComponent);
begin
  inherited;
//	ControlStyle := ControlStyle + [csOpaque];
	Padding.Left := 1;
	Padding.Right := 1;
	Padding.Top := 1;
	Padding.Bottom := 1;
  FAutoHint := False;
//  FButtonPadding := TGnvButtonPadding.Create(nil);
  FButtons := TGnvToolButtons.Create(Self);
  FDownIndex := -1;
  FGroupIndex := -1;
  FItemIndex := -1;
  FSwitchGroup := - 1;
	FUpdateCount := 0;
end;

destructor TGnvToolBar.Destroy;
begin
  FButtons.Free;
//  FButtonPadding.Free;
  inherited;
end;

function TGnvToolBar.ExecuteAction(Action: TBasicAction): Boolean;
begin
  if AutoHint and not (csDesigning in ComponentState) and
     (Action is THintAction) then//and not DoHint then
  begin
    SetHint(THintAction(Action).Hint);
    Result := True;
  end
  else Result := inherited ExecuteAction(Action);
end;

function TGnvToolBar.GetButtonContentRect(const Index: Integer): TRect;
var
	Button: TGnvToolButton;
begin
	Result := GetButtonRect(Index);
	Button := FButtons[Index];

	if not Button.IsHidden then
	begin
		Result.Top := Result.Top + GnvSystemScaledSize(GNV_ITEM_PADDING, FScale) + GnvBorderGetSize(FScale, Button.CanShowBorders);
		Result.Left := Result.Left + GnvSystemScaledSize(GNV_ITEM_ELEMENT_GUTTER, FScale) + GnvBorderGetSize(FScale, Button.CanShowBorders);
		Result.Bottom := Result.Bottom - GnvSystemScaledSize(GNV_ITEM_PADDING, FScale) - GnvBorderGetSize(FScale, Button.CanShowBorders);
		Result.Right := Result.Right - GnvSystemScaledSize(GNV_ITEM_ELEMENT_GUTTER, FScale) - GnvBorderGetSize(FScale, Button.CanShowBorders);
	end;
{
	if not Button.IsHidden then
	begin
		Result.Top := Result.Top + GnvSystemScaledSize(FButtonPadding.Top, FScale) + GnvBorderGetSize(FScale, Button.CanShowBorders);
		Result.Left := Result.Left + GnvSystemScaledSize(FButtonPadding.Left, FScale) + GnvBorderGetSize(FScale, Button.CanShowBorders);
		Result.Bottom := Result.Bottom - GnvSystemScaledSize(FButtonPadding.Bottom, FScale) - GnvBorderGetSize(FScale, Button.CanShowBorders);
		Result.Right := Result.Right - GnvSystemScaledSize(FButtonPadding.Right, FScale) - GnvBorderGetSize(FScale, Button.CanShowBorders);
	end;
}
end;

function TGnvToolBar.GetButtonRect(const Index: Integer): TRect;
begin
  Result := Rect(0, 0, 0, 0);
	if not FButtons[Index].IsHidden then
  begin
		Result.Left := FButtons[Index].FLeft;
		Result.Right := FButtons[Index].FLeft + FButtons[Index].FWidth;
		Result.Top := GnvSystemScaledSize(Padding.Top, FScale) + GnvBorderGetSize(FScale, FStyle.GetShowBorders(FTheme));
		Result.Bottom := Result.Top + FContentMinHeight;
  end;
end;

function TGnvToolBar.GetSwitchGroup: Integer;
begin
  if Assigned(MenuToolButton) then
    Result := MenuToolButton.FSwitchGroup
  else
    Result := FSwitchGroup;
end;

function TGnvToolBar.IndexOfAction(Action: TBasicAction): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FButtons.Count - 1 do
    if FButtons[I].Action = Action then
    begin
      Result := I;
      Exit;
    end;
end;

function TGnvToolBar.IndexOfButtonAt(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FButtons.Count - 1 do
    if PtInRect(GetButtonRect(I), Point(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
end;

procedure TGnvToolBar.InitiateAction;
begin
  inherited;
  UpdateActions;
end;

procedure TGnvToolBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if (Button = mbLeft) then
    SetDownIndex(IndexOfButtonAt(X, Y));
end;

procedure TGnvToolBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
begin
  Index := IndexOfButtonAt(X, Y);

  if Index > -1 then
  begin
    SetSwitchGroup(FButtons[Index].FSwitchGroup);
    Hint := FButtons[Index].Hint;
    if Assigned(FButtons[Index].Action) and (FButtons[Index].Action is TCustomAction) and
      (TCustomAction(FButtons[Index].Action).ShortCut <> 0) then
			Hint := Hint + ' (' + ShortCutToText(TCustomAction(FButtons[Index].Action).ShortCut) + ')';

		if FButtons[Index].FKind = gtkLink then
			Screen.Cursor := crHandPoint
		else
			Screen.Cursor := FButtons[Index].FCursor;
	end
	else
	begin
   	Screen.Cursor := Cursor;
    SetSwitchGroup(-1);
    Hint := '';
  end;

  // Change the display status of toolbar tooltip if active button changes
  // When hovering next button, tooltip will appear again with corresponding delay
  if FItemIndex <> Index then
    Application.CancelHint;

  SetItemIndex(Index);

  inherited;
end;

procedure TGnvToolBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
	Y: Integer);
begin
	inherited;

	if (Button = mbLeft) and (FDownIndex > -1) and (FDownIndex = IndexOfButtonAt(X, Y)) then
		FButtons[FDownIndex].Click;
	SetDownIndex(-1);
end;

procedure TGnvToolBar.Paint;
var
	Theme: TGnvSystemTheme;
	I: Integer;
	R: TRect;
	GP: IGPGraphics;
	Path: IGPGraphicsPath;
	Pen: IGPPen;
	Brush: IGPBrush;
	GPR: TGPRect;
  BorderSize: LongWord;
begin
 	inherited;

	if (Width <= 0) or (Height <= 0) then Exit;

  // Drawing toolbuttons
  for I := 0 to FButtons.Count - 1 do
		PaintButton(I);
end;

procedure TGnvToolBar.PaintButton(const Index: Integer);
//const
//  BorderRadius = 3;
var
  Direction: TGnvDirection;
	Button: TGnvToolButton;
	Elements: TGnvItemElements;
  R, ButtonRect: TRect;
  IsImageLast: Boolean;
  BorderSticking: TGnvDirections;
  BorderSize: Cardinal;
  BorderRadius: Integer;
  GP: IGPGraphics;
  GPPath, GPPath2, HighlightPath: IGPGraphicsPath;
  GPPen, HighlightPen: IGPPen;
  GPBrush: IGPBrush;
	GPR: TGPRect;
	OldFont: TFont;
begin
	Button := FButtons[Index];
	Elements := Button.Elements;

	if Button.IsHidden or (Elements = []) then Exit;

	ButtonRect := GetButtonRect(Index);
	R := ButtonRect;
	// This should be done for any drawn button before GdiPlus procedures
	// to avoid font from one button to expand to other buttons
	Canvas.Font := Button.FFont;

  BorderSize := GnvBorderGetSize(FScale);
  BorderRadius := GnvSystemScaledSize(FStyle.GetRadius(Theme), FScale);

	{ Button background }

	if not (Button.FKind in [gtkSeparator, gtkLabel, gtkLink]) and
		((((Button.FSelection = gtlIndividual) and Button.GetSelected) or Button.GetDown) and Button.FEnabled) or
		((Button.FSelection = gtlSwitchGroup) and (Button.FSwitchGroup > -1) and
		(GetSwitchGroup = FSwitchGroup)) or (Button.FKind = gtkEdit) then
	begin
		if (Win32MajorVersion >= 5) and IsAppThemed then
		begin
			GP := TGPGraphics.Create(Canvas.Handle);
			GP.SmoothingMode := SmoothingModeAntiAlias;

			GPR.InitializeFromLTRB(R.Left, R.Top + BorderSize, R.Right,
				R.Bottom + BorderSize);

			GPPath := TGPGraphicsPath.Create;
			GPPath2 := TGPGraphicsPath.Create;

			BorderSticking := FBorderSticking;
			if not Button.GetDown then
			begin
				GnvFrameCreateGPPathOld(GPPath, GPR, BorderRadius, 1, [], []);
				GPPen := TGPPen.Create(GnvGPColor(clBtnHighLight, 159));
				GP.DrawPath(GPPen, GPPath);
				GPPath.Reset;
			end
			else if Assigned(Button.FDropdownMenu) then
				BorderSticking := BorderSticking + [gdDown];

			if (Win32MajorVersion >= 6) and (Win32MinorVersion >= 2) then
			begin
				GnvFrameCreateGPPathOld(GPPath, TGPRect.Create(R), 0, 1, Button.FBorderSticking, []);
				GnvFrameCreateGPPathOld(GPPath2, TGPRect.Create(R), 0, 1, Button.FBorderSticking, [], True);

				if Button.FKind = gtkEdit then
				begin
					GPPen := TGPPen.Create(GnvGPColor(clBtnShadow, 159));
					GPBrush := TGPSolidBrush.Create(GnvGPColor(Button.FEdit.Color));
					GP.FillPath(GPBrush, GPPath2);
				end
				else if Button.GetDown then
				begin
					GPPen := TGPPen.Create(GnvGPColor(clHighlight));
					GPBrush := TGPSolidBrush.Create(GnvGPColor(clHighlight, 93));
					GP.FillPath(GPBrush, GPPath2);
				end
				else
				begin
					GPPen := TGPPen.Create(GnvGPColor(clHighlight, 159));
					GPBrush := TGPSolidBrush.Create(GnvGPColor(clHighlight, 31));
					GP.FillPath(GPBrush, GPPath2);
				end;
			end
			else
			begin
				// Get larger radius to avoid line collisions
				GnvFrameAddGPPath(GPPath, TGPRect.Create(R), BorderRadius, 1, GNV_BORDERS_LRTB, Button.FBorderSticking);
				GnvFrameAddGPPath(GPPath2, TGPRect.Create(R), BorderRadius, 1, GNV_BORDERS_LRTB, Button.FBorderSticking, True);
//				GnvFrameCreateGPPathOld(GPPath, TGPRect.Create(R), BorderRadius + 1, 1, BorderSticking, []);
//				GnvFrameCreateGPPathOld(GPPath2, TGPRect.Create(R), BorderRadius + 1, 1, BorderSticking, [], True);

				GPPen := TGPPen.Create(GnvGPColor(clBtnShadow, 159));

				if Button.FKind = gtkEdit then
				begin
					GPBrush := TGPSolidBrush.Create(GnvGPColor(Button.FEdit.Color));
					GP.FillPath(GPBrush, GPPath2);
				end
				else if Button.GetDown then
				begin
					GPBrush := TGPPathGradientBrush.Create(GPPath);
					(GPBrush as IGPPathGradientBrush).CenterColor := GnvGPColor(clBtnFace, 79);
					(GPBrush as IGPPathGradientBrush).SetSurroundColors([GnvGPColor(clBtnShadow, 79)]);
						GP.FillPath(GPBrush, GPPath2);
				end;
			end;

			GP.DrawPath(GPPen, GPPath);
		end
		else if Button.FKind = gtkEdit then
			GnvFrameDrawClassic(Canvas, R, [], True, Button.FEdit.Color, FScale)
		else
			GnvFrameDrawClassic(Canvas, R, GNV_BORDERS_LRTB, Button.GetDown, Color, FScale);
	end;


	ButtonRect := GetButtonContentRect(Index);
//	Canvas.Brush.Color := clYellow;
//	Canvas.FillRect(ButtonRect);

  if gieIcon in Elements then
  begin
    R := ButtonRect;
    R.Right := R.Left + Button.GetIconSize.cx;

    case Button.GetIconKind of
      gikGlyph:
        GnvGlyphDraw(Canvas, R, Button.FGlyph, Button.FGlyphDirection, Button.FGlyphOrientation, Button.GetGlyphState, Theme, FScale);
      gikImage:
      begin
        if Button.FEnabled then
          GnvDrawImage(Canvas, R, Button.GetImages, Button.FImageIndex)
//        else if Assigned(FDisabledImages) then
//          GnvDrawImage(Canvas, R, FDisabledImages, Button.FImageIndex);
      end;
      gikProcessGlyph:
        GnvProcessGlyphDraw(Canvas, R, 1, Theme, FScale);
      gikProcessImage:
        GnvDrawImage(Canvas, R, FProcImages, Button.FProcIndex)
    end;
  end;
{
  if (Button.FStyle in [gtsText, gtsImageText]) and (Button.FCaption <> '') and
    (Button.FKind <> gtkEdit) then
}
  if gieText in Elements then
  begin
    R := ButtonRect;
    R.Left := R.Left + Button.GetIconSize.cx;
    if gieIcon in Elements then R.Left := R.Left + GnvSystemScaledSize(GNV_ITEM_ELEMENT_GUTTER, FScale);
    R.Right := R.Left + Button.FTextWidth;

    if Button.FKind = gtkLink then
    begin
      Canvas.Font.Color := clHotLight;
      if Button.GetSelected then
        Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
    end;

    GnvTextDraw(Canvas, R, Button.FCaption, nil, Button.FEnabled);
  end;

  if gieButton in Elements then
  begin
    Direction := Button.FDirection;
    if Button.GetDown and Assigned(Button.FDropdownMenu) then
      Direction := gdDown;

    R := ButtonRect;
    R.Left := R.Right - GnvGlyphGetSize(glCaret, Direction, Theme, FScale).cx;

    GnvGlyphDraw(Canvas, R, glCaret, Direction, Button.FGlyphOrientation, Button.GetGlyphState, Theme, FScale);
  end;
end;

procedure TGnvToolBar.Rebuild;
const
  SeparatorWidth = 6;
var
	I, StartLeft, SpringCount, FirstSpringIndex, Gutter,
		SwitchGroup, Offset, ElementCount, MinHeight: Integer;
  Size, TextExtent: TSize;
  LastKind: TGnvToolButtonKind;
	Button, LastButton: TGnvToolButton;
	Elements: TGnvItemElements;
	R: TRect;

begin
	inherited;

  // Hiding one of neighboring separators
  LastKind := gtkSeparator;
  for I := 0 to FButtons.Count - 1 do
    with FButtons[I] do if FVisible and not GetGroupHidden then
    begin
      FHidden := (FKind = gtkSeparator) and (FKind = LastKind) and (FSizing <> gisSpring);
      LastKind := FButtons[I].Kind;
    end;

	{ Calculating minimal size for all buttons }

	FContentMinHeight := 0;
	LastButton := nil;
	FContentMinWidth := 0;
	SpringCount := 0;
	FirstSpringIndex := -1;
	SwitchGroup := 0;

	StartLeft := GnvSystemScaledSize(Padding.Left, FScale);
	if gbLeft in FBorders then
		StartLeft := StartLeft + GnvBorderGetSize(FScale);

	for I := 0 to FButtons.Count - 1 do
		if not FButtons[I].IsHidden then
		begin
			Button := FButtons[I];
			Elements := Button.Elements;
			ElementCount := 0;
			MinHeight := 0;
      Gutter := 0;

			// Destroying edit controls for buttons that are no longer gtkEdit
			if Assigned(Button.FEdit) and (Button.FKind <> gtkEdit) then
				FreeAndNil(Button.FEdit);

			// Calculating current button switch group
			if Button.FKind = gtkSwitch then
				Button.FSwitchGroup := SwitchGroup
			else
				Inc(SwitchGroup);

			// Removing button gutter and adjusting leaning for neighbor switch buttons
			if (Button.FKind = gtkSwitch) and (LastKind = gtkSwitch) then
			begin
				Gutter := - GnvBorderGetSize(FScale);
				if Assigned(LastButton) then
					LastButton.FBorderSticking := LastButton.FBorderSticking + [gdRight];
				Button.FBorderSticking := [gdLeft];
			end
			else
			begin
				Gutter := GnvBorderGetSize(FScale);
				Button.FBorderSticking := [];
			end;

			Button.FLeft := StartLeft + Gutter;

			case Button.FKind of
				gtkButton, gtkSwitch, gtkLabel, gtkEdit, gtkLink:
				begin
					Button.FWidth := 0;

					// Adding image size to minimal button size
					if gieIcon in Elements then
					begin
						Size := Button.GetIconSize;
						Button.FWidth := Button.FWidth + Size.cx;
						if MinHeight < Size.cy then MinHeight := Size.cy;
						Inc(ElementCount);
          end;

          if Button.FKind = gtkEdit then
					begin
						// Creating edit control for gtkEdit buttons
						if not Assigned(Button.FEdit) then
            begin
							Button.FEdit := TEdit.Create(Self);
							Button.FEdit.AutoSize := True;
							Button.FEdit.Text := Button.FCaption;
							Button.FEdit.BorderStyle := bsNone;
							Button.FEdit.OnChange := Button.FOnChange;
							Button.FEdit.Top := Padding.Top;
							Button.FEdit.Parent := Self;
						end;
						Button.FEdit.Width := 150;
						// Adding edit size to minimal button size
						Button.FEdit.Left := Button.FLeft + Button.FWidth;
						Button.FEdit.Tag := Button.FWidth;
						Button.FWidth := Button.FWidth + Button.FEdit.Width + 3;
						if MinHeight < Button.FEdit.Height - 2 then
							MinHeight := Button.FEdit.Height - 2;
//						Button.FEdit.Height := FButtonHeight - 3;
						// Fix vertical padding oversize
            MinHeight := MinHeight - 6;
          end
          else if gieText in Elements then
					begin
            // Adding text width to minimal button size
						Size := GnvTextGetSize(Canvas, Button.FCaption, Button.FFont);
            //SafeTextExtent(StringReplace(Button.FCaption,
//              '&', '', [rfReplaceAll]), Button.FFont);
						Button.FTextWidth := Size.cx;
						Button.FWidth := Button.FWidth + Button.FTextWidth;
						if MinHeight < Size.cy then MinHeight := Size.cy;
						Inc(ElementCount);
					end;

					// Displaying button arrow
					if gieButton in Elements then
					begin
						Size := GnvGlyphGetSize(glCaret, Button.FDirection, FTheme, FScale);
						Button.FWidth := Button.FWidth + Size.cx;
						if MinHeight < Size.cy then MinHeight := Size.cy;
						Inc(ElementCount);
					end;

					// Adding padding, borders and element gutters to button size
					Button.FWidth := Button.FWidth +
//						GnvSystemScaledSize(FButtonPadding.Left, FScale) +
//						GnvSystemScaledSize(FButtonPadding.Right, FScale) +
						GnvSystemScaledSize(GNV_ITEM_ELEMENT_GUTTER, FScale) +
						GnvSystemScaledSize(GNV_ITEM_ELEMENT_GUTTER, FScale) +
            GnvBorderGetSize(FScale, Button.CanShowBorders) +
            GnvBorderGetSize(FScale, Button.CanShowBorders);
					if ElementCount > 1 then
						Button.FWidth := Button.FWidth + (ElementCount - 1)*GnvSystemScaledSize(GNV_ITEM_ELEMENT_GUTTER, FScale);
        end;
				gtkSeparator: Button.FWidth := GnvSystemScaledSize(SeparatorWidth, FScale);
			end;

			case Button.FSizing of
				// Defining first spring button and spring button count
				gisSpring:
				begin
					if FirstSpringIndex = -1 then
						FirstSpringIndex := I;
					Inc(SpringCount);
					Button.FWidth := 0;
				end;
				gisValue:
				begin
          Button.FTextWidth := Button.FTextWidth - Button.FWidth + Button.FSize;
					Button.FWidth := Button.FSize;
				end;
			end;

			if Button.FTextWidth > Button.FWidth then Button.FTextWidth := Button.FWidth - 2;

			StartLeft := Button.FLeft + Button.FWidth;
			LastKind := Button.FKind;
			LastButton := Button;

			// Adding button borders to minimal size
			MinHeight := MinHeight + GnvBorderGetSize(FScale, Button.CanShowBorders)*2;

			FContentMinWidth := FContentMinWidth + Button.FWidth;
			if FContentMinHeight < MinHeight then FContentMinHeight := MinHeight;
		end
		else
			case Button.FKind of
				gtkEdit:  if Assigned(Button.FEdit) then Button.FEdit.Visible := False;
			end;

	// Adding vertical button padding
	FContentMinHeight := FContentMinHeight +
//		GnvSystemScaledSize(FButtonPadding.Top, FScale) +
//		GnvSystemScaledSize(FButtonPadding.Bottom, FScale);
		GnvSystemScaledSize(GNV_ITEM_PADDING, FScale) +
		GnvSystemScaledSize(GNV_ITEM_PADDING, FScale);
{
  Offset := 0;
  if SpringCount > 0 then
    for I := FirstSpringIndex to FButtons.Count - 1 do
      with FButtons[I] do if not IsHidden then
      begin
				FLeft := FLeft + Offset;
				if Assigned(FEdit) then FEdit.Left := FEdit.Left + Offset;

				if FSizing = gisSpring then
				begin
					Offset := Offset - FWidth;
					FWidth := (Self.ClientWidth - 2 - ContentWidth) div SpringCount;
					// Resizing edit to fit new button width
					if Assigned(FEdit) then
						FEdit.Width := FLeft + FWidth - FEdit.Left - 3;
					// Setting smallest spring button width
					if FWidth < 6 then FWidth := 6;

					ContentWidth := ContentWidth + FWidth;
					Offset := Offset + FWidth;
					Dec(SpringCount);
				end;
			end;
}
end;
{
procedure TGnvToolBar.SetButtonPadding(const Value: TGnvButtonPadding);
begin
  FButtonPadding.Assign(Value);
end;
}
procedure TGnvToolBar.SetButtons(const Value: TGnvToolButtons);
begin
  FButtons.Assign(Value);
end;

procedure TGnvToolBar.SetDisabledImages(const Value: TImageList);
begin
  if FDisabledImages <> Value then
  begin
    FDisabledImages := Value;
    Rebuild;
    AdjustSize;
    SafeRepaint;
  end;
end;

procedure TGnvToolBar.SetDownIndex(const Value: Integer);
begin
  // Cannot press disabled button
  if (Value > -1) and not FButtons[Value].FEnabled then Exit;

  if FDownIndex <> Value then
  begin
    FDownIndex := Value;
    SafeRepaint;
  end;
end;

procedure TGnvToolBar.SetGroupIndex(const Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvToolBar.SetHint(const Value: string);
var
  I: Integer;
begin
{
	for I := 0 to FButtons.Count - 1 do
		if FButtons[I].FKind = gtkSpacer then
		begin
			FButtons[I].Caption := Value;
			Exit;
		end;
}
end;

procedure TGnvToolBar.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    Rebuild;
    AdjustSize;
    SafeRepaint;
  end;
end;

procedure TGnvToolBar.SetItemIndex(const Value: Integer);
begin
  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    SafeRepaint;
  end;
end;

procedure TGnvToolBar.SetSwitchGroup(const Value: Integer);
begin
  if FSwitchGroup <> Value then
  begin
    FSwitchGroup := Value;
    SafeRepaint;
  end;
end;

procedure TGnvToolBar.UpdateActions;
var
  I: Integer;
begin
  for I := 0 to FButtons.Count - 1 do
    if Assigned(FButtons[I].ActionLink) then
      FButtons[I].ActionLink.Update;
end;

procedure TGnvToolBar.WMRButtonUp(var Message: TWMRButtonUp);
var
	Index: Integer;
	P: TPoint;
begin
	Index := IndexOfButtonAt(Message.XPos, Message.YPos);

	if (Index > -1) and Assigned(FButtons[Index].FPopupMenu) then
	begin
		P := Point(Message.XPos, Message.YPos);
		P := ClientToScreen(P);
		FButtons[Index].FPopupMenu.PopupComponent := Self;
		FButtons[Index].FPopupMenu.Popup(P.X, P.Y);
	end
	else
		inherited;
end;

procedure TGnvToolBar.WMSize(var Message: TWMSize);
begin
  Rebuild;
  inherited;
end;

{ TGnvTab }

procedure TGnvTab.Assign(Source: TPersistent);
var
  Tab: TGnvTab;
begin
  Tab := nil;
  if Source is TGnvTab then
    Tab := Source as TGnvTab;

  if Assigned(Tab) then
  begin
    FLeft := Tab.FLeft;
    FWidth := Tab.FWidth;
    FCaption := Tab.FCaption;
    FImageIndex := Tab.FImageIndex;
    FProcessing := Tab.FProcessing;
    FTag := Tab.FTag;
    FProcIndex := Tab.FProcIndex;
    FStart := Tab.FStart;
  end
  else
    inherited;
end;

constructor TGnvTab.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FFont.Assign((Collection as TGnvTabs).GetTabBar.Font);
  FParentFont := True;
  FProcessing := False;
  FTag := 0;
  FProcIndex := -1;
  FStart := 0;
  FVisible := True;
  FCategoryIndex := -1;
  FGhosted := False;
end;

destructor TGnvTab.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TGnvTab.FontChanged(Sender: TObject);
begin
  FParentFont := False;
  if (Collection as TGnvTabs).GetTabBar.FUpdateCount <= 0 then
  begin
    (Collection as TGnvTabs).GetTabBar.Rebuild;
    (Collection as TGnvTabs).GetTabBar.SafeRepaint;
  end;
end;

function TGnvTab.GetDisplayName: string;
begin
  if FCaption <> '' then
    Result := FCaption
  else
    Result := inherited;
end;

function TGnvTab.GetSelected: Boolean;
begin
  Result := (Collection as TGnvTabs).GetTabBar.FTabIndex = Index;
end;

procedure TGnvTab.HideControl;
begin
//  if Assigned(FControl) then
//    FControl.Hide;
end;

function TGnvTab.IsFontStored: Boolean;
begin
  Result := not ParentFont;
end;

procedure TGnvTab.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    if (Collection as TGnvTabs).GetTabBar.FUpdateCount <= 0 then
    begin
      (Collection as TGnvTabs).GetTabBar.Rebuild;
      (Collection as TGnvTabs).GetTabBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvTab.SetCategory(const Value: string);
begin
  if FCategory <> Value then
  begin
    FCategory := Value;
    if (Collection as TGnvTabs).GetTabBar.FUpdateCount <= 0 then
    begin
      (Collection as TGnvTabs).GetTabBar.Rebuild;
      (Collection as TGnvTabs).GetTabBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvTab.SetCategoryIndex(const Value: Integer);
begin
  if FCategoryIndex <> Value then
  begin
    FCategoryIndex := Value;
    if (Collection as TGnvTabs).GetTabBar.FUpdateCount <= 0then
    begin
      (Collection as TGnvTabs).GetTabBar.Rebuild;
      (Collection as TGnvTabs).GetTabBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvTab.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if (Collection as TGnvTabs).GetTabBar.FUpdateCount <= 0then
    begin
      (Collection as TGnvTabs).GetTabBar.Rebuild;
      (Collection as TGnvTabs).GetTabBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvTab.SetIndex(Value: Integer);
begin
  inherited;
//  if Index = Value then
//    (Collection as TGnvTabs).MoveGroup(FGroupIndex, Value);
end;

procedure TGnvTab.SetParentFont(const Value: Boolean);
begin
  if FParentFont <> Value then
  begin
    FParentFont := Value;
    if (Collection as TGnvTabs).GetTabBar.FUpdateCount <= 0 then
    begin
      (Collection as TGnvTabs).GetTabBar.Rebuild;
      (Collection as TGnvTabs).GetTabBar.SafeRepaint;
    end;
  end;
end;

procedure TGnvTab.SetPopupMenu(const Value: TPopupMenu);
begin
  FPopupMenu := Value;
end;

procedure TGnvTab.SetSelected(const Value: Boolean);
begin
  if not GetSelected and Value then
    (Collection as TGnvTabs).GetTabBar.SetTabIndex(Index);
end;

procedure TGnvTab.SetControl(const Value: TControl);
begin
  if FControl <> Value then
  begin
    FControl := Value;
    (Collection as TGnvTabs).GetTabBar.UpdateControls;
  end;
end;

procedure TGnvTab.SetFlickering(const Value: Boolean);
begin
  if FFlickering <> Value then
  begin
    FFlickering := Value and not GetSelected;
    if FFlickering then
      (Collection as TGnvTabs).GetTabBar.AddFlick(Self)
    else
      (Collection as TGnvTabs).GetTabBar.DeleteFlick(Self);
  end;
end;

procedure TGnvTab.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TGnvTab.SetGhosted(const Value: Boolean);
begin
  if FGhosted <> Value then
  begin
    FGhosted := Value;
    (Collection as TGnvTabs).GetTabBar.Rebuild;
    (Collection as TGnvTabs).GetTabBar.SafeRepaint;
  end;
end;

procedure TGnvTab.SetGroupIndex(const Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
//    Index := (Collection as TGnvTabs).GetTabBar.GetGroupLast(Value) + 1;
  end;
end;

procedure TGnvTab.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    (Collection as TGnvTabs).GetTabBar.Rebuild;
    (Collection as TGnvTabs).GetTabBar.SafeRepaint;
  end;
end;

procedure TGnvTab.ShowControl;
begin
  if Assigned(FControl) then
  begin
//    FControl.Show;
    FControl.BringToFront;
  end;
end;

{ TGnvTabs }

function TGnvTabs.Add: TGnvTab;
begin
  Result := inherited Add as TGnvTab;
end;

constructor TGnvTabs.Create(TabBar: TGnvTabBar);
begin
  inherited Create(TGnvTab);
  FOwner := TabBar;
end;

function TGnvTabs.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TGnvTabs.GetTab(Index: Integer): TGnvTab;
begin
  Result := GetItem(Index) as TGnvTab;
end;

function TGnvTabs.GetTabBar: TGnvTabBar;
begin
  Result := FOwner as TGnvTabBar;
end;
{
procedure TGnvTabs.MoveGroup(GroupIndex: Integer; Tab: TGnvTab);
var
  I: Integer;
  FItems: TList;
begin
  BeginUpdate;

  FItems := TList.Create;

  for I := 0 to Count - 1 do
    if GetTab(I).FGroupIndex = GroupIndex then
      FItems.Add(GetTab(I));

  for I := 0 to FItems.Count - 1 do
    GetTabBar.MoveTab(TGnvTab(FItems[I]).Index, Tab.Index + I);

  FItems.Free;

  EndUpdate;
end;
}
procedure TGnvTabs.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;

  case Action of
    cnDeleting, cnExtracting:
    begin
      if GetTabBar.FTabIndex >= Item.Index then
				GetTabBar.FTabIndex := GetTabBar.FTabIndex - 1;

      if (GetTabBar.FTabIndex < 0) and (Count > 1) then
        GetTabBar.FTabIndex := 0;
    end;
	end;

	GetTabBar.UpdateControls;

  if Assigned(GetTabBar.FOnTabAction) then
    GetTabBar.FOnTabAction(GetTabBar, Item.Index, Action);
end;

procedure TGnvTabs.ShowGroupItem(GroupIndex: Integer; Item: TGnvTab);
var
  I, NewIndex: Integer;
begin
  GetTabBar.BeginUpdate;
  NewIndex := -1;
//  if (GetTabBar.FTabIndex > -1) and (GetTab(GetTabBar.FTabIndex).GroupIndex = GroupIndex) then
//    NewIndex := GetTab(GetTabBar.FTabIndex).Index + 1;
  for I := 0 to Count - 1 do
    if GetTab(I).FGroupIndex = GroupIndex then
    begin
      GetTab(I).FVisible := GetItem(I) = Item;
//      if (NewIndex > -1) and (Item.Index > -1) then
//        GetTabBar.MoveTab(Item.Index, NewIndex);
    end;
  GetTabBar.TabIndex := Item.Index;
  GetTabBar.EndUpdate;
end;

procedure TGnvTabs.Update(Item: TCollectionItem);
begin
  inherited;
  GetTabBar.Rebuild;
  GetTabBar.SafeRepaint;
end;

{ TGnvTabBar }

procedure TGnvTabBar.AddFlick(Item: TGnvTab);
begin
  FFlickList.Add(Item);
  if FFlickList.Count = 1 then
  begin
    FFlickShift := 0;
    FFlickDirection := 1;
    FFlickCount := -1;
    FFlickStart := GetTime;
    FFlickTab := Item;
  end;
  StartTimer;
end;

procedure TGnvTabBar.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TGnvTabBar.CMFontChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  // Update font of all tabs with ParentFont setting
  for I := 0 to FTabs.Count - 1 do
    if FTabs[I].FParentFont then
    begin
      FTabs[I].FFont.Assign(Font);
      FTabs[I].FParentFont := True;
    end;
  Rebuild;
  SafeRepaint;
  AdjustSize;
end;

procedure TGnvTabBar.CMMouseLeave(var Message: TMessage);
var
  OldKind: TGnvTabBarButtonKind;
  OldIndex: Integer;
begin
  inherited;
  OldIndex := FOverIndex;
  OldKind := FOverKind;
  FOverKind := gtkNone;
  FOverIndex := -2;
  Cursor := crDefault;
  if (OldIndex <> FOverIndex) or (OldKind <> FOverKind) then
    SafeRepaint;
end;

constructor TGnvTabBar.Create(AOwner: TComponent);
begin
  inherited;
  FTabs := TGnvTabs.Create(Self);
  FTabActiveColors := TGnvControlColors.Create(Self);
  FTabInactiveColors := TGnvControlColors.Create(Self);
  Style.ClassicShowBorders := False;
  Style.FlatColor := gscCtrl;
  Style.FlatShowBorders := False;
  Style.PlasticColor1 := gscCtrl;
  Style.PlasticColor2 := gscCtrlShade0125;
  Style.PlasticShowBorders := False;

  // Set TabBar default properties
  AutoSize := False;
  Height := 21;
  FFlickList := TList.Create;
  FFlickShift := 0;
  FDirection := gdDown;
  FButtonWidth := 18;
  FTabIndent := -1;
  FTabIndex := -1;
  FTabMinSize := 0;
  FTabSize := 150;
  FOverIndex := -2;
  FShift := 0;
  FButtons := [gtbShift, gtbPrevious, gtbNext];
  FNoneTab := False;
  FStripSize := 2;
  FDownIndex := -1;
  FDropIndex := -2;
  FMoveTabs := False;
  FTabStyle := gtsImageText;
  FAlignment := taLeftJustify;
  FDropAlignment := taLeftJustify;
  FTabAlignment := taLeftJustify;
  FAlignLeft := 0;
  FTabRadius := 4;
  FSizing := gisContent;
  FMinSizing := gtmValue;
  FOverflow := gtoClip;
  FTitleMode := False;
  FUpdateCount := 0;
  Kind := gtsTabs;
end;

procedure TGnvTabBar.DeleteFlick(Item: TGnvTab);
begin
  FFlickList.Remove(Item);
  if FFlickList.Count = 0 then
  begin
    FFlickShift := 0;
    FFlickTab := nil;
  end;
  StopTimer;
  SafeRepaint;
end;

destructor TGnvTabBar.Destroy;
begin
  FTabActiveColors.Free;
  FTabInactiveColors.Free;
  FTabs.Free;
  FFlickList.Free;
  inherited;
end;

procedure TGnvTabBar.DropdownControlWndProc(var Message: TMessage);
begin
  if (Message.Msg = CM_VISIBLECHANGED) then
  begin
    if Assigned(FDropdownControl) and FDropdownControl.Visible then
      FDropIndex := FOverIndex
    else
      FDropIndex := -2;
    SafeRepaint;
  end;
  if Assigned(FOldWndProc) then
    FOldWndProc(Message);
end;

procedure TGnvTabBar.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then
  begin
    Rebuild;
    SafeRepaint;
  end;
end;

function TGnvTabBar.GetButtonEnabled(Kind: TGnvTabBarButtonKind): Boolean;
begin
  Result := True;
  case Kind of
    gtkShift1:    Result := FShift < 0;
    gtkShift2:    Result := FShift > FClipWidth - FWantWidth;
    gtkClose:
      if (gtkClose in FButtonKinds) and (FCloseKind = gckCommon) then
        Result := FTabIndex > -1;
//    gtkCategory:  Result := FTitleMode;
  end;
end;

function TGnvTabBar.GetButtonGlyphState(
  const Kind: TGnvTabBarButtonKind): TGnvGlyphState;
begin
  Result := glsDisabled;
  if FOverKind = Kind then
    Result := glsNormal;
end;

function TGnvTabBar.GetButtonRect(const Kind: TGnvTabBarButtonKind): TRect;
var
  ScaledButtonWidth, L: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if not (Kind in FButtonKinds) then Exit;

  Result := ClientRect;
  ScaledButtonWidth := Round(FButtonWidth*Screen.PixelsPerInch/96);
  case Kind of
    gtkShift1:  L := FShift1Left;
    gtkShift2:  L := FShift2Left;
    gtkClose:
      if FCloseKind = gckCommon then
        L := FCloseLeft
      else if FOverIndex > -1 then
      begin
				L := GetTabRect(FOverIndex).Right - GnvGlyphGetSize(glClose).cx - 6;
				if gtkNext in FButtonKinds then L := L - GnvGlyphGetSize(glChevron).cx - 6;
				if gtkDropdown in FButtonKinds then L := L - GnvGlyphGetSize(glCaret).cx - 6;
				ScaledButtonWidth := GnvGlyphGetSize(glClose).cx;
      end
      else
        ScaledButtonWidth := 0;
    gtkDropdown:
      if FOverIndex > -1 then
      begin
				L := GetTabRect(FOverIndex).Right - GnvGlyphGetSize(glCaret).cx - 6;
        if gtkNext in FButtonKinds then
        begin
					L := L - GnvGlyphGetSize(glChevron).cx - 6;
					ScaledButtonWidth := GnvGlyphGetSize(glCaret).cx + 6;
        end
        else
        begin
          L := L - 6;
					ScaledButtonWidth := GnvGlyphGetSize(glCaret).cx + 12;
        end;
        {
        if gtkCategory in FKinds then
        begin
          L := L - FTabs[FOverIndex].FCatWidth;
          ButtonWidth := ButtonWidth + FTabs[FOverIndex].FCatWidth;
        end;
        }
      end
      else
        ScaledButtonWidth := 0;
    gtkCategory:
      if (FOverIndex > -1) and (FDropIndex < 0) then
      begin
        L := GetTabRect(FOverIndex).Right - FTabs[FOverIndex].FCatWidth - 6;
				if gtkNext in FButtonKinds then L := L - GnvGlyphGetSize(glChevron).cx - 6;
				if gtkDropdown in FButtonKinds then L := L - GnvGlyphGetSize(glCaret).cx - 6;
        if gtkClose in FButtonKinds then L := L - GnvGlyphGetSize(glClose).cx - 6;
        ScaledButtonWidth := FTabs[FOverIndex].FCatWidth;
      end
      else
        ScaledButtonWidth := 0;
    gtkMenu:    L := FMenuLeft;
    gtkPrevious:
      if (FOverIndex > -1) and (FDropIndex < 0) then
      begin
        L := GetTabRect(FOverIndex).Left + 6;
				ScaledButtonWidth := GnvGlyphGetSize(glCaret).cx + 6;
      end
      else
        ScaledButtonWidth := 0;
    gtkNext:
      if FOverIndex > -1 then
      begin
//        L := GetTabRect(FOverIndex).Right - GnvShevronWidth - 12;
//        ButtonWidth := GnvShevronWidth + 6;
				L := GetTabRect(FOverIndex).Right - GnvGlyphGetSize(glCaret).cx - 12;
				ScaledButtonWidth := GnvGlyphGetSize(glCaret).cx + 6;
      end
      else
        ScaledButtonWidth := 0;
    gtkHome:
      if (FOverIndex > 0) and (FDropIndex < 0) then
      begin
        L := GetTabRect(FOverIndex).Left + 6;
        if gtkPrevious in FButtonKinds then L := L + GnvGlyphGetSize(glChevron).cx + 6;
        ScaledButtonWidth := GnvGlyphGetSize(glChevron).cx + 6;
      end
      else
        ScaledButtonWidth := 0;
    gtkPlus:
      L := FPlusLeft;
  end;

  // Fix negative offset so tabs dont overlap
  if (Kind <> gtkShift1) and (FClipWidth < 0) then
    L := L - FClipWidth;

  case FDirection of
		gdLeft, gdRight:
		begin
			Result.Top := L;
			Result.Bottom := L + ScaledButtonWidth;
		end;
    gdUp, gdDown:
    begin
      Result.Left := L;
      Result.Right := L + ScaledButtonWidth;
    end;
  end;
end;

function TGnvTabBar.GetClipRect: TRect;
begin
  Result := ClientRect;
  Result.Left := Result.Left + FMargin1;
  Result.Right := Result.Right - FMargin2;
end;

function TGnvTabBar.GetTabLeft(const Index: Integer): Integer;
begin
  Result := 0;
  if Index > -1 then
    Result := FMargin1 + FTabs[Index].FLeft + FShift + FAlignLeft;
end;

function TGnvTabBar.GetTabRect(const Index: Integer; Visible: Boolean = False): TRect;
var
  L, W, Offset: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if FTitleMode then
  begin
    if Index = FTabIndex then Result := ClientRect;
    Exit;
  end;

//  if Index = FDropIndex then
//  begin
//    Result := ClientRect;
//    Exit;
//  end;

  if not FNoneTab and (Index < 0) or (Index > FTabs.Count - 1) or
    ((Index > -1) and not FTabs[Index].FVisible) then Exit;

  Result := ClientRect;
  if Index = -1 then
  begin
    L := 0;
    W := FNoneWidth;
  end
  else
  begin
    if FDownIndex = Index then
      L := FMoveLeft
    else
      L := FMargin1 + FTabs[Index].FLeft + FShift;
    W := FTabs[Index].FWidth;
    if Visible and (L < FMargin1) then
    begin
      W := W + L - FMargin1;
      L := FMargin1;
    end;
    if Visible and (L + W > FWidth - FMargin2) then W := FWidth - FMargin2 - L;
    if W < 0 then W := 0;
  end;

  Offset := 0;
  if (FStyle = gtsTabs) and (Index <> FTabIndex) and (Index <> FDropIndex) and
		not (GnvGetOppositeAnchor(FDirection) in FBorderSticking) then
  begin
    if (Index > -1) and (FTabs[Index] = FFlickTab) then Offset := FFlickShift;
    case FDirection of
			gdDown, gdRight:  Offset := 1 + Offset;
			gdUp, gdLeft:     Offset := -1 - Offset;
    end
  end;

  L := L + FAlignLeft;

  case FAlignment of
    taLeftJustify:  L := L + FIndent;
    taRightJustify: L := L - FIndent;
  end;

  case FDirection of
		gdLeft, gdRight:
		begin
			Result.Top := L;
			Result.Bottom := L + W;
			Result.Left := Result.Left + Offset;
			Result.Right := Result.Right + Offset;
		end;
    gdUp, gdDown:
    begin
      Result.Left := L;
      Result.Right := L + W;
      Result.Top := Result.Top + Offset;
      Result.Bottom := Result.Bottom + Offset;
    end;
  end;
end;

function TGnvTabBar.GetTabWidth(const Index: Integer): Integer;
begin
  Result := 0;
  if Index > -1 then
    Result := FTabs[Index].FWidth;
end;

function TGnvTabBar.IndexOfTabAt(X, Y: Integer): Integer;
var
  R: TRect;
  P: TPoint;
  I: Integer;
begin
  Result := -2;
  P.X := X;
  P.Y := Y;
  for I := -1 to FTabs.Count - 1 do
    if PtInRect(GetTabRect(I, True), P) then
    begin
      Result := I;
      Exit;
    end;
end;

function TGnvTabBar.KindOfButtonAt(X, Y: Integer): TGnvTabBarButtonKind;
var
  I: Integer;
begin
  Result := gtkNone;
  for I := 1 to GnvTabBarButtonKindCount - 1 do
    if PtInRect(GetButtonRect(TGnvTabBarButtonKind(I)), Point(X, Y)) then
      Result := TGnvTabBarButtonKind(I);
end;

procedure TGnvTabBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Index: Integer;
begin
  inherited;
  // Define clicked tab number
  Index := IndexOfTabAt(X, Y);
  FDownKind := KindOfButtonAt(X, Y);
  if (Index < -1) or not (FDownKind in [gtkNone]) then
  begin
    case FDownKind of
      gtkShift1:  StartTimer;
      gtkShift2:  StartTimer;
      gtkMenu:    TabMenu;
      gtkCategory:SafeRepaint;
    end;
  end
  else if FTabIndex <> Index then
  begin
    SetTabIndex(Index);
    if Assigned(FOnChange) then FOnChange(Self);
  end;

  if FMoveTabs and (Index > -1) then
  begin
    FDownIndex := Index;
    FMoveLeft := GetTabLeft(Index);
    FMoveOffset := X - FMoveLeft;
    FMovedTabs := False;
  end;

  SetFocus;
end;

procedure TGnvTabBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Kind: TGnvTabBarButtonKind;
  Index: Integer;
begin
  // Define tab number under cursor
  Index := IndexOfTabAt(X, Y);

  if Index > -1 then
    Hint := FTabs[Index].Hint
  else
    Hint := '';

  if FOverIndex <> Index then
  begin
    FOverIndex := Index;
    if FTitleMode then SafeRepaint;
    // Change the display status of toolbar tooltip if active button changes
    // When hovering next button, tooltip will appear again with corresponding delay
    Application.CancelHint;
  end;

  // Define button under cursor
  Kind := KindOfButtonAt(X, Y);

  if (Kind <> gtkNone) and GetButtonEnabled(Kind) then
    Cursor := crHandPoint
  else
    Cursor := crDefault;

  if FOverKind <> Kind  then
  begin
    FOverKind := Kind;
    SafeRepaint;
  end;

  // Repaint tabs if cursor hovers tab close button
  if (FCloseKind = gckPersonal) and (FOverIndex > -1) and (FOverKind = gtkClose) then
    SafeRepaint;

  if FMoveTabs and (FDownIndex > -1) then
  begin
    FMoveLeft := X - FMoveOffset;
    if FMoveLeft < GetTabLeft(FDownIndex) then
    begin
      Index := IndexOfTabAt(FMoveLeft, Height div 2);
      if (Index > -1) and (GetTabLeft(Index) + (GetTabWidth(Index) div 2) >
        FMoveLeft) then
      begin

        MoveTab(FDownIndex, Index);
        FDownIndex := Index;
      end;
{
      begin
        FTabs[FDownIndex].Index := Index;
        if Assigned(FOnTabMove) then
          FOnTabMove(Self, FDownIndex, Index);
        FDownIndex := Index;
        FTabIndex := Index;
      end;
}
    end
    else
    begin
      Index := IndexOfTabAt(FMoveLeft + FTabs[FDownIndex].FWidth, Height div 2);
      if (Index > -1) and (FMoveLeft + GetTabWidth(FDownIndex) >
        GetTabLeft(Index) + (GetTabWidth(Index) div 2)) then
      begin

        MoveTab(FDownIndex, Index);
        FDownIndex := Index;
      end;
{
      begin
        FTabs[FDownIndex].Index := Index;
        if Assigned(FOnTabMove) then
          FOnTabMove(Self, FDownIndex, Index);
        FDownIndex := Index;
        FTabIndex := Index;
      end;
}
    end;
    SafeRepaint;
  end;

  inherited;
end;

procedure TGnvTabBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Index, I: Integer;
  P: TPoint;
begin
  inherited;
//  if FMovedTabs and (FDownIndex > -1) then
//  begin
//   FTabs.MoveGroup(FTabs[FDownIndex].FGroupIndex, FTabs[FDownIndex]);
//  end;
  if FDownIndex <> - 1 then
  begin
    FDownIndex := -1;
    UpdateShift;
    SafeRepaint;
  end;
  if Assigned(FOnButtonClick) and (KindOfButtonAt(X, Y) = FDownKind) and
    GetButtonEnabled(FDownKind) and (Button = mbLeft) then
    case FDownKind of
      gtkShift1,
      gtkShift2:  FOnButtonClick(Self, gtbShift, -2);
      gtkClose:
        if FCloseKind = gckPersonal then
          FOnButtonClick(Self, gtbClose, FOverIndex)
        else
          FOnButtonClick(Self, gtbClose, FTabIndex);
      gtkMenu:    FOnButtonClick(Self, gtbMenu, -2);
      gtkPlus:    FOnButtonClick(Self, gtbPlus, -2);
      gtkDropdown:
      begin
        FOnButtonClick(Self, gtbDropdown, FOverIndex);
        TabDropdown;
      end;
      gtkCategory:
      begin
        FOnButtonClick(Self, gtbDropdown, FOverIndex);
        TabDropdown;
//        FOnButtonClick(Self, gtbCategory, FOverIndex);
//        TabNext;
//        MouseMove(Shift, X, Y);
      end;
      gtkPrevious:
      begin
        FOnButtonClick(Self, gtbPrevious, FOverIndex);
        TabPrevious;
        MouseMove(Shift, X, Y);
      end;
      gtkNext:
      begin
        FOnButtonClick(Self, gtbNext, FOverIndex);
        TabNext;
        MouseMove(Shift, X, Y);
      end;
      gtkHome:
      begin
        FOnButtonClick(Self, gtbHome, FOverIndex);
        SetTabIndex(0);
      end;
    end;
  FDownKind := gtkNone;
  FMoveLeft := 0;
  FMoveOffset := 0;
  StopTimer;

  if Button = mbRight then
  begin
    // Define the tab over which the right mouse button click occurs
    Index := IndexOfTabAt(X, Y);

    if (Index > -1) and Assigned(FTabs[Index].FPopupMenu) then
    begin
      // Detect mouse position
      P := Point(X, Y);
      P := ClientToScreen(P);
      // Display context menu
      FTabs[Index].FPopupMenu.Popup(P.X, P.Y);
    end;
  end;
end;

procedure TGnvTabBar.MoveTab(OldIndex, NewIndex: Integer);
begin
  FTabs[OldIndex].Index := NewIndex;
  if Assigned(FOnTabMove) then
    FOnTabMove(Self, OldIndex, NewIndex);
  if OldIndex = FTabIndex then
    FTabIndex := NewIndex;
  FMovedTabs := True;
end;

procedure TGnvTabBar.Paint;
var
  Theme: TGnvSystemTheme;
  Scale: TGnvSystemScale;
  R: TRect;
  OldRgn, NewRgn: HRGN;
  I: Integer;
begin
  inherited;

  Exit;

  if (Width <= 0) or (Height <= 0) then Exit;

	Theme := GnvSystemThemeDetect(FTheme);
	Scale := GnvSystemScaleDetect(FScale);

{
  if not FTransparent then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect);
  end;
}
  Canvas.Font := Self.Font;

  if FTitleMode then
  begin
    if FTabIndex > -1 then
      PaintTab(FTabIndex);
  end
  else
  begin
//    if FDropIndex > -1 then
//      PaintTab(FDropIndex)
//    else
    begin
      if gtkPlus in FButtonKinds then
        GnvGlyphDraw(Canvas, GetButtonRect(gtkPlus), glPlus, gdDown, goForward, GetButtonGlyphState(gtkPlus), Theme, Scale);

      R := GetClipRect;

      // Remove margins for painting tabs
      GetClipRgn(Canvas.Handle, OldRgn);
      NewRgn := CreateRectRgn(R.Left, R.Top, R.Right, R.Bottom);
      SelectClipRgn(Canvas.Handle, NewRgn);

      for I := 0 to FTabs.Count - 1 do
        if (FTabIndex <> I) and (FDropIndex <> I) then
          PaintTab(I);
      PaintTab(FTabIndex);

      // Return full paint
      DeleteObject(NewRgn);
      SelectClipRgn(Canvas.Handle, OldRgn);

      if FNoneTab then PaintTab(-1);

      PaintStrip;

      if FDropIndex > -1 then
        PaintTab(FDropIndex);

      if gtkShift1 in FButtonKinds then
        GnvDrawGlyphChevron(Canvas, GetButtonRect(gtkShift1), gdLeft, GetButtonEnabled(gtkShift1) and (FOverKind = gtkShift1));

      if gtkShift2 in FButtonKinds then
        GnvDrawGlyphChevron(Canvas, GetButtonRect(gtkShift2), gdRight, GetButtonEnabled(gtkShift2) and (FOverKind = gtkShift2));

      if (gtkClose in FButtonKinds) and (FCloseKind = gckCommon) then
        GnvDrawGlyphClose(Canvas, GetButtonRect(gtkClose), GetButtonEnabled(gtkClose) and (FOverKind = gtkClose));

      if gtkMenu in FButtonKinds then
        GnvDrawGlyphTriangle(Canvas, GetButtonRect(gtkMenu), FDirection, FOverKind = gtkMenu);
    end;
  end;
end;

procedure TGnvTabBar.PaintStrip;
var
  R, TabR: TRect;
  Points: array [0..5] of TPoint;
  GP: IGPGraphics;
  GPR: TGPRect;
  GPPen: IGPPen;
  GPPath: IGPGraphicsPath;
  GPPoints: array [0..5] of TGPPoint;
begin
  R := ClientRect;
	if (gdUp in GetHideBorders) and not (FDirection = gdDown) then R.Top := R.Top - 1;
	if (gdLeft in GetHideBorders) and not (FDirection = gdRight) then R.Left := R.Left - 1;
	if (gdDown in GetHideBorders) and not (FDirection = gdUp) then R.Bottom := R.Bottom + 1;
	if (gdRight in GetHideBorders) and not (FDirection = gdRight) then R.Right := R.Right + 1;

  TabR := GetTabRect(FTabIndex, True);

  if (Win32MajorVersion >= 5) and IsAppThemed then
  begin
    case FDirection of
			gdLeft:
			begin
				GPPoints[0] := TGPPoint.Create(R.Left, R.Top);
				GPPoints[1] := TGPPoint.Create(R.Left + FStripSize, R.Top);
				GPPoints[2] := TGPPoint.Create(R.Left + FStripSize, TabR.Top);
				GPPoints[3] := TGPPoint.Create(R.Left + FStripSize, TabR.Bottom - 1);
				GPPoints[4] := TGPPoint.Create(R.Left + FStripSize, R.Bottom - 1);
				GPPoints[5] := TGPPoint.Create(R.Left, R.Bottom - 1);
				GPR := TGPRect.Create(R.Left, R.Top, FStripSize, R.Bottom - R.Top);
			end;
			gdUp:
			begin
				GPPoints[0] := TGPPoint.Create(R.Left, R.Top);
				GPPoints[1] := TGPPoint.Create(R.Left, R.Top + FStripSize);
				GPPoints[2] := TGPPoint.Create(TabR.Left, R.Top + FStripSize);
				GPPoints[3] := TGPPoint.Create(TabR.Right - 1, R.Top + FStripSize);
				GPPoints[4] := TGPPoint.Create(R.Right - 1, R.Top + FStripSize);
				GPPoints[5] := TGPPoint.Create(R.Right - 1, R.Top);
				GPR := TGPRect.Create(R.Left, R.Top, R.Right - R.Left, FStripSize);
			end;
			gdRight:
			begin
				GPPoints[0] := TGPPoint.Create(R.Right - 1, R.Top);
				GPPoints[1] := TGPPoint.Create(R.Right - FStripSize - 1, R.Top);
				GPPoints[2] := TGPPoint.Create(R.Right - FStripSize - 1, TabR.Top);
				GPPoints[3] := TGPPoint.Create(R.Right - FStripSize - 1, TabR.Bottom - 1);
				GPPoints[4] := TGPPoint.Create(R.Right - FStripSize - 1, R.Bottom - 1);
				GPPoints[5] := TGPPoint.Create(R.Right - 1, R.Bottom - 1);
				GPR := TGPRect.Create(R.Right - FStripSize, R.Top, FStripSize, R.Bottom - R.Top);
			end;
      gdDown:
      begin
        GPPoints[0] := TGPPoint.Create(R.Left, R.Bottom - 1);
        GPPoints[1] := TGPPoint.Create(R.Left, R.Bottom - FStripSize - 1);
        GPPoints[2] := TGPPoint.Create(TabR.Left, R.Bottom - FStripSize - 1);
        GPPoints[3] := TGPPoint.Create(TabR.Right - 1, R.Bottom - FStripSize - 1);
        GPPoints[4] := TGPPoint.Create(R.Right - 1, R.Bottom - FStripSize - 1);
        GPPoints[5] := TGPPoint.Create(R.Right - 1, R.Bottom - 1);
        GPR := TGPRect.Create(R.Left, R.Bottom - FStripSize, R.Right - R.Left, FStripSize);
      end;
    end;

    GP := TGPGraphics.Create(Canvas.Handle);
    GPPen := TGPPen.Create(GnvGPColor(GnvBorderGetColor));

    GP.FillRectangle(GnvColorsCreateGPBrush(FTabActiveColors, GPR, FTheme), GPR);

    GP.DrawLine(GPPen, GPPoints[0], GPPoints[1]);
    GP.DrawLine(GPPen, GPPoints[1], GPPoints[2]);
    GP.DrawLine(GPPen, GPPoints[3], GPPoints[4]);
    GP.DrawLine(GPPen, GPPoints[4], GPPoints[5]);
  end
  else
  begin
    case FDirection of
			gdLeft:
			begin
				Points[0] := Point(R.Left, R.Top);
				Points[1] := Point(R.Left + FStripSize, R.Top);
				Points[2] := Point(R.Left + FStripSize, TabR.Top);
				Points[3] := Point(R.Left + FStripSize, TabR.Bottom - 1);
				Points[4] := Point(R.Left + FStripSize, R.Bottom - 1);
				Points[5] := Point(R.Left, R.Bottom - 1);
				R := Rect(R.Left, R.Top, R.Left + FStripSize, R.Bottom);
			end;
			gdUp:
			begin
				Points[0] := Point(R.Left, R.Top);
				Points[1] := Point(R.Left, R.Top + FStripSize);
				Points[2] := Point(TabR.Left, R.Top + FStripSize);
				Points[3] := Point(TabR.Right - 1, R.Top + FStripSize);
				Points[4] := Point(R.Right - 1, R.Top + FStripSize);
				Points[5] := Point(R.Right - 1, R.Top);
				R := Rect(R.Left, R.Top, R.Right, R.Top + FStripSize);
			end;
			gdRight:
			begin
				Points[0] := Point(R.Right - 1, R.Top);
				Points[1] := Point(R.Right - FStripSize - 1, R.Top);
				Points[2] := Point(R.Right - FStripSize - 1, TabR.Top);
				Points[3] := Point(R.Right - FStripSize - 1, TabR.Bottom - 1);
				Points[4] := Point(R.Right - FStripSize - 1, R.Bottom - 1);
				Points[5] := Point(R.Right - 1, R.Bottom - 1);
				R := Rect(R.Right - FStripSize, R.Top, R.Right, R.Bottom);
			end;
			gdDown:
			begin
				Points[0] := Point(R.Left, R.Bottom);
				Points[1] := Point(R.Left, R.Bottom - FStripSize);
				Points[2] := Point(TabR.Left, R.Bottom - FStripSize);
				Points[3] := Point(TabR.Right, R.Bottom - FStripSize);
				Points[4] := Point(R.Right - 1, R.Bottom - FStripSize);
				Points[5] := Point(R.Right - 1, R.Bottom);
				R := Rect(R.Left, R.Bottom - FStripSize + 1, R.Right, R.Bottom);
			end;
		end;

		with Canvas do
		begin
      Brush.Color := clBtnFace;
      FillRect(R);

//      if FDirection in [akBottom, akTop, akLeft] then
      Pen.Color := clBtnHighlight;
      MoveTo(Points[0].X, Points[0].Y);
      LineTo(Points[1].X, Points[1].Y);

      if FDirection in [gdUp, gdLeft] then
        Pen.Color := clBtnShadow
      else
        Pen.Color := clBtnHighlight;
      LineTo(Points[2].X, Points[2].Y);
      MoveTo(Points[3].X, Points[3].Y);
      LineTo(Points[4].X, Points[4].Y);

      Pen.Color := clBtnShadow;
      LineTo(Points[5].X, Points[5].Y);

      if FDirection in [gdDown, gdUp] then
        Pen.Color := clBtnHighlight
      else
        Pen.Color := clBtnShadow;
      LineTo(Points[0].X, Points[0].Y);
    end;
  end;
end;

procedure TGnvTabBar.PaintTab(const Index: Integer);
var
  Rgn: HRGN;
  TabRect, R, ImgR, TextR, CatR, BufR, OldR, DrawR: TRect;
  // Moving Alignment variable to the top of the list causes paint error:
  // tab contents are not cut when going outside display region
  Alignment: TAlignment;
  MiddleX: Integer;
  BorderSticking: TGnvDirections;
  GP: IGPGraphics;
  GPR: TGPRect;
  GPPen: IGPPen;
  GPBrush: IGPBrush;
  GPPath: IGPGraphicsPath;
  Format: Cardinal;
begin
  if not FNoneTab and (Index < 0) or (Index > FTabs.Count - 1) then Exit;

  TabRect := GetTabRect(Index);

  if (Index > -1) and not IntersectRect(BufR, GetClipRect, TabRect) then Exit;

  GetClipRgn(Canvas.Handle, Rgn);

  { Drawing tab background }

  if (Win32MajorVersion >= 5) and IsAppThemed then
  // Drawing for themed Windows XP+
  begin
    GP := TGPGraphics.Create(Canvas.Handle);
    GPR.Initialize(TabRect);
    GPPath := TGPGraphicsPath.Create;

    if (Win32MajorVersion >= 6) and (Win32MinorVersion >= 2) then
    // No smoothing, leaning, color flow and tab radius needed for Windows 8+
    begin
			GnvFrameCreateGPPathOld(GPPath, GPR, 0, 1, [], [FDirection]);

      GPBrush := TGPSolidBrush.Create(GnvGPColor(clBtnFace));
      GPPen := TGPPen.Create(GnvGPColor(GnvBorderGetColor));
    end
    else
    begin
      GP.SmoothingMode := SmoothingModeAntiAlias;

      if GnvGetOppositeAnchor(FDirection) in FBorderSticking then
        BorderSticking := [GnvGetOppositeAnchor(FDirection)]
      else
        BorderSticking := [];

			if (TabRect.Left = 0) and (gdLeft in FBorderSticking) then
				BorderSticking := BorderSticking + [gdLeft];
			if (TabRect.Right = ClientRect.Right) and (gdRight in FBorderSticking) then
				BorderSticking := BorderSticking + [gdRight];

      if not FTitleMode and (FDropIndex < -1) and (FStyle = gtsTitleTabs) and
        (FLastVisibleIndex > -1) then
      begin
        if FLastVisibleIndex = Index then
					BorderSticking := BorderSticking + [gdLeft]
				else if FFirstVisibleIndex = Index then
					BorderSticking := BorderSticking + [gdRight]
				else
					BorderSticking := BorderSticking + [gdLeft, gdRight];
      end;

			GnvFrameAddGPPath(GPPath, GPR, FTabRadius, 1, GNV_BORDERS_LRTB,
				BorderSticking + [FDirection], True);//[FDirection]);

      GPBrush := GnvColorsCreateGPBrush(FTabActiveColors, GPR, FTheme);
      GPPen := TGPPen.Create(GnvGPColor(GnvBorderGetColor));
    end;

    GP.FillPath(GPBrush, GPPath);
    GP.DrawPath(GPPen, GPPath);
  end
  else
    // Drawing for classic style
    GnvDrawClassicPanel(Canvas, TabRect, [FDirection]);

  SelectClipRgn(Canvas.Handle, Rgn);

  if Index = -1 then
    GnvDrawGlyphTriangle(Canvas, TabRect, FDirection)
  else
  begin
    // Set tab painting rectangle
    R := TabRect;
    R.Right := R.Right - 6;

    // Paint tab switch button
    if (gtkNext in FButtonKinds) then
    begin
			R.Left := R.Right - GnvGlyphGetSize(glChevron).cx;
//      GnvDrawShevron(Canvas, R, gdRight, (FOverIndex = Index) and (FOverKind = gtkNext));
			GnvDrawGlyphTriangle(Canvas, R, gdRight, (FOverIndex = Index) and (FOverKind = gtkNext));
      R.Right := R.Left - 6;
    end;

    // Paint context menu button
    if (gtkDropdown in FButtonKinds) then
    begin
      R.Left := R.Right - GnvGlyphGetSize(glCaret).cx;
			GnvDrawGlyphTriangle(Canvas, R, gdDown, (FDropIndex = Index) or ((FOverIndex = Index) and (FOverKind in [gtkDropdown, gtkCategory])));
      R.Right := R.Left - 6;
    end;

    // Paint tab close button
    if (gtkClose in FButtonKinds) and (FCloseKind = gckPersonal) then
    begin
      R.Left := R.Right - GnvGlyphGetSize(glClose).cx;
      GnvDrawGlyphClose(Canvas, R, (FOverIndex = Index) and (FOverKind = gtkClose));
      R.Right := R.Left - 6;
    end;

    CatR := R;
    CatR.Left := CatR.Right;

    // Paint category text
    if (FTabs[Index].FCategory <> '') and (gtkCategory in FButtonKinds)  then
    begin
      CatR := R;
      CatR.Left := CatR.Right - FTabs[Index].FCatWidth;

      Canvas.Font := FTabs[Index].Font;
      GnvDrawText(Canvas, CatR, FTabs[Index].FCategory, DT_LEFT or DT_VCENTER or
        DT_SINGLELINE or DT_END_ELLIPSIS, False, not ((FDropIndex = Index) or ((FOverIndex = Index) and (FOverKind in [gtkDropdown, gtkCategory]))));

      CatR.Left := CatR.Left - 6;
    end;

    R.Left := TabRect.Left + 6;

    // Paint tab backward switching button
    if (gtkPrevious in FButtonKinds) and (FDropIndex < 0) then
    begin
      OldR := R;
      R.Right := R.Left + GnvGlyphGetSize(glCaret).cx;
			GnvDrawGlyphTriangle(Canvas, R, gdLeft, (FOverIndex = Index) and (FOverKind = gtkPrevious));
      R.Left := R.Right + 6;
      R.Right := OldR.Right;
    end;

    // Paint home button
    if (gtkHome in FButtonKinds) and (FDropIndex < 0) and (Index > 0) then
    begin
      OldR := R;
      R.Right := R.Left + GnvGlyphGetSize(glChevron).cx;
//      GnvDrawShevron(Canvas, R, akLeft, (FOverIndex = Index) and (FOverKind = gtkHome));
      GnvDrawGlyphClose(Canvas, R, (FOverIndex = Index) and (FOverKind = gtkHome));
      R.Left := R.Right + 6;
      R.Right := OldR.Right;
    end;

    // Define tab content alignment
    if Index = FDropIndex then
      Alignment := FDropAlignment
    else
      Alignment := FAlignment;

    TextR := R;

    // Paint image, define text alignment and calculate text display region
    if (gtbCategory in FButtons) and (FTabs[Index].FCategory <> '') or
      (FTabStyle in [gtsImage, gtsImageText]) then
    begin
      ImgR := R;
      ImgR.Right := ImgR.Left;
      if ((FTabs[Index].FImageIndex > -1) or (FTabs[Index].FProcIndex > -1)) then
      begin
        if Assigned(FImages) then
          ImgR.Right := ImgR.Left + FImages.Width
        else if Assigned(FProcImages) and (FTabs[Index].FProcIndex > -1) then
          ImgR.Right := ImgR.Left + FProcImages.Width;
      end;

      Format := 0;

      case Alignment of
        taLeftJustify:
        begin
          TextR.Left := ImgR.Right;
          if (ImgR.Right - ImgR.Left) > 0 then TextR.Left := TextR.Left + 6;
          Format := DT_LEFT;
        end;
        taRightJustify:
        begin
          ImgR.Left := R.Right - (ImgR.Right - ImgR.Left);
          ImgR.Right := R.Right;
          TextR.Right := ImgR.Left;
          if (ImgR.Right - ImgR.Left) > 0 then TextR.Right := TextR.Right - 6;
          Format := DT_RIGHT;
        end;
        taCenter:
        begin
          MiddleX := R.Left + (R.Right - R.Left - FTabs[Index].FTextWidth -
            (ImgR.Right - ImgR.Left)) div 2;
          if MiddleX < R.Left then MiddleX := R.Left;

          ImgR.Left := ImgR.Left + MiddleX - R.Left;
          ImgR.Right := ImgR.Right + MiddleX - R.Left;

          TextR.Left := ImgR.Right;
          if (ImgR.Right - ImgR.Left) > 0 then TextR.Left := TextR.Left + 3;
          Format := DT_LEFT;
        end;
      end;

      if TextR.Right > CatR.Left then TextR.Right := CatR.Left;

      // Paint tab image
      if IntersectRect(BufR, GetClipRect, ImgR) then
      begin
        if (FTabs[Index].FProcIndex > -1) and Assigned(FProcImages) then
          GnvDrawImage(Canvas, ImgR, FProcImages, FTabs[Index].FProcIndex)
        else if Assigned(FImages) then
          GnvDrawImage(Canvas, ImgR, FImages, FTabs[Index].ImageIndex);
      end;
    end
    else
    begin
      // Set initial text format
      Format := 0;
      case Alignment of
        taLeftJustify:  Format := DT_LEFT;
        taRightJustify: Format := DT_RIGHT;
        taCenter:       Format := DT_CENTER;
      end;
    end;

    // Paint tab text
    if (FTabStyle in [gtsText, gtsImageText]) and (FTabs[Index].Caption <> '') then
    begin
      Canvas.Font := FTabs[Index].Font;
      GnvDrawText(Canvas, TextR, FTabs[Index].Caption, Format or DT_VCENTER or
        DT_SINGLELINE or DT_END_ELLIPSIS, True, FTabs[Index].FGhosted);
    end;
  end;
end;

procedure TGnvTabBar.Rebuild;
var
  I, L, MaxTabWidth, MinWidth, VisibleCount, Indent: Integer;

  procedure CalcTabWidths;
  var
    I, NewWidth, LeftWidth, LeftCount, ScaledTabSize: Integer;
  begin
  // Define tab positions
  L := 0;
  FWantWidth := 0;
  LeftWidth := FClipWidth;
  LeftCount := VisibleCount;
  ScaledTabSize := Round(FTabSize*Screen.PixelsPerInch/96);
  for I := 0 to FTabs.Count - 1 do
    if FTabs[I].FVisible then
    begin
      if (FSizing in [gisValue, gisSpringToSize, gisMaxContentToSize]) then
        FTabs[I].FWidth := ScaledTabSize;

      case FSizing of
        gisMaxContent:    FTabs[I].FWidth := MaxTabWidth;
        gisMaxContentToSize:
          if MaxTabWidth < FTabs[I].FWidth then
            FTabs[I].FWidth := MaxTabWidth;
        gisSpring:        FTabs[I].FWidth := Floor(LeftWidth/LeftCount);
        gisSpringToSize:
        begin
          NewWidth := Floor(LeftWidth/LeftCount);
          if FTabs[I].FWidth > NewWidth then
            FTabs[I].FWidth := NewWidth;
        end;
      end;

      // Define minimal tab size
      case FMinSizing of
        gtmValue:
          if FTabs[I].FMinWidth < FTabMinSize then
            FTabs[I].FMinWidth := FTabMinSize;
        gtmContent:     FTabs[I].FMinWidth := FTabs[I].FWidth;
        gtmMaxContent:  FTabs[I].FMinWidth := MaxTabWidth;
      end;

      if (FMinSizing = gtmMaxContent) and (FTabs[I].FMinWidth > ScaledTabSize) then
        FTabs[I].FMinWidth := ScaledTabSize;

      if FTabs[I].FWidth < FTabs[I].FMinWidth then
        FTabs[I].FWidth := FTabs[I].FMinWidth;

      case FSizing of
        gisSpring,
        gisSpringToSize:
        begin
          LeftWidth := LeftWidth - FTabs[I].FWidth - Indent;
          Dec(LeftCount);
        end;
      end;

      FTabs[I].FLeft := L;
      // Define next tab position and width of all tabs
      L := L + FTabs[I].FWidth + Indent;
      case FSizing of
        gisSpring,
        gisSpringToSize:   FWantWidth := FWantWidth + FTabs[I].FMinWidth;
        else                FWantWidth := FWantWidth + FTabs[I].FWidth;
      end;
    end;
  end;

begin
  inherited;

  case FDirection of
		gdLeft, gdRight:  FWidth := ClientRect.Bottom - ClientRect.Top;
		gdUp, gdDown:  FWidth := ClientRect.Right - ClientRect.Left;
  end;

  FMargin1 := 0;
  FMargin2 := 0;

  if (Win32MajorVersion >= 5) and IsAppThemed then
    Indent := FTabIndent
  else
    Indent := FTabIndent +  1;

  // Define width home button
  if FNoneTab then
  begin
    FNoneWidth := FButtonWidth + 4;
    // Set next element offset
    if (Win32MajorVersion >= 5) and IsAppThemed then
      FMargin1 := FNoneWidth + 1
    else
      FMargin1 := FNoneWidth + 2;
  end
  else
    FNoneWidth := 0;

  FButtonKinds := [];

  FMenuLeft := 0;
  if gtbMenu in FButtons then
  begin
    FButtonKinds := FButtonKinds + [gtkMenu];
    FMenuLeft := FWidth - FMargin2 - FButtonWidth;
    FMargin2 := FMargin2 + FButtonWidth;
  end;

  if gtbDropdown in FButtons then
    FButtonKinds := FButtonKinds + [gtkDropdown];

  FCloseLeft := 0;
  if gtbClose in FButtons then
  begin
    FButtonKinds := FButtonKinds + [gtkClose];
    // If tab close button is common for all tabs,
    // define it's position through other buttons
    if FCloseKind = gckCommon then
    begin
      FCloseLeft := FWidth - FMargin2 - FButtonWidth;
      FMargin2 := FMargin2 + FButtonWidth;
    end;
  end;

  if gtbPlus in FButtons then
  begin
    FButtonKinds := FButtonKinds + [gtkPlus];
    FPlusLeft := FWidth - FMargin2 - FButtonWidth;
    FMargin2 := FMargin2 + FButtonWidth;
  end;

  MaxTabWidth := 0;
  VisibleCount := 0;
  FFirstVisibleIndex := -2;
  FLastVisibleIndex := -2;
  for I := 0 to FTabs.Count - 1 do
    if FTabs[I].FVisible then
    begin
      FTabs[I].FWidth := 6;
      // Add tab image width
      if FTabStyle in [gtsImage, gtsImageText] then
      begin
        if Assigned(FImages) and (FTabs[I].FImageIndex > -1) then
          FTabs[I].FWidth := FTabs[I].FWidth + FImages.Width + 6
//        else if FTabs[I].Processing and Assigned(FProcImages) then
//          FTabs[I].FWidth := FTabs[I].FWidth + FProcImages.Width + 6;
      end;
      // Add context menu button width
      if (gtbDropdown in FButtons) then
        FTabs[I].FWidth := FTabs[I].FWidth + GnvGlyphGetSize(glCaret).cx + 6;
      // Add tab close button width
      if (gtbClose in FButtons) and (FCloseKind = gckPersonal) then
        FTabs[I].FWidth := FTabs[I].FWidth + GnvGlyphGetSize(glClose).cx + 6;
      // Memoize minimal tab width (without text)
      FTabs[I].FMinWidth := FTabs[I].FWidth;
      // Calculate tab text width
      FTabs[I].FTextWidth := SafeTextExtent(FTabs[I].FCaption, FTabs[I].Font).cx;
      // Add category text width
      FTabs[I].FCatWidth := SafeTextExtent(FTabs[I].FCategory, FTabs[I].Font).cx;
      if (FTabs[I].FCategory <> '') then
        FTabs[I].FWidth := FTabs[I].FWidth + FTabs[I].FCatWidth + 6;

      // Add tab text width
      if (FTabStyle in [gtsText, gtsImageText]) and (FTabs[I].FCaption <> '') then
        FTabs[I].FWidth := FTabs[I].FWidth + FTabs[I].FTextWidth + 6;

      // Define minimal tab width through all tabs
      if FTabs[I].FWidth > MaxTabWidth then MaxTabWidth := FTabs[I].FWidth;

      Inc(VisibleCount);
      if FFirstVisibleIndex = -2 then FFirstVisibleIndex := I;
      FLastVisibleIndex := I;
    end;

  FClipWidth := FWidth - FMargin1 - FMargin2;
  CalcTabWidths;

  FAlignLeft := 0;
  case FTabAlignment of
    taLeftJustify:  FAlignLeft := 0;
    taRightJustify: FAlignLeft := FWidth - FWantWidth;
    taCenter:       FAlignLeft := (FWidth - FWantWidth) div 2;
  end;

  FShift1Left := 0;
  FShift2Left := 0;
  // Tabs clipping nedded when they dont's fit into allocated width
  if (FWantWidth > FWidth - FMargin1 - FMargin2 - 2 - FButtonWidth*2) and
    (gtbShift in FButtons) and (FTabs.Count > 0) and (FOverflow = gtoClip) then
  begin
    FButtonKinds := FButtonKinds + [gtkShift1, gtkShift2];
    FShift1Left := FMargin1;
    FMargin1 := FMargin1 + FButtonWidth;
    FMargin2 := FMargin2 + 2;
    FShift2Left := FWidth - FMargin2 - FButtonWidth;
    FMargin2 := FMargin2 + FButtonWidth;

    FClipWidth := FWidth - FMargin1 - FMargin2;
    CalcTabWidths;
  end;

  if gtbPlus in FButtons then
  begin
    if FLastVisibleIndex > -1 then
    begin
      I := GetTabLeft(FLastVisibleIndex) + GetTabWidth(FLastVisibleIndex) + Indent;
      if I < FWidth - FMargin2 - FButtonWidth then FPlusLeft := I;
    end
    else
      FPlusLeft := FMargin1;
  end;

  FTitleMode := (FWantWidth > FClipWidth) and (FOverflow = gtoDisplayTitle);

  if (gtbPrevious in FButtons) and FTitleMode then
    FButtonKinds := FButtonKinds + [gtkPrevious];

  if (gtbHome in FButtons) and FTitleMode then
    FButtonKinds := FButtonKinds + [gtkHome];

  if (gtbCategory in FButtons) then// and FTitleMode then
    FButtonKinds := FButtonKinds + [gtkCategory];

  if (gtbNext in FButtons) and FTitleMode then
    FButtonKinds := FButtonKinds + [gtkNext];

  UpdateShift;
end;

procedure TGnvTabBar.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetButtons(const Value: TGnvTabBarButtons);
begin
  if FButtons <> Value then
  begin
    FButtons := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetCloseKind(const Value: TGnvTabBarCloseKind);
begin
  if FCloseKind <> Value then
  begin
    FCloseKind := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetDirection(const Value: TGnvDirection);
begin
  if FDirection <> Value then
  begin
    FDirection := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetDropAlignment(const Value: TAlignment);
begin
  if FDropAlignment <> Value then
  begin
    FDropAlignment := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetDropdownControl(const Value: TWinControl);
begin
  FDropdownControl := Value;
  FOldWndProc := FDropdownControl.WindowProc;
  FDropdownControl.WindowProc := DropdownControlWndProc;
end;

procedure TGnvTabBar.SetDropdownMenu(const Value: TPopupMenu);
begin
  if FDropdownMenu <> Value then
    FDropdownMenu := Value;
end;

procedure TGnvTabBar.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetIndent(const Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetBorderSticking(const Value: TGnvDirections);
begin
	if FBorderSticking <> Value then
  begin
    FBorderSticking := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetMinSizing(const Value: TGnvTabBarMinSizing);
begin
  if FMinSizing <> Value then
  begin
    FMinSizing := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetNoneTab(const Value: Boolean);
begin
  if FNoneTab <> Value then
  begin
    FNoneTab := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetOverflow(const Value: TGnvTabBarOverflow);
begin
  if FOverflow <> Value then
  begin
    FOverflow := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetSizing(const Value: TGnvItemSizing);
begin
  if FSizing <> Value then
  begin
    FSizing := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetStripSize(const Value: Integer);
begin
  if FStripSize <> Value then
  begin
    FStripSize := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetStyle(const Value: TGnvTabBarStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTabStyle(const Value: TGnvToolButtonStyle);
begin
  if FTabStyle <> Value then
  begin
    FTabStyle := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTransparent(const Value: Boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
    if Value then
      ControlStyle := ControlStyle - [csOpaque] else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TGnvTabBar.SetTabAlignment(const Value: TAlignment);
begin
  if FTabAlignment <> Value then
  begin
    FTabAlignment := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTabActiveColors(const Value: TGnvControlColors);
begin
  FTabActiveColors.Assign(Value);
  SafeRepaint;
end;

procedure TGnvTabBar.SetTabInactiveColors(const Value: TGnvControlColors);
begin
  FTabInactiveColors.Assign(Value);
  SafeRepaint;
end;

procedure TGnvTabBar.SetTabIndent(const Value: Integer);
begin
  if FTabIndent <> Value then
  begin
    FTabIndent := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTabIndex(const Value: Integer);
begin
  if FTabIndex <> Value then
  begin
    FTabIndex := Value;
    UpdateControls;
    if FTabIndex > -1 then
      UpdateShift;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTabMinSize(const Value: Integer);
begin
  if FTabMinSize <> Value then
  begin
    FTabMinSize := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTabRadius(const Value: Integer);
begin
  if FTabRadius <> Value then
  begin
    FTabRadius := Value;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.SetTabs(const Value: TGnvTabs);
begin
  FTabs.Assign(Value);
end;

procedure TGnvTabBar.SetTabSize(const Value: Integer);
begin
  if FTabSize <> Value then
  begin
    FTabSize := Value;
    Rebuild;
    SafeRepaint;
  end;
end;

procedure TGnvTabBar.StartTimer;
begin
  if (FProcList.Count = 1) or (FDownKind = FOverKind) or (FFlickList.Count = 1) then
    SetTimer(Handle, 0, 10, nil);
end;

procedure TGnvTabBar.StopTimer;
begin
  if (FProcList.Count = 0) and (FDownKind <> FOverKind) and (FFlickList.Count = 0) then
    KillTimer(Handle, 0);
end;

procedure TGnvTabBar.TabDropdown;
var
  R: TRect;
begin
  if Assigned(FDropdownControl) then
    with FDropDownControl do
    begin
      R := GetTabRect(FOverIndex);
      //R := Self.ClientRect;
      R.TopLeft := Self.ClientToParent(R.TopLeft, Parent);
      R.BottomRight := Self.ClientToParent(R.BottomRight, Parent);

      Left := R.Left;
      Top := R.Bottom;
      //Width := Self.Width;
      Width := R.Right - R.Left;

      Show;
      SetFocus;
    end;
end;

procedure TGnvTabBar.TabMenu;
var
  R: TRect;
  P: TPoint;
begin
  if (gtkMenu in FButtonKinds) and Assigned(FDropdownMenu) then
  begin
    R := GetButtonRect(gtkMenu);
    case FDirection of
			gdRight, gdLeft:  P := Point(R.Right, R.Top);
      gdDown, gdUp:
        case FDropdownMenu.Alignment of
          paLeft:   P := Point(R.Left, R.Bottom - FStripSize - 1);
          paCenter: P := Point((R.Right - R.Left) div 2, R.Bottom - FStripSize - 1);
          paRight:  P := Point(R.Right, R.Bottom - FStripSize - 1);
        end;
    end;
    P := ClientToScreen(P);
    FDropdownMenu.Popup(P.X, P.Y);
  end;
end;

procedure TGnvTabBar.TabNext;
var
  Index: Integer;
begin
  Index := FTabIndex;
  Inc(Index);
  if Index > FTabs.Count - 1 then
  begin
    if FNoneTab then
      Index := -1
    else
      Index := 0;
  end;
  SetTabIndex(Index);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGnvTabBar.TabPrevious;
var
  Index: Integer;
begin
  Index := FTabIndex;
  Dec(Index);
  if FNoneTab then
  begin
    if Index < -1 then
      Index := FTabs.Count - 1;
  end
  else if Index < 0 then
    Index := FTabs.Count - 1;
  SetTabIndex(Index);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGnvTabBar.TabShift(const Value: Integer);
begin
  FShift := FShift + Value;
  ValidateShift;
  SafeRepaint;
end;

procedure TGnvTabBar.UpdateControls;
var
  I: Integer;
begin
  for I := 0 to FTabs.Count - 1 do
    if I <> FTabIndex then
      FTabs[I].HideControl;
  if (FTabIndex > -1) and (FTabIndex < FTabs.Count) then
    FTabs[FTabIndex].ShowControl;
end;

procedure TGnvTabBar.UpdateShift;
var
  L, W: Integer;
begin
  if (FTabIndex > -1) and (FTabs.Count > 1) then
  begin
    L := FTabs[FTabIndex].FLeft;
    W := L + FTabs[FTabIndex].FWidth;

    // Make active tab visible
    if (W + FShift > FClipWidth) and (L + FShift <> 0) then
      FShift := FClipWidth - W
    else if L + FShift < 0 then
      FShift := - L;
  end
  else
    FShift := 0;

  ValidateShift;
end;

procedure TGnvTabBar.ValidateShift;
begin
  // Remove unnecessary left offset
  if FWantWidth + FShift < FClipWidth then
    FShift := FClipWidth - FWantWidth;

  // Remove unnecessary right offset
  if FShift > 0 then
    FShift := 0;
end;

procedure TGnvTabBar.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  // Prevent title flickering
  Message.Result := 1;
end;

procedure TGnvTabBar.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  // Prevent double click if cursor is over button
  if Assigned(FOnDblClick) and (FOverKind = gtkNone) then
    FOnDblClick(Self)
  else
    MouseDown(mbLeft, KeysToShiftState(Message.Keys), Message.XPos, Message.YPos);
end;

procedure TGnvTabBar.WMSize(var Message: TWMSize);
begin
  Rebuild;
  inherited;
end;

procedure TGnvTabBar.WMTimer(var Message: TWMTimer);
const
  FlickInterval = 1000;
  FlickTick = 50;
  FlickShift = 3;
  FlickCount = 2;
var
  Index: Integer;
  Painting: Boolean;
begin
  FShifting := not FShifting;
  if (FDownKind = FOverKind) and FShifting then
    case FDownKind of
      gtkShift1: TabShift(16);
      gtkShift2: TabShift(-16);
    end;

  Painting := False;

  if FFlickCount < 0 then
  begin
    if MilliSecondsBetween(GetTime, FFlickStart) >= FlickInterval then
      FFlickCount := 0;
  end
  else if MilliSecondsBetween(GetTime, FFlickStart) >= FlickTick then
  begin
    FFlickShift := FFlickShift + FFlickDirection;
    if FFlickShift >= FlickShift then
      FFlickDirection := -1
    else if FFlickShift <= 0 then
    begin
      FFlickDirection := 1;
      Inc(FFlickCount);
    end;
    if FFlickCount >= FlickCount then
    begin
      Index := FFlickList.IndexOf(FFlickTab);
      Inc(Index);
      if Index > FFlickList.Count - 1 then
        Index := 0;
      if Index <= FFlickList.Count - 1 then
        FFlickTab := TGnvTab(FFlickList[Index])
      else
        FFlicktab := nil;
      FFlickCount := -1;
    end;
    FFlickStart := GetTime;
    Painting := True;
  end;

  if Painting then SafeRepaint;

  inherited;
end;

{ TGnvButtonPadding }
{
constructor TGnvButtonPadding.Create(Control: TControl);
begin
  inherited;
  Left := 3;
	Top := 2;
  Bottom := 2;
  Right := 3;
end;
}

{ TGnvAnimate }

constructor TGnvAnimate.Create(AOwner: TComponent);
begin
  inherited;
  FImageIndex := -1;
  FDelay := 1000;
  FInterval := 10;
end;

procedure TGnvAnimate.Paint;
begin
  inherited;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  if Assigned(FImages) and (FImageIndex > -1) and (FImageIndex < FImages.Count) then
    GnvDrawImage(Canvas, ClientRect, FImages, FImageIndex);
end;

procedure TGnvAnimate.SetAnimating(const Value: Boolean);
begin
  if FAnimating <> Value then
  begin
    FAnimating := Value;
    if FAnimating then
    begin
      FImageIndex := -1;
      FStart := GetTime;
      SetTimer(Handle, 0, 10, nil);
    end
    else
      KillTimer(Handle, 0);
  end;
end;

procedure TGnvAnimate.SetInterval(const Value: Integer);
begin
  FInterval := Value;
end;

procedure TGnvAnimate.WMTimer(var Message: TWMTimer);
begin
  if FImageIndex < 0 then
  begin
    if MilliSecondsBetween(GetTime, FStart) >= FDelay then
    begin
      FStart := GetTime;
      FImageIndex := 0;
      SafeRepaint;
    end
  end
  else
  begin
    if MilliSecondsBetween(GetTime, FStart) >= FInterval then
    begin
      Inc(FImageIndex);
      if FImageIndex > FImages.Count - 1 then
        FImageIndex := 0;
      FStart := GetTime;
      SafeRepaint;
    end;
  end;
end;

{ TGnvSplitter }

constructor TGnvSplitter.Create(AOwner: TComponent);
begin
  inherited;
	FHideBorders := [gdLeft, gdRight, gdUp, gdDown];
end;

procedure TGnvSplitter.Paint;
var
  R: TRect;
  GP: IGPGraphics;
  BorderPath: IGPGraphicsPath;
  BorderPen: IGPPen;
  GPR: TGPRect;
begin
  inherited;

  if (Win32MajorVersion >= 5) and IsAppThemed then
  begin
    GP := TGPGraphics.Create(Canvas.Handle);

    R := ClientRect;
    GPR.Initialize(R);

    BorderPen := TGPPen.Create(GnvGPColor(GnvBorderGetColor));

    BorderPath := TGPGraphicsPath.Create;
		GnvFrameCreateGPPathOld(BorderPath, GPR, 0, 1, FHideBorders, FHideBorders);

    GP.DrawPath(BorderPen, BorderPath);
  end
  else
    GnvDrawClassicPanel(Canvas, ClientRect, FHideBorders);
end;

procedure TGnvSplitter.SetHideBorders(const Value: TGnvDirections);
begin
  FHideBorders := Value;
end;

procedure TGnvSplitter.SetResizeStyle(const Value: TResizeStyle);
begin
  FResizeStyle := Value;
end;

procedure TGnvSplitter.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
	if csDesigning in ComponentState then inherited;
	Message.Result := 1;
end;

{ TGnvLabel }

constructor TGnvLabel.Create(AOwner: TComponent);
begin
  inherited;
  FShowArrow := False;
  FArrowDirection := gdDown;
end;

procedure TGnvLabel.Paint;
var
  R: TRect;
begin
  inherited;
  case Alignment of
    taLeftJustify:  ;
    taRightJustify: ;
    taCenter:       ;
  end;
  if FShowArrow then
  begin
    R := ClientRect;
    R.Left := R.Right - GnvGlyphGetSize(glChevron).cx;
    GnvDrawGlyphChevron(Canvas, R, FArrowDirection, False);
  end;
end;

procedure TGnvLabel.SafeRepaint;
begin
  //if Showing then
  Repaint;
end;

procedure TGnvLabel.SetArrowDirection(const Value: TGnvDirection);
begin
  if FArrowDirection <> Value then
  begin
    FArrowDirection := Value;
    SafeRepaint;
  end;
end;

procedure TGnvLabel.SetShowArrow(const Value: Boolean);
begin
  if FShowArrow <> Value then
  begin
    FShowArrow := Value;
    SafeRepaint;
  end;
end;

{ TGnvControlStyle }

procedure TGnvControlStyle.AssignTo(Dest: TPersistent);
var
  Style: TGnvControlStyle;
begin
  Style := nil;
  if Dest is TGnvControlStyle then
    Style := Dest as TGnvControlStyle;

  if Assigned(Style) then
  begin
    Style.FFlatRadius := FFlatRadius;
    Style.FFlatShowBorders := FFlatShowBorders;
    Style.FPlasticRadius := FPlasticRadius;
  end;

  inherited;
end;

constructor TGnvControlStyle.Create(AControl: TGnvControl);
begin
  inherited;
  FClassicShowBorders := True;
  FFlatRadius := 0;
  FFlatShowBorders := True;
  FPlasticRadius := 4;
  FPlasticShowBorders := True;
end;

function TGnvControlStyle.GetRadius(Theme: TGnvSystemTheme = gstAuto): Cardinal;
begin
  Theme := GnvSystemThemeDetect(Theme);
  Result := 0;

  case Theme of
    gstPlastic: Result := FPlasticRadius;
    gstFlat:    Result := FFlatRadius;
  end;
end;

function TGnvControlStyle.GetShowBorders(Theme: TGnvSystemTheme): Boolean;
begin
  Theme := GnvSystemThemeDetect(Theme);
  Result := True;

  case Theme of
    gstClassic: Result := FClassicShowBorders;
    gstPlastic: Result := FPlasticShowBorders;
    gstFlat:    Result := FFlatShowBorders;
  end;
end;

procedure TGnvControlStyle.SetClassicShowBorders(const Value: Boolean);
begin
	if ClassicShowBorders <> Value then
	begin
		FClassicShowBorders := Value;
		FControl.SafeRepaint;
	end;
end;

procedure TGnvControlStyle.SetFlatRadius(const Value: Cardinal);
begin
	if FFlatRadius <> Value then
	begin
		FFlatRadius := Value;
		FControl.SafeRepaint;
	end;
end;

procedure TGnvControlStyle.SetFlatShowBorders(const Value: Boolean);
begin
	if FFlatShowBorders <> Value then
	begin
		FFlatShowBorders := Value;
		FControl.SafeRepaint;
	end;
end;

procedure TGnvControlStyle.SetPlasticRadius(const Value: Cardinal);
begin
  if FPlasticRadius <> Value then
  begin
    FPlasticRadius := Value;
    FControl.SafeRepaint;
  end;
end;

procedure TGnvControlStyle.SetPlasticShowBorders(const Value: Boolean);
begin
	if PlasticShowBorders <> Value then
	begin
		FPlasticShowBorders := Value;
		FControl.SafeRepaint;
	end;
end;

{ TGnvControlColors }

procedure TGnvControlColors.AssignTo(Dest: TPersistent);
var
  Colors: TGnvControlColors;
begin
  Colors := nil;
  if Dest is TGnvControlColors then
    Colors := Dest as TGnvControlColors;

  if Assigned(Colors) then
  begin
    Colors.FClassicColor := FClassicColor;
    Colors.FFlatColor := FFlatColor;
    Colors.FPlasticColor1 := FPlasticColor1;
    Colors.FPlasticColor2 := FPlasticColor2;
  end
  else
    inherited;
end;

constructor TGnvControlColors.Create(AControl: TGnvControl);
begin
  FControl := AControl;
  FClassicColor := gscCtrl;
  FFlatColor := gscCtrlLight0250;
  FPlasticColor1 := gscCtrlLight0750;
  FPlasticColor2 := gscCtrl;
end;

procedure TGnvControlColors.SetClassicColor(const Value: TGnvSystemColor);
begin
  if FClassicColor <> Value then
  begin
    FClassicColor := Value;
    FControl.SafeRepaint;
  end;
end;

procedure TGnvControlColors.SetFlatColor(const Value: TGnvSystemColor);
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    FControl.SafeRepaint;
  end;
end;

procedure TGnvControlColors.SetPlasticColor1(const Value: TGnvSystemColor);
begin
  if FPlasticColor1 <> Value then
  begin
    FPlasticColor1 := Value;
    FControl.SafeRepaint;
  end;
end;

procedure TGnvControlColors.SetPlasticColor2(const Value: TGnvSystemColor);
begin
  if FPlasticColor2 <> Value then
  begin
    FPlasticColor2 := Value;
    FControl.SafeRepaint;
  end;
end;

{ TGnvComboBox }

procedure TGnvComboBox.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TGnvComboBox.CMMouseWheel(var Message: TCMMouseWheel);
begin
  // Need this handler to make mouse scroll work
end;

procedure TGnvComboBox.CMRelease(var Message: TMessage);
begin
  Free;
end;

procedure TGnvComboBox.CNDrawItem(var Message: TWMDrawItem);
var
  GroupItem: Boolean;
  State: TOwnerDrawState;
  ImageR: TRect;
  Indent, Offset, BktOffset, ImageIndex: Integer;
  Text, BktText: string;
begin
  with Message.DrawItemStruct^ do
  begin
    // Define item display parameters
    State := TOwnerDrawState(LongRec(itemState).Lo);
    if (itemState and ODS_DEFAULT) <> 0 then
      Include(State, odDefault);

    // Bind control canvas to items display canvas
    Canvas.Handle := hDC;
    Canvas.Font   := Font;
    Canvas.Brush  := Brush;
    TControlCanvas(Canvas).UpdateTextFlags;

    // Define group item
    GroupItem := (ItemID < Items.Count) and (Items.Objects[itemID] = FGroupObject) and FShowGroups;

    // Change group and no-group item indent
    if FShowGroups and DroppedDown then
    begin
      if GroupItem then
        Indent := 3
      else
        Indent := 11;
    end
    else
      Indent := 1;

    // Group items use bold font and cannot be selected
    if GroupItem then
      Canvas.Font.Style := [fsBold]
    else if odSelected in State then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
    end;

    if Assigned(FItemPaintProc) then
      FItemPaintProc(Canvas, State, itemID, Indent);

    Offset := 0;
    case Font.Size of
      8:
      begin
        Offset := 1;
      end;
      10:
      begin
        Offset := 0;
        rcItem.Top := rcItem.Top - 1;
        rcItem.Bottom := rcItem.Bottom + 1;
      end;
    end;

    // Paint element background and display text with precalculated offset
    Canvas.FillRect(rcItem);

    // Paint image
    if Assigned(FImages) then
    begin
      if Assigned(FGetImageIndexProc) then
        FGetImageIndexProc(Self, itemID, ImageIndex);

      if ImageIndex > -1 then
      begin
        Indent := Indent + FImages.Width + 3;

        ImageR := rcItem;
        ImageR.Right := ImageR.Left + FImages.Width;

        GnvDrawImage(Canvas, ImageR, FImages, ImageIndex);
      end;
    end;

    Text := Items[itemID];
    // Find text after bracket
    BktOffset := Pos('(', Text);
    if BktOffset > 0 then
    begin
      BktText := RightStr(Text, Length(Text) - BktOffset + 1);
      Text := LeftStr(Text, BktOffset - 1);
      BktOffset := Canvas.TextExtent(Text).cx;
    end;

    // Paint main text
    Canvas.TextOut(rcItem.Left + Indent, rcItem.Top + Offset, Text);
    // Paint text after bracket
    if BktOffset > 0 then
    begin
      Canvas.Font.Color := GnvBlendColors(Canvas.Font.Color, Canvas.Brush.Color, 95);
      Canvas.TextOut(rcItem.Left + Indent + BktOffset, rcItem.Top + Offset, BktText);
    end;

    // Paint focus rectangle
    {
    if (odFocused in State) and not GroupItem then
      DrawFocusRect(hDC, rcItem);
    }

    // Unbind canvas from control
    Canvas.Handle := 0;
  end;
end;

constructor TGnvComboBox.Create(AOwner: TComponent);
begin
  inherited;

  FGroupObject := TObject.Create;
  FListInstance := MakeObjectInstance(ListWndProc);
  FUpdating := False;
  FImages := nil;

  Style := csOwnerDrawFixed;
  DropDownCount := 10;
end;

destructor TGnvComboBox.Destroy;
begin
  FGroupObject.Free;
  inherited;
end;

procedure TGnvComboBox.EndUpdate;
begin
  FUpdating := False;
end;

function TGnvComboBox.ItemSelected(var Index: Integer): Boolean;
begin
  Result := True;
  FLastIndex := Index;
  if Assigned(FItemSelectedProc) then
    Result := FItemSelectedProc(FLastIndex);
  Index := FLastIndex;
end;

procedure TGnvComboBox.ListWndProc(var Message: TMessage);
var
  Index: Integer;
  Selected: Boolean;
begin
  if (Message.Msg = LB_GETCURSEL) and (FUpdating) then
  begin
    Message.Result := FLastIndex;
    Exit;
  end;

  Selected := (Message.Msg = WM_LBUTTONUP) or ((Message.Msg = WM_CHAR) and
    (TWMKey(Message).CharCode = VK_SPACE));

  if Selected then
  begin
    Index := CallWindowProcA(FDefListProc, FListHandle, LB_GETCURSEL, Message.WParam, Message.LParam);
    if (Index > -1) and (Items.Objects[Index] = FGroupObject) or not ItemSelected(Index) then
    begin
      ItemIndex := Index;
      Message.Result := 0;
      Exit;
    end;
  end;

  ComboWndProc(Message, FListHandle, FDefListProc);
end;

procedure TGnvComboBox.Select;
begin
  // Cannot select group item
  if FShowGroups and (ItemIndex > -1) and (Items.Objects[ItemIndex] = FGroupObject) then
    ItemIndex := ItemIndex + 1;
end;

procedure TGnvComboBox.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
  end;
end;

procedure TGnvComboBox.SetShowGroups(const Value: Boolean);
begin
  FShowGroups := Value;
end;

procedure TGnvComboBox.WndProc(var Message: TMessage);
var
  LWnd : HWND;
begin

  if Message.Msg = WM_CTLCOLORLISTBOX then
  begin
    // If the listbox hasn't been subclassed yet, do so...
    if (FListHandle = 0) then
    begin
      LWnd := Message.LParam;
      if (LWnd <> 0) and (LWnd <> FDropHandle) then
      begin
        // Save the listbox handle
        FListHandle := LWnd;
        FDefListProc := Pointer(GetWindowLong(FListHandle, GWL_WNDPROC));
        SetWindowLong(FListHandle, GWL_WNDPROC, Longint(FListInstance));
      end;
    end;
  end;

  inherited;
end;

end.

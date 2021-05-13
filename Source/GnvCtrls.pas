unit GnvCtrls;

interface

uses
  Classes, Controls, ComCtrls, Messages, Windows, StdCtrls, ExtCtrls,
  ActnList, Graphics, Menus, GDIPlus, Dialogs, ImgList;

type
  TGnvGlyphDirection = (gdUp, gdDown, gdLeft, gdRight);

  TGnvControl = class(TCustomControl)
  private
    FLeanTo: TAnchors;
    FCutOff: TAnchors;
    FColorRow: Integer;
    FColorFlow: Boolean;
    FUpdateCount: Integer;
    procedure SafeRepaint;
    function SafeTextExtent(const Text: string; AFont: TFont = nil): TSize;
    procedure SetColorRow(const Value: Integer);
    procedure SetCutOff(const Value: TAnchors);
    procedure SetLeanTo(const Value: TAnchors);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetColorFlow(const Value: Boolean);
  protected
    procedure Rebuild; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ColorFlow: Boolean read FColorFlow write SetColorFlow default True;
    property ColorRow: Integer read FColorRow write SetColorRow default 0;
    property CutOff: TAnchors read FCutOff write SetCutOff;
    property Height default 21;
    property LeanTo: TAnchors read FLeanTo write SetLeanTo;
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
    property CutOff: TAnchors read FCutOff write SetCutOff;
    property Delay: Integer read FDelay write FDelay default 1000;
    property Height;
    property Images: TImageList read FImages write FImages;
    property Interval: Integer read FInterval write SetInterval default 10;
    property LeanTo;
    property Width;
    property Visible;
  end;

  TGnvPanel = class(TCustomPanel)
  private
    FCutOff: TAnchors;
    FColorRow: Integer;
    FColorFlow: Boolean;
    FShowBorder: Boolean;
    FProcessing: Boolean;
    FProcInterval: Integer;
    FProcDelay: Integer;
    FProcImages: TImageList;
    procedure SafeRepaint;
    procedure SetCutOff(const Value: TAnchors);
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
    property Color;
    property ColorFlow: Boolean read FColorFlow write SetColorFlow default False;
    property ColorRow: Integer read FColorRow write SetColorRow default 0;
    property Constraints;
    property Ctl3D;
    property CutOff: TAnchors read FCutOff write SetCutOff;
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
    FCutOff: TAnchors;
    procedure SetResizeStyle(const Value: TResizeStyle);
    procedure SetCutOff(const Value: TAnchors);
  protected
		procedure Paint; override;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property CutOff: TAnchors read FCutOff write SetCutOff default [akLeft,
      akRight, akTop, akBottom];
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

	TGnvArrowType = (gatTriangle, gatChevron, gatClose, gatPlus);

	TGnvItemSizing = (
		gtsValue,
		gtsContent,
		gtsContentToValue,
		gtsMaxContent,
		gtsMaxContentToValue,
		gtsSpring,
		gtsSpringToValue
	);

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
    FDirection: TAnchorKind;
    FShowArrow: Boolean;
    FLeanTo: TAnchors;
    FSwitchGroup: Integer;
    FSelection: TGnvToolButtonSelection;
    FArrowType: TGnvArrowType;
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
    function GetHidden: Boolean;
    procedure SetDirection(const Value: TAnchorKind);
    procedure SetShowArrow(const Value: Boolean);
    procedure SetSelection(const Value: TGnvToolButtonSelection);
    procedure SetArrowType(const Value: TGnvArrowType);
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
	protected
    procedure AssignTo(Dest: TPersistent); override;
    property ActionLink: TGnvToolButtonActionLink read FActionLink write FActionLink;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;
    function GetActionLinkClass: TGnvToolButtonActionLinkClass; dynamic;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Click;
    property Down: Boolean read GetDown write SetDown;
    property GroupHidden: Boolean read GetGroupHidden;
    property Hidden: Boolean read GetHidden;
    property Selected: Boolean read GetSelected write SetSelected;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property ArrowType: TGnvArrowType read FArrowType write SetArrowType default gatTriangle;
    property Caption: string read GetCaption write SetCaption stored IsCaptionStored;
    property Checked: Boolean read FChecked write SetChecked stored IsCheckedStored default False;
    property Direction: TAnchorKind read FDirection write SetDirection default akBottom;
		property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex default 0;
		property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    // ParentImages should be read before Images to load images correctly
		property ParentImages: Boolean read FParentImages write SetParentImages default True;
		property Images: TCustomImageList read GetImages write SetImages stored IsImagesStored;
    property Hint: string read FHint write FHint stored IsHintStored;
    property Name: string read FName write FName stored IsNameStored;
    property Kind: TGnvToolButtonKind read FKind write SetKind;
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
    property Size: Integer read FSize write SetSize default 175;
		property Sizing: TGnvItemSizing read FSizing write SetSizing default gtsContentToValue;
    property Style: TGnvToolButtonStyle read FStyle write SetStyle;
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

  TGnvButtonPadding = class(TMargins)
  public
    constructor Create(Control: TControl); override;
  published
    property Left default 2;
    property Top default 1;
    property Right default 2;
    property Bottom default 1;
  end;

  TGnvToolBar = class(TGnvProcessControl)
  private
    FButtons: TGnvToolButtons;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FButtonHeight: Integer;
    FItemIndex: Integer;
    FDownIndex: Integer;
    FAutoHint: Boolean;
    FSwitchGroup: Integer;
    FButtonPadding: TGnvButtonPadding;
    FGroupIndex: Integer;
    function GetSwitchGroup: Integer;
    function GetButtonRect(const Index: Integer): TRect;
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
		procedure SetButtonPadding(const Value: TGnvButtonPadding);
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
    property ButtonPadding: TGnvButtonPadding read FButtonPadding write SetButtonPadding;
    property Buttons: TGnvToolButtons read FButtons write SetButtons;
    property Color;
    property ColorRow default -1;
    property Cursor;
    property CutOff;
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
    property ShowHint;
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
    FDirection: TAnchorKind;
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
    procedure AddFlick(Item: TGnvTab);
    procedure DeleteFlick(Item: TGnvTab);
    procedure DropdownControlWndProc(var Message: TMessage);
    function GetButtonEnabled(Kind: TGnvTabBarButtonKind): Boolean;
    function GetButtonRect(const Kind: TGnvTabBarButtonKind): TRect;
    function CreateColorFlowBrush(Enabled: Boolean = True): IGPBrush;
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
    procedure SetLeanTo(const Value: TAnchors);
    procedure SetImages(const Value: TImageList);
    procedure SetDirection(const Value: TAnchorKind);
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
    property Buttons: TGnvTabBarButtons read FButtons write SetButtons default [gtbShift, gtbPrevious, gtbNext];
    property ButtonWidth: Integer read FButtonWidth write FButtonWidth default 21;
    property CloseKind: TGnvTabBarCloseKind read FCloseKind write SetCloseKind default gckPersonal;
    property Color;
    property ColorRow;
    property CutOff;
    property Direction: TAnchorKind read FDirection write SetDirection default akBottom;
    property DropAlignment: TAlignment read FDropAlignment write SetDropAlignment default taLeftJustify;
    property DropdownControl: TWinControl read FDropdownControl write SetDropdownControl;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property Enabled;
    property Font;
    property Indent: Integer read FIndent write SetIndent default 0;
    property Images: TImageList read FImages write SetImages;
    property LeanTo;
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
    property Sizing: TGnvItemSizing read FSizing write SetSizing default gtsContent;
    property StripSize: Integer read FStripSize write SetStripSize default 2;
    property Style: TGnvTabBarStyle read FStyle write SetStyle default gtsTabs;
    property TabAlignment: TAlignment read FTabAlignment write SetTabAlignment default taLeftJustify;
    property TabIndent: Integer read FTabIndent write SetTabIndent default -1;
    property TabRadius: Integer read FTabRadius write SetTabRadius default 4;
    property TabMinSize: Integer read FTabMinSize write SetTabMinSize default 0;
    property TabSize: Integer read FTabSize write SetTabSize default 150;
    property TabStop;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property Visible;
  end;

  TGnvLabel = class(TLabel)
  private
    FShowArrow: Boolean;
    FArrowDirection: TGnvGlyphDirection;
    procedure SafeRepaint;
    procedure SetShowArrow(const Value: Boolean);
    procedure SetArrowDirection(const Value: TGnvGlyphDirection);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ArrowDirection: TGnvGlyphDirection read FArrowDirection write
      SetArrowDirection default gdDown;
    property ShowArrow: Boolean read FShowArrow write SetShowArrow default False;
  end;

var
  ToolMenuHook: HHOOK;
  MenuToolButton: TGnvToolButton;

const
  GnvCloseWidth = 9;
  GnvArrowWidth = 7;
  GnvChevronWidth = 11;

  GnvTabBarButtonKindCount = 11;

procedure Register;

function GnvBlendColors(Color1, Color2: TColor; Value: Byte = 127): TColor;
function ColorToGPColor(Color: TColor; Alpha: Byte = 255): TGPColor; inline;

procedure GnvAddFrame(Path: IGPGraphicsPath; Rect: TGPRect; Radius: Integer;
  const LeanTo: TAnchors = []; const CutOff: TAnchors = []; Filled: Boolean = False);
procedure GnvDrawTriangle(Canvas: TCanvas; Rect: TRect; Direction: TAnchorKind;
	Enabled: Boolean = True);
procedure GnvDrawClose(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
procedure GnvDrawImage(Canvas: TCanvas; Rect: TRect; Images: TCustomImageList;
  Index: Integer);
procedure GnvDrawText(Canvas: TCanvas; Rect: TRect; Text: string; Format: UINT;
  Enabled: Boolean = True; Ghosted: Boolean = False);
procedure GnvDrawClassicPanel(Canvas: TCanvas; Rect: TRect; CutOff: TAnchors = [];
  Down: Boolean = False; Color: TColor = clBtnFace);
procedure GnvDrawPlus(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
procedure GnvDrawChevron(Canvas: TCanvas; Rect: TRect; Direction: TAnchorKind;
  Enabled: Boolean = True); overload;
procedure GnvDrawChevron(Canvas: TCanvas; Rect: TRect; Direction: TGnvGlyphDirection;
  Enabled: Boolean = True); overload;
function GnvGetOppositeAnchor(Direction: TAnchorKind): TAnchorKind;

function GnvGetColorFlowColor(Row: Integer): TColor;
function GnvGetBorderColor: TColor; inline;

function ToolMenuGetMsgHook(Code: Integer; WParam: LongInt; LParam: LongInt): LongInt; stdcall;

implementation

uses
  Types, SysUtils, UxTheme, Math, DateUtils, Forms, StdActns;

procedure Register;
begin
  RegisterComponents('GnvCtrls', [TGnvToolBar, TGnvTabBar, TGnvPanel,
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

function ColorToGPColor(Color: TColor; Alpha: Byte = 255): TGPColor;
begin
  Result := TGPColor.CreateFromColorRef(ColorToRGB(Color));
  Result.A := Alpha;
end;

procedure GnvAddFrame(Path: IGPGraphicsPath; Rect: TGPRect; Radius: Integer;
  const LeanTo: TAnchors = []; const CutOff: TAnchors = []; Filled: Boolean = False);
var
  Offset: Integer;
  R: TRect;
begin
  R.Left := Rect.Left;
  R.Top := Rect.Top;
  if not Filled then
  begin
    R.Right := Rect.Right - 1;
    R.Bottom := Rect.Bottom - 1;
  end;

  if (akBottom in LeanTo) or (akLeft in LeanTo) or (Radius <= 0) then
    Offset := 0
  else
    Offset := Radius + 1;

  if (akLeft in LeanTo) or (akTop in LeanTo) or (Radius <= 0) then
  begin
    if not ((Offset = 0) and (akLeft in CutOff)) or Filled then
      Path.AddLine(R.Left, R.Bottom - Offset, R.Left, R.Top)
    else
      Path.StartFigure;
    Offset := 0;
  end
  else
  begin
    Path.AddLine(R.Left, R.Bottom - Offset, R.Left, R.Top + Radius + 1);
    Path.AddArc(R.Left, R.Top, Radius*2, Radius*2, 180, 90);
    Offset := Radius + 1;
  end;

  if (akTop in LeanTo) or (akRight in LeanTo) or (Radius <= 0) then
  begin
    if not ((Offset = 0) and (akTop in CutOff)) or Filled then
      Path.AddLine(R.Left + Offset, R.Top, R.Right, R.Top)
    else
      Path.StartFigure;
    Offset := 0;
  end
  else
  begin
    Path.AddLine(R.Left + Offset, R.Top, R.Right - Radius - 1, R.Top);
    Path.AddArc(R.Right - Radius*2, R.Top, Radius*2, Radius*2, 270, 90);
    Offset := Radius + 1;
  end;

  if (akRight in LeanTo) or (akBottom in LeanTo) or (Radius <= 0) then
  begin
    if not ((Offset = 0) and (akRight in CutOff)) or Filled then
      Path.AddLine(R.Right, R.Top + Offset, R.Right, R.Bottom)
    else
      Path.StartFigure;
    Offset := 0;
  end
  else
  begin
    Path.AddLine(R.Right, R.Top + Offset, R.Right, R.Bottom - Radius - 1);
    Path.AddArc(R.Right - Radius*2, R.Bottom - Radius*2, Radius*2, Radius*2, 0, 90);
    Offset := Radius + 1;
  end;

  if (akBottom in LeanTo) or (akLeft in LeanTo) or (Radius <= 0) then
  begin
    if not ((Offset = 0) and (akBottom in CutOff)) or Filled then
      Path.AddLine(R.Right - Offset, R.Bottom, R.Left, R.Bottom)
    else
      Path.StartFigure;
  end
  else
  begin
    Path.AddLine(R.Right - Offset, R.Bottom, R.Left + Radius + 1, R.Bottom);
    Path.AddArc(R.Left, R.Bottom - Radius*2, Radius*2, Radius*2, 90, 90);
  end;
end;

procedure GnvDrawTriangle(Canvas: TCanvas; Rect: TRect; Direction: TAnchorKind;
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

  if Screen.PixelsPerInch >= 120 then
  begin
    case Direction of
      akLeft:
      begin
        Points[0] := Point(X + 2, Y - 4);
        Points[1] := Point(X + 2, Y + 4);
        Points[2] := Point(X - 2, Y);
      end;
      akTop:
      begin
        Points[0] := Point(X - 4, Y + 2);
        Points[1] := Point(X + 4, Y + 2);
        Points[2] := Point(X, Y - 2);
      end;
      akRight:
      begin
        Points[0] := Point(X - 2, Y - 4);
        Points[1] := Point(X - 2, Y + 4);
        Points[2] := Point(X + 2, Y);
      end;
      akBottom:
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
      akLeft:
      begin
        Points[0] := Point(X + 1, Y - 3);
        Points[1] := Point(X + 1, Y + 3);
        Points[2] := Point(X - 2, Y);
      end;
      akTop:
      begin
        Points[0] := Point(X - 3, Y + 1);
        Points[1] := Point(X + 3, Y + 1);
        Points[2] := Point(X, Y - 2);
      end;
      akRight:
      begin
        Points[0] := Point(X - 1, Y - 3);
        Points[1] := Point(X - 1, Y + 3);
        Points[2] := Point(X + 2, Y);
      end;
      akBottom:
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
        akLeft, akRight:
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

      GPBrush := TGPSolidBrush.Create(ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 180), Alpha));

      GPPen0 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 193), Alpha));
      GPPen1 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 223), Alpha));
      GPPen2 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 193), Alpha));
      GPPen3 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
      GPPen4 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 63), Alpha));
      GPPen5 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnHighlight, clWhite, 127), Alpha));

      GP.FillPolygon(GPBrush, GPPoints);
      case Direction of
        akLeft:
        begin
          GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
          GP.DrawLine(GPPen4, GPPoints[1], GPPoints[2]);
          GP.DrawLine(GPPen0, GPPoints[2], GPPoints[0]);

          GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1),
  					TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1));
        end;
        akTop:
        begin
          GP.DrawLine(GPPen4, GPPoints[0], GPPoints[1]);
          GP.DrawLine(GPPen1, GPPoints[1], GPPoints[2]);
          GP.DrawLine(GPPen1, GPPoints[2], GPPoints[0]);
          GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[0].X, GPPoints[0].Y + 1),
            TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1));
        end;
        akRight:
        begin
          GP.DrawLine(GPPen2, GPPoints[0], GPPoints[1]);
          GP.DrawLine(GPPen4, GPPoints[1], GPPoints[2]);
          GP.DrawLine(GPPen0, GPPoints[2], GPPoints[0]);

          GP.DrawLine(GPPen5, TGPPointF.Create(GPPoints[1].X, GPPoints[1].Y + 1),
            TGPPointF.Create(GPPoints[2].X, GPPoints[2].Y + 1));
        end;
        akBottom:
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

procedure GnvDrawClose(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
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
      if Screen.PixelsPerInch >= 120 then
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
        GPBrush := TGPSolidBrush.Create(ColorToGPColor(clBtnText))
      else
        GPBrush := TGPSolidBrush.Create(ColorToGPColor(clGrayText));

      GP.FillPolygon(GPBrush, GPPointsF1);
      GP.FillPolygon(GPBrush, GPPointsF2);
    end
    else
    begin
      if Screen.PixelsPerInch >= 120 then
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

      GPBrush := TGPSolidBrush.Create(ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 180), Alpha));

      GPPen0 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 193), Alpha));
      GPPen1 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 223), Alpha));
      GPPen2 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 193), Alpha));
      GPPen3 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
      GPPen4 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 63), Alpha));
      GPPen5 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnHighlight, clWhite, 127), Alpha));

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
      if Screen.PixelsPerInch >= 120 then
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

procedure GnvDrawClassicPanel(Canvas: TCanvas; Rect: TRect; CutOff: TAnchors = [];
  Down: Boolean = False; Color: TColor = clBtnFace);
begin
  with Canvas do
  begin
    if akTop in CutOff then Rect.Top := Rect.Top - 1;
    if akLeft in CutOff then Rect.Left := Rect.Left - 1;
    if akBottom in CutOff then Rect.Bottom := Rect.Bottom + 1;
    if akRight in CutOff then Rect.Right := Rect.Right + 1;

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

procedure GnvDrawPlus(Canvas: TCanvas; Rect: TRect; Enabled: Boolean = True);
var
  X, Y, I, Alpha: Integer;
  OldPenStyle: TPenStyle;
  OldBrushStyle: TBrushStyle;
  OldBrushColor: TColor;
  Points: array [0..11] of TPoint;
  GP: IGPGraphics;
  GPBrush: IGPBrush;
  GPPoints: array [0..11] of TGPPoint;
  GPPen0, GPPen1, GPPen2, GPPen3, GPPen4, GPPen5: IGPPen;
begin
  X := Rect.Left + (Rect.Right - Rect.Left) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2;


  if Screen.PixelsPerInch >= 120 then
  begin
    Points[0]   := Point(X - 5, Y + 1);
    Points[1]   := Point(X - 5, Y - 1);
    Points[2]   := Point(X - 1, Y - 1);
    Points[3]   := Point(X - 1, Y - 5);
    Points[4]   := Point(X + 1, Y - 5);
    Points[5]   := Point(X + 1, Y - 1);
    Points[6]   := Point(X + 5, Y - 1);
    Points[7]   := Point(X + 5, Y + 1);
    Points[8]   := Point(X + 1, Y + 1);
    Points[9]   := Point(X + 1, Y + 5);
    Points[10]  := Point(X - 1, Y + 5);
    Points[11]  := Point(X - 1, Y + 1);
  end
  else
  begin
    Points[0]   := Point(X - 4, Y + 1);
    Points[1]   := Point(X - 4, Y - 1);
    Points[2]   := Point(X - 1, Y - 1);
    Points[3]   := Point(X - 1, Y - 4);
    Points[4]   := Point(X + 1, Y - 4);
    Points[5]   := Point(X + 1, Y - 1);
    Points[6]   := Point(X + 4, Y - 1);
    Points[7]   := Point(X + 4, Y + 1);
    Points[8]   := Point(X + 1, Y + 1);
    Points[9]   := Point(X + 1, Y + 4);
    Points[10]  := Point(X - 1, Y + 4);
    Points[11]  := Point(X - 1, Y + 1);
  end;

  if (Win32MajorVersion >= 5) and IsAppThemed and
    not ((Win32MajorVersion >= 6) and (Win32MinorVersion >= 2)) then
  begin
    GP := TGPGraphics.Create(Canvas.Handle);
    GP.SmoothingMode := SmoothingModeAntiAlias;

    for I := 0 to Length(Points) - 1 do
      GPPoints[I] := TGPPoint.Create(Points[I].X, Points[I].Y);

    if Enabled then
      Alpha := 255
    else
      Alpha := 95;

    GPBrush := TGPSolidBrush.Create(ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 193), Alpha));

    GPPen0 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 193), Alpha));
    GPPen1 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 223), Alpha));
    GPPen2 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 193), Alpha));
    GPPen3 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
    GPPen4 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 96), Alpha));
    GPPen5 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnHighlight, clWhite, 127), Alpha));

    GP.FillPolygon(GPBrush, GPPoints);

    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints[11].X, GPPoints[11].Y + 1),
      TGPPoint.Create(GPPoints[0].X, GPPoints[0].Y + 1));

    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints[7].X, GPPoints[7].Y + 1),
      TGPPoint.Create(GPPoints[8].X, GPPoints[8].Y + 1));

    GP.DrawLine(GPPen5, TGPPoint.Create(GPPoints[9].X, GPPoints[9].Y + 1),
      TGPPoint.Create(GPPoints[10].X, GPPoints[10].Y + 1));

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
  end
  else
    with Canvas do
    begin
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

procedure GnvDrawChevron(Canvas: TCanvas; Rect: TRect; Direction: TAnchorKind;
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
      akLeft:
      begin
        GPPoints[0] := TGPPointF.Create(X + 2, Y - 3);
        GPPoints[1] := TGPPointF.Create(X - 1, Y);
        GPPoints[2] := TGPPointF.Create(X + 2, Y + 3);
        GPPoints[3] := TGPPointF.Create(X, Y + 3);
        GPPoints[4] := TGPPointF.Create(X - 3, Y);
        GPPoints[5] := TGPPointF.Create(X, Y - 3);
      end;
      akTop:
      begin
        GPPoints[0] := TGPPointF.Create(X - 3, Y + 2);
        GPPoints[1] := TGPPointF.Create(X, Y - 1);
        GPPoints[2] := TGPPointF.Create(X + 3, Y + 2);
        GPPoints[3] := TGPPointF.Create(X + 3, Y);
        GPPoints[4] := TGPPointF.Create(X, Y - 3);
        GPPoints[5] := TGPPointF.Create(X - 3, Y);
      end;
      akRight:
      begin
        GPPoints[0] := TGPPointF.Create(X - 2, Y - 3);
        GPPoints[1] := TGPPointF.Create(X + 1, Y);
        GPPoints[2] := TGPPointF.Create(X - 2, Y + 3);
        GPPoints[3] := TGPPointF.Create(X, Y + 3);
        GPPoints[4] := TGPPointF.Create(X + 3, Y);
        GPPoints[5] := TGPPointF.Create(X, Y - 3);
      end;
      akBottom:
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

    GPBrush := TGPSolidBrush.Create(ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 193), Alpha));

    GPPen0 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBlack, 207), Alpha));
    GPPen1 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 223), Alpha));
    GPPen2 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 255), Alpha));
    GPPen3 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 143), Alpha));
    GPPen4 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnShadow, clBtnFace, 63), Alpha));
    GPPen5 := TGPPen.Create(ColorToGPColor(GnvBlendColors(clBtnHighlight, clWhite, 143), Alpha));

    GP.FillPolygon(GPBrush, GPPoints);

    case Direction of
      akLeft:
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
      akTop:
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
      akRight:
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
      akBottom:
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
        akLeft:
        begin
          Points[0] := Point(X - 3, Y);
          Points[1] := Point(X, Y - 3);
          Points[2] := Point(X + 3, Y - 3);
          Points[3] := Point(X, Y);
          Points[4] := Point(X + 3, Y + 4);
          Points[5] := Point(X, Y + 4);
        end;
        akTop:
        begin
          Points[0] := Point(X - 3, Y + 1);
          Points[1] := Point(X, Y - 3);
          Points[2] := Point(X + 4, Y + 1);
          Points[3] := Point(X + 4, Y + 4);
          Points[4] := Point(X, Y);
          Points[5] := Point(X - 3, Y + 4);
        end;
        akRight:
        begin
          Points[0] := Point(X + 4, Y);
          Points[1] := Point(X + 1, Y - 3);
          Points[2] := Point(X - 2, Y - 3);
          Points[3] := Point(X + 1, Y);
          Points[4] := Point(X - 3, Y + 4);
          Points[5] := Point(X, Y + 4);
        end;
        akBottom:
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

procedure GnvDrawChevron(Canvas: TCanvas; Rect: TRect; Direction: TGnvGlyphDirection;
  Enabled: Boolean = True);
var
  Anchor: TAnchorKind;
begin
  case Direction of
    gdUp:     Anchor := akTop;
    gdDown:   Anchor := akBottom;
    gdLeft:   Anchor := akLeft;
    gdRight:  Anchor := akRight;
  end;
  GnvDrawChevron(Canvas, Rect, Anchor, Enabled);
end;

procedure GnvDrawText(Canvas: TCanvas; Rect: TRect; Text: string; Format: UINT;
  Enabled: Boolean = True; Ghosted: Boolean = False);
var
  OldStyle: TBrushStyle;
	OldColor: TColor;
	OldSize: Integer;
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
	DrawText(Canvas.Handle, PWideChar(Text), Length(Text), Rect, Format);
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

function GnvGetOppositeAnchor(Direction: TAnchorKind): TAnchorKind;
begin
  case Direction of
    akLeft:   Result := akRight;
    akTop:    Result := akBottom;
    akRight:  Result := akLeft;
    akBottom: Result := akTop;
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

function GnvGetBorderColor: TColor;
begin
  Result := GnvBlendColors(clBtnFace, clBtnShadow, 63);
end;

{ TGnvControl }

procedure TGnvControl.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

constructor TGnvControl.Create(AOwner: TComponent);
begin
  inherited;
  // All GnvControls are double buffered by default
  DoubleBuffered := True;
  Height := 21;
  Width := 185;
  FColorRow := 0;
  FColorFlow := True;
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

procedure TGnvControl.SetColorFlow(const Value: Boolean);
begin
  if FColorFlow <> Value then
  begin
    FColorFlow := Value;
    SafeRepaint;
  end;
end;

procedure TGnvControl.SetColorRow(const Value: Integer);
begin
  if FColorRow <> Value then
  begin
    FColorRow := Value;
    SafeRepaint;
  end;
end;

procedure TGnvControl.SetCutOff(const Value: TAnchors);
begin
  if FCutOff <> Value then
  begin
    FCutOff := Value;
    SafeRepaint;
  end;
end;

procedure TGnvControl.SetLeanTo(const Value: TAnchors);
begin
  if FLeanTo <> Value then
  begin
    FLeanTo := Value;
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
  if akLeft in FCutOff then Rect.Left := Rect.Left - 1;
  if akTop in FCutOff then Rect.Top := Rect.Top - 1;
  if akRight in FCutOff then Rect.Right := Rect.Right + 1;
  if akBottom in FCutOff then Rect.Bottom := Rect.Bottom + 1;
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
        ColorToGPColor(GnvGetColorFlowColor(FColorRow)),
        ColorToGPColor(GnvGetColorFlowColor(FColorRow + 1)), LinearGradientModeVertical)
    else
      Brush := TGPSolidBrush.Create(ColorToGPColor(Color));

    GP.FillRectangle(Brush, GPR);

    if FShowBorder then
    begin
      BorderPen := TGPPen.Create(ColorToGPColor(GnvGetBorderColor));

      BorderPath := TGPGraphicsPath.Create;
      GnvAddFrame(BorderPath, GPR, 0, FCutOff, FCutOff);

      GP.DrawPath(BorderPen, BorderPath);
    end;
  end
  else if FShowBorder then
    GnvDrawClassicPanel(Canvas, R, FCutOff)
  else
    inherited;

  if ShowCaption and (Caption <> '') then
  begin
    Canvas.Font := Self.Font;
    GnvDrawText(Canvas, ClientRect, Caption, DT_SINGLELINE or DT_VCENTER or DT_CENTER);
  end;
end;

procedure TGnvPanel.SetCutOff(const Value: TAnchors);
begin
  if FCutOff <> Value then
  begin
    FCutOff := Value;
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
  FVisible := True;
  FEnabled := True;
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FFont.Assign((Collection as TGnvToolButtons).FToolBar.Font);
  FImageIndex := -1;
  FHint := '';
  FName := '';
  FTag := 0;
  FHidden := False;
  FGroupIndex := 0;
  FDirection := akBottom;
  FShowArrow := False;
  FShowChecked := True;
  FLeanTo := [];
  FSwitchGroup := -1;
  FSelection := gtlIndividual;
  FArrowType := gatTriangle;
  FParentFont := True;
	FEdit := nil;
	FSizing := gtsContentToValue;
	FSize := 175;
	FPopupMenu := nil;
	FImages := nil;
	FParentImages := True;
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
		Button.FArrowType			:= FArrowType;
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

function TGnvToolButton.GetGroupHidden: Boolean;
begin
  Result := (FGroupIndex <> GetToolBar.FGroupIndex) and
    (GetToolBar.FGroupIndex > -1) and (FGroupIndex > -1);
end;

function TGnvToolButton.GetHidden: Boolean;
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

procedure TGnvToolButton.SetArrowType(const Value: TGnvArrowType);
begin
  if FArrowType <> Value then
  begin
    FArrowType := Value;
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

procedure TGnvToolButton.SetDirection(const Value: TAnchorKind);
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
  Paddings: Integer;
begin
  Result := True;
  Paddings := Padding.Top + Padding.Bottom;
  // Adding borders to paddings
  if not (akBottom in FCutOff) then Inc(Paddings);
  if not (akTop in FCutOff) then Inc(Paddings);

  if Assigned(FImages) and (FImages.Height + 10 > FButtonHeight + Paddings) then
    NewHeight := FImages.Height + 10
  else
    NewHeight := FButtonHeight + Paddings;
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
  FButtons := TGnvToolButtons.Create(Self);
  FDownIndex := -1;
  FItemIndex := -1;
  FAutoHint := False;
  ControlStyle := ControlStyle + [csOpaque];
  FSwitchGroup := - 1;
  FColorRow := -1;
  FButtonPadding := TGnvButtonPadding.Create(nil);
  FGroupIndex := -1;
	FUpdateCount := 0;
end;

destructor TGnvToolBar.Destroy;
begin
  FButtons.Free;
  FButtonPadding.Free;
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

function TGnvToolBar.GetButtonRect(const Index: Integer): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  with FButtons[Index] do if not GetHidden then
  begin
    Result := ClientRect;
    Result.Left := FButtons[Index].FLeft;
    Result.Right := Result.Left + FButtons[Index].FWidth;
    Result.Top := Result.Top + Padding.Top;
    Result.Bottom := Result.Top + FButtonHeight;
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
  I: Integer;
  R: TRect;
  GP: IGPGraphics;
  BorderPath, HighlightPath: IGPGraphicsPath;
  BorderPen, HighlightPen: IGPPen;
  Brush, HighlightBrush: IGPBrush;
  GPR: TGPRect;
begin
  if (Width <= 0) or (Height <= 0) then Exit;

  R := ClientRect;

  if ((Win32MajorVersion >= 5) and IsAppThemed) or (FColorRow < 0) then
  begin
    GPR.Initialize(R);

    GP := TGPGraphics.Create(Canvas.Handle);

    case FColorRow of
      0:    Brush := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(clBtnHighlight),
              ColorToGPColor(GnvBlendColors(clBtnHighlight, clBtnFace, 191)), LinearGradientModeVertical);
      1:    Brush := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(GnvBlendColors(clBtnHighlight, clBtnFace, 191)),
              ColorToGPColor(clBtnFace), LinearGradientModeVertical);
      2:    Brush := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(clBtnFace),
              ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 241)),
              LinearGradientModeVertical);
      else
            Brush := TGPSolidBrush.Create(ColorToGPColor(Color));
    end;

    BorderPen := TGPPen.Create(ColorToGPColor(GnvGetBorderColor));

    BorderPath := TGPGraphicsPath.Create;
    GnvAddFrame(BorderPath, GPR, 0, FCutOff, FCutOff);

    GP.FillRectangle(Brush, GPR);
    GP.DrawPath(BorderPen, BorderPath);
  end
  else
    GnvDrawClassicPanel(Canvas, R, FCutOff);

  // Paint toolbar buttons
  for I := 0 to FButtons.Count - 1 do
    PaintButton(I);
end;

procedure TGnvToolBar.PaintButton(const Index: Integer);
const
  BorderSize = 1;
  BorderRadius = 3;
var
  R, ButtonRect: TRect;
  IsImageLast: Boolean;
  LeanTo: TAnchors;
  GP: IGPGraphics;
  GPPath, GPPath2, HighlightPath: IGPGraphicsPath;
  GPPen, HighlightPen: IGPPen;
  GPBrush: IGPBrush;
	GPR: TGPRect;
	OldFont: TFont;
begin
  with FButtons[Index] do if not GetHidden then
  begin
    if (FKind = gtkSeparator) and (FCaption = '') then Exit;

    ButtonRect := GetButtonRect(Index);
		R := ButtonRect;
		// This should be done for any drawn button before GdiPlus procedures
		// to avoid font from one button to expand to other buttons
		Canvas.Font := FFont;

    { Button background }

    if not (FKind in [gtkSeparator, gtkLabel, gtkLink]) and
		  ((((FSelection = gtlIndividual) and GetSelected) or GetDown) and FEnabled) or
      ((FSelection = gtlSwitchGroup) and (FSwitchGroup > -1) and
      (GetSwitchGroup = FSwitchGroup)) or (FKind = gtkEdit) then
		begin
		  if (Win32MajorVersion >= 5) and IsAppThemed then
			begin
  			GP := TGPGraphics.Create(Canvas.Handle);
  			GP.SmoothingMode := SmoothingModeAntiAlias;

  			GPR.InitializeFromLTRB(R.Left, R.Top + BorderSize, R.Right,
          R.Bottom + BorderSize);

  			GPPath := TGPGraphicsPath.Create;
				GPPath2 := TGPGraphicsPath.Create;

  			LeanTo := FLeanTo;
  			if not GetDown then
  			begin
  			  GnvAddFrame(GPPath, GPR, BorderRadius, [], []);
  			  GPPen := TGPPen.Create(ColorToGPColor(clBtnHighLight, 159));
  			  GP.DrawPath(GPPen, GPPath);
  			  GPPath.Reset;
  			end
  			else if Assigned(FDropdownMenu) then
					LeanTo := LeanTo + [akBottom];

        if (Win32MajorVersion >= 6) and (Win32MinorVersion >= 2) then
        begin
    			GnvAddFrame(GPPath, TGPRect.Create(R), 0, LeanTo, []);
    			GnvAddFrame(GPPath2, TGPRect.Create(R), 0, LeanTo, [], True);

          if FKind = gtkEdit then
          begin
     			  GPPen := TGPPen.Create(ColorToGPColor(clBtnShadow, 159));
            GPBrush := TGPSolidBrush.Create(ColorToGPColor(FEdit.Color));
            GP.FillPath(GPBrush, GPPath2);
          end
          else if GetDown then
          begin
     			  GPPen := TGPPen.Create(ColorToGPColor(clHighlight));
            GPBrush := TGPSolidBrush.Create(ColorToGPColor(clHighlight, 93));
            GP.FillPath(GPBrush, GPPath2);
          end
          else
          begin
     			  GPPen := TGPPen.Create(ColorToGPColor(clHighlight, 159));
            GPBrush := TGPSolidBrush.Create(ColorToGPColor(clHighlight, 31));
            GP.FillPath(GPBrush, GPPath2);
          end;
        end
        else
        begin
          // Get larger radius to avoid line collisions
    			GnvAddFrame(GPPath, TGPRect.Create(R), BorderRadius + 1, LeanTo, []);
    			GnvAddFrame(GPPath2, TGPRect.Create(R), BorderRadius + 1, LeanTo, [], True);

  			  GPPen := TGPPen.Create(ColorToGPColor(clBtnShadow, 159));

          if FKind = gtkEdit then
          begin
            GPBrush := TGPSolidBrush.Create(ColorToGPColor(FEdit.Color));
            GP.FillPath(GPBrush, GPPath2);
          end
          else if GetDown then
          begin
            GPBrush := TGPPathGradientBrush.Create(GPPath);
            (GPBrush as IGPPathGradientBrush).CenterColor := ColorToGPColor(clBtnFace, 79);
            (GPBrush as IGPPathGradientBrush).SetSurroundColors([ColorToGPColor(clBtnShadow, 79)]);
              GP.FillPath(GPBrush, GPPath2);
          end;
        end;

				GP.DrawPath(GPPen, GPPath);
			end
		  else if FKind = gtkEdit then
        GnvDrawClassicPanel(Canvas, R, [], True, FEdit.Color)
      else
  			GnvDrawClassicPanel(Canvas, R, [], GetDown);
		end;

		R.Left := R.Left + 3;

		if FKind = gtkSeparator then
			GnvDrawText(Canvas, R, FCaption, DT_LEFT or DT_VCENTER or
				DT_SINGLELINE or DT_HIDEPREFIX or DT_END_ELLIPSIS, False)
		else
		begin
		  IsImageLast := False;

			if (FStyle in [gtsImage, gtsImageText]) and (FButtons[Index].GetImages <> nil)
				and ((FImageIndex > -1) or (FProcIndex > -1)) then
  	  begin
	  		R.Right := R.Left + FButtons[Index].GetImages.Width;
  			if (FProcIndex > -1) and Assigned(FProcImages) then
  			  GnvDrawImage(Canvas, R, FProcImages, FProcIndex)
			  else
  			begin
  			  if FEnabled then
						GnvDrawImage(Canvas, R, FButtons[Index].GetImages, FImageIndex)
  			  else if Assigned(GetToolBar.FDisabledImages) then
  		  		GnvDrawImage(Canvas, R, GetToolBar.FDisabledImages, FImageIndex);
  			end;
        R.Left := R.Right + 3;
		  	IsImageLast := True;
		  end;

		  if (FStyle in [gtsText, gtsImageText]) and (FCaption <> '') and
        (FKind <> gtkEdit) then
		  begin
  			if not IsImageLast then R.Left := R.Left + 2;
				R.Right := R.Left + FTextWidth;

				if FKind = gtkLink then
				begin
					Canvas.Font.Color := clHotLight;
					if GetSelected then
          	Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
				end;

				GnvDrawText(Canvas, R, FCaption, DT_LEFT or DT_VCENTER or
					DT_SINGLELINE or DT_HIDEPREFIX or DT_END_ELLIPSIS, FEnabled);
				R.Left := R.Right + 3;
		  end;

		  if FShowArrow then
		  begin
	  		R.Right := R.Left + 11;
  			if GetDown and Assigned(FDropdownMenu) then
  			  GnvDrawTriangle(Canvas, R, akBottom)
  			else
  			  case FArrowType of
    				gatTriangle:  GnvDrawTriangle(Canvas, R, FDirection);
    				gatChevron:   GnvDrawChevron(Canvas, R, FDirection);
    				gatClose:     GnvDrawClose(Canvas, R);
    				gatPlus:      GnvDrawPlus(Canvas, R);
  			  end
  	  end;
		end;
  end;
end;

procedure TGnvToolBar.Rebuild;
var
	I, StartLeft, ContentWidth, SpringCount, FirstSpringIndex, Gutter,
		SwitchGroup, Offset: Integer;
  IsImageLast: Boolean;
  TextExtent: TSize;
  LastKind: TGnvToolButtonKind;
  LastButton: TGnvToolButton;
begin
  inherited;

  // Hiding one of neighboring separators
  LastKind := gtkSeparator;
  for I := 0 to FButtons.Count - 1 do
    with FButtons[I] do if FVisible and not GetGroupHidden then
    begin
      FHidden := (FKind = gtkSeparator) and (FKind = LastKind) and (FSizing <> gtsSpring);
      LastKind := FButtons[I].Kind;
    end;

	{ Calculating minimal size for all buttons }

	FButtonHeight := 0;
  LastButton := nil;
	ContentWidth := 0;
  SpringCount := 0;
  FirstSpringIndex := -1;
  SwitchGroup := 0;
  StartLeft := Padding.Left + IfThen(akLeft in FCutOff, 0, 1);
  for I := 0 to FButtons.Count - 1 do
    with FButtons[I] do if not GetHidden then
		begin
    	// Destroying edit controls for buttons that are no longer gtkEdit
      if Assigned(FEdit) and (FKind <> gtkEdit) then
        FreeAndNil(FEdit);

      // Calculating current button switch group
      if FKind = gtkSwitch then
        FSwitchGroup := SwitchGroup
      else
        Inc(SwitchGroup);

			// Removing button gutter and adjusting leaning for neighbor switch buttons
			if (FKind = gtkSwitch) and (LastKind = gtkSwitch) then
      begin
        Gutter := - 1;
        if Assigned(LastButton) then
          LastButton.FLeanTo := LastButton.FLeanTo + [akRight];
        FLeanTo := [akLeft];
      end
      else
      begin
        Gutter := 2;
        FLeanTo := [];
      end;

 			FLeft := StartLeft + Gutter;

      case FKind of
        gtkButton, gtkSwitch, gtkLabel, gtkEdit, gtkLink:
				begin
          IsImageLast := False;
					// Adding left padding to button size
					FWidth := 3;

					// Adding image size to minimal button size
          if (FStyle in [gtsImage, gtsImageText]) and (FButtons[I].GetImages <> nil) and
            (FImageIndex > -1) then
          begin
						FWidth := FWidth + FButtons[I].GetImages.Width + 3;
						if FButtonHeight < FButtons[I].GetImages.Height then
							FButtonHeight := FButtons[I].GetImages.Height;
						IsImageLast := True;
          end;

          if FKind = gtkEdit then
					begin
						// Creating edit control for gtkEdit buttons
            if not Assigned(FEdit) then
            begin
              FEdit := TEdit.Create(Self);
              FEdit.Text := FCaption;
              FEdit.BorderStyle := bsNone;
              FEdit.OnChange := FOnChange;
							FEdit.Top := 4;
              FEdit.Parent := Self;
						end;
						FEdit.Width := 150;
						// Adding edit size to minimal button size
						FEdit.Left := FLeft + FWidth;
						FEdit.Tag := FWidth;
		        FWidth := FWidth + FEdit.Width + 3;
            if FButtonHeight < FEdit.Height - 2 then
              FButtonHeight := FEdit.Height - 2;
            FEdit.Height := FButtonHeight - 3;
            // Fix vertical padding oversize
            FButtonHeight := FButtonHeight - 6;
          end
          else if (FStyle in [gtsText, gtsImageText]) and (FCaption <> '') then
					begin
          	// Adding gutter to text displaying after image
						if not IsImageLast then FWidth := FWidth + 2;
            // Adding text width to minimal button size
            TextExtent := SafeTextExtent(StringReplace(FCaption,
              '&', '', [rfReplaceAll]), FFont);
            FTextWidth := TextExtent.cx;
            FWidth := FWidth + FTextWidth + 3;
            if FButtonHeight < TextExtent.cy then
              FButtonHeight := TextExtent.cy;
            IsImageLast := False;
          end;

					// Displaying button arrow
          if FShowArrow then
          begin
            FWidth := FWidth + 11 + 3;
            if FButtonHeight < 5 then
              FButtonHeight := 5;
            IsImageLast := True;
          end;

          // Adding right padding to button size
          if not IsImageLast then FWidth := FWidth + 2;
        end;
        gtkSeparator: FWidth := 6;
			end;

			case FSizing of
				// Defining first spring button and spring button count
				gtsSpring:
				begin
					if FirstSpringIndex = -1 then
						FirstSpringIndex := I;
					Inc(SpringCount);
					FWidth := 0;
				end;
				gtsValue:
				begin
          FTextWidth := FTextWidth - FWidth + FSize;
					FWidth := FSize;
				end;
			end;

      if FTextWidth > FWidth then FTextWidth := FWidth - 2;

//      if FWidth < FButtonHeight then FWidth := FButtonHeight;

			StartLeft := FLeft + FWidth;
			LastKind := FKind;
			LastButton := Buttons[I];
		end
    else
      case FKind of
        gtkEdit:  if Assigned(FEdit) then FEdit.Visible := False;
      end;

	ContentWidth := StartLeft;

	// Adding vertical button padding
	FButtonHeight := FButtonHeight + 6;

  Offset := 0;
  if SpringCount > 0 then
    for I := FirstSpringIndex to FButtons.Count - 1 do
      with FButtons[I] do if not GetHidden then
      begin
				FLeft := FLeft + Offset;
				if Assigned(FEdit) then FEdit.Left := FEdit.Left + Offset;

				if FSizing = gtsSpring then
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
end;

procedure TGnvToolBar.SetButtonPadding(const Value: TGnvButtonPadding);
begin
  FButtonPadding.Assign(Value);
end;

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
  // Set TabBar default properties
  AutoSize := False;
  Height := 21;
  FFlickList := TList.Create;
  FFlickShift := 0;
  FDirection := akBottom;
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
  FSizing := gtsContent;
  FMinSizing := gtmValue;
  FOverflow := gtoClip;
  FTitleMode := False;
  FUpdateCount := 0;
  Style := gtsTabs;
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
        L := GetTabRect(FOverIndex).Right - GnvCloseWidth - 6;
        if gtkNext in FButtonKinds then L := L - GnvChevronWidth - 6;
        if gtkDropdown in FButtonKinds then L := L - GnvArrowWidth - 6;
        ScaledButtonWidth := GnvCloseWidth;
      end
      else
        ScaledButtonWidth := 0;
    gtkDropdown:
      if FOverIndex > -1 then
      begin
        L := GetTabRect(FOverIndex).Right - GnvArrowWidth - 6;
        if gtkNext in FButtonKinds then
        begin
          L := L - GnvChevronWidth - 6;
          ScaledButtonWidth := GnvArrowWidth + 6;
        end
        else
        begin
          L := L - 6;
          ScaledButtonWidth := GnvArrowWidth + 12;
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
        if gtkNext in FButtonKinds then L := L - GnvArrowWidth - 6;
        if gtkDropdown in FButtonKinds then L := L - GnvArrowWidth - 6;
        if gtkClose in FButtonKinds then L := L - GnvCloseWidth - 6;
        ScaledButtonWidth := FTabs[FOverIndex].FCatWidth;
      end
      else
        ScaledButtonWidth := 0;
    gtkMenu:    L := FMenuLeft;
    gtkPrevious:
      if (FOverIndex > -1) and (FDropIndex < 0) then
      begin
        L := GetTabRect(FOverIndex).Left + 6;
        ScaledButtonWidth := GnvArrowWidth + 6;
      end
      else
        ScaledButtonWidth := 0;
    gtkNext:
      if FOverIndex > -1 then
      begin
//        L := GetTabRect(FOverIndex).Right - GnvShevronWidth - 12;
//        ButtonWidth := GnvShevronWidth + 6;
        L := GetTabRect(FOverIndex).Right - GnvArrowWidth - 12;
        ScaledButtonWidth := GnvArrowWidth + 6;
      end
      else
        ScaledButtonWidth := 0;
    gtkHome:
      if (FOverIndex > 0) and (FDropIndex < 0) then
      begin
        L := GetTabRect(FOverIndex).Left + 6;
        if gtkPrevious in FButtonKinds then L := L + GnvArrowWidth + 6;
        ScaledButtonWidth := GnvChevronWidth + 6;
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
    akLeft, akRight:
    begin
      Result.Top := L;
      Result.Bottom := L + ScaledButtonWidth;
    end;
    akTop, akBottom:
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

function TGnvTabBar.CreateColorFlowBrush(Enabled: Boolean = True): IGPBrush;
var
  GPR: TGPRect;
begin
  GPR := TGPRect.Create(0, 0, Width, Height);

  if Enabled then
    case FColorRow of
      0:    Result := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(clBtnHighlight),
              ColorToGPColor(GnvBlendColors(clBtnHighlight, clBtnFace, 191)), LinearGradientModeVertical);
      1:    Result := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(GnvBlendColors(clBtnHighlight, clBtnFace, 191)),
              ColorToGPColor(clBtnFace), LinearGradientModeVertical);
      2:  Result := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(clBtnFace),
              ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 241)),
              LinearGradientModeVertical);
      else
          Result := TGPSolidBrush.Create(ColorToGPColor(clBtnFace));
    end
  else
  {
    case FColorRow of
      0:    Result := TGPLinearGradientBrush.Create(GPR, GetGPColor(clBtnHighlight),
              GetGPColor(BlendColors(clBtnHighlight, clBtnFace, 191)), LinearGradientModeVertical);
      2:    Result := TGPLinearGradientBrush.Create(GPR, GetGPColor(BlendColors(clBtnHighlight, clBtnFace, 191)),
              GetGPColor(clBtnFace), LinearGradientModeVertical);
      1:  Result := TGPLinearGradientBrush.Create(GPR, GetGPColor(clBtnFace),
              GetGPColor(BlendColors(clBtnFace, clBtnShadow, 241)),
              LinearGradientModeVertical);
    end
    }
    case FColorRow of
      0:    Result := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(clBtnHighlight),
              ColorToGPColor(GnvBlendColors(clBtnHighlight, clBtnFace, 191)), LinearGradientModeVertical);
      1:    Result := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(GnvBlendColors(GnvBlendColors(clBtnHighlight, clBtnFace, 191), clBlack, 249)),
              ColorToGPColor(GnvBlendColors(clBtnFace, clBlack, 249)), LinearGradientModeVertical);
      else  Result := TGPLinearGradientBrush.Create(GPR, ColorToGPColor(clBtnFace),
              ColorToGPColor(GnvBlendColors(clBtnFace, clBtnShadow, 241)),
              LinearGradientModeVertical);
    end;

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
    not (GnvGetOppositeAnchor(FDirection) in FLeanTo) then
  begin
    if (Index > -1) and (FTabs[Index] = FFlickTab) then Offset := FFlickShift;
    case FDirection of
      akBottom, akRight:  Offset := 1 + Offset;
      akTop, akLeft:      Offset := -1 - Offset;
    end
  end;

  L := L + FAlignLeft;

  case FAlignment of
    taLeftJustify:  L := L + FIndent;
    taRightJustify: L := L - FIndent;
  end;

  case FDirection of
    akLeft, akRight:
    begin
      Result.Top := L;
      Result.Bottom := L + W;
      Result.Left := Result.Left + Offset;
      Result.Right := Result.Right + Offset;
    end;
    akTop, akBottom:
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
  R: TRect;
  OldRgn, NewRgn: HRGN;
  I: Integer;
begin
  inherited;

  if (Width <= 0) or (Height <= 0) then Exit;

  if not FTransparent then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect);
  end;
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
        GnvDrawPlus(Canvas, GetButtonRect(gtkPlus), FOverKind = gtkPlus);

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
        GnvDrawChevron(Canvas, GetButtonRect(gtkShift1), akLeft, GetButtonEnabled(gtkShift1) and (FOverKind = gtkShift1));

      if gtkShift2 in FButtonKinds then
        GnvDrawChevron(Canvas, GetButtonRect(gtkShift2), akRight, GetButtonEnabled(gtkShift2) and (FOverKind = gtkShift2));

      if (gtkClose in FButtonKinds) and (FCloseKind = gckCommon) then
        GnvDrawClose(Canvas, GetButtonRect(gtkClose), GetButtonEnabled(gtkClose) and (FOverKind = gtkClose));

      if gtkMenu in FButtonKinds then
        GnvDrawTriangle(Canvas, GetButtonRect(gtkMenu), FDirection, FOverKind = gtkMenu);
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
  if (akTop in FCutOff) and not (FDirection = akBottom) then R.Top := R.Top - 1;
  if (akLeft in FCutOff) and not (FDirection = akRight) then R.Left := R.Left - 1;
  if (akBottom in FCutOff) and not (FDirection = akTop) then R.Bottom := R.Bottom + 1;
  if (akRight in FCutOff) and not (FDirection = akRight) then R.Right := R.Right + 1;

  TabR := GetTabRect(FTabIndex, True);

  if (Win32MajorVersion >= 5) and IsAppThemed then
  begin
    case FDirection of
      akLeft:
      begin
        GPPoints[0] := TGPPoint.Create(R.Left, R.Top);
        GPPoints[1] := TGPPoint.Create(R.Left + FStripSize, R.Top);
        GPPoints[2] := TGPPoint.Create(R.Left + FStripSize, TabR.Top);
        GPPoints[3] := TGPPoint.Create(R.Left + FStripSize, TabR.Bottom - 1);
        GPPoints[4] := TGPPoint.Create(R.Left + FStripSize, R.Bottom - 1);
        GPPoints[5] := TGPPoint.Create(R.Left, R.Bottom - 1);
        GPR := TGPRect.Create(R.Left, R.Top, FStripSize, R.Bottom - R.Top);
      end;
      akTop:
      begin
        GPPoints[0] := TGPPoint.Create(R.Left, R.Top);
        GPPoints[1] := TGPPoint.Create(R.Left, R.Top + FStripSize);
        GPPoints[2] := TGPPoint.Create(TabR.Left, R.Top + FStripSize);
        GPPoints[3] := TGPPoint.Create(TabR.Right - 1, R.Top + FStripSize);
        GPPoints[4] := TGPPoint.Create(R.Right - 1, R.Top + FStripSize);
        GPPoints[5] := TGPPoint.Create(R.Right - 1, R.Top);
        GPR := TGPRect.Create(R.Left, R.Top, R.Right - R.Left, FStripSize);
      end;
      akRight:
      begin
        GPPoints[0] := TGPPoint.Create(R.Right - 1, R.Top);
        GPPoints[1] := TGPPoint.Create(R.Right - FStripSize - 1, R.Top);
        GPPoints[2] := TGPPoint.Create(R.Right - FStripSize - 1, TabR.Top);
        GPPoints[3] := TGPPoint.Create(R.Right - FStripSize - 1, TabR.Bottom - 1);
        GPPoints[4] := TGPPoint.Create(R.Right - FStripSize - 1, R.Bottom - 1);
        GPPoints[5] := TGPPoint.Create(R.Right - 1, R.Bottom - 1);
        GPR := TGPRect.Create(R.Right - FStripSize, R.Top, FStripSize, R.Bottom - R.Top);
      end;
      akBottom:
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
    GPPen := TGPPen.Create(ColorToGPColor(GnvGetBorderColor));

    GP.FillRectangle(CreateColorFlowBrush, GPR);

    GP.DrawLine(GPPen, GPPoints[0], GPPoints[1]);
    GP.DrawLine(GPPen, GPPoints[1], GPPoints[2]);
    GP.DrawLine(GPPen, GPPoints[3], GPPoints[4]);
    GP.DrawLine(GPPen, GPPoints[4], GPPoints[5]);
  end
  else
  begin
    case FDirection of
      akLeft:
      begin
        Points[0] := Point(R.Left, R.Top);
        Points[1] := Point(R.Left + FStripSize, R.Top);
        Points[2] := Point(R.Left + FStripSize, TabR.Top);
        Points[3] := Point(R.Left + FStripSize, TabR.Bottom - 1);
        Points[4] := Point(R.Left + FStripSize, R.Bottom - 1);
        Points[5] := Point(R.Left, R.Bottom - 1);
        R := Rect(R.Left, R.Top, R.Left + FStripSize, R.Bottom);
      end;
      akTop:
      begin
        Points[0] := Point(R.Left, R.Top);
        Points[1] := Point(R.Left, R.Top + FStripSize);
        Points[2] := Point(TabR.Left, R.Top + FStripSize);
        Points[3] := Point(TabR.Right - 1, R.Top + FStripSize);
        Points[4] := Point(R.Right - 1, R.Top + FStripSize);
        Points[5] := Point(R.Right - 1, R.Top);
        R := Rect(R.Left, R.Top, R.Right, R.Top + FStripSize);
      end;
      akRight:
      begin
        Points[0] := Point(R.Right - 1, R.Top);
        Points[1] := Point(R.Right - FStripSize - 1, R.Top);
        Points[2] := Point(R.Right - FStripSize - 1, TabR.Top);
        Points[3] := Point(R.Right - FStripSize - 1, TabR.Bottom - 1);
        Points[4] := Point(R.Right - FStripSize - 1, R.Bottom - 1);
        Points[5] := Point(R.Right - 1, R.Bottom - 1);
        R := Rect(R.Right - FStripSize, R.Top, R.Right, R.Bottom);
      end;
      akBottom:
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

      if FDirection in [akTop, akLeft] then
        Pen.Color := clBtnShadow
      else
        Pen.Color := clBtnHighlight;
      LineTo(Points[2].X, Points[2].Y);
      MoveTo(Points[3].X, Points[3].Y);
      LineTo(Points[4].X, Points[4].Y);

      Pen.Color := clBtnShadow;
      LineTo(Points[5].X, Points[5].Y);

      if FDirection in [akBottom, akTop] then
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
  LeanTo: TAnchors;
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
      GnvAddFrame(GPPath, GPR, 0, [], [FDirection]);

      GPBrush := TGPSolidBrush.Create(ColorToGPColor(clBtnFace));
      GPPen := TGPPen.Create(ColorToGPColor(GnvGetBorderColor));
    end
    else
    begin
      GP.SmoothingMode := SmoothingModeAntiAlias;

      if GnvGetOppositeAnchor(FDirection) in FLeanTo then
        LeanTo := [GnvGetOppositeAnchor(FDirection)]
      else
        LeanTo := [];

      if (TabRect.Left = 0) and (akLeft in FLeanTo) then
        LeanTo := LeanTo + [akLeft];
      if (TabRect.Right = ClientRect.Right) and (akRight in FLeanTo) then
        LeanTo := LeanTo + [akRight];

      if not FTitleMode and (FDropIndex < -1) and (FStyle = gtsTitleTabs) and
        (FLastVisibleIndex > -1) then
      begin
        if FLastVisibleIndex = Index then
          LeanTo := LeanTo + [akLeft]
        else if FFirstVisibleIndex = Index then
          LeanTo := LeanTo + [akRight]
        else
          LeanTo := LeanTo + [akLeft, akRight];
      end;

      GnvAddFrame(GPPath, GPR, FTabRadius,//Round(FTabRadius*Screen.PixelsPerInch/96),
        LeanTo + [FDirection], [FDirection]);

      GPBrush := CreateColorFlowBrush;
      GPPen := TGPPen.Create(ColorToGPColor(GnvGetBorderColor));
    end;

    GP.FillPath(GPBrush, GPPath);
    GP.DrawPath(GPPen, GPPath);
  end
  else
    // Drawing for classic style
    GnvDrawClassicPanel(Canvas, TabRect, [FDirection]);

  SelectClipRgn(Canvas.Handle, Rgn);

  if Index = -1 then
    GnvDrawTriangle(Canvas, TabRect, FDirection)
  else
  begin
    // Set tab painting rectangle
    R := TabRect;
    R.Right := R.Right - 6;

    // Paint tab switch button
    if (gtkNext in FButtonKinds) then
    begin
      R.Left := R.Right - GnvChevronWidth;
//      GnvDrawShevron(Canvas, R, akRight, (FOverIndex = Index) and (FOverKind = gtkNext));
      GnvDrawTriangle(Canvas, R, akRight, (FOverIndex = Index) and (FOverKind = gtkNext));
      R.Right := R.Left - 6;
    end;

    // Paint context menu button
    if (gtkDropdown in FButtonKinds) then
    begin
      R.Left := R.Right - GnvArrowWidth;
      GnvDrawTriangle(Canvas, R, akBottom, (FDropIndex = Index) or ((FOverIndex = Index) and (FOverKind in [gtkDropdown, gtkCategory])));
      R.Right := R.Left - 6;
    end;

    // Paint tab close button
    if (gtkClose in FButtonKinds) and (FCloseKind = gckPersonal) then
    begin
      R.Left := R.Right - GnvCloseWidth;
      GnvDrawClose(Canvas, R, (FOverIndex = Index) and (FOverKind = gtkClose));
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
      R.Right := R.Left + GnvArrowWidth;
      GnvDrawTriangle(Canvas, R, akLeft, (FOverIndex = Index) and (FOverKind = gtkPrevious));
      R.Left := R.Right + 6;
      R.Right := OldR.Right;
    end;

    // Paint home button
    if (gtkHome in FButtonKinds) and (FDropIndex < 0) and (Index > 0) then
    begin
      OldR := R;
      R.Right := R.Left + GnvChevronWidth;
//      GnvDrawShevron(Canvas, R, akLeft, (FOverIndex = Index) and (FOverKind = gtkHome));
      GnvDrawClose(Canvas, R, (FOverIndex = Index) and (FOverKind = gtkHome));
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
      if (FSizing in [gtsValue, gtsSpringToValue, gtsMaxContentToValue]) then
        FTabs[I].FWidth := ScaledTabSize;

      case FSizing of
        gtsMaxContent:    FTabs[I].FWidth := MaxTabWidth;
        gtsMaxContentToValue:
          if MaxTabWidth < FTabs[I].FWidth then
            FTabs[I].FWidth := MaxTabWidth;
        gtsSpring:        FTabs[I].FWidth := Floor(LeftWidth/LeftCount);
        gtsSpringToValue:
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
        gtsSpring,
        gtsSpringToValue:
        begin
          LeftWidth := LeftWidth - FTabs[I].FWidth - Indent;
          Dec(LeftCount);
        end;
      end;

      FTabs[I].FLeft := L;
      // Define next tab position and width of all tabs
      L := L + FTabs[I].FWidth + Indent;
      case FSizing of
        gtsSpring,
        gtsSpringToValue:   FWantWidth := FWantWidth + FTabs[I].FMinWidth;
        else                FWantWidth := FWantWidth + FTabs[I].FWidth;
      end;
    end;
  end;

begin
  inherited;

  case FDirection of
    akLeft, akRight:  FWidth := ClientRect.Bottom - ClientRect.Top;
    akTop, akBottom:  FWidth := ClientRect.Right - ClientRect.Left;
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
        FTabs[I].FWidth := FTabs[I].FWidth + GnvArrowWidth + 6;
      // Add tab close button width
      if (gtbClose in FButtons) and (FCloseKind = gckPersonal) then
        FTabs[I].FWidth := FTabs[I].FWidth + GnvCloseWidth + 6;
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

procedure TGnvTabBar.SetDirection(const Value: TAnchorKind);
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

procedure TGnvTabBar.SetLeanTo(const Value: TAnchors);
begin
  if FLeanTo <> Value then
  begin
    FLeanTo := Value;
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
      akRight, akLeft:  P := Point(R.Right, R.Top);
      akBottom, akTop:
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

constructor TGnvButtonPadding.Create(Control: TControl);
begin
  inherited;
  Left := 2;
  Top := 1;
  Bottom := 1;
  Right := 2;
end;

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
	FCutOff := [akLeft, akRight, akTop, akBottom];
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

    BorderPen := TGPPen.Create(ColorToGPColor(GnvGetBorderColor));

    BorderPath := TGPGraphicsPath.Create;
    GnvAddFrame(BorderPath, GPR, 0, FCutOff, FCutOff);

    GP.DrawPath(BorderPen, BorderPath);
  end
  else
    GnvDrawClassicPanel(Canvas, ClientRect, FCutOff);
end;

procedure TGnvSplitter.SetCutOff(const Value: TAnchors);
begin
  FCutOff := Value;
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
    R.Left := R.Right - GnvChevronWidth;
    GnvDrawChevron(Canvas, R, FArrowDirection, False);
  end;
end;

procedure TGnvLabel.SafeRepaint;
begin
  //if Showing then
  Repaint;
end;

procedure TGnvLabel.SetArrowDirection(const Value: TGnvGlyphDirection);
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

end.

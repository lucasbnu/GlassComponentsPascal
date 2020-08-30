unit Glass.controller.Json;

{$IFDEF fpc}
  {$MODE objfpc}
  {$H+}
  {.$DEFINE HAVE_FORMATSETTING}
{$ELSE}
  {$IF RTLVersion > 14.00}
    {$DEFINE HAVE_FORMATSETTING}
    {$IF RTLVersion > 19.00}
      {$DEFINE USE_D2009}
    {$IFEND}
  {$IFEND}
{$ENDIF}

interface

{.$DEFINE USE_D2009}
{.$DEFINE KOL}
{.$define DOTNET}
{$DEFINE THREADSAFE}
{$DEFINE NEW_STYLE_GENERATE}
{.$DEFINE USE_HASH}
{.$DEFINE TCB_EXT}

uses windows,
  SysUtils,
{$IFNDEF KOL}
  classes,
{$ELSE}
  kol,
{$ENDIF}
  variants;

type
  TJsonTypes = (jsBase, jsNumber, jsString, jsBoolean, jsNull,
    jsList, jsObject);

{$IFDEF DOTNET}

  TJSonDotNetClass = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure AfterConstruction; virtual;
    procedure BeforeDestruction; virtual;
  end;

{$ENDIF DOTNET}

  TJsonObjectBase = class{$IFDEF DOTNET}(TJSonDotNetClass){$ENDIF}
  protected
    function GetValue: variant; virtual;
    procedure SetValue(const AValue: variant); virtual;
    function GetChild(idx: Integer): TJsonObjectBase; virtual;
    procedure SetChild(idx: Integer; const AValue: TJsonObjectBase);
      virtual;
    function GetCount: Integer; virtual;
    function GetField(AName: Variant):TJsonObjectBase; virtual;
  public
    property Field[AName: Variant]: TJsonObjectBase read GetField;
    property Count: Integer read GetCount;
    property Child[idx: Integer]: TJsonObjectBase read GetChild write SetChild;
    property Value: variant read GetValue write SetValue;
    class function SelfType: TJsonTypes; virtual;
    class function SelfTypeName: string; virtual;
  end;

  TJsonNumber = class(TJsonObjectBase)
  protected
    FValue: extended;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(AValue: extended = 0): TJsonNumber;
    class function SelfType: TJsonTypes; override;
    class function SelfTypeName: string; override;
  end;

  TJsonstring = class(TJsonObjectBase)
  protected
    FValue: WideString;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(const wsValue: WideString = ''):
      TJsonstring;
    class function SelfType: TJsonTypes; override;
    class function SelfTypeName: string; override;
  end;

  TJSonBoolean = class(TJsonObjectBase)
  protected
    FValue: Boolean;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(AValue: Boolean = true): TJSonBoolean;
    class function SelfType: TJsonTypes; override;
    class function SelfTypeName: string; override;
  end;

  TJsonNull = class(TJsonObjectBase)
  protected
    function GetValue: Variant; override;
    function Generate: TJsonNull;
  public
    class function SelfType: TJsonTypes; override;
    class function SelfTypeName: string; override;
  end;

  TJsonFuncEnum = procedure(ElName: string; Elem: TJsonObjectBase;
    data: pointer; var Continue: Boolean) of object;

  TJsonCustomList = class(TJsonObjectBase)
  protected
    fList: TList;
    function GetCount: Integer; override;
    function GetChild(idx: Integer): TJsonObjectBase; override;
    procedure SetChild(idx: Integer; const AValue: TJsonObjectBase);
      override;
    function ForEachElement(idx: Integer; var nm: string):
      TJsonObjectBase; virtual;

    function GetField(AName: Variant):TJsonObjectBase; override;

    function _Add(obj: TJsonObjectBase): Integer; virtual;
    procedure _Delete(iIndex: Integer); virtual;
    function _IndexOf(obj: TJsonObjectBase): Integer; virtual;
  public
    procedure ForEach(fnCallBack: TJsonFuncEnum; pUserData:
      pointer);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function getInt(idx: Integer): Integer; virtual;
    function getString(idx: Integer): string; virtual;
    function getWideString(idx: Integer): WideString; virtual;
    function getDouble(idx: Integer): Double; virtual;
    function getBoolean(idx: Integer): Boolean; virtual;
  end;

  TJsonList = class(TJsonCustomList)
  protected
  public
    function Add(obj: TJsonObjectBase): Integer; overload;

    function Add(aboolean: Boolean): Integer; overload;
    function Add(nmb: double): Integer; overload;
    function Add(s: string): Integer; overload;
    function Add(const ws: WideString): Integer; overload;
    function Add(inmb: Integer): Integer; overload;

    procedure Delete(idx: Integer);
    function IndexOf(obj: TJsonObjectBase): Integer;
    class function Generate: TJsonList;
    class function SelfType: TJsonTypes; override;
    class function SelfTypeName: string; override;
  end;

  TJsonObjectMethod = class(TJsonObjectBase)
  protected
    FValue: TJsonObjectBase;
    FName: WideString;
    procedure SetName(const AValue: WideString);
  public
    property ObjValue: TJsonObjectBase read FValue;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property Name: WideString read FName write SetName;
    class function Generate(const aname: WideString; aobj: TJsonObjectBase):
      TJsonObjectMethod;
  end;

{$IFDEF USE_HASH}
  PHashItem = ^THashItem;
  THashItem = packed record
    hash: cardinal;
    index: Integer;
  end;

  THashFunction = function(const ws: WideString): cardinal of
    object;

  THashTable = class
  private
    FParent: TObject;
    FHashFunction: THashFunction;
    procedure SetHashFunction(const AValue: THashFunction);
  protected
    a_x: array[0..255] of TList;
    procedure hswap(j, k, l: Integer);
    function InTable(const ws: WideString; var i, j, k: cardinal):
      Boolean;
  public
    function counters: string;

    function DefaultHashOf(const ws: WideString): cardinal;
    function SimpleHashOf(const ws: WideString): cardinal;

    property HashOf: THashFunction read FHashFunction write
      SetHashFunction;

    function IndexOf(const ws: WideString): Integer;

    procedure AddPair(const ws: WideString; idx: Integer);
    procedure Delete(const ws: WideString);

    constructor Create;
    destructor Destroy; override;
  end;

{$ELSE}

  PBalNode = ^TBalNode;
  TBalNode = packed record
    left,right: PBalNode;
    level: byte;
    key: Integer;
    nm: WideString;
  end;

  TBalTree = class
  protected
    fdeleted,flast,fbottom,froot: PBalNode;
    procedure skew(var t:PBalNode);
    procedure split(var t:PBalNode);
  public
    function counters: string;

    procedure Clear;

    function Insert(const ws: WideString; x: Integer): Boolean;
    function Delete(const ws: WideString): Boolean;

    function IndexOf(const ws: WideString): Integer;

    constructor Create;
    destructor Destroy; override;
  end;
{$ENDIF USE_HASH}

  TJsonObject = class(TJsonCustomList)
  protected
{$IFDEF USE_HASH}
    ht: THashTable;
{$ELSE}
    ht: TBalTree;
{$ENDIF USE_HASH}
    FUseHash: Boolean;
    function GetFieldByIndex(idx: Integer): TJsonObjectBase;
    function GetNameOf(idx: Integer): WideString;
    procedure SetFieldByIndex(idx: Integer; const AValue: TJsonObjectBase);
{$IFDEF USE_HASH}
    function GetHashTable: THashTable;
{$ELSE}
    function GetHashTable: TBalTree;
{$ENDIF USE_HASH}
    function ForEachElement(idx: Integer; var nm: string): TJsonObjectBase;
      override;
    function GetField(AName: Variant):TJsonObjectBase; override;
  public
    property UseHash: Boolean read FUseHash;
{$IFDEF USE_HASH}
    property HashTable: THashTable read GetHashTable;
{$ELSE}
    property HashTable: TBalTree read GetHashTable;
{$ENDIF USE_HASH}

    function Add(const aname: WideString; aobj: TJsonObjectBase): Integer;
      overload;

    function OldGetField(nm: WideString): TJsonObjectBase;
    procedure OldSetField(nm: WideString; const AValue: TJsonObjectBase);

    function Add(const aname: WideString; aboolean: Boolean): Integer; overload;
    function Add(const aname: WideString; nmb: double): Integer; overload;
    function Add(const aname: WideString; s: string): Integer; overload;
    function Add(const aname: WideString; const ws: WideString): Integer;
      overload;
    function Add(const aname: WideString; inmb: Integer): Integer; overload;

    procedure Delete(idx: Integer);
    function IndexOfName(const aname: WideString): Integer;
    function IndexOfObject(aobj: TJsonObjectBase): Integer;
    property Field[nm: WideString]: TJsonObjectBase read OldGetField
      write OldSetField; default;

    constructor Create(bUseHash: Boolean = true);
    destructor Destroy; override;

    class function Generate(AUseHash: Boolean = true): TJsonObject;
    class function SelfType: TJsonTypes; override;
    class function SelfTypeName: string; override;

    property FieldByIndex[idx: Integer]: TJsonObjectBase read GetFieldByIndex
    write SetFieldByIndex;
    property NameOf[idx: Integer]: WideString read GetNameOf;

    function getDouble(idx: Integer): Double; overload; override;
    function getInt(idx: Integer): Integer; overload; override;
    function getString(idx: Integer): string; overload; override;
    function getWideString(idx: Integer): WideString; overload; override;
    function getBoolean(idx: Integer): Boolean; overload; override;

    function {$ifdef TCB_EXT}getDoubleFromName{$else}getDouble{$endif}
      (nm: string): Double; overload;
    function {$ifdef TCB_EXT}getIntFromName{$else}getInt{$endif}
      (nm: string): Integer; overload;
    function {$ifdef TCB_EXT}getStringFromName{$else}getString{$endif}
      (nm: string): string; overload;
    function {$ifdef TCB_EXT}getWideStringFromName{$else}getWideString{$endif}
      (nm: string): WideString; overload;
    function {$ifdef TCB_EXT}getBooleanFromName{$else}getBoolean{$endif}
      (nm: string): Boolean; overload;
  end;

  TJson = class
  public
    class function ParseText(const txt: string): TJsonObjectBase;
    class function GenerateText(obj: TJsonObjectBase): string;
  end;

{$IFNDEF KOL}
  TJsonStreamed = class(TJson)
    class function LoadFromStream(src: TStream): TJsonObjectBase;
    class procedure SaveToStream(obj: TJsonObjectBase; dst: TStream);
    class function LoadFromFile(srcname: string): TJsonObjectBase;
    class procedure SaveToFile(obj: TJsonObjectBase; dstname: string);
  end;
{$ENDIF}

function GenerateReadableText(vObj: TJsonObjectBase; var vLevel:
  Integer): string;

implementation

uses math,strutils;

type
  EIntException = class(Exception)
  public
    idx: Integer;
    constructor Create(idx: Integer; msg: string);
  end;


function Indent(vTab: Integer): string;
begin
  result := DupeString('  ', vTab);
end;

function GenerateReadableText(vObj: TJsonObjectBase; var vLevel:
  Integer): string;
var
  i: Integer;
  vStr: string;
  xs: TJsonstring;
begin
  vLevel := vLevel + 1;
  if vObj is TJsonObject then
    begin
      vStr := '';
      for i := 0 to TJsonObject(vObj).Count - 1 do
        begin
          if vStr <> '' then
            begin
              vStr := vStr + ','#13#10;
            end;
          vStr := vStr + Indent(vLevel) +
            GenerateReadableText(TJsonObject(vObj).Child[i], vLevel);
        end;
      if vStr <> '' then
        begin
          vStr := '{'#13#10 + vStr + #13#10 + Indent(vLevel - 1) + '}';
        end
      else
        begin
          vStr := '{}';
        end;
      result := vStr;
    end
  else if vObj is TJsonList then
    begin
      vStr := '';
      for i := 0 to TJsonList(vObj).Count - 1 do
        begin
          if vStr <> '' then
            begin
              vStr := vStr + ','#13#10;
            end;
          vStr := vStr + Indent(vLevel) +
              GenerateReadableText(TJsonList(vObj).Child[i], vLevel);
        end;
      if vStr <> '' then
        begin
          vStr := '['#13#10 + vStr + #13#10 + Indent(vLevel - 1) + ']';
        end
      else
        begin
          vStr := '[]';
        end;
      result := vStr;
    end
  else if vObj is TJsonObjectMethod then
    begin
      vStr := '';
      xs := TJsonstring.Create;
      try
        xs.Value := TJsonObjectMethod(vObj).Name;
        vStr := GenerateReadableText(xs, vLevel);
        vLevel := vLevel - 1;
        vStr := vStr + ':' + GenerateReadableText(TJsonObjectBase(
          TJsonObjectMethod(vObj).ObjValue), vLevel);
        vLevel := vLevel + 1;
        result := vStr;
      finally
        xs.Free;
      end;
    end
  else
    begin
      if vObj is TJsonObjectMethod then
        begin
          if TJsonObjectMethod(vObj).Name <> '' then
            begin
            end;
        end;
      result := TJson.GenerateText(vObj);
    end;
  vLevel := vLevel - 1;
end;


function code2utf(iNumber: Integer): UTF8String;
begin
  if iNumber < 128 then Result := chr(iNumber)
  else if iNumber < 2048 then
    Result := chr((iNumber shr 6) + 192) + chr((iNumber and 63) + 128)
  else if iNumber < 65536 then
    Result := chr((iNumber shr 12) + 224) + chr(((iNumber shr 6) and
      63) + 128) + chr((iNumber and 63) + 128)
  else if iNumber < 2097152 then
    Result := chr((iNumber shr 18) + 240) + chr(((iNumber shr 12) and
      63) + 128) + chr(((iNumber shr 6) and 63) + 128) +
      chr((iNumber and 63) + 128);
end;

{ TJsonObjectBase }

function TJsonObjectBase.GetChild(idx: Integer): TJsonObjectBase;
begin
  result := nil;
end;

function TJsonObjectBase.GetCount: Integer;
begin
  result := 0;
end;

function TJsonObjectBase.GetField(AName: Variant):TJsonObjectBase;
begin
  result := self;
end;

function TJsonObjectBase.GetValue: variant;
begin
  result := variants.Null;
end;

class function TJsonObjectBase.SelfType: TJsonTypes;
begin
  result := jsBase;
end;

class function TJsonObjectBase.SelfTypeName: string;
begin
  result := 'jsBase';
end;

procedure TJsonObjectBase.SetChild(idx: Integer; const AValue:
  TJsonObjectBase);
begin

end;

procedure TJsonObjectBase.SetValue(const AValue: variant);
begin

end;

{ TJsonNumber }

procedure TJsonNumber.AfterConstruction;
begin
  inherited;
  FValue := 0;
end;

class function TJsonNumber.Generate(AValue: extended):
  TJsonNumber;
begin
  result := TJsonNumber.Create;
  result.FValue := AValue;
end;

function TJsonNumber.GetValue: Variant;
begin
  result := FValue;
end;

class function TJsonNumber.SelfType: TJsonTypes;
begin
  result := jsNumber;
end;

class function TJsonNumber.SelfTypeName: string;
begin
  result := 'jsNumber';
end;

procedure TJsonNumber.SetValue(const AValue: Variant);
begin
  FValue := VarAsType(AValue, varDouble);
end;

{ TJsonstring }

procedure TJsonstring.AfterConstruction;
begin
  inherited;
  FValue := '';
end;

class function TJsonstring.Generate(const wsValue: WideString):
  TJsonstring;
begin
  result := TJsonstring.Create;
  result.FValue := wsValue;
end;

function TJsonstring.GetValue: Variant;
begin
  result := FValue;
end;

class function TJsonstring.SelfType: TJsonTypes;
begin
  result := jsString;
end;

class function TJsonstring.SelfTypeName: string;
begin
  result := 'jsString';
end;

procedure TJsonstring.SetValue(const AValue: Variant);
begin
  FValue := VarToWideStr(AValue);
end;

{ TJSonBoolean }

procedure TJSonBoolean.AfterConstruction;
begin
  FValue := false;
end;

class function TJSonBoolean.Generate(AValue: Boolean):
  TJSonBoolean;
begin
  result := TJSonBoolean.Create;
  result.Value := AValue;
end;

function TJSonBoolean.GetValue: Variant;
begin
  result := FValue;
end;

class function TJSonBoolean.SelfType: TJsonTypes;
begin
  Result := jsBoolean;
end;

class function TJSonBoolean.SelfTypeName: string;
begin
  Result := 'jsBoolean';
end;

procedure TJSonBoolean.SetValue(const AValue: Variant);
begin
  FValue := boolean(AValue);
end;

{ TJsonNull }

function TJsonNull.Generate: TJsonNull;
begin
  result := TJsonNull.Create;
end;

function TJsonNull.GetValue: Variant;
begin
  result := variants.Null;
end;

class function TJsonNull.SelfType: TJsonTypes;
begin
  result := jsNull;
end;

class function TJsonNull.SelfTypeName: string;
begin
  result := 'jsNull';
end;

{ TJsonCustomList }

function TJsonCustomList._Add(obj: TJsonObjectBase): Integer;
begin
  if not Assigned(obj) then
    begin
      result := -1;
      exit;
    end;
  result := fList.Add(obj);
end;

procedure TJsonCustomList.AfterConstruction;
begin
  inherited;
  fList := TList.Create;
end;

procedure TJsonCustomList.BeforeDestruction;
var
  i: Integer;
begin
  for i := (Count - 1) downto 0 do _Delete(i);
  fList.Free;
  inherited;
end;


procedure TJsonCustomList._Delete(iIndex: Integer);
var
  idx: Integer;
begin
  if not ((iIndex < 0) or (iIndex >= Count)) then
    begin
      if fList.Items[iIndex] <> nil then
        TJsonObjectBase(fList.Items[iIndex]).Free;
      idx := pred(fList.Count);
      if iIndex<idx then
        begin
          fList.Items[iIndex] := fList.Items[idx];
          fList.Delete(idx);
        end
      else
        begin
          fList.Delete(iIndex);
        end;
    end;
end;

function TJsonCustomList.GetChild(idx: Integer): TJsonObjectBase;
begin
  if (idx < 0) or (idx >= Count) then
    begin
      result := nil;
    end
  else
    begin
      result := fList.Items[idx];
    end;
end;

function TJsonCustomList.GetCount: Integer;
begin
  result := fList.Count;
end;

function TJsonCustomList._IndexOf(obj: TJsonObjectBase): Integer;
begin
  result := fList.IndexOf(obj);
end;

procedure TJsonCustomList.SetChild(idx: Integer; const AValue:
  TJsonObjectBase);
begin
  if not ((idx < 0) or (idx >= Count)) then
    begin
      if fList.Items[idx] <> nil then
        TJsonObjectBase(fList.Items[idx]).Free;
      fList.Items[idx] := AValue;
    end;
end;

procedure TJsonCustomList.ForEach(fnCallBack: TJsonFuncEnum;
  pUserData:
  pointer);
var
  iCount: Integer;
  IsContinue: Boolean;
  anJSON: TJsonObjectBase;
  wsObject: string;
begin
  if not assigned(fnCallBack) then exit;
  IsContinue := true;
  for iCount := 0 to GetCount - 1 do
    begin
      anJSON := ForEachElement(iCount, wsObject);
      if assigned(anJSON) then
        fnCallBack(wsObject, anJSON, pUserData, IsContinue);
      if not IsContinue then break;
    end;
end;

function TJsonCustomList.GetField(AName: Variant):TJsonObjectBase;
var
  index: Integer;
begin
  if VarIsNumeric(AName) then
    begin
      index := integer(AName);
      result := GetChild(index);
    end
  else
    begin
      result := inherited GetField(AName);
    end;
end;

function TJsonCustomList.ForEachElement(idx: Integer; var nm:
  string): TJsonObjectBase;
begin
  nm := inttostr(idx);
  result := GetChild(idx);
end;

function TJsonCustomList.getDouble(idx: Integer): Double;
var
  jn: TJsonNumber;
begin
  jn := Child[idx] as TJsonNumber;
  if not assigned(jn) then result := 0
  else result := jn.Value;
end;

function TJsonCustomList.getInt(idx: Integer): Integer;
var
  jn: TJsonNumber;
begin
  jn := Child[idx] as TJsonNumber;
  if not assigned(jn) then result := 0
  else result := round(int(jn.Value));
end;

function TJsonCustomList.getString(idx: Integer): string;
var
  js: TJsonstring;
begin
  js := Child[idx] as TJsonstring;
  if not assigned(js) then result := ''
  else result := VarToStr(js.Value);
end;

function TJsonCustomList.getWideString(idx: Integer): WideString;
var
  js: TJsonstring;
begin
  js := Child[idx] as TJsonstring;
  if not assigned(js) then result := ''
  else result := VarToWideStr(js.Value);
end;

function TJsonCustomList.getBoolean(idx: Integer): Boolean;
var
  jb: TJSonBoolean;
begin
  jb := Child[idx] as TJSonBoolean;
  if not assigned(jb) then result := false
  else result := jb.Value;
end;

{ TJsonObjectMethod }

procedure TJsonObjectMethod.AfterConstruction;
begin
  inherited;
  FValue := nil;
  FName := '';
end;

procedure TJsonObjectMethod.BeforeDestruction;
begin
  FName := '';
  if FValue <> nil then
    begin
      FValue.Free;
      FValue := nil;
    end;
  inherited;
end;

class function TJsonObjectMethod.Generate(const aname: WideString;
  aobj: TJsonObjectBase): TJsonObjectMethod;
begin
  result := TJsonObjectMethod.Create;
  result.FName := aname;
  result.FValue := aobj;
end;

procedure TJsonObjectMethod.SetName(const AValue: WideString);
begin
  FName := AValue;
end;

{ TJsonList }

function TJsonList.Add(obj: TJsonObjectBase): Integer;
begin
  result := _Add(obj);
end;

function TJsonList.Add(nmb: double): Integer;
begin
  Result := self.Add(TJsonNumber.Generate(nmb));
end;

function TJsonList.Add(aboolean: Boolean): Integer;
begin
  Result := self.Add(TJSonBoolean.Generate(aboolean));
end;

function TJsonList.Add(inmb: Integer): Integer;
begin
  Result := self.Add(TJsonNumber.Generate(inmb));
end;

function TJsonList.Add(const ws: WideString): Integer;
begin
  Result := self.Add(TJsonstring.Generate(ws));
end;

function TJsonList.Add(s: string): Integer;
begin
  Result := self.Add(TJsonstring.Generate(s));
end;

procedure TJsonList.Delete(idx: Integer);
begin
  _Delete(idx);
end;

class function TJsonList.Generate: TJsonList;
begin
  result := TJsonList.Create;
end;

function TJsonList.IndexOf(obj: TJsonObjectBase): Integer;
begin
  result := _IndexOf(obj);
end;

class function TJsonList.SelfType: TJsonTypes;
begin
  result := jsList;
end;

class function TJsonList.SelfTypeName: string;
begin
  result := 'jsList';
end;

{ TJsonObject }

function TJsonObject.Add(const aname: WideString; aobj:
  TJsonObjectBase):
  Integer;
var
  mth: TJsonObjectMethod;
begin
  if not assigned(aobj) then
    begin
      result := -1;
      exit;
    end;
  mth := TJsonObjectMethod.Create;
  mth.FName := aname;
  mth.FValue := aobj;
  result := self._Add(mth);
  if FUseHash then
{$IFDEF USE_HASH}
    ht.AddPair(aname, result);
{$ELSE}
    ht.Insert(aname, result);
{$ENDIF USE_HASH}
end;

procedure TJsonObject.Delete(idx: Integer);
var
  i,j,k:cardinal;
  mth: TJsonObjectMethod;
begin
  if (idx >= 0) and (idx < Count) then
    begin
      mth := TJsonObjectMethod(fList.Items[idx]);
      if FUseHash then
        begin
          ht.Delete(mth.FName);
        end;
    end;
  _Delete(idx);
{$ifdef USE_HASH}
  if (idx<Count) and (FUseHash) then
    begin
      mth := TJsonObjectMethod(fList.Items[idx]);
      ht.AddPair(mth.FName,idx);
    end;
{$endif}
end;

class function TJsonObject.Generate(AUseHash: Boolean = true):
  TJsonObject;
begin
  result := TJsonObject.Create(AUseHash);
end;

function TJsonObject.OldGetField(nm: WideString): TJsonObjectBase;
var
  mth: TJsonObjectMethod;
  i: Integer;
begin
  i := IndexOfName(nm);
  if i = -1 then
    begin
      result := nil;
    end
  else
    begin
      mth := TJsonObjectMethod(fList.Items[i]);
      result := mth.FValue;
    end;
end;

function TJsonObject.IndexOfName(const aname: WideString): Integer;
var
  mth: TJsonObjectMethod;
  i: Integer;
begin
  if not FUseHash then
    begin
      result := -1;
      for i := 0 to Count - 1 do
        begin
          mth := TJsonObjectMethod(fList.Items[i]);
          if mth.Name = aname then
            begin
              result := i;
              break;
            end;
        end;
    end
  else
    begin
      result := ht.IndexOf(aname);
    end;
end;

function TJsonObject.IndexOfObject(aobj: TJsonObjectBase): Integer;
var
  mth: TJsonObjectMethod;
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    begin
      mth := TJsonObjectMethod(fList.Items[i]);
      if mth.FValue = aobj then
        begin
          result := i;
          break;
        end;
    end;
end;

procedure TJsonObject.OldSetField(nm: WideString; const AValue:
  TJsonObjectBase);
var
  mth: TJsonObjectMethod;
  i: Integer;
begin
  i := IndexOfName(nm);
  if i <> -1 then
    begin
      mth := TJsonObjectMethod(fList.Items[i]);
      mth.FValue := AValue;
    end;
end;

function TJsonObject.Add(const aname: WideString; nmb: double):
  Integer;
begin
  Result := self.Add(aname, TJsonNumber.Generate(nmb));
end;

function TJsonObject.Add(const aname: WideString; aboolean: Boolean):
  Integer;
begin
  Result := self.Add(aname, TJSonBoolean.Generate(aboolean));
end;

function TJsonObject.Add(const aname: WideString; s: string):
  Integer;
begin
  Result := self.Add(aname, TJsonstring.Generate(s));
end;

function TJsonObject.Add(const aname: WideString; inmb: Integer):
  Integer;
begin
  Result := self.Add(aname, TJsonNumber.Generate(inmb));
end;

function TJsonObject.Add(const aname, ws: WideString): Integer;
begin
  Result := self.Add(aname, TJsonstring.Generate(ws));
end;

class function TJsonObject.SelfType: TJsonTypes;
begin
  Result := jsObject;
end;

class function TJsonObject.SelfTypeName: string;
begin
  Result := 'jsObject';
end;

function TJsonObject.GetFieldByIndex(idx: Integer): TJsonObjectBase;
var
  nm: WideString;
begin
  nm := GetNameOf(idx);
  if nm <> '' then
    begin
      result := Field[nm];
    end
  else
    begin
      result := nil;
    end;
end;

function TJsonObject.GetNameOf(idx: Integer): WideString;
var
  mth: TJsonObjectMethod;
begin
  if (idx < 0) or (idx >= Count) then
    begin
      result := '';
    end
  else
    begin
      mth := Child[idx] as TJsonObjectMethod;
      result := mth.Name;
    end;
end;

procedure TJsonObject.SetFieldByIndex(idx: Integer;
  const AValue: TJsonObjectBase);
var
  nm: WideString;
begin
  nm := GetNameOf(idx);
  if nm <> '' then
    begin
      Field[nm] := AValue;
    end;
end;

function TJsonObject.ForEachElement(idx: Integer;
  var nm: string): TJsonObjectBase;
begin
  nm := GetNameOf(idx);
  result := GetFieldByIndex(idx);
end;

function TJsonObject.GetField(AName: Variant):TJsonObjectBase;
begin
  if VarIsStr(AName) then
    result := OldGetField(VarToWideStr(AName))
  else
    result := inherited GetField(AName);
end;

{$IFDEF USE_HASH}
function TJsonObject.GetHashTable: THashTable;
{$ELSE}
function TJsonObject.GetHashTable: TBalTree;
{$ENDIF USE_HASH}
begin
  result := ht;
end;

constructor TJsonObject.Create(bUseHash: Boolean);
begin
  inherited Create;
  FUseHash := bUseHash;
{$IFDEF USE_HASH}
  ht := THashTable.Create;
  ht.FParent := self;
{$ELSE}
  ht := TBalTree.Create;
{$ENDIF}
end;

destructor TJsonObject.Destroy;
begin
  if assigned(ht) then FreeAndNil(ht);
  inherited;
end;

function TJsonObject.getDouble(idx: Integer): Double;
var
  jn: TJsonNumber;
begin
  jn := FieldByIndex[idx] as TJsonNumber;
  if not assigned(jn) then result := 0
  else result := jn.Value;
end;

function TJsonObject.getInt(idx: Integer): Integer;
var
  jn: TJsonNumber;
begin
  jn := FieldByIndex[idx] as TJsonNumber;
  if not assigned(jn) then result := 0
  else result := round(int(jn.Value));
end;

function TJsonObject.getString(idx: Integer): string;
var
  js: TJsonstring;
begin
  js := FieldByIndex[idx] as TJsonstring;
  if not assigned(js) then result := ''
  else result := vartostr(js.Value);
end;

function TJsonObject.getWideString(idx: Integer): WideString;
var
  js: TJsonstring;
begin
  js := FieldByIndex[idx] as TJsonstring;
  if not assigned(js) then result := ''
  else result := VarToWideStr(js.Value);
end;

{$ifdef TCB_EXT}
function TJsonObject.getDoubleFromName(nm: string): Double;
{$else}
function TJsonObject.getDouble(nm: string): Double;
{$endif}
begin
  result := getDouble(IndexOfName(nm));
end;

{$ifdef TCB_EXT}
function TJsonObject.getIntFromName(nm: string): Integer;
{$else}
function TJsonObject.getInt(nm: string): Integer;
{$endif}
begin
  result := getInt(IndexOfName(nm));
end;

{$ifdef TCB_EXT}
function TJsonObject.getStringFromName(nm: string): string;
{$else}
function TJsonObject.getString(nm: string): string;
{$endif}
begin
  result := getString(IndexOfName(nm));
end;

{$ifdef TCB_EXT}
function TJsonObject.getWideStringFromName(nm: string): WideString;
{$else}
function TJsonObject.getWideString(nm: string): WideString;
{$endif}
begin
  result := getWideString(IndexOfName(nm));
end;

function TJsonObject.getBoolean(idx: Integer): Boolean;
var
  jb: TJSonBoolean;
begin
  jb := FieldByIndex[idx] as TJSonBoolean;
  if not assigned(jb) then result := false
  else result := jb.Value;
end;

{$ifdef TCB_EXT}
function TJsonObject.getBooleanFromName(nm: string): Boolean;
{$else}
function TJsonObject.getBoolean(nm: string): Boolean;
{$endif}
begin
  result := getBoolean(IndexOfName(nm));
end;

{ TJson }

class function TJson.GenerateText(obj: TJsonObjectBase): string;
var
{$IFDEF HAVE_FORMATSETTING}
  fs: TFormatSettings;
{$ENDIF}
  pt1, pt0, pt2: PChar;
  ptsz: cardinal;

{$IFNDEF NEW_STYLE_GENERATE}

  function gn_base(obj: TJsonObjectBase): string;
  var
    ws: string;
    i, j: Integer;
    xs: TJsonstring;
  begin
    result := '';
    if not assigned(obj) then exit;
    if obj is TJsonNumber then
      begin
{$IFDEF HAVE_FORMATSETTING}
        result := FloatToStr(TJsonNumber(obj).FValue, fs);
{$ELSE}
        result := FloatToStr(TJsonNumber(obj).FValue);
        i := pos(DecimalSeparator, result);
        if (DecimalSeparator <> '.') and (i > 0) then
          result[i] := '.';
{$ENDIF}
      end
    else if obj is TJsonstring then
      begin
        ws := UTF8Encode(TJsonstring(obj).FValue);
        i := 1;
        result := '"';
        while i <= length(ws) do
          begin
            case ws[i] of
              '/', '\', '"': result := result + '\' + ws[i];
              #8: result := result + '\b';
              #9: result := result + '\t';
              #10: result := result + '\n';
              #13: result := result + '\r';
              #12: result := result + '\f';
            else
              if ord(ws[i]) < 32 then
                result := result + '\u' + inttohex(ord(ws[i]), 4)
              else
                result := result + ws[i];
            end;
            inc(i);
          end;
        result := result + '"';
      end
    else if obj is TJSonBoolean then
      begin
        if TJSonBoolean(obj).FValue then
          result := 'true'
        else
          result := 'false';
      end
    else if obj is TJsonNull then
      begin
        result := 'null';
      end
    else if obj is TJsonList then
      begin
        result := '[';
        j := TJsonObject(obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then result := result + ',';
            result := result + gn_base(TJsonList(obj).Child[i]);
          end;
        result := result + ']';
      end
    else if obj is TJsonObjectMethod then
      begin
        try
          xs := TJsonstring.Create;
          xs.FValue := TJsonObjectMethod(obj).FName;
          result := gn_base(TJsonObjectBase(xs)) + ':';
          result := result +
            gn_base(TJsonObjectBase(TJsonObjectMethod(obj).FValue));
        finally
          if assigned(xs) then FreeAndNil(xs);
        end;
      end
    else if obj is TJsonObject then
      begin
        result := '{';
        j := TJsonObject(obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then result := result + ',';
            result := result + gn_base(TJsonObject(obj).Child[i]);
          end;
        result := result + '}';
      end;
  end;
{$ELSE}

  procedure get_more_memory;
  var
    delta: cardinal;
  begin
    delta := 50000;
    if pt0 = nil then
      begin
        pt0 := AllocMem(delta);
        ptsz := 0;
        pt1 := pt0;
      end
    else
      begin
        ReallocMem(pt0, ptsz + delta);
        pt1 := pointer(cardinal(pt0) + ptsz);
      end;
    ptsz := ptsz + delta;
    pt2 := pointer(cardinal(pt1) + delta);
  end;

  procedure mem_ch(ch: char);
  begin
    if pt1 >= pt2 then get_more_memory;
    pt1^ := ch;
    inc(pt1);
  end;

  procedure mem_write(rs: string);
  var
    i: Integer;
  begin
    for i := 1 to length(rs) do
      begin
        if pt1 >= pt2 then get_more_memory;
        pt1^ := rs[i];
        inc(pt1);
      end;
  end;

  procedure gn_base(obj: TJsonObjectBase);
  var
    ws: string;
    i, j: Integer;
    xs: TJsonstring;
  begin
    if not assigned(obj) then exit;
    if obj is TJsonNumber then
      begin
{$IFDEF HAVE_FORMATSETTING}
        mem_write(FloatToStr(TJsonNumber(obj).FValue, fs));
{$ELSE}
        ws := FloatToStr(TJsonNumber(obj).FValue);
        i := pos(DecimalSeparator, ws);
        if (DecimalSeparator <> '.') and (i > 0) then ws[i] := '.';
        mem_write(ws);
{$ENDIF}
      end
    else if obj is TJsonstring then
      begin
        ws := UTF8Encode(TJsonstring(obj).FValue);
        i := 1;
        mem_ch('"');
        while i <= length(ws) do
          begin
            case ws[i] of
              '/', '\', '"':
                begin
                  mem_ch('\');
                  mem_ch(ws[i]);
                end;
              #8: mem_write('\b');
              #9: mem_write('\t');
              #10: mem_write('\n');
              #13: mem_write('\r');
              #12: mem_write('\f');
            else
              if ord(ws[i]) < 32 then
                mem_write('\u' + inttohex(ord(ws[i]), 4))
              else
                mem_ch(ws[i]);
            end;
            inc(i);
          end;
        mem_ch('"');
      end
    else if obj is TJSonBoolean then
      begin
        if TJSonBoolean(obj).FValue then
          mem_write('true')
        else
          mem_write('false');
      end
    else if obj is TJsonNull then
      begin
        mem_write('null');
      end
    else if obj is TJsonList then
      begin
        mem_ch('[');
        j := TJsonObject(obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then mem_ch(',');
            gn_base(TJsonList(obj).Child[i]);
          end;
        mem_ch(']');
      end
    else if obj is TJsonObjectMethod then
      begin
        try
          xs := TJsonstring.Create;
          xs.FValue := TJsonObjectMethod(obj).FName;
          gn_base(TJsonObjectBase(xs));
          mem_ch(':');
          gn_base(TJsonObjectBase(TJsonObjectMethod(obj).FValue));
        finally
          if assigned(xs) then FreeAndNil(xs);
        end;
      end
    else if obj is TJsonObject then
      begin
        mem_ch('{');
        j := TJsonObject(obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then mem_ch(',');
            gn_base(TJsonObject(obj).Child[i]);
          end;
        mem_ch('}');
      end;
  end;
{$ENDIF NEW_STYLE_GENERATE}

begin
{$IFDEF HAVE_FORMATSETTING}
  GetLocaleFormatSettings(GetThreadLocale, fs);
  fs.DecimalSeparator := '.';
{$ENDIF}
{$IFDEF NEW_STYLE_GENERATE}
  pt0 := nil;
  get_more_memory;
  gn_base(obj);
  mem_ch(#0);
  result := string(pt0);
  freemem(pt0);
{$ELSE}
  result := gn_base(obj);
{$ENDIF}
end;

class function TJson.ParseText(const txt: string): TJsonObjectBase;
{$IFDEF HAVE_FORMATSETTING}
var
  fs: TFormatSettings;
{$ENDIF}

  function js_base(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean; forward;

  function xe(idx: Integer): Boolean;
  {$IFDEF FPC}inline;
  {$ENDIF}
  begin
    result := idx <= length(txt);
  end;

  procedure skip_spc(var idx: Integer);
  {$IFDEF FPC}inline;
  {$ENDIF}
  begin
    while (xe(idx)) and (ord(txt[idx]) < 33) do
      inc(idx);
  end;

  procedure add_child(var o, c: TJsonObjectBase);
  var
    i: Integer;
  begin
    if o = nil then
      begin
        o := c;
      end
    else
      begin
        if o is TJsonObjectMethod then
          begin
            TJsonObjectMethod(o).FValue := c;
          end
        else if o is TJsonList then
          begin
            TJsonList(o)._Add(c);
          end
        else if o is TJsonObject then
          begin
            i := TJsonObject(o)._Add(c);
            if TJsonObject(o).UseHash then
{$IFDEF USE_HASH}
              TJsonObject(o).ht.AddPair(TJsonObjectMethod(c).Name, i);
{$ELSE}
              TJsonObject(o).ht.Insert(TJsonObjectMethod(c).Name, i);
{$ENDIF USE_HASH}
          end;
      end;
  end;

  function js_boolean(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  var
    js: TJSonBoolean;
  begin
    skip_spc(idx);
    if copy(txt, idx, 4) = 'true' then
      begin
        result := true;
        ridx := idx + 4;
        js := TJSonBoolean.Create;
        js.FValue := true;
        add_child(o, TJsonObjectBase(js));
      end
    else if copy(txt, idx, 5) = 'false' then
      begin
        result := true;
        ridx := idx + 5;
        js := TJSonBoolean.Create;
        js.FValue := false;
        add_child(o, TJsonObjectBase(js));
      end
    else
      begin
        result := false;
      end;
  end;

  function js_null(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  var
    js: TJsonNull;
  begin
    skip_spc(idx);
    if copy(txt, idx, 4) = 'null' then
      begin
        result := true;
        ridx := idx + 4;
        js := TJsonNull.Create;
        add_child(o, TJsonObjectBase(js));
      end
    else
      begin
        result := false;
      end;
  end;

  function js_integer(idx: Integer; var ridx: Integer): Boolean;
  begin
    result := false;
    while (xe(idx)) and (txt[idx] in ['0'..'9']) do
      begin
        result := true;
        inc(idx);
      end;
    if result then ridx := idx;
  end;

  function js_number(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  var
    js: TJsonNumber;
    ws: string;
  {$IFNDEF HAVE_FORMATSETTING}
    i: Integer;
  {$ENDIF}
  begin
    skip_spc(idx);
    result := xe(idx);
    if not result then exit;
    if txt[idx] in ['+', '-'] then
      begin
        inc(idx);
        result := xe(idx);
      end;
    if not result then exit;
    result := js_integer(idx, idx);
    if not result then exit;
    if (xe(idx)) and (txt[idx] = '.') then
      begin
        inc(idx);
        result := js_integer(idx, idx);
        if not result then exit;
      end;
    if (xe(idx)) and (txt[idx] in ['e', 'E']) then
      begin
        inc(idx);
        if (xe(idx)) and (txt[idx] in ['+', '-']) then inc(idx);
        result := js_integer(idx, idx);
        if not result then exit;
      end;
    if not result then exit;
    js := TJsonNumber.Create;
    ws := copy(txt, ridx, idx - ridx);
{$IFDEF HAVE_FORMATSETTING}
    js.FValue := StrToFloat(ws, fs);
{$ELSE}
    i := pos('.', ws);
    if (DecimalSeparator <> '.') and (i > 0) then
      ws[pos('.', ws)] := DecimalSeparator;
    js.FValue := StrToFloat(ws);
{$ENDIF}
    add_child(o, TJsonObjectBase(js));
    ridx := idx;
  end;

{

}
  function js_string(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;

    function strSpecialChars(const s: string): string;
    var
      i, j : integer;
    begin
      i := Pos('\', s);
      if (i = 0) then
        Result := s
      else
      begin
        Result := Copy(s, 1, i-1);
        j := i;
        repeat
          if (s[j] = '\') then
          begin
            inc(j);
            case s[j] of
              '\': Result := Result + '\';
              '"': Result := Result + '"';
              '''': Result := Result + '''';
              '/': Result := Result + '/';
              'b': Result := Result + #8;
              'f': Result := Result + #12;
              'n': Result := Result + #10;
              'r': Result := Result + #13;
              't': Result := Result + #9;
              'u':
                begin
                  Result := Result + code2utf(strtoint('$' + copy(s, j + 1, 4)));
                  inc(j, 4);
                end;
            end;
          end
          else
            Result := Result + s[j];
          inc(j);
        until j > length(s);
      end;
    end;

  var
    js: TJsonstring;
    fin: Boolean;
    ws: String;
    i,j,widx: Integer;
  begin
    skip_spc(idx);

    result := xe(idx) and (txt[idx] = '"');
    if not result then exit;

    inc(idx);
    widx := idx;

    fin:=false;
    REPEAT
      i := 0;
      j := 0;
      while (widx<=length(txt)) and (j=0) do
        begin
          if (i=0) and (txt[widx]='\') then i:=widx;
          if (j=0) and (txt[widx]='"') then j:=widx;
          inc(widx);
        end;
      if j=0 then
        begin
          result := false;
          exit;
        end;
      if (i=0) or (j<i) then
        begin
          ws := copy(txt,idx,j-idx);
          idx := j;
          fin := true;
        end
      else
        begin
          widx:=i+2;
        end;
    UNTIL fin;

    ws := strSpecialChars(ws);
    inc(idx);

    js := TJsonstring.Create;
{$ifdef USE_D2009}
    js.FValue := UTF8ToString(ws);
{$else}
    js.FValue := UTF8Decode(ws);
{$endif}
    add_child(o, TJsonObjectBase(js));
    ridx := idx;
  end;

  function js_list(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  var
    js: TJsonList;
  begin
    result := false;
    try
      js := TJsonList.Create;
      skip_spc(idx);
      result := xe(idx);
      if not result then exit;
      result := txt[idx] = '[';
      if not result then exit;
      inc(idx);
      while js_base(idx, idx, TJsonObjectBase(js)) do
        begin
          skip_spc(idx);
          if (xe(idx)) and (txt[idx] = ',') then inc(idx);
        end;
      skip_spc(idx);
      result := (xe(idx)) and (txt[idx] = ']');
      if not result then exit;
      inc(idx);
    finally
      if not result then
        begin
          js.Free;
        end
      else
        begin
          add_child(o, TJsonObjectBase(js));
          ridx := idx;
        end;
    end;
  end;

  function js_method(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  var
    mth: TJsonObjectMethod;
    ws: TJsonstring;
  begin
    result := false;
    try
      ws := nil;
      mth := TJsonObjectMethod.Create;
      skip_spc(idx);
      result := xe(idx);
      if not result then exit;
      result := js_string(idx, idx, TJsonObjectBase(ws));
      if not result then exit;
      skip_spc(idx);
      result := xe(idx) and (txt[idx] = ':');
      if not result then exit;
      inc(idx);
      mth.FName := ws.FValue;
      result := js_base(idx, idx, TJsonObjectBase(mth));
    finally
      if ws <> nil then ws.Free;
      if result then
        begin
          add_child(o, TJsonObjectBase(mth));
          ridx := idx;
        end
      else
        begin
          mth.Free;
        end;
    end;
  end;

  function js_object(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  var
    js: TJsonObject;
  begin
    result := false;
    try
      js := TJsonObject.Create;
      skip_spc(idx);
      result := xe(idx);
      if not result then exit;
      result := txt[idx] = '{';
      if not result then exit;
      inc(idx);
      while js_method(idx, idx, TJsonObjectBase(js)) do
        begin
          skip_spc(idx);
          if (xe(idx)) and (txt[idx] = ',') then inc(idx);
        end;
      skip_spc(idx);  
      result := (xe(idx)) and (txt[idx] = '}');
      if not result then exit;
      inc(idx);
    finally
      if not result then
        begin
          js.Free;
        end
      else
        begin
          add_child(o, TJsonObjectBase(js));
          ridx := idx;
        end;
    end;
  end;

  function js_base(idx: Integer; var ridx: Integer; var o:
    TJsonObjectBase): Boolean;
  begin
    skip_spc(idx);
    result := js_boolean(idx, idx, o);
    if not result then result := js_null(idx, idx, o);
    if not result then result := js_number(idx, idx, o);
    if not result then result := js_string(idx, idx, o);
    if not result then result := js_list(idx, idx, o);
    if not result then result := js_object(idx, idx, o);
    if result then ridx := idx;
  end;

var
  idx: Integer;
begin
{$IFDEF HAVE_FORMATSETTING}
  GetLocaleFormatSettings(GetThreadLocale, fs);
  fs.DecimalSeparator := '.';
{$ENDIF}

  result := nil;
  if txt = '' then exit;
  try
    idx := 1;
    if copy(txt,idx,3)=#239#187#191 then
      begin
        inc(idx,3);
        if idx>length(txt) then exit;
      end;
    if not js_base(idx, idx, result) then FreeAndNil(result);
  except
    if assigned(result) then FreeAndNil(result);
  end;
end;

{ EIntException }

constructor EIntException.Create(idx: Integer; msg: string);
begin
  self.idx := idx;
  inherited Create(msg);
end;

{ THashTable }

{$IFDEF USE_HASH}
procedure THashTable.AddPair(const ws: WideString; idx: Integer);
var
  i, j, k: cardinal;
  p: PHashItem;
  find: boolean;
begin
  find := false;
  if InTable(ws, i, j, k) then
    begin
      if TJsonObject(FParent).GetNameOf(PHashItem(a_x[j].Items[k])^.index) = ws then
        begin
           PHashItem(a_x[j].Items[k])^.index := idx;
           find := true;
        end;
    end;
  if find = false then
    begin
      GetMem(p,sizeof(THashItem));
      k := a_x[j].Add(p);
      p^.hash := i;
      p^.index := idx;
      while (k>0) and (PHashItem(a_x[j].Items[k])^.hash < PHashItem(a_x[j].Items[k-1])^.hash) do
        begin
          a_x[j].Exchange(k,k-1);
          dec(k);
        end;
    end;
end;

function THashTable.counters: string;
var
  i, j: Integer;
  ws: string;
begin
  ws := '';
  for i := 0 to 15 do
    begin
      for j := 0 to 15 do
        ws := ws + format('%.3d ', [a_x[i * 16 + j].Count]);
      ws := ws + #13#10;
    end;
  result := ws;
end;

procedure THashTable.Delete(const ws: WideString);
var
  i, j, k: cardinal;
begin
  if InTable(ws, i, j, k) then
    begin
      FreeMem(a_x[j].Items[k]);
      a_x[j].Delete(k);
    end;
end;

{$IFDEF THREADSAFE}
const
  rnd_table: array[0..255] of byte =
  (216, 191, 234, 201, 12, 163, 190, 205, 128, 199, 210, 17, 52, 43,
    38, 149, 40, 207, 186, 89, 92, 179, 142, 93, 208, 215, 162,
    161, 132, 59, 246, 37, 120, 223, 138, 233, 172, 195, 94, 237, 32,
    231, 114, 49, 212, 75, 198, 181, 200, 239, 90, 121, 252, 211,
    46, 125, 112, 247, 66, 193, 36, 91, 150, 69, 24, 255, 42, 9, 76,
    227, 254, 13, 192, 7, 18, 81, 116, 107, 102, 213, 104, 15, 250,
    153, 156, 243, 206, 157, 16, 23, 226, 225, 196, 123, 54, 101,
    184, 31, 202, 41, 236, 3, 158, 45, 96, 39, 178, 113, 20, 139, 6,
    245, 8, 47, 154, 185, 60, 19, 110, 189, 176, 55, 130, 1, 100,
    155, 214, 133, 88, 63, 106, 73, 140, 35, 62, 77, 0, 71, 82, 145,
    180,
    171, 166, 21, 168, 79, 58, 217, 220, 51, 14, 221, 80, 87, 34, 33,
    4, 187, 118, 165, 248, 95, 10, 105, 44, 67, 222, 109, 160, 103,
    242, 177, 84, 203, 70, 53, 72, 111, 218, 249, 124, 83, 174, 253,
    240, 119, 194, 65, 164, 219, 22, 197, 152, 127, 170, 137, 204,
    99, 126, 141, 64, 135, 146, 209, 244, 235, 230, 85, 232, 143,
    122, 25, 28, 115, 78, 29, 144, 151, 98, 97, 68, 251, 182, 229,
    56,
    159, 74, 169, 108, 131, 30, 173, 224, 167, 50, 241, 148, 11, 134,
    117, 136, 175, 26, 57, 188, 147, 238, 61, 48, 183, 2, 129,
    228, 27, 86, 5);
{$ELSE}
var
  rnd_table: array[0..255] of byte;
{$ENDIF}

function THashTable.DefaultHashOf(const ws: WideString): cardinal;
{$IFDEF DOTNET}
var
  i, j: Integer;
  x1, x2, x3, x4: byte;
begin
  result := 0;
  x1 := 0;
  x2 := 1;
  for i := 1 to length(ws) do
    begin
      j := ord(ws[i]);
      x1 := (x1 + j)
      x2 := (x2 + 1 + (j shr 8))
      x3 := rnd_table[x1];
      x4 := rnd_table[x3];
      result := ((x1 * x4) + (x2 * x3)) xor result;
    end;
end;
{$ELSE}
var
  x1, x2, x3, x4: byte;
  p: PWideChar;
begin
  result := 0;
  x1 := 0;
  x2 := 1;
  p := PWideChar(ws);
  while p^ <> #0 do
    begin
      inc(x1, ord(p^)) {and $FF};
      inc(x2, 1 + (ord(p^) shr 8)) {and $FF};
      x3 := rnd_table[x1];
      x4 := rnd_table[x3];
      result := ((x1 * x4) + (x2 * x3)) xor result;
      inc(p);
    end;
end;
{$ENDIF}

procedure THashTable.hswap(j, k, l: Integer);
begin
  a_x[j].Exchange(k, l);
end;

function THashTable.IndexOf(const ws: WideString): Integer;
var
  i, j, k: Cardinal;
begin
  if not InTable(ws, i, j, k) then
    begin
      result := -1;
    end
  else
    begin
      result := PHashItem(a_x[j].Items[k])^.index;
    end;
end;

function THashTable.InTable(const ws: WideString; var i, j, k:
  cardinal):
  Boolean;
var
  l, wu, wl: Integer;
  x: Cardinal;
  fin: Boolean;
begin
  i := HashOf(ws);
  j := i and $FF;
  result := false;
  if a_x[j].Count-1 >= 0 then
    begin
      wl := 0;
      wu := a_x[j].Count-1;
      repeat
        fin := true;
        if PHashItem(a_x[j].Items[wl])^.hash = i then
          begin
            k := wl;
            result := true;
          end
        else if PHashItem(a_x[j].Items[wu])^.hash = i then
          begin
            k := wu;
            result := true;
          end
        else if (wu - wl) > 1 then
          begin
            fin := false;
            x := (wl + wu) shr 1;
            if PHashItem(a_x[j].Items[x])^.hash > i then
              begin
                wu := x;
              end
            else
              begin
                wl := x;
              end;
          end;
      until fin;
    end;

  if result = true then
    begin
      while (k > 0) and (PHashItem(a_x[j].Items[k])^.hash = PHashItem(a_x[j].Items[k-1])^.hash) do dec(k);
      repeat
        fin := true;
        if TJsonObject(FParent).GetNameOf(PHashItem(a_x[j].Items[k])^.index) <> ws then
          begin
            if k < a_x[j].Count-1 then
              begin
                inc(k);
                fin := false;
              end
            else
              begin
                result := false;
              end;
          end
        else
          begin
            result := true;
          end;
      until fin;
    end;
end;

{$IFNDEF THREADSAFE}

procedure init_rnd;
var
  x0: Integer;
  i: Integer;
begin
  x0 := 5;
  for i := 0 to 255 do
    begin
      x0 := (x0 * 29 + 71) and $FF;
      rnd_table[i] := x0;
    end;
end;
{$ENDIF}

procedure THashTable.SetHashFunction(const AValue:
  THashFunction);
begin
  FHashFunction := AValue;
end;

constructor THashTable.Create;
var
  i: Integer;
begin
  inherited;
  for i := 0 to 255 do a_x[i] := TList.Create;
  HashOf := {$IFDEF FPC}@{$ENDIF}DefaultHashOf;
end;

destructor THashTable.Destroy;
var
  i, j: Integer;
begin
  for i := 0 to 255 do
    begin
      for j := 0 to a_x[i].Count - 1 do Freemem(a_x[i].Items[j]);
      a_x[i].Free;
    end;
  inherited;
end;

function THashTable.SimpleHashOf(const ws: WideString): cardinal;
var
  i: Integer;
begin
  result := length(ws);
  for i := 1 to length(ws) do result := result + ord(ws[i]);
end;
{$ENDIF USE_HASH}

{ TJsonStreamed }
{$IFNDEF KOL}

class function TJsonStreamed.LoadFromFile(srcname: string):
  TJsonObjectBase;
var
  fs: TFileStream;
begin
  result := nil;
  if not FileExists(srcname) then exit;
  try
    fs := TFileStream.Create(srcname, fmOpenRead);
    result := LoadFromStream(fs);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

class function TJsonStreamed.LoadFromStream(src: TStream):
  TJsonObjectBase;
var
  ws: string;
  len: int64;
begin
  result := nil;
  if not assigned(src) then exit;
  len := src.Size - src.Position;
  SetLength(ws, len);
  src.Read(pchar(ws)^, len);
  result := ParseText(ws);
end;

class procedure TJsonStreamed.SaveToFile(obj: TJsonObjectBase;
  dstname: string);
var
  fs: TFileStream;
begin
  if not assigned(obj) then exit;
  try
    fs := TFileStream.Create(dstname, fmCreate);
    SaveToStream(obj, fs);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

class procedure TJsonStreamed.SaveToStream(obj: TJsonObjectBase;
  dst: TStream);
var
  ws: string;
begin
  if not assigned(obj) then exit;
  if not assigned(dst) then exit;
  ws := GenerateText(obj);
  dst.Write(pchar(ws)^, length(ws));
end;

{$ENDIF}

{ TJSonDotNetClass }

{$IFDEF DOTNET}

procedure TJSonDotNetClass.AfterConstruction;
begin

end;

procedure TJSonDotNetClass.BeforeDestruction;
begin

end;

constructor TJSonDotNetClass.Create;
begin
  inherited;
  AfterConstruction;
end;

destructor TJSonDotNetClass.Destroy;
begin
  BeforeDestruction;
  inherited;
end;
{$ENDIF DOTNET}

{ TBalTree }

{$IFNDEF USE_HASH}
procedure TBalTree.Clear;

  procedure rec(t: PBalNode);
  begin
    if t.left<>fbottom then rec(t.left);
    if t.right<>fbottom then rec(t.right);
    t.nm := '';
    dispose(t);
  end;

begin
  if froot<>fbottom then rec(froot);
  froot := fbottom;
  fdeleted := fbottom;
end;

function TBalTree.counters: string;
begin
  result := format('Balanced tree root node level is %d',[froot.level]);
end;

constructor TBalTree.Create;
begin
  inherited Create;
  new(fbottom);
  fbottom.left := fbottom;
  fbottom.right := fbottom;
  fbottom.level := 0;
  fdeleted := fbottom;
  froot := fbottom;
end;

function TBalTree.Delete(const ws: WideString): Boolean;

  procedure UpdateKeys(t: PBalNode; idx: integer);
  begin
    if t <> fbottom then begin
      if t.key > idx then
        t.key := t.key - 1;
      UpdateKeys(t.left, idx);
      UpdateKeys(t.right, idx);
    end;
  end;

  function del(var t: PBalNode): Boolean;
  begin
    result := false;
    if t<>fbottom then begin
      flast := t;
      if ws<t.nm then
        result := del(t.left)
      else begin
        fdeleted := t;
        result := del(t.right);
      end;
      if (t = flast) and (fdeleted <> fbottom) and (ws = fdeleted.nm) then begin
        UpdateKeys(froot, fdeleted.key);
        fdeleted.key := t.key;
        fdeleted.nm := t.nm;
        t := t.right;
        flast.nm := '';
        dispose(flast);
        result := true;
      end
      else if (t.left.level < (t.level - 1)) or (t.right.level < (t.level - 1)) then begin
        t.level := t.level - 1;
        if t.right.level > t.level then
          t.right.level := t.level;
        skew(t);
        skew(t.right);
        skew(t.right.right);
        split(t);
        split(t.right);
      end;
    end;
  end;

begin
  result := del(froot);
end;

destructor TBalTree.Destroy;
begin
  Clear;
  dispose(fbottom);
  inherited;
end;

function TBalTree.IndexOf(const ws: WideString): Integer;
var
  tk: PBalNode;
begin
  result := -1;
  tk := froot;
  while (result=-1) and (tk<>fbottom) do
    begin
      if tk.nm = ws then result := tk.key
      else if ws<tk.nm then tk := tk.left
      else tk := tk.right;
    end;
end;

function TBalTree.Insert(const ws: WideString; x: Integer): Boolean;

  function ins(var t: PBalNode): Boolean;
  begin
    if t = fbottom then
      begin
        new(t);
        t.key := x;
        t.nm := ws;
        t.left := fbottom;
        t.right := fbottom;
        t.level := 1;
        result := true;
      end
    else
      begin
        if ws < t.nm then
          result := ins(t.left)
        else if ws > t.nm then
          result := ins(t.right)
        else result := false;
        skew(t);
        split(t);
      end;
  end;

begin
  result := ins(froot);
end;

procedure TBalTree.skew(var t: PBalNode);
var
  temp: PBalNode;
begin
  if t.left.level = t.level then
    begin
      temp := t;
      t := t.left;
      temp.left := t.right;
      t.right := temp;
    end;
end;

procedure TBalTree.split(var t: PBalNode);
var
  temp: PBalNode;
begin
  if t.right.right.level = t.level then
    begin
      temp := t;
      t := t.right;
      temp.right := t.left;
      t.left := temp;
      t.level := t.level+1;
    end;
end;
{$ENDIF USE_HASH}

initialization
{$IFNDEF THREADSAFE}
{$IFDEF USE_HASH}
  init_rnd;
{$ENDIF USE_HASH}
{$ENDIF THREADSAFE}
end.


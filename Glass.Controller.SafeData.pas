unit Glass.Controller.SafeData;

interface

uses
  SysUtils, Dialogs;

type
  TEncodeAction = (EncryptAction, DecryptAction) ;

  TEncoder = class(TObject)
  private
    FKey: Integer;
    function Codefy( const Value: string; const Action: TEncodeAction; const Key: Integer ): string;
    procedure SetKey(const Value: Integer);
  public
    function Encode( pValue: String; pKey: Integer = 0 ): String;
    function Decode( pValue: String; pKey: Integer = 0 ): String;
    property Key: Integer read FKey write SetKey;
    constructor Create; overload;
    destructor Destroy; overload;
  end;

  const
    DefaultKey = 967957;

implementation

function TEncoder.Codefy( const Value: string; const Action: TEncodeAction; const Key: Integer ): string;
var
  SChave: string[07];
  L, K, T: Integer;
  DeCod: ShortInt;
  function GetActionAsInteger : ShortInt;
  begin
    if ( Action = EncryptAction ) then
    begin
      Result := -1;
    end
    else
    begin
      Result := 1;
    end;
  end;
begin
  DeCod := GetActionAsInteger;
  Result := '';
  SChave := IntToStr(Key);

  while Length(SChave) < 7 do
  begin
    SChave := '0' + SChave;
  end;

  for K := 1 to length(Value) do
  begin
    L := K - (K div 7) * 7 + 1;
    T := ord(Value[K]) + (DeCod * StrToInt(SChave[L]));
    if (T > 127) or (T < 32) then
      T := T - (DeCod * 26);
    Result := Result + Chr(T);
  end;

end;

constructor TEncoder.Create;
begin
  inherited Create;
  FKey := 0;
end;

function TEncoder.Decode(pValue: String; pKey: Integer): String;
begin
  if pkey > 0 then
  begin
    Result := Codefy(pValue, DecryptAction, pKey);
  end
  else
  begin
    if FKey > 0 then
    begin
      Result := Codefy(pValue, DecryptAction, FKey);
    end
    else
    begin
      Result := Codefy(pValue, DecryptAction, DefaultKey);
    end;
  end;
end;

destructor TEncoder.Destroy;
begin
  inherited Destroy;
end;

function TEncoder.Encode(pValue: String; pKey: Integer): String;
begin
  if pkey > 0 then
  begin
    Result := Codefy(pValue, EncryptAction, pKey);
  end
  else
  begin
    if FKey > 0 then
    begin
      Result := Codefy(pValue, EncryptAction, FKey);
    end
    else
    begin
      Result := Codefy(pValue, EncryptAction, DefaultKey);
    end;
  end;
end;

procedure TEncoder.SetKey(const Value: Integer);
begin
  if Length(IntToStr(Value)) <> 6 then
  begin
    ShowMessage('A chave deve ter o total de 6 caracteres!');
    Exit;
  end
  else
  begin
    FKey := Value;
  end;
end;

end.


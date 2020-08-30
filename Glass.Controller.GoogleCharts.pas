unit Glass.Controller.GoogleCharts;

interface

uses
  Classes, SysUtils, ActiveX; //, System;

type
  TGooglePie = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleColumn = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleBar = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleLine = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleArea = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleCandleStick = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleGantt = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleHistogram = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleComboChart = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

  TGoogleOrgChart = class
  private
    HTMLPage: TStringList;
    Data: TStringList;
    FTitle: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataClear;
    procedure AddData(Caption: string; Value: string);
    procedure SetChartToDocument(Document: IDispatch);
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
  end;

implementation

{ TGoogleColumn }

procedure TGoogleColumn.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleColumn.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleColumn.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleColumn.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleColumn.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.ColumnChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleColumn.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleColumn.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleColumn.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGooglePie }

procedure TGooglePie.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGooglePie.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGooglePie.DataClear;
begin
  Data.Clear;
end;

destructor TGooglePie.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGooglePie.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.PieChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGooglePie.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGooglePie.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGooglePie.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleBar }

procedure TGoogleBar.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleBar.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleBar.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleBar.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleBar.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.BarChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleBar.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleBar.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleBar.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleLine }

procedure TGoogleLine.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleLine.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleLine.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleLine.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleLine.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.LineChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleLine.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleLine.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleLine.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleArea }

procedure TGoogleArea.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleArea.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleArea.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleArea.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleArea.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.AreaChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleArea.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleArea.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleArea.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleCandleStick }

procedure TGoogleCandleStick.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleCandleStick.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleCandleStick.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleCandleStick.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleCandleStick.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.CandleStickChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleCandleStick.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleCandleStick.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleCandleStick.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleGantt }

procedure TGoogleGantt.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleGantt.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleGantt.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleGantt.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleGantt.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.Gantt(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleGantt.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleGantt.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleGantt.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleHistogram }

procedure TGoogleHistogram.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleHistogram.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleHistogram.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleHistogram.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleHistogram.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.Histogram(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleHistogram.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleHistogram.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleHistogram.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

 { TGoogleComboChart }

procedure TGoogleComboChart.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleComboChart.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleComboChart.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleComboChart.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleComboChart.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.ComboChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleComboChart.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleComboChart.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleComboChart.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TGoogleOrgChart }

procedure TGoogleOrgChart.AddData(Caption, Value: string);
begin
  Data.Add(Caption + '=' + Value);
end;

constructor TGoogleOrgChart.Create;
begin
  HTMLPage := TStringList.create;
  Data := TStringList.create;
  FTitle := 'NO_TITLE';
  FHeight := 255;
  FWidth := 455;
end;

procedure TGoogleOrgChart.DataClear;
begin
  Data.Clear;
end;

destructor TGoogleOrgChart.Destroy;
begin
  FreeAndNil(HTMLPage);
  FreeAndNil(Data);
  inherited Destroy;
end;

procedure TGoogleOrgChart.SetChartToDocument(Document: IDispatch);
var
  I: Integer;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  HTMLPage.Add('<html>');
  HTMLPage.Add('  <head>');
  HTMLPage.Add('    <script type="text/javascript" src="https://www.google.com/jsapi"></script>');
  HTMLPage.Add('    <script type="text/javascript">');
  HTMLPage.Add('      google.load("visualization", "1", {packages:["corechart"]});');
  HTMLPage.Add('      google.setOnLoadCallback(drawChart);');
  HTMLPage.Add('      function drawChart() {');
  HTMLPage.Add('        var data = google.visualization.arrayToDataTable([');
//  HTMLPage.Add('          [' + QuotedStr('Tipo') + ', ' + QuotedStr('Valor') + '],');
  for I := 0 to Data.Count - 1 do
  begin
    HTMLPage.Add('[' + QuotedStr(Data.Names[I]) + ', ' + Data.Values[Data.Names[I]] + ']');
    if not (I = Data.Count - 1) then
    begin
      HTMLPage.Add(', ');
    end;
  end;
  HTMLPage.Add('        ]);');
  HTMLPage.Add('');
  HTMLPage.Add('        var options = {');
  HTMLPage.Add('          title: ' + QuotedStr(Title));
  HTMLPage.Add('        };');
  HTMLPage.Add('');
  HTMLPage.Add('        var chart = new google.visualization.OrgChart(document.getElementById(' + QuotedStr('chart_div') + '));');
  HTMLPage.Add('        chart.draw(data, options);');
  HTMLPage.Add('      }');
  HTMLPage.Add('    </script>');
  HTMLPage.Add('  </head>');
  HTMLPage.Add('  <body margintop=0 marginleft=0 marginright=0 marginbottom=0>');
  HTMLPage.Add('    <div id="chart_div" style="width: ' + IntToStr(width) + 'px; height: ' + IntToStr(height) + 'px;"></div>');
  HTMLPage.Add('  </body>');
  HTMLPage.Add('</html>');
  HTMLPage.SaveToStream(MemStream);
  MemStream.Seek(0, 0);
  (Document as IPersistStreamInit).Load(TStreamAdapter.Create(MemStream));
end;

procedure TGoogleOrgChart.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TGoogleOrgChart.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TGoogleOrgChart.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

end.


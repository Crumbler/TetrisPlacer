{
MIT License

Copyright (c) 2021 Crumbler

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
}

unit unitMain;


interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls;


type
  TfrmMain = class(TForm)
    pnlMenu: TPanel;
    spinGridX: TSpinEdit;
    spinGridY: TSpinEdit;
    btnSetGridSize: TButton;
    lblGridWidth: TLabel;
    lblGridHeight: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnSetGridSizeClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FMouseButton: TMouseButton;
    FCurrWidth, FCurrHeight, // Width and height of the grid in pixels
    FCellSize,
    FOffsetX, // Account for pnlMenu and centering
    FOffsetY, // Account for centering
    FLineWidth, FLastCell,
    // Grid dimensions
    FGridX, FGridY: Integer;
    FGrid: array of Boolean;

    procedure RecalcBounds();
    { Private declarations }
  public
    { Public declarations }
  end;


var
  frmMain: TfrmMain;


implementation


{$R *.dfm}


procedure TfrmMain.FormPaint(Sender: TObject);
var
  I, J: Integer;
  Cnv: TCanvas;
  CellRect: TRect;
begin
  Cnv := Canvas;

  Cnv.Pen.Color := clMaroon;
  Cnv.Pen.Width := FLineWidth;

  Cnv.Brush.Color := clYellow;

  for I := 0 to FGridY do
  begin
    Cnv.MoveTo(FOffsetX,              FOffsetY + I * FCellSize);
    Cnv.LineTo(FOffsetX + FCurrWidth, FOffsetY + I * FCellSize);
  end;

  for J := 0 to FGridX do
  begin
    Cnv.MoveTo(FOffsetX + J * FCellSize, FOffsetY);
    Cnv.LineTo(FOffsetX + J * FCellSize, FOffsetY + FCurrHeight);
  end;

  for I := 0 to FGridY - 1 do
    for J := 0 to FGridX - 1 do
      if FGrid[I * FGridX + J] then
      begin
        CellRect.Top := FOffsetY + I * FCellSize + FLineWidth div 2;
        CellRect.Left := FOffsetX + J * FCellSize + FLineWidth div 2;
        CellRect.Bottom := CellRect.Top + FCellSize - FLineWidth;
        CellRect.Right := CellRect.Left + FCellSize - FLineWidth;

        Cnv.FillRect(CellRect);
      end;
end;


procedure TfrmMain.FormResize(Sender: TObject);
begin
  RecalcBounds();

  Invalidate();
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;

  FMouseButton := mbRight;
  FLastCell := -1;

  FGridX := 4;
  FGridY := 4;

  RecalcBounds();

  SetLength(FGrid, FGridY * FGridX);

  FillChar(FGrid[0], SizeOf(Boolean) * FGridX * FGridY, false);
end;


procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseButton := Button;

  Dec(X, FOffsetX);
  Dec(Y, FOffsetY);

  case Button of
    mbLeft, mbRight:
    if (X <= FCurrWidth - FLineWidth div 2) and
       (Y <= FCurrHeight - FLineWidth div 2) and
       (X >= FLineWidth div 2) and (Y >= FLineWidth div 2) then
    begin
      Y := Y div FCellSize;
      X := X div FCellSize;

      FGrid[Y * FGridX + X] := Button = mbLeft;
      FLastCell := Y * FGridX + X;

      Invalidate();
    end;
  end;
end;


procedure TfrmMain.RecalcBounds();
const
  CellToLineWidth = 12;
begin
  if ((ClientWidth - pnlMenu.Width) * FGridY) / FGridX > ClientHeight then
  begin
    FCurrHeight := ClientHeight;

    FCellSize := FCurrHeight div FGridY;

    FCurrWidth := FCellSize * FGridX;

    FOffsetX := pnlMenu.Width +
                (ClientWidth - FCurrWidth - pnlMenu.Width) div 2;

    FOffsetY := 0;
  end
  else
  begin
    FOffsetX := pnlMenu.Width;
    
    FCurrWidth := ClientWidth - FOffsetX;

    FCellSize := FCurrWidth div FGridX;

    FCurrHeight := FCellSize * FGridY;

    FOffsetY := (ClientHeight - FCurrHeight) div 2;
  end;

  FLineWidth := FCellSize div CellToLineWidth;

  FCurrWidth := FCellSize * FGridX;
  FCurrHeight := FCellSize * FGridY;
end;


procedure TfrmMain.btnSetGridSizeClick(Sender: TObject);
begin
  FGridX := spinGridX.Value;
  FGridY := spinGridY.Value;

  RecalcBounds();

  SetLength(FGrid, FGridX * FGridY);
  FillChar(FGrid[0], SizeOf(Boolean) * Length(FGrid), false);

  Invalidate();
end;


procedure TfrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Dec(X, FOffsetX);
  Dec(Y, FOffsetY);

  case FMouseButton of
    mbLeft, mbRight:
    if (X <= FCurrWidth - FLineWidth div 2) and
       (Y <= FCurrHeight - FLineWidth div 2) and
       (X >= FLineWidth div 2) and (Y >= FLineWidth div 2) then
    begin
      Y := Y div FCellSize;
      X := X div FCellSize;

      // If dragging over new cell
      if (Y * FGridX + X) <> FLastCell then
      begin
        FGrid[Y * FGridX + X] := FMouseButton = mbLeft;
        FLastCell := Y * FGridX + X;

        Invalidate();
      end;
    end;
  end;
end;


procedure TfrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft, mbRight:
    begin
      FLastCell := -1;
      FMouseButton := mbMiddle;
    end;
  end;
end;

end.

unit Transmitter;

interface

uses
  TransmitRecords, System.SysUtils;

Type

  TSendConfigProc<T> = reference to procedure(var A: T);
  TSendConfigProcIter<T> = reference to procedure(var A: T; AIndex: integer);

  TTxer = class
  private

  public

    class procedure SendRecord(ARecord: PTxRec); static;
    class procedure SendRecords(ARecordArray: PTxRec; ACount: integer); static;

    class procedure Send<T>(AConfigureProc: TSendConfigProc<T>); overload;
    class procedure Send<T>(ANumRecords: integer; AConfigureProc: TSendConfigProcIter<T>); overload;
  end;

implementation

{$DEFINE TESTFRAME}
{$IFDEF TESTFRAME}
//This section is just a sample of how a receiver may implement the exports
uses
  Windows, ReceiveRecords;

procedure SendTxRecords(APRxRec: PRxRec; ACount: integer); stdcall;
begin
//   case APRXRec.RecType of
//    RxRectType_Point :
//      ReceivePoints(PRxPointRec(APRxRec), ACount);
//    RxRectType_Line :
//      ReceiveLines(PRxLineRec(APRxRec), ACount);
//    RxRectType_Arc :
//      ReceiveArcs(PRxArcRec(APRxRec), ACount);
//    RxRectType_Polyline :
//      ReceivePollines(PRxPolyLineRec(APRxRec), ACount);
//    RxRectType_GeometryList :
//      ReceivePollines(RxGeometryListRec(APRxRec), ACount);
//  end;
end;

procedure SendTxRecord(APRxRec: PRxRec); stdcall;
begin
  SendTxRecords(APRxRec, 1);
end;
//End of sample section
{$ELSE}

// In a real implementation the DLL methods would be statically or dynamically linked
const
  DLLName = 'dllname.dll';

procedure SendTxRecord(APTxRec: PTxRec); stdcall; external DLLName;

procedure SendTxRecords(APTxRec: PTxRec; ACount: integer); stdcall; external DLLName;

{$ENDIF}

class procedure TTxer.SendRecords(ARecordArray: PTxRec; ACount: integer);
begin
  SendTxRecords(ARecordArray, ACount); // dll call
end;

class procedure TTxer.Send<T>(ANumRecords: integer; AConfigureProc: TSendConfigProcIter<T>);
Var
  LDynArray: TArray<T>;
  i: integer;
  LDefault: T;
begin
  SetLength(LDynArray, ANumRecords);

  LDefault := TxRec.Default<T>;

  for i := 0 to ANumRecords - 1 do
  begin
    LDynArray[i] := LDefault;
    AConfigureProc(LDynArray[i], i);
  end;
  SendRecords(@LDynArray[0], ANumRecords);

end;

class procedure TTxer.SendRecord(ARecord: PTxRec);
begin
  SendTxRecord(ARecord); // dll call
end;

class procedure TTxer.Send<T>(AConfigureProc: TSendConfigProc<T>);
Var
  L: T;
begin
  L := TxRec.Default<T>;
  AConfigureProc(L);
  SendRecord(@L);
end;

end.

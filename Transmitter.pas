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

    class procedure Send<T>(); overload;  // signal type, no configured data
    class procedure Send<T>(AConfigureProc: TSendConfigProc<T>); overload;
    class procedure Send<T>(ANumRecords: integer; AConfigureProc: TSendConfigProcIter<T>); overload;
  end;

implementation

{$DEFINE TESTFRAME}
{$IFDEF TESTFRAME}
//This section is just a sample of how a receiver may implement the exports
uses
  Windows, ReceiveRecords;

procedure ReceivePoints(Rec: PRxPointRec; Count: integer);
begin
 // Use Pointer arithmetic to walk the PRxPointRec array
   while Count > 0 do
   begin
     // Rec^ is a TRxPointRec... process as needed
     Inc(Rec);   //advance to next item in array
     Dec(Count);
   end;
end;


procedure SendTxRecords(APRxRec: PRxRec; ACount: integer); stdcall;
begin
   case APRXRec.RecType of
    RxRectType_Point :
      ReceivePoints(PRxPointRec(APRxRec), ACount);
// use the pattern above for other types
//    RxRectType_Line :
//      ReceiveLines(PRxLineRec(APRxRec), ACount);
//   RxRectType_Arc :
//      ReceiveArcs(PRxArcRec(APRxRec), ACount);
//    RxRectType_Polyline :
//      ReceivePollines(PRxPolyLineRec(APRxRec), ACount);
//    RxRectType_GeometryList :
//      ReceivePollines(PRxGeometryListRec(APRxRec), ACount);
  end;
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
 {$IFDEF TESTFRAME}
   SendTxRecords(PRxRec(ARecordArray), ACount); // direct cast to emulate reader's interpretation
 {$ELSE}
  SendTxRecords(ARecordArray, ACount); // dll call
 {$ENDIF}
end;

class procedure TTxer.Send<T>(ANumRecords: integer; AConfigureProc: TSendConfigProcIter<T>);
Var
  LDynArray: TArray<T>;
  i: integer;
  LDefault: T;
begin
  SetLength(LDynArray, ANumRecords);

  for i := 0 to ANumRecords - 1 do
    AConfigureProc(LDynArray[i], i);

  SendRecords(@LDynArray[0], ANumRecords);
end;


class procedure TTxer.SendRecord(ARecord: PTxRec);
begin
 {$IFDEF TESTFRAME}
   SendTxRecord(PRxRec(ARecord));  // direct cast to emulate reader's interpretation
 {$ELSE}
  SendTxRecord(ARecord); // dll call
 {$ENDIF}
end;

// signal types require no configuration they may define bounds of certain data, signal the requirement
// of action on the receiver side, or notify of simple events
class procedure TTxer.Send<T>;
Var
  L: T;
begin
  SendRecord(@L);
end;

class procedure TTxer.Send<T>(AConfigureProc: TSendConfigProc<T>);
Var
  L: T;
begin
  AConfigureProc(L);
  SendRecord(@L);
end;

end.

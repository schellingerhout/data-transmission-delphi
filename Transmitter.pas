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

uses
  Windows, ReceiveRecords;

procedure SendTxRecords(APTxRec: PTxRec; ACount: integer); stdcall;
begin
  // emulate the dll receiving the records
end;

procedure SendTxRecord(APTxRec: PTxRec); stdcall;
begin
  SendTxRecords(APTxRec, 1);
end;

{$ELSE}

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

unit TransmitRecords;

interface

type
{$Z4} // intger enum
  TxRectTypeEnum = (TxRectType_Point, TxRectType_Line, TxRectType_Arc, TxRectType_Polyline, TxRectType_GeometryList);
{$Z1}

const
  TxRectType_Undefined = TxRectTypeEnum(-1);

Type

  // The base memory block of all parameter recs, also serves as a signal parameter (no data transmitted)
  PTxRec = ^TxRec;

  TxRec = Record

    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum; // Integer

    class function Default<T>: T; static;
  End;

  PointRec = Record
    X, Y: double;
  End;

  PTxPointRec = ^TxPointRec;

  TxPointRec = Record

    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // Point Specific
    p: PointRec;
  End;

  PTxLineRec = ^TxLineRec;

  TxLineRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // Line Specific
    p1, p2: PointRec;
  End;

  PTxArcRec = ^TxArcRec;

  TxArcRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // Arc Specific
    p: PointRec;
    CCW: Boolean; // in Delphi a Boolean has size of Byte
    StartAngle, EndAngle: double;
  End;

  PTxPolyLineRec = ^TxPolyLineRec;

  TxPolyLineRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // Polyline Specific
    VertexCount: Uint32;
    Vertices: TArray<PointRec>;
  End;

  PTxGeometryListRec = ^TxGeometryListRec;

  TxGeometryListRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // PolyLineArcRec Specific
    Geometry: TArray<PTxRec>; // since we have an array of pointers,
                             //  this array can be null terminated.
  End;

const

  DefaultPointRec: TxPointRec = (
    Size: SizeOf(TxPointRec);
    RecType: TxRectType_Point
  );

  DefaultLineRec: TxLineRec = (
    Size: SizeOf(TxPointRec);
    RecType: TxRectType_Line
  );

  DefaultArcRec: TxArcRec = (
    Size: SizeOf(TxArcRec);
    RecType: TxRectType_Arc
  );

  DefaultPolyLineRec: TxPolyLineRec = (
    Size: SizeOf(TxPolyLineRec);
    RecType: TxRectType_Polyline
  );

  DefaultGeometryListRec: TxGeometryListRec = (
    Size: SizeOf(TxGeometryListRec);
    RecType: TxRectType_GeometryList
  );

implementation

{ TxPointRec }

class function TxRec.Default<T>: T;
var
  PT: ^T; // this will be a pointer to a const, do not modify values via this pointer
begin

  if TypeInfo(T) = TypeInfo(TxPointRec) then
    PT := @DefaultPointRec
  else if TypeInfo(T) = TypeInfo(TxLineRec) then
    PT := @DefaultLineRec
  else if TypeInfo(T) = TypeInfo(TxArcRec) then
    PT := @DefaultArcRec
  else if TypeInfo(T) = TypeInfo(TxPolyLineRec) then
    PT := @DefaultPolyLineRec
  else if TypeInfo(T) = TypeInfo(TxGeometryListRec) then
    PT := @DefaultGeometryListRec
  else
    PT := nil; // raise exception

  result := PT^; // We Copy value, so the constant is not inadvertently modified
end;

end.

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

    class operator Initialize(out Dest: TxPointRec);
  End;

  PTxLineRec = ^TxLineRec;

  TxLineRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // Line Specific
    p1, p2: PointRec;

    class operator Initialize(out Dest: TxLineRec);
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

    class operator Initialize(out Dest: TxArcRec);
  End;

  PTxPolyLineRec = ^TxPolyLineRec;

  TxPolyLineRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // Polyline Specific
    VertexCount: Uint32;
    Vertices: TArray<PointRec>;

    class operator Initialize(out Dest: TxPolyLineRec);
  End;

  PTxGeometryListRec = ^TxGeometryListRec;

  TxGeometryListRec = Record
    // Common header
    Size: Cardinal; // UInt32
    RecType: TxRectTypeEnum;

    // PolyLineArcRec Specific
    Geometry: TArray<PTxRec>; // since we have an array of pointers,
                             //  this array can be null terminated.

    class operator Initialize(out Dest: TxGeometryListRec);
  End;

implementation


{ TxPointRec }

class operator TxPointRec.Initialize(out Dest: TxPointRec);
begin
  Dest.Size := SizeOf(TxPointRec);
  Dest.RecType := TxRectType_Point;
  // p is not initialized
end;

{ TxLineRec }

class operator TxLineRec.Initialize(out Dest: TxLineRec);
begin
  Dest.Size := SizeOf(TxLineRec);
  Dest.RecType :=TxRectType_Line;
  // p1 and p2 are not initialzed
end;


{ TxArcRec }

class operator TxArcRec.Initialize(out Dest: TxArcRec);
begin
  Dest.Size := SizeOf(TxArcRec);
  Dest.RecType := TxRectType_Arc;
  // Arc definition fields are not initialized
end;

{ TxPolyLineRec }

class operator TxPolyLineRec.Initialize(out Dest: TxPolyLineRec);
begin
  Dest.Size := SizeOf(TxPolyLineRec);
  Dest.RecType := TxRectType_Polyline;
  Dest.VertexCount := 0;   // Vertices auto initialized to empty array
end;

{ TxGeometryListRec }

class operator TxGeometryListRec.Initialize(out Dest: TxGeometryListRec);
begin
  Dest.Size := SizeOf(TxGeometryListRec);
  Dest.RecType := TxRectType_GeometryList;
  // Geometry auto intialized to empty array
end;



end.

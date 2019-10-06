unit ReceiveRecords;

interface

type
{$Z4} //integer enum
  RxRectTypeEnum = (RxRectType_Point,  RxRectType_Line, RxRectType_Arc, RxRectType_Polyline, RxRectType_GeometryList);
{$Z1}
const
  RxRectType_Undefined = RxRectTypeEnum(-1);


Type

  //The base memory block of all parameter recs,
  // also serves as a signal parameter (no data transmitted)

  PPRxRec = ^PRxRec; //array of pointers to  RxRec
  PRxRec = ^RxRec;
  RxRec = Record

    Size: Cardinal; //UInt32
    RecType: RxRectTypeEnum; // Integer

  End;

  PPointRec = ^PointRec;
  PointRec = Record
    X, Y : double;
  End;

  PRxPointRec = ^RxPointRec;
  RxPointRec = Record
    // Common header
    Size: Cardinal; //UInt32
    RecType: RxRectTypeEnum;


    //Point Specific
    p: PointRec;
  End;


  PRxLineRec = ^RxLineRec;
  RxLineRec = Record
    // Common header
    Size: Cardinal; //UInt32
    RecType: RxRectTypeEnum;


    //Line Specific
    p1, p2 : PointRec;
  End;

  PRxArcRec = ^RxArcRec;
  RxArcRec = Record
    // Common header
    Size: Cardinal; //UInt32
    RecType: RxRectTypeEnum;


    // Arc Specific
    p : PointRec;
    CCW: Boolean;   //in Delphi a Boolean has size of Byte
    StartAngle, EndAngle: Double;

  End;


  PRxPolyLineRec = ^RxPolyLineRec;
  RxPolyLineRec = Record
    // Common header
    Size: Cardinal; //UInt32
    RecType: RxRectTypeEnum;


    // Polyline Specific
    VertexCount: Uint32;
    Vertices : PPointRec;    // since x can have a valid value of zero, we need a count, we can't use null termination
  End;



  PRxGeometryListRec = ^RxGeometryListRec;
  RxGeometryListRec = Record
    // Common header
    Size: Cardinal; //UInt32
    RecType: RxRectTypeEnum;


    // GeometryListRec Specific
    Geometry : PPRxRec;   //  null terminated
  End;



implementation

end.

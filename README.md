# data-transmission-delphi
Example code for blog post on dll communication with Delphi

https://schellingerhout.github.io/tags/#data-transmission

``` pascal
//Transmit records one by one
 TTXer.Send<TxLineRec>( 
    procedure(var ARec: TxLineRec) 
    begin
      ARec.p1.x := 0.5;
      ARec.p2.y := 0.25;
      ARec.p2.x := 1.0;
      ARec.p2.y := 2.0;
    end
  );
  
 // Transmit records as an array (pointer and count)
  TTxer.Send<TxPolyLineRec>(FPolylines.Count, 
    Procedure(var ARec: TxPolyLineRec; AIdx: integer)
    begin
      ARec.VertexCount := Length(FPolylines[AIdx].Vertices);
      ARec.Vertices := FPolylines[AIdx].Vertices;  
    end
  );
```

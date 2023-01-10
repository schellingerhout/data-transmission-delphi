# data-transmission-delphi
Example code for blog post on dll communication with Delphi

[Part 1: Pointers and Structures](https://schellingerhout.github.io/data%20transmission/datatransmission1/)

[Part 2: Arrays and Pointer Math](https://schellingerhout.github.io/data%20transmission/datatransmission2/)

[Part 3: Transmitting and Interpreting Data](https://schellingerhout.github.io/data%20transmission/datatransmission3/)

``` pascal
//Transmit records one by one
 TTXer.Send<TxLineRec>( 
    procedure(var ARec: TxLineRec) 
    begin
      ARec.p1.x := 0.5;
      ARec.p1.y := 0.25;
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

This branch has code specifically for Delphi 10.4 and up

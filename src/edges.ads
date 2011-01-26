package Edges is
   type Edge is tagged private;
   function Create
     (From, To   : Positive;
      Visible    : Boolean := True)
      return     Edge;
   function From (E : Edge) return Positive;
   function To (E : Edge) return Positive;
private
   type Edge is tagged record
      From, To   : Positive;
      Visible    : Boolean; --  not used yet
   end record;
end Edges;

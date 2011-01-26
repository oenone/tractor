package body Edges is

   function Create
     (From, To   : Positive;
      Visible  : Boolean := True)
      return     Edge
   is
   begin
      return (From, To, Visible);
   end Create;

   function From (E : Edge) return Positive is
   begin
      return E.From;
   end From;

   function To (E : Edge) return Positive is
   begin
      return E.To;
   end To;

end Edges;

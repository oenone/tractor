package body Points is

   function "*" (Left, Right : Point) return Float is
   begin
      return (Left.X * Right.X + Left.Y * Right.Y + Left.Z * Right.Z);
   end "*";

   function "+" (Left, Right : Point) return Point is
   begin
      return (Vector =>
                (Left.X + Right.X, Left.Y + Right.Y, Left.Z + Right.Z));
   end "+";

   function "-" (Left, Right : Point) return Point is
   begin
      return (Vector =>
                (Left.X - Right.X, Left.Y - Right.Y, Left.Z - Right.Z));
   end "-";

   function Create (X, Y, Z : Float) return Point is
   begin
      return (Vector => (X, Y, Z));
   end Create;

   procedure Set_X (P : in out Point; X : Float) is
   begin
      P.Vector (1) := X;
   end Set_X;

   procedure Set_Y (P : in out Point; Y : Float) is
   begin
      P.Vector (2) := Y;
   end Set_Y;

   procedure Set_Z (P : in out Point; Z : Float) is
   begin
      P.Vector (3) := Z;
   end Set_Z;

   function X (P : Point) return Float is
   begin
      return P.Vector (1);
   end X;

   function Y (P : Point) return Float is
   begin
      return P.Vector (2);
   end Y;

   function Z (P : Point) return Float is
   begin
      return P.Vector (3);
   end Z;

end Points;

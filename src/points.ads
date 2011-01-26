package Points is
   type Direction is (X, Y, Z);
   type Point is tagged private;
   function Create (X, Y, Z : Float) return Point;
   function X (P : Point) return Float;
   function Y (P : Point) return Float;
   function Z (P : Point) return Float;
   procedure Set_X (P : in out Point; X : Float);
   procedure Set_Y (P : in out Point; Y : Float);
   procedure Set_Z (P : in out Point; Z : Float);
   function "-" (Left, Right : Point) return Point;
   function "+" (Left, Right : Point) return Point;
   function "*" (Left, Right : Point) return Float;
private
   type Vector_Type is array (1 .. 3) of Float;
   type Point is tagged record
      Vector : Vector_Type;
   end record;
end Points;

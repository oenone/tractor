with Ada.Numerics.Elementary_Functions;
package body Transformations is

   procedure Empty (Object : in out Transformation) is
   begin
      Object.Matrix := (others => (others => 0.0));
   end Empty;

   function Get_Value
     (Object      : Transformation;
      Row, Column : Positive)
      return Float
   is
   begin
      return Object.Matrix (Row, Column);
   end Get_Value;

   procedure Reset (Object : in out Transformation) is
   begin
      Object.Matrix := ((1.0, 0.0, 0.0, 0.0),
                        (0.0, 1.0, 0.0, 0.0),
                        (0.0, 0.0, 1.0, 0.0));
   end Reset;

   procedure Rotate
     (Object    : in out Transformation;
      Alpha     : Float;
      Direction : Points.Direction)
   is
      use Ada.Numerics.Elementary_Functions;
      Degrees : constant Float := Alpha * Ada.Numerics.Pi / 180.0;
      X, Y    : Positive;
      Tmp     : Transformation;
   begin
      Tmp.Reset;
      case Direction is
         when Points.X =>
            X := 2;
            Y := 3;
         when Points.Y =>
            X := 3;
            Y := 1;
         when Points.Z =>
            X := 1;
            Y := 2;
      end case;
      Tmp.Set_Value (Row    => X,
                     Column => X,
                     Value  => Cos (Degrees));
      Tmp.Set_Value (Row    => X,
                     Column => Y,
                     Value  => -Sin (Degrees));
      Tmp.Set_Value (Row    => Y,
                     Column => X,
                     Value  => Sin (Degrees));
      Tmp.Set_Value (Row    => Y,
                     Column => Y,
                     Value  => Cos (Degrees));
      Object.Transform (T => Tmp);
   end Rotate;

   procedure Scale (Object : in out Transformation; SX, SY, SZ : Float) is
      Tmp : Transformation;
   begin
      Tmp.Reset;
      Tmp.Set_Value (1, 1, SX);
      Tmp.Set_Value (2, 2, SY);
      Tmp.Set_Value (3, 3, SZ);
      Object.Transform (T => Tmp);
   end Scale;

   procedure Set_Value
     (Object      : in out Transformation;
      Row, Column : Positive;
      Value       : Float)
   is
   begin
      Object.Matrix (Row, Column) := Value;
   end Set_Value;

   procedure Transform (Object : in out Transformation; T : Transformation) is
      Tmp : Matrix_Type := (others => (others => 0.0));
   begin
      for Row in Tmp'Range (1) loop
         for Column in Tmp'Range (2) loop
            for X in 1 .. 3 loop
               --  multiply rows scalar with according columns
               Tmp (Row, Column) := Tmp (Row, Column) +
                 Object.Matrix (Row, X) * T.Matrix (X, Column);
            end loop;
            --  last column: pure translation
            if Column = 4 then
               Tmp (Row, Column) := Tmp (Row, Column) +
                 Object.Matrix (Row, Column);
            end if;
         end loop;
      end loop;
      Object.Matrix := Tmp;
   end Transform;

   procedure Transform
     (Object     : Transformation;
      Point_List : in out Points.Lists.Vector)
   is
      procedure Transform_Cursor (Position : Points.Lists.Cursor);
      procedure Transform_Element (Element : in out Points.Point);
      procedure Transform_Cursor (Position : Points.Lists.Cursor) is
      begin
         Point_List.Update_Element (Position, Transform_Element'Access);
      end Transform_Cursor;
      procedure Transform_Element (Element : in out Points.Point) is
      begin
         Object.Transform (Point => Element);
      end Transform_Element;
   begin
      Point_List.Iterate (Transform_Cursor'Access);
   end Transform;

   procedure Transform
     (Object : Transformation;
      Point  : in out Points.Point)
   is
   begin
      Point := Points.Create (X => Point.X * Object.Matrix (1, 1) +
                                Point.Y * Object.Matrix (1, 2) +
                                Point.Z * Object.Matrix (1, 3) +
                                Object.Matrix (1, 4),
                              Y => Point.X * Object.Matrix (2, 1) +
                                Point.Y * Object.Matrix (2, 2) +
                                Point.Z * Object.Matrix (2, 3) +
                                Object.Matrix (2, 4),
                              Z => Point.X * Object.Matrix (3, 1) +
                                Point.Y * Object.Matrix (3, 2) +
                                Point.Z * Object.Matrix (3, 3) +
                                Object.Matrix (3, 4));
   end Transform;

   procedure Translate (Object : in out Transformation; V : Points.Point) is
   begin
      Object.Translate (DX => V.X,
                        DY => V.Y,
                        DZ => V.Z);
   end Translate;

   procedure Translate (Object : in out Transformation; DX, DY, DZ : Float) is
      Tmp : Transformation;
   begin
      Tmp.Reset;
      Tmp.Set_Value (1, 4, DX);
      Tmp.Set_Value (2, 4, DY);
      Tmp.Set_Value (3, 4, DZ);
      Object.Transform (T => Tmp);
   end Translate;

end Transformations;

with Points;
package body Drawables.Wheels is

   package body Factory is
      function Create (Radius, Width, Depth : Float) return Wheel is
         Result : Wheel;
      begin
         Result.Radius := Radius;
         Result.Width := Width;
         Result.Depth := Depth;
         Result.Recalculate;
         return Result;
      end Create;
   end Factory;

   function Get_Depth (Object : Wheel) return Float is
   begin
      return Object.Depth;
   end Get_Depth;

   function Get_Radius (Object : Wheel) return Float is
   begin
      return Object.Radius;
   end Get_Radius;

   function Get_Width (Object : Wheel) return Float is
   begin
      return Object.Width;
   end Get_Width;

   procedure Recalculate (Object : in out Wheel) is
      X : constant Float := Object.Width / 2.0;
      P : Points.Point;
      R : Transformations.Transformation;
   begin
      --  start new model
      Object.Model.Empty;

      --  starting point: Top, front
      P := Points.Create (X => X,
                          Y => Object.Radius,
                          Z => 0.0);
      --  rotate each point by 30° around X axis
      R.Rotate (Alpha     => 30.0,
                Direction => Points.X);
      --  12 points at the front
      for I in 1 .. 12 loop
         Object.Model.Add_Point (P);
         R.Transform (P);
      end loop;

      --  starting point: Top, back
      P := Points.Create (X => -X,
                          Y => Object.Radius,
                          Z => 0.0);
      --  12 points in the back
      for I in 1 .. 12 loop
         Object.Model.Add_Point (P);
         R.Transform (P);
      end loop;

      --  add connecting edges
      for I in 1 .. 36 loop
         case I is
            when 1 .. 11 | 13 .. 23 =>
               --  connect each point in front/back with neighbour
               Object.Model.Add_Edge (From => I,
                                      To   => I + 1);
            when 12 | 24 =>
               --  connect last point of each side with first
               Object.Model.Add_Edge (From => I,
                                      To   => I - 11);
            when 25 .. 36 =>
               --  connect front with back
               Object.Model.Add_Edge (From => I - 12,
                                      To   => I - 24);
         end case;
      end loop;

      declare
         Inner : Models.Model := Object.Model;
         S     : Transformations.Transformation;
      begin
         --  scale inner model
         S.Scale (SX => 1.0,
                  SY => Object.Depth,
                  SZ => Object.Depth);
         Inner.Transform (S);
         Object.Model.Add_Model (Inner);
      end;

      for I in 1 .. 24 loop
         --  connect the two models
         Object.Model.Add_Edge (From => I,
                                To   => I + 24);
      end loop;
   end Recalculate;

   procedure Set_Depth (Object : in out Wheel; Depth : Float) is
   begin
      Object.Depth := Depth;
   end Set_Depth;

   procedure Set_Radius (Object : in out Wheel; Radius : Float) is
   begin
      Object.Radius := Radius;
   end Set_Radius;

   procedure Set_Width (Object : in out Wheel; Width : Float) is
   begin
      Object.Width := Width;
   end Set_Width;

end Drawables.Wheels;

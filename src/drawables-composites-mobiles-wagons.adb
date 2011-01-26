with Drawables.Composites.Mobiles.Drawbars;
package body Drawables.Composites.Mobiles.Wagons is

   package body Factory is
      function Create (Wheelbase, Height : Float) return Wagon is
         Result : Wagon :=
                    (Mobiles.Factory.Create (Wheel_Gap    => Height,
                                             Axle_Present => True,
                                             Radius       => Height * 0.3,
                                             Width        => Height * 0.1)
                     with Wheelbase => Wheelbase,
                     others         => <>);
      begin
         declare
            Tmp : Points.Point :=
                    Points.Create (X => Height * 0.375,
                                   Y => 0.0,
                                   Z => Wheelbase + Height * 0.3);
         begin
            -- points in front
            Result.Model.Add_Point (Tmp);
            Tmp.Set_X (-Height * 0.375);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_X (-Height * 0.625);
            Tmp.Set_Y (Height);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_X (Height * 0.625);
            Result.Model.Add_Point (Tmp);
            -- points in back
            Tmp := Points.Create (X => Height * 0.375,
                                  Y => 0.0,
                                  Z => -Height * 0.3);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_X (-Height * 0.375);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_X (-Height * 0.625);
            Tmp.Set_Y (Height);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_X (Height * 0.625);
            Result.Model.Add_Point (Tmp);
         end;

         -- connect front points
         for I in 1 .. 3 loop
            Result.Model.Add_Edge (From => I,
                                   To   => I + 1);
         end loop;
         Result.Model.Add_Edge (From => 4,
                                To   => 1);
         -- connect back points
         for I in 4 .. 7 loop
            Result.Model.Add_Edge (From => I,
                                   To   => I + 1);
         end loop;
         Result.Model.Add_Edge (From => 8,
                                To   => 4);
         -- connect front with back
         for I in 1 .. 4 loop
            Result.Model.Add_Edge (From => I,
                                   To   => I + 4);
         end loop;

         -- create smaller copy for inside
         declare
            Inner : Models.Model := Result.Model;
            T     : Transformations.Transformation;
         begin
            T.Scale (SX => 0.9,
                     SY => 0.9,
                     SZ => 0.9);
            T.Translate (DX => 0.0,
                         DY => Height * 0.1,
                         DZ => Height * 0.05);
            Inner.Transform (T);
            Result.Model.Add_Model (Inner);
         end;

         -- add Drawbar
         declare
            Bar : Drawbars.Drawbar :=
                    Drawbars.Factory.Create (Width  => Height,
                                             Radius => Height * 0.3);
         begin
            Bar.Move (DX => 0.0,
                      DY => 0.0,
                      DZ => Wheelbase);
            Result.Add_Item (Item => Bar,
                             ID   => Result.Drawbar);
         end;
         return Result;
      end Create;
   end Factory;

   function Get_Drawbar (Object : Wagon) return Natural is
   begin
      return Object.Drawbar;
   end Get_Drawbar;

   overriding procedure Reset (Object : in out Wagon) is
      procedure Move_Drawbar (Bar : in out Drawable'Class);
      procedure Move_Drawbar (Bar : in out Drawable'Class) is
      begin
         Bar.Move (DX => 0.0,
                   DY => 0.0,
                   DZ => Object.Wheelbase);
      end Move_Drawbar;
   begin
      Mobile (Object).Reset;
      Object.Items.Update_Element (Object.Drawbar, Move_Drawbar'Access);
   end Reset;

   procedure Rotate_Drawbar
     (Object    : in out Wagon;
      Alpha     : Float;
      Direction : Points.Direction)
   is
      procedure Rotate_Drawbar (Bar : in out Drawable'Class);
      procedure Rotate_Drawbar (Bar : in out Drawable'Class) is
      begin
         Bar.Rotate (Alpha, Direction);
      end Rotate_Drawbar;
   begin
      Object.Items.Update_Element (Object.Drawbar, Rotate_Drawbar'Access);
   end Rotate_Drawbar;

   overriding procedure Rotate_Wheels
     (Object    : in out Wagon;
      Alpha     : Float;
      Direction : Points.Direction)
   is
      use type Points.Direction;
      procedure Rotate_Drawbar_Wheel (Bar : in out Drawable'Class);
      procedure Rotate_Drawbar_Wheel (Bar : in out Drawable'Class) is
      begin
         Drawbars.Drawbar (Bar).Rotate_Wheels (Alpha, Direction);
      end Rotate_Drawbar_Wheel;
   begin
      if Direction = Points.X then
         Mobile (Object).Rotate_Wheels (Alpha, Direction);
         Object.Items.Update_Element
           (Object.Drawbar, Rotate_Drawbar_Wheel'Access);
      elsif Direction = Points.Y then
         Object.Rotate_Drawbar (Alpha, Direction);
      end if;
   end Rotate_Wheels;

end Drawables.Composites.Mobiles.Wagons;

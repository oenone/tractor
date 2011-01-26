with Drawables.Wheels;
with Drawables.Cuboids;
with Drawables.Composites.Mobiles.Steering_Axles;
package body Drawables.Composites.Mobiles.Tractors is

   package body Factory is
      --function Create (Wheelbase, Height : Float) return Tractor is
      function Create (R, Width : Float) return Tractor is
         Result : Tractor :=
                    (Mobiles.Factory.Create (Wheel_Gap    => Width * 1.5,
                                             Axle_Present => True,
                                             Radius       => R * 2.0,
                                             Width        => Width * 0.3)
                     with Wheelbase => R * 4.5,
                     others         => <>);
      begin
         declare
            Tmp : Points.Point := Points.Create (X => Width * 0.5,
                                                 Y => 0.0,
                                                 Z => R * 5.5);
         begin
            -- points in front
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 2.0);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 3.0);
            Tmp.Set_Z (R * 4.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Z (R * 1.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 2.0);
            Tmp.Set_Z (R * 0.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Z (-R);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 0.75);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Z (-R * 2.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (0.0);
            Result.Model.Add_Point (Tmp);
            -- points in the back
            Tmp.Set_X (-Width * 0.5);
            Tmp.Set_Z (R * 5.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 2.0);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 3.0);
            Tmp.Set_Z (R * 4.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Z (R * 1.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 2.0);
            Tmp.Set_Z (R * 0.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Z (-R);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (R * 0.75);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Z (-R * 2.5);
            Result.Model.Add_Point (Tmp);
            Tmp.Set_Y (0.0);
            Result.Model.Add_Point (Tmp);
         end;

         -- connect front points
         for I in 1 .. 7 loop
            Result.Model.Add_Edge (From => I,
                                   To   => I + 1);
         end loop;
         Result.Model.Add_Edge (From => 9,
                                To   => 1);
         -- connect back points
         for I in 10 .. 17 loop
            Result.Model.Add_Edge (From => I,
                                   To   => I + 1);
         end loop;
         Result.Model.Add_Edge (From => 18,
                                To   => 10);
         -- connect front with back
         for I in 1 .. 9 loop
            Result.Model.Add_Edge (From => I,
                                   To   => I + 9);
         end loop;

         -- make back wheels higher
         declare
            procedure Wheels_Up (Wheel : in out Drawable'Class);
            procedure Wheels_Up (Wheel : in out Drawable'Class) is
            begin
               Wheel.Move (DX => 0.0,
                           DY => R,
                           DZ => 0.0);
            end Wheels_Up;
            Position : Drawable_Vectors.Cursor := Result.Items.First;
         begin
            for I in 1 .. 3 loop
               Result.Items.Update_Element (Position, Wheels_Up'Access);
               Position := Drawable_Vectors.Next (Position);
            end loop;
         end;

         -- add steering axle
         declare
            Item : Steering_Axles.Steering_Axle :=
                     Steering_Axles.Factory.Create (Width  => Width * 1.4,
                                                    Radius => R);
         begin
            Item.Move (DX => 0.0,
                       DY => 0.0,
                       DZ => Result.Wheelbase);
            Result.Add_Item (Item, Result.Steering_Axle);
         end;

         -- add front axis
         declare
            Item : Cuboids.Cuboid := Cuboids.Factory.Create (X => Width * 1.4,
                                                             Y => R / 4.0,
                                                             Z => R / 4.0);
         begin
            Item.Move (DX => 0.0,
                       DY => 0.0,
                       DZ => Result.Wheelbase);
            Result.Add_Item (Item, Result.Axis);
         end;

         -- add steering wheel
         declare
            Item : Wheels.Wheel := Wheels.Factory.Create (Radius => R * 0.8,
                                                          Width  => R / 6.0,
                                                          Depth  => 0.5);
         begin
            Item.Move (DX => 0.0,
                       DY => R * 3.0,
                       DZ => R);
            Item.Rotate (Alpha     => 90.0,
                         Direction => Points.Y);
            Item.Rotate (Alpha     => 45.0,
                         Direction => Points.Z);
            Result.Add_Item (Item, Result.Axis);
         end;
         return Result;
      end Create;
   end Factory;

   function Get_Wheelbase (Object : Tractor) return Float is
   begin
      return Object.Wheelbase;
   end Get_Wheelbase;

   overriding procedure Reset (Object : in out Tractor) is
      procedure Reset_Axis_And_Axle (Axle : in out Drawable'Class);
      procedure Reset_Steering_Wheel (Wheel : in out Drawable'Class);
      procedure Wheels_Up (Wheel : in out Drawable'Class);
      procedure Reset_Axis_And_Axle (Axle : in out Drawable'Class) is
      begin
         Axle.Move (DX => 0.0,
                    DY => 0.0,
                    DZ => Object.Wheelbase);
      end Reset_Axis_And_Axle;
      procedure Reset_Steering_Wheel (Wheel : in out Drawable'Class) is
      begin
         Wheel.Move (DX => 0.0,
                     DY => Object.Wheelbase * 3.0 / 4.5,
                     DZ => Object.Wheelbase / 4.5);
         Wheel.Rotate (Alpha     => 90.0,
                       Direction => Points.Y);
         Wheel.Rotate (Alpha     => 45.0,
                       Direction => Points.Z);
      end Reset_Steering_Wheel;
      procedure Wheels_Up (Wheel : in out Drawable'Class) is
      begin
         Wheel.Move (DX => 0.0,
                     DY => Object.Wheelbase / 4.5,
                     DZ => 0.0);
      end Wheels_Up;
   begin
      Mobile (Object).Reset;
      Object.Items.Update_Element
        (Object.Axis,
         Reset_Axis_And_Axle'Access);
      Object.Items.Update_Element
        (Object.Steering_Axle,
         Reset_Axis_And_Axle'Access);
      -- make back wheels higher
      declare
         Position : Drawable_Vectors.Cursor := Object.Items.First;
      begin
         for I in 1 .. 3 loop
            Object.Items.Update_Element (Position, Wheels_Up'Access);
            Position := Drawable_Vectors.Next (Position);
         end loop;
      end;
      Object.Items.Update_Element
        (Object.Steering_Wheel,
         Reset_Steering_Wheel'Access);
   end Reset;

   overriding procedure Rotate_Wheels
     (Object : in out Tractor;
      Alpha  : Float;
      Direction : Points.Direction)
   is
      use type Points.Direction;
      procedure Rotate_Steering_Axle (Axle : in out Drawable'Class);
      procedure Rotate_Steering_Axle (Axle : in out Drawable'Class) is
      begin
         Steering_Axles.Steering_Axle (Axle).Rotate_Wheels (Alpha, Direction);
      end Rotate_Steering_Axle;
   begin
      if Direction = Points.X then
         Mobile (Object).Rotate_Wheels (Alpha / 2.0, Direction);
      end if;
      Object.Items.Update_Element (Index   => Object.Steering_Axle,
                                   Process => Rotate_Steering_Axle'Access);
   end Rotate_Wheels;

end Drawables.Composites.Mobiles.Tractors;

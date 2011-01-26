with Drawables.Wheels;
with Drawables.Cuboids;
package body Drawables.Composites.Mobiles is

   package body Factory is
      function Create
        (Wheel_Gap     : Float;
         Axle_Present  : Boolean;
         Radius, Width : Float)
         return Mobile
      is
         Result : Mobile;
         Wheel  : Wheels.Wheel := Wheels.Factory.Create (Radius => Radius,
                                                         Width  => Width,
                                                         Depth  => 0.6);
      begin
         Result.Wheel_Gap := Wheel_Gap;
         Result.Axle_Present := Axle_Present;
         Wheel.Move (DX => Wheel_Gap / 2.0,
                     DY => 0.0,
                     DZ => 0.0);
         Result.Add_Item (Wheel);
         Wheel.Move (DX => -Wheel_Gap,
                     DY => 0.0,
                     DZ => 0.0);
         Result.Add_Item (Wheel);
         if Axle_Present then
            declare
               Cuboid : constant Cuboids.Cuboid :=
                          Cuboids.Factory.Create (X => Wheel_Gap,
                                                  Y => Radius / 4.0,
                                                  Z => Radius / 4.0);
            begin
               Result.Add_Item (Cuboid);
            end;
         end if;
         return Result;
      end Create;
   end Factory;

   function Get_Wheel_Gap (Object : Mobile) return Float is
   begin
      return Object.Wheel_Gap;
   end Get_Wheel_Gap;

   function Has_Axle (Object : Mobile) return Boolean is
   begin
      return Object.Axle_Present;
   end Has_Axle;

   overriding procedure Reset (Object : in out Mobile) is
   begin
      Composite (Object).Reset;
      declare
         Wheel : Drawable'Class := Object.Items.Element (1);
      begin
         Wheel.Move (DX => Object.Wheel_Gap / 2.0,
                     DY => 0.0,
                     DZ => 0.0);
         Object.Items.Replace_Element (Index    => 1,
                                       New_Item => Wheel);
      end;
      declare
         Wheel : Drawable'Class := Object.Items.Element (2);
      begin
         Wheel.Move (DX => -Object.Wheel_Gap / 2.0,
                     DY => 0.0,
                     DZ => 0.0);
         Object.Items.Replace_Element (Index    => 2,
                                       New_Item => Wheel);
      end;
   end Reset;

   procedure Rotate_Wheels
     (Object    : in out Mobile;
      Alpha     : Float;
      Direction : Points.Direction)
   is
      use type Drawable_Vectors.Cursor;
      procedure Rotate_Wheel (Wheel : in out Drawable'Class);
      procedure Rotate_Wheel (Wheel : in out Drawable'Class) is
      begin
         Wheel.Rotate (Alpha, Direction);
      end Rotate_Wheel;
   begin
      Object.Items.Update_Element (Index   => 1,
                                   Process => Rotate_Wheel'Access);
      Object.Items.Update_Element (Index   => 2,
                                   Process => Rotate_Wheel'Access);
   end Rotate_Wheels;

   procedure Set_Axle (Object : in out Mobile; Axle_Present : Boolean) is
   begin
      Object.Axle_Present := Axle_Present;
   end Set_Axle;

   procedure Set_Wheel_Gap (Object : in out Mobile; Wheel_Gap : Float) is
   begin
      Object.Wheel_Gap := Wheel_Gap;
   end Set_Wheel_Gap;

end Drawables.Composites.Mobiles;

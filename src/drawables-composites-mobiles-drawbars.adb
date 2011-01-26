with Drawables.Cuboids;
package body Drawables.Composites.Mobiles.Drawbars is

   package body Factory is
      function Create (Width, Radius : Float) return Drawbar is
         Result : Drawbar := (Mobiles.Factory.Create
           (Wheel_Gap    => Width,
            Axle_Present => True,
            Radius       => Radius,
            Width        => Radius / 3.0)
           with Offset => Radius * 9.0 / 8.0);
         C      : Cuboids.Cuboid := Cuboids.Factory.Create (X => Width / 10.0,
                                                            Y => Radius / 4.0,
                                                            Z => Radius * 2.0);
      begin
         C.Move (DX => 0.0,
                 DY => 0.0,
                 DZ => Result.Offset);
         Result.Add_Item (C);
         return Result;
      end Create;
   end Factory;

   function Get_Offset (Object : Drawbar) return Float is
   begin
      return Object.Offset;
   end Get_Offset;

   overriding procedure Reset (Object : in out Drawbar) is
      procedure Move_Bar (Bar : in out Drawable'Class);
      procedure Move_Bar (Bar : in out Drawable'Class) is
      begin
         Bar.Move (DX => 0.0,
                   DY => 0.0,
                   DZ => Object.Offset);
      end Move_Bar;
   begin
      Mobile (Object).Reset;
      Object.Items.Update_Element (Object.Items.Last, Move_Bar'Access);
   end Reset;

   procedure Set_Offset (Object : in out Drawbar; Offset : Float) is
   begin
      Object.Offset := Offset;
   end Set_Offset;

end Drawables.Composites.Mobiles.Drawbars;

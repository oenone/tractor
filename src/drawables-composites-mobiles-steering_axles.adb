package body Drawables.Composites.Mobiles.Steering_Axles is

   package body Factory is
      function Create (Width, Radius : Float) return Steering_Axle is
         Result : constant Steering_Axle := (Mobiles.Factory.Create
           (Wheel_Gap    => Width,
            Axle_Present => True,
            Radius       => Radius,
            Width        => Radius / 3.0)
           with Offset => Radius * 9.0 / 8.0);
      begin
         return Result;
      end Create;
   end Factory;

   function Get_Offset (Object : Steering_Axle) return Float is
   begin
      return Object.Offset;
   end Get_Offset;

   overriding procedure Rotate_Wheels
     (Object    : in out Steering_Axle;
      Alpha     : Float;
      Direction : Points.Direction)
   is
      use type Points.Direction;
      procedure Update_First_Translation (Item : in out Drawable'Class);
      procedure Update_Translation (Item : in out Drawable'Class);
      procedure Update_First_Translation (Item : in out Drawable'Class) is
      begin
         Item.Translation.Reset;
         Item.Translation.Translate
           (DX => Steering_Axles.Steering_Axle (Item).Get_Offset,
            DY => 0.0,
            DZ => 0.0);
         Item.Translation.Rotate (-Alpha, Direction);
      end Update_First_Translation;
      procedure Update_Translation (Item : in out Drawable'Class) is
      begin
         Item.Translation.Reset;
         Item.Translation.Translate
           (DX => -Steering_Axles.Steering_Axle (Item).Get_Offset,
            DY => 0.0,
            DZ => 0.0);
         Item.Translation.Rotate (-Alpha, Direction);
      end Update_Translation;
   begin
      if Direction = Points.X then
         Mobile (Object).Rotate_Wheels (Alpha, Direction);
      elsif Direction = Points.Y then
         Object.Items.Update_Element (1, Update_First_Translation'Access);
         for I in 2 .. 3 loop
            Object.Items.Update_Element (I, Update_Translation'Access);
         end loop;
      end if;
   end Rotate_Wheels;

   procedure Set_Offset (Object : in out Steering_Axle; Offset : Float) is
   begin
      Object.Offset := Offset;
   end Set_Offset;

end Drawables.Composites.Mobiles.Steering_Axles;

package Drawables.Wheels is
   type Wheel is new Drawables.Drawable with private;
   package Factory is
      function Create (Radius, Width, Depth : Float) return Wheel;
   end Factory;
   function Get_Radius (Object : Wheel) return Float;
   function Get_Width (Object : Wheel) return Float;
   function Get_Depth (Object : Wheel) return Float;
   procedure Set_Radius (Object : in out Wheel; Radius : Float);
   procedure Set_Width (Object : in out Wheel; Width : Float);
   procedure Set_Depth (Object : in out Wheel; Depth : Float);
   procedure Recalculate (Object : in out Wheel);
private
   type Wheel is new Drawables.Drawable with record
      Radius : Float;
      Width  : Float;
      Depth  : Float;
   end record;
end Drawables.Wheels;

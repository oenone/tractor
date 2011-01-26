package Drawables.Composites.Mobiles.Steering_Axles is
   type Steering_Axle is new Mobile with private;
   package Factory is
      function Create (Width, Radius : Float) return Steering_Axle;
   end Factory;
   function Get_Offset (Object : Steering_Axle) return Float;
   procedure Set_Offset (Object : in out Steering_Axle; Offset : Float);
   overriding procedure Rotate_Wheels
     (Object    : in out Steering_Axle;
      Alpha     : Float;
      Direction : Points.Direction);
private
   type Steering_Axle is new Mobile with record
      Offset : Float := 1.0;
   end record;
end Drawables.Composites.Mobiles.Steering_Axles;

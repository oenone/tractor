with Points;
package Drawables.Composites.Mobiles.Tractors is
   type Tractor is new Mobile with private;
   package Factory is
      --function Create (Wheelbase, Height : Float) return Tractor;
      function Create (R, Width : Float) return Tractor;
   end Factory;
   overriding procedure Rotate_Wheels (Object : in out Tractor;
                                       Alpha  : Float;
                                       Direction : Points.Direction);
   overriding procedure Reset (Object : in out Tractor);
   function Get_Wheelbase (Object : Tractor) return Float;
private
   type Tractor is new Mobile with record
      Wheelbase      : Float := 1.0;
      Steering_Axle  : Natural := 0;
      Axis           : Natural := 0;
      Steering_Wheel : Natural := 0;
   end record;
end Drawables.Composites.Mobiles.Tractors;

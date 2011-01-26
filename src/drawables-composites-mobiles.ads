with Points;
package Drawables.Composites.Mobiles is
   type Mobile is new Composite with private;
   package Factory is
      function Create
        (Wheel_Gap     : Float;
         Axle_Present  : Boolean;
         Radius, Width : Float)
         return          Mobile;
   end Factory;
   function Get_Wheel_Gap (Object : Mobile) return Float;
   procedure Set_Wheel_Gap (Object : in out Mobile; Wheel_Gap : Float);
   function Has_Axle (Object : Mobile) return Boolean;
   procedure Set_Axle (Object : in out Mobile; Axle_Present : Boolean);
   procedure Rotate_Wheels
     (Object    : in out Mobile;
      Alpha     : Float;
      Direction : Points.Direction);
   overriding procedure Reset (Object : in out Mobile);
private
   type Mobile is new Composite with record
      Wheel_Gap    : Float   := 1.0;
      Axle_Present : Boolean := False;
   end record;
end Drawables.Composites.Mobiles;

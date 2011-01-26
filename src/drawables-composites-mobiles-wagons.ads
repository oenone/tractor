package Drawables.Composites.Mobiles.Wagons is
   type Wagon is new Mobile with private;
   package Factory is
      function Create (Wheelbase, Height : Float) return Wagon;
   end Factory;
   overriding procedure Rotate_Wheels
     (Object    : in out Wagon;
      Alpha     : Float;
      Direction : Points.Direction);
   procedure Rotate_Drawbar
     (Object    : in out Wagon;
      Alpha     : Float;
      Direction : Points.Direction);
   overriding procedure Reset (Object : in out Wagon);
   function Get_Drawbar (Object : Wagon) return Natural;
private
   type Wagon is new Mobile with record
      Wheelbase : Float   := 1.0;
      Drawbar   : Natural := 0;
   end record;
end Drawables.Composites.Mobiles.Wagons;

package Drawables.Composites.Mobiles.Drawbars is
   type Drawbar is new Mobile with private;
   package Factory is
      function Create (Width, Radius : Float) return Drawbar;
   end Factory;
   function Get_Offset (Object : Drawbar) return Float;
   procedure Set_Offset (Object : in out Drawbar; Offset : Float);
   overriding procedure Reset (Object : in out Drawbar);
private
   type Drawbar is new Mobile with record
      Offset : Float := 1.0;
   end record;
end Drawables.Composites.Mobiles.Drawbars;

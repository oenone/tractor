with Ada.Calendar;
with Drawables.Composites.Mobiles.Tractors;
with Drawables.Composites.Mobiles.Wagons;
package Drawables.Composites.Worlds is
   type World is new Composite with private;

   package Factory is
      function Create
        (Tractor            : Mobiles.Tractors.Tractor;
         Radius_1, Radius_2 : Float)
         return               World;
   end Factory;

   -- add/delete a wagon
   procedure Add_Wagon
     (Object : in out World;
      Wagon  : Mobiles.Wagons.Wagon);
   procedure Add_Wagon
     (Object : in out World;
      Wagon  : Mobiles.Wagons.Wagon;
      ID     : out Positive);
   procedure Delete_Wagon (Object : in out World);

   -- calculate position of a point on an ellipse
   procedure Get_Ellipse
     (Object : World;
      Point  : in out Points.Point;
      Alpha  : Float);

   -- animation
   procedure Animate
     (Object : in out World;
      Time   : Ada.Calendar.Time;
      Alpha  : out Float);

   -- setter/getter
   function Count_Wagons (Object : World) return Natural;
   function Get_Speed (Object : World) return Float;
   procedure Set_Speed (Object : in out World; Speed : Float);
   function Get_Radius_1 (Object : World) return Float;
   function Get_Radius_2 (Object : World) return Float;
   procedure Set_Radius_1 (Object : in out World; Radius : Float);
   procedure Set_Radius_2 (Object : in out World; Radius : Float);
   function Get_Start_Time (Object : World) return Ada.Calendar.Time;
   procedure Set_Start_Time
     (Object : in out World;
      Time   : Ada.Calendar.Time);

   procedure Set_Center_Point
     (Object : in out World;
      Center : Points.Point);

   function Get_Width (Object : World) return Float;
   function Get_Height (Object : World) return Float;

   -- reset
   overriding procedure Reset (Object : in out World);

   overriding function Get_Transformed_Model
     (Object : World)
      return   Models.Model;
   procedure Set_D (Object : in out World; D : Float);
   procedure Set_V (Object : in out World; V : Float);
   procedure Set_U (Object : in out World; U : Float);
private
   type World is new Composite with record
      Wagon_Count        : Natural := 0;
      Speed              : Float := 0.01;
      Radius_1, Radius_2 : Float := 1.0;
      Start_Time         : Ada.Calendar.Time;
      Center             : Points.Point;
      Old_Beta           : Float;
      D, V, U            : Float;
   end record;
   procedure Recalculate_Center_Points (Object : in out World);
end Drawables.Composites.Worlds;

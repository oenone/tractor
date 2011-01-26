with Ada.Numerics.Elementary_Functions;
package body Drawables.Composites.Worlds is

   package body Factory is
      function Create
        (Tractor            : Mobiles.Tractors.Tractor;
         Radius_1, Radius_2 : Float)
         return World
      is
         Result : World;
      begin
         Result.Model.Add_Point (Points.Create (X => Radius_1,
                                                Y => 0.0,
                                                Z => 0.0));
         Result.Radius_1 := Radius_1;
         Result.Radius_2 := Radius_2;
         Result.Add_Item (Tractor);
         Result.Center := Points.Create (X => 0.0,
                                         Y => 0.0,
                                         Z => 0.0);
         return Result;
      end Create;
   end Factory;

   procedure Add_Wagon
     (Object : in out World;
      Wagon  : Mobiles.Wagons.Wagon)
   is
   begin
      Object.Wagon_Count := Object.Wagon_Count + 1;
      Object.Add_Item (Wagon);
      Object.Recalculate_Center_Points;
   end Add_Wagon;

   procedure Add_Wagon
     (Object : in out World;
      Wagon  : Mobiles.Wagons.Wagon;
      ID     : out Positive)
   is
   begin
      Object.Wagon_Count := Object.Wagon_Count + 1;
      Object.Add_Item (Wagon, ID);
      Object.Recalculate_Center_Points;
   end Add_Wagon;

   procedure Animate
     (Object : in out World;
      Time   : Ada.Calendar.Time;
      Alpha  : out Float)
   is
      use Ada.Numerics.Elementary_Functions;
      use type Ada.Calendar.Time;
      DeltaT : constant Float := Float (Object.Start_Time - Time);
      Tmp : Points.Point;
      Beta, Old_Beta, X, Y : Float;
      procedure Update_Drawbar (Object : in out Drawable'Class);
      procedure Update_Rotation (Object : in out Drawable'Class);
      procedure Update_Tractor (Object : in out Drawable'Class);
      procedure Update_Wagon (Object : in out Drawable'Class);
      procedure Update_Drawbar (Object : in out Drawable'Class) is
      begin
         Object.Rotation.Reset;
         Object.Rotate ((Beta - Old_Beta) * 180.0 / Ada.Numerics.Pi, Points.Y);
      end Update_Drawbar;
      procedure Update_Rotation (Object : in out Drawable'Class) is
      begin
         Object.Rotation.Reset;
         Object.Rotate (-Beta * 180.0 / Ada.Numerics.Pi, Points.Y);
         Mobiles.Mobile (Object).Rotate_Wheels (-5.0 * Alpha, Points.X);
      end Update_Rotation;
      procedure Update_Tractor (Object : in out Drawable'Class) is
      begin
         Update_Rotation (Object);
      end Update_Tractor;
      procedure Update_Wagon (Object : in out Drawable'Class) is
      begin
         Update_Rotation (Object);
         Composite (Object).Items.Update_Element
           (Mobiles.Wagons.Wagon (Object).Get_Drawbar, Update_Drawbar'Access);
      end Update_Wagon;
   begin
      Alpha := DeltaT * Object.Speed;
      if Alpha > 10.0 then
         Alpha := 10.0;
         Object.Speed := 10.0 / DeltaT;
      end if;

      -- get temporary point
      Tmp := Points.Create (X => 0.0,
                            Y => 0.0,
                            Z => -Mobiles.Tractors.Tractor
                              (Object.Get_Item (1)).Get_Wheelbase);
      -- apply transformations
      Object.Get_Item (1).Scale.Transform (Tmp);
      Object.Get_Item (1).Rotation.Transform (Tmp);
      Object.Get_Item (1).Translation.Transform (Tmp);
      -- move point
      Tmp.Set_X (Tmp.X + Object.Model.Get_Point (1).X);
      Tmp.Set_Y (Tmp.Y + Object.Model.Get_Point (1).Y);
      Tmp.Set_Z (Tmp.Z + Object.Model.Get_Point (1).Z);
      -- calculate old beta
      Old_Beta := Arctan
        (Tmp.Z / Tmp.X * Object.Radius_1 ** 2 / Object.Radius_2 ** 2);
      if Tmp.X < 0.0 then
         Old_Beta := Old_Beta - Ada.Numerics.Pi;
      end if;

      -- calculate new center points of the wagons
      for I in 1 .. Object.Wagon_Count + 1 loop
         Tmp := Object.Model.Get_Point (I);
         X := Tmp.X;
         Y := Tmp.Z;
         -- new Point on ellipse
         Object.Get_Ellipse (Tmp, -Alpha);
         Object.Model.Set_Point (I, Tmp);

         Beta := Arctan (Y / X * Object.Radius_1 ** 2 / Object.Radius_2 ** 2);
         if X < 0.0 then
            Beta := Beta - Ada.Numerics.Pi;
         end if;
         if I > 1 then
            Object.Items.Update_Element (I, Update_Wagon'Access);
         else
            Object.Items.Update_Element (I, Update_Tractor'Access);
         end if;
         Old_Beta := Beta;
      end loop;
   end Animate;

   function Count_Wagons (Object : World) return Natural is
   begin
      return Object.Wagon_Count;
   end Count_Wagons;

   procedure Delete_Wagon (Object : in out World) is
   begin
      if Object.Wagon_Count > 0 then
         Object.Items.Delete_Last;
         Object.Wagon_Count := Object.Wagon_Count - 1;
      end if;
   end Delete_Wagon;

   procedure Get_Ellipse
     (Object : World;
      Point  : in out Points.Point;
      Alpha  : Float)
   is
      T : Transformations.Transformation;
   begin
      T.Scale (SX => 1.0 / Object.Radius_2,
               SY => 0.0,
               SZ => 1.0 / Object.Radius_1);
      T.Rotate (Alpha, Points.Y);
      T.Scale (SX => Object.Radius_2,
               SY => 0.0,
               SZ => Object.Radius_1);
      T.Transform (Point);
   end Get_Ellipse;

   function Get_Height (Object : World) return Float is
   begin
      return 2.0 * Object.Radius_2 + 100.0;
   end Get_Height;

   function Get_Radius_1 (Object : World) return Float is
   begin
      return Object.Radius_1;
   end Get_Radius_1;

   function Get_Radius_2 (Object : World) return Float is
   begin
      return Object.Radius_2;
   end Get_Radius_2;

   function Get_Speed (Object : World) return Float is
   begin
      return Object.Speed;
   end Get_Speed;

   function Get_Start_Time (Object : World) return Ada.Calendar.Time is
   begin
      return Object.Start_Time;
   end Get_Start_Time;

   overriding function Get_Transformed_Model
     (Object : World)
      return Models.Model
   is
      Result : Models.Model := Object.Model;
   begin
      return Result;
   end Get_Transformed_Model;

   function Get_Width (Object : World) return Float is
   begin
      return 2.0 * Object.Radius_1 + 100.0;
   end Get_Width;

   procedure Recalculate_Center_Points (Object : in out World) is
      procedure Rotate_Wagon (Object : in out Drawable'Class);
      procedure Rotate_Wagon (Object : in out Drawable'Class) is
      begin
         Object.Rotate (30.0, Points.Y);
      end Rotate_Wagon;
      T1, T2, T3 : Transformations.Transformation;
      Tmp : Points.Point;
   begin
      Object.Model.Empty;
      T1.Scale (SX => 1.0 / Object.Radius_1,
                SY => 0.0,
                SZ => 1.0 / Object.Radius_2);
      T3.Scale (SX => Object.Radius_1,
                SY => 0.0,
                SZ => Object.Radius_2);
      T2.Rotate (Alpha     => 30.0,
                 Direction => Points.Y);
      Tmp := Points.Create (X => Object.Radius_1,
                            Y => 0.0,
                            Z => 0.0);
      T1.Transform (Tmp);
      -- T2.Transform (Tmp);
      T3.Transform (Tmp);
      Object.Model.Add_Point (Tmp);

      for I in 1 .. Object.Wagon_Count + 1 loop
         Object.Get_Ellipse (Tmp, 30.0);
         Object.Model.Add_Point (Tmp);
         Object.Items.Update_Element (I, Rotate_Wagon'Access);
      end loop;
   end Recalculate_Center_Points;

   overriding procedure Reset (Object : in out World) is
   begin
      Composite (Object).Reset;
      Object.Translation.Translate (Object.Center);
      Object.Recalculate_Center_Points;
   end Reset;

   procedure Set_Center_Point
     (Object : in out World;
      Center : Points.Point)
   is
   begin
      Object.Center := Center;
      Object.Translation.Reset;
      Object.Translation.Translate (Center);
   end Set_Center_Point;

   procedure Set_D (Object : in out World; D : Float) is
   begin
      Object.D := D;
   end Set_D;

   procedure Set_Radius_1 (Object : in out World; Radius : Float) is
   begin
      Object.Radius_1 := Radius;
   end Set_Radius_1;

   procedure Set_Radius_2 (Object : in out World; Radius : Float) is
   begin
      Object.Radius_2 := Radius;
   end Set_Radius_2;

   procedure Set_Speed (Object : in out World; Speed : Float) is
   begin
      Object.Speed := Speed;
   end Set_Speed;

   procedure Set_Start_Time
     (Object : in out World;
      Time   : Ada.Calendar.Time)
   is
   begin
      Object.Start_Time := Time;
   end Set_Start_Time;

   procedure Set_U (Object : in out World; U : Float) is
   begin
      Object.U := U;
   end Set_U;

   procedure Set_V (Object : in out World; V : Float) is
   begin
      Object.V := V;
   end Set_V;

end Drawables.Composites.Worlds;

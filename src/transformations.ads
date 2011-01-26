with Points.Lists;
package Transformations is
   type Transformation is tagged private;
   procedure Set_Value
     (Object      : in out Transformation;
      Row, Column : Positive;
      Value       : Float);
   function Get_Value
     (Object      : Transformation;
      Row, Column : Positive)
      return Float;

   --  Reset values
   procedure Reset (Object : in out Transformation);
   procedure Empty (Object : in out Transformation);

   --  Transformations
   --  Rotation
   procedure Rotate
     (Object    : in out Transformation;
      Alpha     : Float;
      Direction : Points.Direction);
   --  Translation
   procedure Translate (Object : in out Transformation; V : Points.Point);
   procedure Translate (Object : in out Transformation; DX, DY, DZ : Float);
   --  Scale
   procedure Scale (Object : in out Transformation; SX, SY, SZ : Float);
   --  complex transformation
   procedure Transform (Object : in out Transformation; T : Transformation);

   --  Apply to Points
   procedure Transform
     (Object     : Transformation;
      Point_List : in out Points.Lists.Vector);
   procedure Transform (Object : Transformation; Point : in out Points.Point);

private
   type Matrix_Type is array (1 .. 3, 1 .. 4) of Float;
   type Transformation is tagged record
      Matrix : Matrix_Type := ((1.0, 0.0, 0.0, 0.0),
                               (0.0, 1.0, 0.0, 0.0),
                               (0.0, 0.0, 1.0, 0.0));
   end record;
end Transformations;

with Models;
with Points;
with Transformations;
package Drawables is
   type Drawable is tagged private;

   procedure Set_Scale
     (Object : in out Drawable;
      Scale  : Transformations.Transformation);
   function Get_Scale
     (Object : Drawable)
      return   Transformations.Transformation;
   procedure Set_Rotation
     (Object   : in out Drawable;
      Rotation : Transformations.Transformation);
   function Get_Rotation
     (Object : Drawable)
      return   Transformations.Transformation;
   procedure Set_Translation
     (Object      : in out Drawable;
      Translation : Transformations.Transformation);
   function Get_Translation
     (Object : Drawable)
      return   Transformations.Transformation;
   procedure Set_Model (Object : in out Drawable; Model : Models.Model);
   function Get_Model (Object : Drawable) return Models.Model;

   function Get_Transformed_Model (Object : Drawable) return Models.Model;

   procedure Scale (Object : in out Drawable; SX, SY, SZ : Float);
   procedure Rotate
     (Object    : in out Drawable;
      Alpha     : Float;
      Direction : Points.Direction);
   procedure Move (Object : in out Drawable; P : Points.Point);
   procedure Move (Object : in out Drawable; DX, DY, DZ : Float);
   procedure Reset (Object : in out Drawable);

   procedure Draw (Object : Drawable);

private
   type Drawable is tagged record
      Scale       : Transformations.Transformation;
      Rotation    : Transformations.Transformation;
      Translation : Transformations.Transformation;
      Model       : Models.Model;
   end record;
end Drawables;

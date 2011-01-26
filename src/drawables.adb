with Edges;
with GL;
package body Drawables is

   procedure Draw (Object : Drawable) is
      use GL;
      M    : constant Models.Model :=
        Drawable'Class (Object).Get_Transformed_Model;
      E    : Edges.Edge;
      P, Q : Points.Point;
   begin
      glLineWidth (0.5);
      glColor3f (0.5, 0.5, 0.5);
      glBegin (GL_LINES);

      for ID in 1 .. M.Count_Edges loop
         E := M.Get_Edge (ID);
         P := M.Get_Point (E.From);
         Q := M.Get_Point (E.To);
         glVertex3f (GLfloat (P.X), GLfloat (P.Y), GLfloat (P.Z));
         glVertex3f (GLfloat (Q.X), GLfloat (Q.Y), GLfloat (Q.Z));
      end loop;

      glEnd;
   end Draw;

   function Get_Model (Object : Drawable) return Models.Model is
   begin
      return Object.Model;
   end Get_Model;

   function Get_Rotation
     (Object : Drawable)
      return Transformations.Transformation
   is
   begin
      return Object.Rotation;
   end Get_Rotation;

   function Get_Scale
     (Object : Drawable)
      return Transformations.Transformation
   is
   begin
      return Object.Scale;
   end Get_Scale;

   function Get_Transformed_Model (Object : Drawable) return Models.Model is
      Result : Models.Model := Object.Model;
   begin
      Result.Transform (Object.Scale);
      Result.Transform (Object.Rotation);
      Result.Transform (Object.Translation);
      return Result;
   end Get_Transformed_Model;

   function Get_Translation
     (Object : Drawable)
      return Transformations.Transformation
   is
   begin
      return Object.Translation;
   end Get_Translation;

   procedure Move (Object : in out Drawable; P : Points.Point) is
   begin
      Object.Translation.Translate (P);
   end Move;

   procedure Move (Object : in out Drawable; DX, DY, DZ : Float) is
   begin
      Object.Translation.Translate (DX, DY, DZ);
   end Move;

   procedure Reset (Object : in out Drawable) is
   begin
      Object.Scale.Reset;
      Object.Rotation.Reset;
      Object.Translation.Reset;
   end Reset;

   procedure Rotate
     (Object    : in out Drawable;
      Alpha     : Float;
      Direction : Points.Direction)
   is
   begin
      Object.Rotation.Rotate (Alpha, Direction);
   end Rotate;

   procedure Scale (Object : in out Drawable; SX, SY, SZ : Float) is
   begin
      Object.Scale.Scale (SX, SY, SZ);
   end Scale;

   procedure Set_Model (Object : in out Drawable; Model : Models.Model) is
   begin
      Object.Model := Model;
   end Set_Model;

   procedure Set_Rotation
     (Object   : in out Drawable;
      Rotation : Transformations.Transformation)
   is
   begin
      Object.Rotation := Rotation;
   end Set_Rotation;

   procedure Set_Scale
     (Object : in out Drawable;
      Scale  : Transformations.Transformation)
   is
   begin
      Object.Scale := Scale;
   end Set_Scale;

   procedure Set_Translation
     (Object      : in out Drawable;
      Translation : Transformations.Transformation)
   is
   begin
      Object.Translation := Translation;
   end Set_Translation;

end Drawables;

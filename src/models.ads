with Points.Lists;
with Edges.Lists;
with Transformations;
package Models is
   type Model is tagged private;
   procedure Add_Point (Object : in out Model; P  : Points.Point);
   procedure Add_Point
     (Object : in out Model;
      P  : Points.Point;
      ID : out Positive);
   function Get_Point (From : Model; ID : Positive) return Points.Point;
   function Count_Points (From : Model) return Natural;
   procedure Add_Edge (Object : in out Model; From, To : Positive);
   function Get_Edge (From : Model; ID : Positive) return Edges.Edge;
   function Count_Edges (From : Model) return Natural;
   procedure Add_Model (Object : in out Model; Other : Model);
   procedure Empty (Object : in out Model);
   procedure Transform
     (Object : in out Model;
      T      : Transformations.Transformation);
private
   type Model is tagged record
      Point_List : Points.Lists.Vector := Points.Lists.Empty_Vector;
      Edge_List  : Edges.Lists.Vector := Edges.Lists.Empty_Vector;
   end record;
end Models;

package body Models is

   procedure Add_Edge (Object : in out Model; From, To : Positive) is
   begin
      Object.Edge_List.Append (Edges.Create (From => From, To => To));
   end Add_Edge;

   procedure Add_Model (Object : in out Model; Other : Model) is
      procedure Add_Edges (Position : Edges.Lists.Cursor);
      procedure Add_Points (Position : Points.Lists.Cursor);
      Offset : constant Natural := Object.Point_List.Last_Index;
      procedure Add_Edges (Position : Edges.Lists.Cursor) is
         Edge : constant Edges.Edge := Edges.Lists.Element (Position);
      begin
         Object.Add_Edge (From => Edge.From + Offset, To => Edge.To + Offset);
      end Add_Edges;
      procedure Add_Points (Position : Points.Lists.Cursor) is
      begin
         Object.Point_List.Append (Points.Lists.Element (Position));
      end Add_Points;
   begin
      Other.Point_List.Iterate (Process => Add_Points'Access);
      Other.Edge_List.Iterate (Process => Add_Edges'Access);
   end Add_Model;

   procedure Add_Point (Object : in out Model; P : Points.Point) is
   begin
      Object.Point_List.Append (P);
   end Add_Point;

   procedure Add_Point
     (Object : in out Model;
      P  : Points.Point;
      ID : out Positive)
   is
   begin
      Object.Point_List.Append (P);
      ID := Object.Point_List.Last_Index;
   end Add_Point;

   function Count_Edges (From : Model) return Natural is
   begin
      return Integer (Edges.Lists.Length (From.Edge_List));
   end Count_Edges;

   function Count_Points (From : Model) return Natural is
   begin
      return Integer (Points.Lists.Length (From.Point_List));
   end Count_Points;

   procedure Empty (Object : in out Model) is
   begin
      Object.Point_List.Clear;
      Object.Edge_List.Clear;
   end Empty;

   function Get_Edge (From : Model; ID : Positive) return Edges.Edge is
   begin
      return From.Edge_List.Element (Index => ID);
   end Get_Edge;

   function Get_Point (From : Model; ID : Positive) return Points.Point is
   begin
      return From.Point_List.Element (Index => ID);
   end Get_Point;

   procedure Set_Point
     (Object : in out Model;
      ID     : Positive;
      Point  : Points.Point)
   is
   begin
      Object.Point_List.Replace_Element (ID, Point);
   end Set_Point;

   procedure Transform
     (Object : in out Model;
      T      : Transformations.Transformation)
   is
   begin
      T.Transform (Object.Point_List);
   end Transform;

end Models;

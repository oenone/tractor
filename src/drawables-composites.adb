package body Drawables.Composites is

   procedure Add_Item (Object : in out Composite; Item : Drawable'Class) is
   begin
      Object.Items.Append (Item);
   end Add_Item;

   procedure Add_Item
     (Object : in out Composite;
      Item   : Drawable'Class;
      ID     : out Positive) is
   begin
      Object.Items.Append (Item);
      ID := Object.Items.Last_Index;
   end Add_Item;

   procedure Delete_Item (Object : in out Composite; ID : Positive) is
   begin
      --  Generated stub: replace with real body!
      raise Program_Error with "Unimplemented procedure Delete_Item";
   end Delete_Item;

   function Get_Item
     (Object : Composite;
      ID     : Positive)
      return   Drawable'Class
   is
   begin
      return Object.Items.Element (ID);
   end Get_Item;

   overriding function Get_Transformed_Model
     (Object : Composite)
      return   Models.Model
   is
      use type Drawable_Vectors.Cursor;
      Iterator : Drawable_Vectors.Cursor := Object.Items.First;
      Result   : Models.Model            := Object.Model;
   begin
      while Iterator /= Drawable_Vectors.No_Element loop
         declare
            Item : constant Drawable'Class :=
               Drawable_Vectors.Element (Iterator);
         begin
            Result.Add_Model (Item.Get_Transformed_Model);
         end;
         Iterator := Drawable_Vectors.Next (Iterator);
      end loop;
      Result.Transform (Object.Scale);
      Result.Transform (Object.Rotation);
      Result.Transform (Object.Translation);
      return Result;
   end Get_Transformed_Model;

   overriding procedure Reset (Object : in out Composite) is
      use type Drawable_Vectors.Cursor;
      Iterator : Drawable_Vectors.Cursor := Object.Items.First;
   begin
      while Iterator /= Drawable_Vectors.No_Element loop
         declare
            Item : Drawable'Class := Drawable_Vectors.Element (Iterator);
         begin
            Item.Reset;
            Object.Items.Replace_Element (Iterator, Item);
         end;
         Iterator := Drawable_Vectors.Next (Iterator);
      end loop;
      Reset (Drawable (Object));
   end Reset;

end Drawables.Composites;

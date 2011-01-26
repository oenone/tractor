with Ada.Containers.Indefinite_Vectors;
package Drawables.Composites is
   type Composite is new Drawable with private;
   procedure Add_Item (Object : in out Composite; Item : Drawable'Class);
   procedure Add_Item
     (Object : in out Composite;
      Item   : Drawable'Class;
      ID     : out Positive);
   function Get_Item
     (Object : Composite;
      ID     : Positive)
      return   Drawable'Class;
   procedure Delete_Item (Object : in out Composite; ID : Positive);
   overriding function Get_Transformed_Model
     (Object : Composite)
      return   Models.Model;
   overriding procedure Reset (Object : in out Composite);
private
   package Drawable_Vectors is new Ada.Containers.Indefinite_Vectors
     (Element_Type => Drawable'Class,
      Index_Type   => Positive);
   type Composite is new Drawable with record
      Items : Drawable_Vectors.Vector := Drawable_Vectors.Empty_Vector;
   end record;
end Drawables.Composites;

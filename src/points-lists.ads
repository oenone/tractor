with Ada.Containers.Vectors;
package Points.Lists is new Ada.Containers.Vectors
  (Element_Type => Point,
   Index_Type   => Positive);

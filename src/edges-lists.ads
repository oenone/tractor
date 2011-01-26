with Ada.Containers.Vectors;
package Edges.Lists is new Ada.Containers.Vectors
  (Element_Type => Edge,
   Index_Type   => Positive);

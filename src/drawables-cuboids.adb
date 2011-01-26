with Points;
package body Drawables.Cuboids is

   package body Factory is
      function Create (X, Y, Z : Float) return Cuboid is
         Result : Cuboid;
      begin
         --  insert first point
         Result.Model.Add_Point (Points.Create (X / 2.0, Y / 2.0, Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (-X / 2.0, Y / 2.0, Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (-X / 2.0, -Y / 2.0, Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (X / 2.0, -Y / 2.0, Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (X / 2.0, Y / 2.0, -Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (-X / 2.0, Y / 2.0, -Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (-X / 2.0, -Y / 2.0, -Z / 2.0));
         --  insert next point
         Result.Model.Add_Point (Points.Create (X / 2.0, -Y / 2.0, -Z / 2.0));

         --  connect the points
         for I in 1 .. 12 loop
            case I is
            when 1 .. 3 | 5 .. 7 =>
               --  connect points with neighbour
               Result.Model.Add_Edge (I, I + 1);
            when 4 | 8 =>
               --  connect first and last points
               Result.Model.Add_Edge (I, I - 3);
            when 9 .. 12 =>
               --  connect front with back
               Result.Model.Add_Edge (I - 4, I - 8);
            end case;
         end loop;
         return Result;
      end Create;
   end Factory;

end Drawables.Cuboids;

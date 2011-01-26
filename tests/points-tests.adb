package body Points.Tests is

   function Image (P : Point) return String;
   procedure Assert_Equal_Points is new Ahven.Assert_Equal
     (Data_Type => Point,
      Image     => Image);
   procedure Assert_Equal_Float is new Ahven.Assert_Equal
     (Data_Type => Float,
      Image     => Float'Image);

   function Image (P : Point) return String is
      Result : constant String := "P ("
        & Float'Image (P.X) & ","
        & Float'Image (P.Y) & ","
        & Float'Image (P.Z) & ")";
   begin
      return Result;
   end Image;

   overriding
   procedure Initialize (T : in out Test) is
   begin
      T.Set_Name (Name => "Point Tests");
      T.Add_Test_Routine (Routine => Test_XYZ'Access,
                          Name    => "Test X, Y, and Z selectors");
      T.Add_Test_Routine (Routine => Test_Equality'Access,
                          Name    => "Test equality of points");
      T.Add_Test_Routine (Routine => Test_Addition'Access,
                          Name    => "Test addition of points");
      T.Add_Test_Routine (Routine => Test_Subtraction'Access,
                          Name    => "Test subtraction of points");
      T.Add_Test_Routine (Routine => Test_Product'Access,
                          Name    => "Test product of points");
   end Initialize;

   procedure Test_Addition is
      P, Q, R : Point;
   begin
      P := Points.Create (X => 1.0,
                          Y => 2.0,
                          Z => 3.0);
      Q := Points.Create (X => 2.0,
                          Y => 3.0,
                          Z => 4.0);
      R := Points.Create (X => 3.0,
                          Y => 5.0,
                          Z => 7.0);
      Assert_Equal_Points (Actual   => P + Q,
                           Expected => R,
                           Message  => "Addition failed!");
   end Test_Addition;

   procedure Test_Equality is
      P, Q : Point;
   begin
      P := Create (X => 1.0,
                   Y => 2.0,
                   Z => 3.0);
      Ahven.Assert (Condition => P = P,
                    Message   => "Equality failed");
      Q := Create (X => 1.0,
                   Y => 2.0,
                   Z => 3.0);
      Ahven.Assert (Condition => P = Q,
                    Message   => "Equality failed");
      Q := Create (X => 2.0,
                   Y => 1.0,
                   Z => 3.0);
      Ahven.Assert (Condition => P /= Q,
                    Message   => "Equality failed");
      Q := P;
      Ahven.Assert (Condition => P = Q,
                    Message   => "Equality failed");
      P := Create (X => 3.0,
                   Y => 2.0,
                   Z => 1.0);
      Ahven.Assert (Condition => P /= Q,
                    Message   => "Equality failed");
   end Test_Equality;

   procedure Test_Product is
      P, Q : Point;
      R    : constant Float := 36.0;
   begin
      P := Points.Create (X =>  1.0,
                          Y =>  2.0,
                          Z =>  3.0);
      Q := Points.Create (X => -7.0,
                          Y =>  8.0,
                          Z =>  9.0);
      Assert_Equal_Float (Actual   => P * Q,
                          Expected => R,
                          Message  => "Product failed!");
      Assert_Equal_Float (Actual   => P * P,
                          Expected => 14.0,
                          Message  => "Self-Product failed!");
   end Test_Product;

   procedure Test_Subtraction is
      P, Q, R : Point;
   begin
      P := Create (X => 1.0,
                   Y => 2.0,
                   Z => 3.0);
      Q := Create (X => 2.0,
                   Y => 3.0,
                   Z => 4.0);
      R := Create (X => -1.0,
                   Y => -1.0,
                   Z => -1.0);
      Assert_Equal_Points (Actual   => P - Q,
                           Expected => R,
                           Message  => "Subtraction failed!");
   end Test_Subtraction;

   procedure Test_XYZ is
      P : constant Point :=
            Create (X => 1.0, Y => 2.0, Z => 3.0);
   begin
      Assert_Equal_Float (Actual   => P.X,
                          Expected => P.Vector (1),
                          Message  => "X selector failed!");
      Assert_Equal_Float (Actual   => P.Y,
                          Expected => P.Vector (2),
                          Message  => "Y selector failed!");
      Assert_Equal_Float (Actual   => P.Z,
                          Expected => P.Vector (3),
                          Message  => "Z selector failed!");
   end Test_XYZ;

end Points.Tests;

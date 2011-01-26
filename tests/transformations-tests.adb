with Ada.Numerics.Float_Random;
with Ada.Numerics.Elementary_Functions;
package body Transformations.Tests is
   Gen : Ada.Numerics.Float_Random.Generator;
   function Random (Gen : Ada.Numerics.Float_Random.Generator) return Float
                    renames Ada.Numerics.Float_Random.Random;

   procedure Assert_Float_Equals
     (Actual, Expected : Float;
      Message          : String);
   procedure Assert_Point_Equals
     (Actual, Expected : Points.Point;
      Message          : String);

   procedure Assert_Float_Equals
     (Actual, Expected : Float;
      Message          : String)
   is
   begin
      if abs (Actual - Expected) > 1.0E-5 then
         Ahven.Fail (Message => Message
                     & "( Expected:" & Float'Image (Expected)
                     & "; Got:" & Float'Image (Actual) & ")");
      end if;
   end Assert_Float_Equals;

   procedure Assert_Point_Equals
     (Actual, Expected : Points.Point;
      Message          : String)
   is
   begin
      Assert_Float_Equals (Actual   => Actual.X,
                           Expected => Expected.X,
                           Message  => Message
                           & "(X)");
      Assert_Float_Equals (Actual   => Actual.Y,
                           Expected => Expected.Y,
                           Message  => Message
                           & "(Y)");
      Assert_Float_Equals (Actual   => Actual.Z,
                           Expected => Expected.Z,
                           Message  => Message
                           & "(Z)");
   end Assert_Point_Equals;

   overriding procedure Initialize (T : in out Test) is
   begin
      Ada.Numerics.Float_Random.Reset (Gen, 1);
      T.Set_Name (Name => "Transformation Tests");
      T.Add_Test_Routine (Routine => Test_Get_Set'Access,
                          Name    => "Test Getter and Setter");
      T.Add_Test_Routine (Routine => Test_Empty'Access,
                          Name    => "Test Empty");
      T.Add_Test_Routine (Routine => Test_Reset'Access,
                          Name    => "Test Reset");
      T.Add_Test_Routine (Routine => Test_Rotation'Access,
                          Name    => "Test Rotation");
      T.Add_Test_Routine (Routine => Test_Scale'Access,
                          Name    => "Test Scale");
      T.Add_Test_Routine (Routine => Test_Translation'Access,
                          Name    => "Test Translation");
      T.Add_Test_Routine (Routine => Test_Complex_Transform'Access,
                          Name    => "Test complex Transformation");
      T.Add_Test_Routine (Routine => Test_Transforming_Point'Access,
                          Name    => "Test transforming Points");
      T.Add_Test_Routine (Routine => Test_Transforming_Point_List'Access,
                          Name    => "Test transforming Point Lists");
   end Initialize;

   procedure Test_Complex_Transform is
      T1, T2 : Transformation;
   begin
      T2.Reset;
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            T1.Set_Value (Row    => Row,
                          Column => Column,
                          Value  => Random (Gen));
         end loop;
      end loop;
      T2.Transform (T => T1);
      Ahven.Assert (Condition => T1 = T2,
                    Message   => "complex transformation failed!");
      T2.Transform (T => T1);
      Ahven.Assert (Condition => T1 /= T2,
                    Message   => "complex transformation failed!");
   end Test_Complex_Transform;

   procedure Test_Empty is
      T1 : Transformation;
   begin
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            T1.Set_Value (Row    => Row,
                          Column => Column,
                          Value  => Random (Gen));
         end loop;
      end loop;
      T1.Empty;
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual    => T1.Matrix (Row, Column),
                                 Expected  => 0.0,
                                 Message   => "Empty failed!");
         end loop;
      end loop;
   end Test_Empty;

   procedure Test_Get_Set is
      T1  : Transformation;
      Tmp : Float;
   begin
      T1.Reset;
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Tmp := Random (Gen);
            T1.Set_Value (Row    => Row,
                          Column => Column,
                          Value  => Tmp);
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => Tmp,
                                 Message  => "Set failed!");
            Assert_Float_Equals (Actual   => T1.Get_Value (Row    => Row,
                                                           Column => Column),
                                 Expected => T1.Matrix (Row, Column),
                                 Message  => "Get failed!");
         end loop;
      end loop;
   end Test_Get_Set;

   procedure Test_Reset is
      T1 : Transformation;
   begin
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            T1.Set_Value (Row    => Row,
                          Column => Column,
                          Value  => Random (Gen));
         end loop;
      end loop;
      T1.Reset;
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            if Row = Column then
               Ahven.Assert (Condition => T1.Matrix (Row, Column) = 1.0,
                             Message   => "Reset failed!");
            else
               Ahven.Assert (Condition => T1.Matrix (Row, Column) = 0.0,
                             Message   => "Reset failed!");
            end if;
         end loop;
      end loop;
   end Test_Reset;

   procedure Test_Rotation is
      use Ada.Numerics.Elementary_Functions;
      T1 : Transformation;
      R1 : Transformation;
   begin
      T1.Reset;
      T1.Rotate (Alpha     => 30.0,
                 Direction => Points.X);
      R1.Matrix := (1 => (1.0, 0.0, 0.0, 0.0),
                    2 => (0.0, 0.5 * Sqrt (3.0), -0.5, 0.0),
                    3 => (0.0, 0.5, 0.5 * Sqrt (3.0), 0.0));
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Rotation X failed for " & Integer'Image (Row) & "," & Integer'Image (Column));
         end loop;
      end loop;
      T1.Reset;
      T1.Rotate (Alpha     => 30.0,
                 Direction => Points.Y);
      R1.Matrix := (1 => (0.5 * Sqrt (3.0), 0.0, 0.5, 0.0),
                    2 => (0.0, 1.0, 0.0, 0.0),
                    3 => (-0.5, 0.0, 0.5 * Sqrt (3.0), 0.0));
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Rotation Y failed for " & Integer'Image (Row) & "," & Integer'Image (Column));
         end loop;
      end loop;
      T1.Reset;
      T1.Rotate (Alpha     => 30.0,
                 Direction => Points.Z);
      R1.Matrix := (1 => (0.5 * Sqrt (3.0), -0.5, 0.0, 0.0),
                    2 => (0.5, 0.5 * Sqrt (3.0), 0.0, 0.0),
                    3 => (0.0, 0.0, 1.0, 0.0));
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Rotation Z failed for " & Integer'Image (Row) & "," & Integer'Image (Column));
         end loop;
      end loop;
   end Test_Rotation;

   procedure Test_Scale is
      T1 : Transformation;
      R1 : Transformation;
   begin
      T1.Reset;
      T1.Scale (SX => 3.0,
                SY => 4.0,
                SZ => 2.0);
      R1.Matrix := (1 => (3.0, 0.0, 0.0, 0.0),
                    2 => (0.0, 4.0, 0.0, 0.0),
                    3 => (0.0, 0.0, 2.0, 0.0));
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Scale failed for " & Integer'Image (Row) & "," & Integer'Image (Column));
         end loop;
      end loop;
      T1.Scale (SX => 1.0 / 3.0,
                SY => 1.0 / 4.0,
                SZ => 1.0 / 2.0);
      R1.Reset;
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Re-Scale failed for " & Integer'Image (Row) & "," & Integer'Image (Column));
         end loop;
      end loop;
   end Test_Scale;

   procedure Test_Transforming_Point is
      P1     : constant Points.Point :=
                 Points.Create (X => 2.0,
                                Y => 3.5,
                                Z => 1.2);
      P2, P3 : Points.Point;
      T1     : Transformation;
   begin
      T1.Reset;
      T1.Rotate (Alpha     => 90.0,
                 Direction => Points.X);
      P2 := P1;
      --  Rotate Point P2
      T1.Transform (Point => P2);
      Assert_Point_Equals (Actual => P2,
                           Expected => Points.Create (X => 2.0,
                                                      Y => -1.2,
                                                      Z => 3.5),
                           Message => "Rotating Point failed!");

      T1.Scale (SX => 3.0,
                SY => 4.0,
                SZ => 5.0);
      P2 := P1;
      --  Scale and rotate Point P2
      T1.Transform (Point => P2);
      Assert_Point_Equals (Actual   => P2,
                           Expected => Points.Create (X =>  6.0,
                                                      Y => -6.0,
                                                      Z => 14.0),
                           Message  => "Scaling Point failed!");

      P3 := P1;
      T1.Reset;
      T1.Scale (SX => 3.0,
                SY => 4.0,
                SZ => 5.0);
      --  Scale Point P3 first
      T1.Transform (Point => P3);
      T1.Reset;
      T1.Rotate (Alpha     => 90.0,
                 Direction => Points.X);
      --  Then rotate scaled Point P3
      T1.Transform (Point => P3);
      --  Has to be equal to P2!
      Assert_Point_Equals (Actual   => P3,
                           Expected => P2,
                           Message  => "Scaling Point failed!");

      T1.Reset;
      T1.Translate (DX => 2.0,
                    DY => 1.0,
                    DZ => 0.5);
      P2 := P1;
      --  Translate Point P2
      T1.Transform (Point => P2);
      Assert_Point_Equals (Actual => P2,
                           Expected => Points.Create (X => 4.0,
                                                      Y => 4.5,
                                                      Z => 1.7),
                           Message => "Rotating Point failed!");
   end Test_Transforming_Point;

   procedure Test_Transforming_Point_List is
      Point_List : Points.Lists.Vector;
      Original   : Points.Lists.Vector;
      P          : Points.Point;
      T          : Transformation;
   begin
      P := Points.Create (X => 1.0,
                          Y => 2.0,
                          Z => 3.0);
      Point_List.Append (P);
      Original.Append (P);
      P := Points.Create (X => 2.0,
                          Y => 2.0,
                          Z => 0.0);
      Point_List.Append (P);
      Original.Append (P);
      P := Points.Create (X => -1.0,
                          Y => 4.0,
                          Z => 2.0);
      Point_List.Append (P);
      Original.Append (P);
      P := Points.Create (X => 9.0,
                          Y => -4.0,
                          Z => -5.0);
      Point_List.Append (P);
      Original.Append (P);

      T.Reset;
      T.Rotate (Alpha     => 45.0,
                Direction => Points.Y);
      T.Scale (SX => 2.0,
               SY => 1.5,
               SZ => 2.0);
      P := Points.Create (X => 0.0,
                          Y => 0.0,
                          Z => -4.0);
      T.Translate (V => P);

      --  Transform the whole list
      T.Transform (Point_List => Point_List);

      --  Transform each single point
      for Position in 1 .. 4 loop
         P := Original.Element (Index => Position);
         T.Transform (Point => P);
         Original.Replace_Element (Index => Position, New_Item => P);
      end loop;

      --  Vectors have to be same!
      for Position in 1 .. 4 loop
         Assert_Point_Equals (Actual   => Point_List.Element (Index => Position),
                              Expected => Original.Element (Index => Position),
                              Message  => "Transforming List failed!");
      end loop;
   end Test_Transforming_Point_List;

   procedure Test_Translation is
      T1, T2 : Transformation;
      R1     : Transformation;
      P : constant Points.Point := Points.Create (3.0, 4.0, 2.0);
   begin
      T1.Reset;
      T1.Translate (DX => 3.0,
                    DY => 4.0,
                    DZ => 2.0);
      T2.Reset;
      T2.Translate (V => P);
      R1.Reset;
      R1.Matrix (1, 4) := 3.0;
      R1.Matrix (2, 4) := 4.0;
      R1.Matrix (3, 4) := 2.0;
      for Row in 1 .. 3 loop
         for Column in 1 .. 4 loop
            Assert_Float_Equals (Actual   => T1.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Translation failed for T1 " & Integer'Image (Row) & "," & Integer'Image (Column));
            Assert_Float_Equals (Actual   => T2.Matrix (Row, Column),
                                 Expected => R1.Matrix (Row, Column),
                                 Message  => "Translation failed for T2 " & Integer'Image (Row) & "," & Integer'Image (Column));
         end loop;
      end loop;
   end Test_Translation;

end Transformations.Tests;

with Edges;
package body Edge_Tests is
   procedure Assert_Positive_Equals is new Ahven.Assert_Equal
     (Data_Type => Positive,
      Image     => Positive'Image);
   overriding procedure Initialize (T : in out Test) is
   begin
      T.Set_Name (Name => "Edge Tests");
      T.Add_Test_Routine (Routine => Test_Create'Access,
                          Name    => "Test Create function");
      T.Add_Test_Routine (Routine => Test_From'Access,
                          Name    => "Test From selector");
      T.Add_Test_Routine (Routine => Test_To'Access,
                          Name    => "Test To selector");
   end Initialize;
   procedure Test_Create is
   begin
      null;
   end Test_Create;
   procedure Test_From is
      E : constant Edges.Edge := Edges.Create (1, 2);
   begin
      Assert_Positive_Equals (Actual   => E.From,
                              Expected => 1,
                              Message  => "From failed!");
   end Test_From;
   procedure Test_To is
      E : constant Edges.Edge := Edges.Create (1, 2);
   begin
      Assert_Positive_Equals (Actual   => E.To,
                              Expected => 2,
                              Message  => "To failed!");
   end Test_To;
end Edge_Tests;

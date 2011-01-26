package body Tractor_Tests is

   ----------------
   -- Initialize --
   ----------------

   overriding
   procedure Initialize (T : in out Test) is
   begin
      T.Set_Name (Name => "Tractor Tests");
      T.Add_Test_Routine (Routine => My_First_Test'Access,
                          Name    => "First Test");
   end Initialize;

   -------------------
   -- My_First_Test --
   -------------------

   procedure My_First_Test is
   begin
      Ahven.Assert (Condition => 1 /= 4,
                    Message   => "1 /= 4 failed!");
   end My_First_Test;

end Tractor_Tests;

with Ahven.Framework;
with Ahven.Text_Runner;
with Points.Tests;
with Edge_Tests;
with Transformations.Tests;
procedure Tester is
   S : constant Ahven.Framework.Test_Suite_Access := Ahven.Framework.Create_Suite ("Tractor Tests");
begin
   S.Add_Test (T => new Points.Tests.Test);
   S.Add_Test (T => new Edge_Tests.Test);
   S.Add_Test (T => new Transformations.Tests.Test);
   Ahven.Text_Runner.Run (Suite => S);
   Ahven.Framework.Release_Suite (T => S);
end Tester;

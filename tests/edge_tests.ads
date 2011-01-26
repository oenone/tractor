with Ahven.Framework;
package Edge_Tests is
   type Test is new Ahven.Framework.Test_Case with null record;
   overriding procedure Initialize (T : in out Test);
   procedure Test_Create;
   procedure Test_From;
   procedure Test_To;
end Edge_Tests;

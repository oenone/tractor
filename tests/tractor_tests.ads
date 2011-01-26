with Ahven.Framework;
package Tractor_Tests is
   type Test is new Ahven.Framework.Test_Case with null record;
   overriding
   procedure Initialize (T : in out Test);
   procedure My_First_Test;
end Tractor_Tests;

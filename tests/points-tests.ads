with Ahven.Framework;
package Points.Tests is
   type Test is new Ahven.Framework.Test_Case with null record;
   overriding procedure Initialize (T : in out Test);
   procedure Test_XYZ;
   procedure Test_Equality;
   procedure Test_Addition;
   procedure Test_Subtraction;
   procedure Test_Product;
end Points.Tests;

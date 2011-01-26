with Ahven.Framework;
package Transformations.Tests is
   type Test is new Ahven.Framework.Test_Case with null record;
   overriding procedure Initialize (T : in out Test);
   procedure Test_Get_Set;

   procedure Test_Empty;
   procedure Test_Reset;

   procedure Test_Rotation;
   procedure Test_Scale;
   procedure Test_Translation;
   procedure Test_Complex_Transform;

   procedure Test_Transforming_Point;
   procedure Test_Transforming_Point_List;
end Transformations.Tests;

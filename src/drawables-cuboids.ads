package Drawables.Cuboids is
   type Cuboid is new Drawable with private;
   package Factory is
      function Create (X, Y, Z : Float) return Cuboid;
   end Factory;
private
   type Cuboid is new Drawable with null record;
end Drawables.Cuboids;

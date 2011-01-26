--
-- Copyright (c) 2010 Julian Leyh <julian@vgai.de>
--
-- Permission to use, copy, modify, and distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--

with Lumen.Window;
with Lumen.Events;
with Lumen.Events.Animate;
with GL;
with GLU;
with Drawables.Composites.Mobiles.Tractors;
with Points;

procedure Main is

   procedure Draw;
   procedure Frame_Handler (Frame_Delta : Duration);
   procedure Init_GL;
   procedure Quit_Handler (Event : Lumen.Events.Event_Data);
   procedure Resize_Handler (Event : Lumen.Events.Event_Data);
   procedure Resize_Scene (Width, Height : Natural);

   The_Window : Lumen.Window.Handle;
   Wheel_X_Rotation : constant Float := 2.0;
   -- Wheel_Y_Rotation : constant Float := 0.1;
   Object : Drawables.Composites.Mobiles.Tractors.Tractor;

   procedure Draw is
      use GL;
   begin
      -- clear screen and depth buffer
      glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

      glLineWidth (width => 1.0);
      glColor3f (red   => 0.1,
                 green => 0.8,
                 blue  => 0.1);

      Object.Rotate_Wheels (Wheel_X_Rotation, Points.X);
      -- Y Rotation is BROKEN!
      --Object.Rotate_Wheels (Wheel_Y_Rotation, Points.Y);
      Object.Draw;

   end Draw;

   procedure Frame_Handler (Frame_Delta : Duration) is
      pragma Unreferenced (Frame_Delta);
   begin
      Draw;
      Lumen.Window.Swap (The_Window);
   end Frame_Handler;

   procedure Init_GL is
      use GL;
      use GLU;
   begin
      -- smooth shading
      glShadeModel (GL_SMOOTH);

      -- black background
      glClearColor (0.0, 0.0, 0.0, 0.0);

      -- depth buffer setup
      glClearDepth (1.0);
      -- type of depth test
      glDepthFunc (GL_LESS);
      -- enable depth testing
      glEnable (GL_DEPTH_TEST);
      glEnable (GL_LINE_SMOOTH);

      glHint (GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
   end Init_GL;

   -- simply exit this program
   procedure Quit_Handler (Event : Lumen.Events.Event_Data) is
      pragma Unreferenced (Event);
   begin
      Lumen.Events.End_Events (The_Window);
   end Quit_Handler;

   -- Resize and Initialize the GL window
   procedure Resize_Handler (Event : Lumen.Events.Event_Data) is
      Height : Natural := Event.Resize_Data.Height;
      Width  : constant Natural := Event.Resize_Data.Width;
   begin
      -- prevent div by zero
      if Height = 0 then
         Height := 1;
      end if;

      Resize_Scene (Width, Height);
   end Resize_Handler;

   -- Resize the scene
   procedure Resize_Scene (Width, Height : Natural) is
      use GL;
      use GLU;
   begin
      -- reset current viewport
      glViewport (0, 0, GLsizei (Width), GLsizei (Height));

      -- select projection matrix and reset it
      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;

      -- calculate aspect ratio
      gluPerspective (45.0, GLdouble (Width) / GLdouble (Height), 0.1, 100.0);

      -- select modelview matrix and reset it
      glMatrixMode (GL_MODELVIEW);
   end Resize_Scene;

begin

   Lumen.Window.Create (Win => The_Window, Name   => "Tractor",
                        Width  => 500,
                        Height => 500,
                        Events => (Lumen.Window.Want_Exposure  => True,
                                   others                      => False));

   Object  :=
     Drawables.Composites.Mobiles.Tractors.Factory.Create (R     => 30.0,
                                                           Width => 50.0);

   Object.Move (-10.0, 0.0, -80.0);
   Object.Scale (0.2, 0.2, 0.2);
   Object.Rotate (90.0, Points.Y);
   Object.Rotate (45.0, Points.Z);
   Object.Rotate (-30.0, Points.Y);

   Resize_Scene (500, 500);
   Init_GL;

   Lumen.Events.Animate.Select_Events
     (Win   => The_Window,
      FPS   => 40,
      Frame => Frame_Handler'Unrestricted_Access,
      Calls => (Lumen.Events.Resized       =>
                  Resize_Handler'Unrestricted_Access,
                Lumen.Events.Close_Window  =>
                  Quit_Handler'Unrestricted_Access,
                others                     => Lumen.Events.No_Callback));
end Main;

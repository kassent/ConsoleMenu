﻿package ConsoleMenu
{
   import flash.display.MovieClip;
   
   public dynamic class ConsoleAnimationHolder extends MovieClip
   {
       
      
      public var Menu_mc:Console;
      
      public function ConsoleAnimationHolder()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,11,this.frame12);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame7() : *
      {
         this.Menu_mc.ShowComplete();
         stop();
      }
      
      function frame12() : *
      {
         this.Menu_mc.HideComplete();
         stop();
      }
   }
}
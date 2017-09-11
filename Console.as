package
{
	//import Shared.*;
	import Shared.AS3.BSScrollingList;
	
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
   //import flash.ui.Keyboard;
   
	import flash.display.*;
	import flash.ui.*;
	import scaleform.gfx.*;
	import Shared.IMenu;
   
   public class Console extends IMenu
   {
       
      public var FirstExtraInfoPanel_mc: MovieClip;
	  public var SecondExtraInfoPanel_mc: MovieClip;
	  public var ThirdExtraInfoPanel_mc: MovieClip;
 
      public var BGSCodeObj:Object;
      
      public var CommandEntry:TextField;
      
      public var Background:MovieClip;
      
      public var CommandHistory:TextField;
      
      public var CurrentSelection:TextField;
      
      public var CommandPrompt_tf:TextField;  
	  
	
	  // added by kassent  
	  public static var showExtraInfoWindow : Boolean = false;
	  
	  public var refName:TextField;
	  
	  public var refFormType:TextField;
	  
	  public var refFormID:TextField;
	  
	  public var baseFormID:TextField;
	  
	  public var refDefineModName: TextField;

	  public var baseDefineModName:TextField;
	  
	  public var baseLastChangeModName: TextField;

      
      private const PREVIOUS_COMMANDS:uint = 32;
      
      private var HistoryCharBufferSize:uint = 8192;
      
      private var CurrentSelectionYOffset:Number;
      
      private var TextXOffset:Number;
      
      private var Commands:Array;
      
      private var PreviousCommandOffset:int;
      
      private var OriginalWidth:Number;
      
      private var OriginalHeight:Number;
      
      private var ScreenPercent:Number;
      
      private var Shown:Boolean;
      
      private var Animating:Boolean;
      
      private var Hiding:Boolean;
      
      public function Console()
      {
         this.Commands = new Array();
         super();
         this.BGSCodeObj = new Object();
         Extensions.enabled = true;
		 
		 //this.FirstExtraInfoPanel_mc.filterer.itemFilter = uint(2);
		 FirstExtraInfoPanel_mc.visible = SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
						
         this.CurrentSelectionYOffset = this.Background.height + this.CurrentSelection.y;
         this.TextXOffset = this.CommandEntry.x;
         this.OriginalHeight = stage.stageHeight;
         this.OriginalWidth = stage.stageWidth;
         this.ScreenPercent = 100 * (this.height / stage.stageHeight);

         this.PreviousCommandOffset = 0;
         this.Shown = false;
         this.Animating = false;
         this.Hiding = false;
         this.CommandEntry.defaultTextFormat = this.CommandEntry.getTextFormat();
         this.CommandEntry.text = "";
         TextFieldEx.setNoTranslate(this.CommandEntry,true);
		 
         this.CurrentSelection.defaultTextFormat = this.CurrentSelection.getTextFormat();
         this.CurrentSelection.text = "";	 
         TextFieldEx.setNoTranslate(this.CurrentSelection,true);
		 
         this.CommandHistory.defaultTextFormat = this.CommandHistory.getTextFormat();
         this.CommandHistory.text = "";	 
         TextFieldEx.setNoTranslate(this.CommandHistory,true);

	  	 this.baseLastChangeModName.defaultTextFormat = this.baseLastChangeModName.getTextFormat();
         this.baseLastChangeModName.text = "";	 
         TextFieldEx.setNoTranslate(this.baseLastChangeModName,true);	
	  
		 this.refDefineModName.defaultTextFormat = this.refDefineModName.getTextFormat();
         this.refDefineModName.text = "";	 
         TextFieldEx.setNoTranslate(this.refDefineModName,true);	
		
		 this.baseDefineModName.defaultTextFormat = this.baseDefineModName.getTextFormat();
         this.baseDefineModName.text = "";	 
         TextFieldEx.setNoTranslate(this.baseDefineModName,true);	
	  
		 this.baseFormID.defaultTextFormat = this.baseFormID.getTextFormat();
         this.baseFormID.text = "";	 
         TextFieldEx.setNoTranslate(this.baseFormID,true);	  
	  
		 this.refFormID.defaultTextFormat = this.refFormID.getTextFormat();
         this.refFormID.text = "";	 
         TextFieldEx.setNoTranslate(this.refFormID,true);
	  
	  	 this.refFormType.defaultTextFormat = this.refFormType.getTextFormat();
         this.refFormType.text = "";	 
         TextFieldEx.setNoTranslate(this.refFormType,true);
	  
		 this.refName.defaultTextFormat = this.refName.getTextFormat();
         this.refName.text = "";	 
         TextFieldEx.setNoTranslate(this.refName,true);
		 
         stage.align = StageAlign.BOTTOM_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.addEventListener(Event.RESIZE,this.onResize);

         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
		 addEventListener(Shared.AS3.BSScrollingList.SELECTION_CHANGE, onExtraInfoListSelectionChange);
		
		 FirstExtraInfoPanel_mc.List_mc.ID = 1;
		 SecondExtraInfoPanel_mc.List_mc.ID = 2;
		 ThirdExtraInfoPanel_mc.List_mc.ID = 3;

		 root.addEventListener("OnConsoleOpen",this.OnConsoleOpen);
		 
         this.onResize();
      }
      
	  internal function onExtraInfoListSelectionChange(e : flash.events.Event):*
	  {
			trace("onFeatureSelectionChange");
			var list: ExtraInfoList = e.target as ExtraInfoList;
			trace(list.ID);
			var selectedIndex: * = null;
			var currentEntry: Object = null;
			var arrObj: * = null;
			if(list.ID == 1)
			{
				selectedIndex = FirstExtraInfoPanel_mc.List_mc.selectedIndex;
				currentEntry = FirstExtraInfoPanel_mc.List_mc.entryList[selectedIndex];
				if(currentEntry != null && currentEntry.hasOwnProperty("extraInfo"))
				{
					arrObj = currentEntry.extraInfo;
					if(arrObj is Array)
					{
						SecondExtraInfoPanel_mc.List_mc.entryList = arrObj;
						SecondExtraInfoPanel_mc.List_mc.selectedIndex = -1;		 
         				SecondExtraInfoPanel_mc.List_mc.InvalidateData();						
						SecondExtraInfoPanel_mc.visible = true;
					}
				}
				else
				{
					ThirdExtraInfoPanel_mc.visible = false;
					ThirdExtraInfoPanel_mc.List_mc.entryList = null;
					ThirdExtraInfoPanel_mc.List_mc.selectedIndex = -1;
					ThirdExtraInfoPanel_mc.List_mc.InvalidateData();

					SecondExtraInfoPanel_mc.visible = false;
					SecondExtraInfoPanel_mc.List_mc.entryList = null;
					SecondExtraInfoPanel_mc.List_mc.selectedIndex = -1;
					SecondExtraInfoPanel_mc.List_mc.InvalidateData();
				}
			}
			else if(list.ID == 2)
			{
				selectedIndex = SecondExtraInfoPanel_mc.List_mc.selectedIndex;
				currentEntry = SecondExtraInfoPanel_mc.List_mc.entryList[selectedIndex];
				if(currentEntry != null && currentEntry.hasOwnProperty("extraInfo"))
				{
					arrObj = currentEntry.extraInfo;
					if(arrObj is Array)
					{
						ThirdExtraInfoPanel_mc.List_mc.entryList = arrObj;
						ThirdExtraInfoPanel_mc.List_mc.selectedIndex = -1;		 
         				ThirdExtraInfoPanel_mc.List_mc.InvalidateData();						
						ThirdExtraInfoPanel_mc.visible = true;
					}
				}
				else
				{
					ThirdExtraInfoPanel_mc.visible = false;
					ThirdExtraInfoPanel_mc.List_mc.entryList = null;
					ThirdExtraInfoPanel_mc.List_mc.selectedIndex = -1;
					ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
				}
			}
	  }
	  //API called by native code.
	  public function canScrollMouse() : Boolean
	  {
            var point:* = localToGlobal(new flash.geom.Point(mouseX, mouseY));
            if (FirstExtraInfoPanel_mc.visible && FirstExtraInfoPanel_mc.background.hitTestPoint(point.x, point.y, false)) 
			{
				return false;
			}
            if (SecondExtraInfoPanel_mc.visible && SecondExtraInfoPanel_mc.background.hitTestPoint(point.x, point.y, false)) 
			{
				return false;
			}
            if (ThirdExtraInfoPanel_mc.visible && ThirdExtraInfoPanel_mc.background.hitTestPoint(point.x, point.y, false)) 
			{
				return false;
			}
			return true;
	  }


	  public function OnConsoleOpen(param1:Event) : void
      {
		 try
         {
			if(showExtraInfoWindow)
			{
				var resultArr: Array = root.f4se.plugins.BetterConsole.GetExtraData();
				if(resultArr is Array)
				{
					SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
					SecondExtraInfoPanel_mc.List_mc.entryList = ThirdExtraInfoPanel_mc.List_mc.entryList = null;
					FirstExtraInfoPanel_mc.List_mc.entryList = resultArr;
					FirstExtraInfoPanel_mc.List_mc.selectedIndex = -1;		 
					FirstExtraInfoPanel_mc.List_mc.InvalidateData();						
					SecondExtraInfoPanel_mc.List_mc.InvalidateData();
					ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
					FirstExtraInfoPanel_mc.visible = true;
				}
				else
				{
					FirstExtraInfoPanel_mc.visible = SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
					FirstExtraInfoPanel_mc.List_mc.entryList = SecondExtraInfoPanel_mc.List_mc.entryList = ThirdExtraInfoPanel_mc.List_mc.entryList = null;
					FirstExtraInfoPanel_mc.List_mc.InvalidateData();
					SecondExtraInfoPanel_mc.List_mc.InvalidateData();
					ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
				}
			}
         }
         catch(err:Error)
         {
			trace("Failed to get extra data...");
         }
      }
	  
      public function get shown() : Boolean
      {
         return this.Shown && !this.Animating;
      }
      
      public function get hiding() : Boolean
      {
         return this.Hiding;
      }
      
      public function set currentSelection(param1:String) : *
      {
         GlobalFunc.SetText(this.CurrentSelection,param1,false);

		 try
         {
            var resultObj: Object = root.f4se.plugins.BetterConsole.GetBaseData();
			if(resultObj is Object)
			{
	  			if(resultObj.hasOwnProperty("refName"))
				{
					GlobalFunc.SetText(this.refName, "'" + String(resultObj.refName) + "'", false);
				}
				else
				{
					GlobalFunc.SetText(this.refName, "none", false);
				}

				GlobalFunc.SetText(this.refFormType, "type: " + String(resultObj.baseFormType), false);
				GlobalFunc.SetText(this.refFormID, "ID: " + String(resultObj.refFormID), false);
				GlobalFunc.SetText(this.baseFormID, "baseID: " + String(resultObj.baseFormID), false);
				GlobalFunc.SetText(this.refDefineModName, "locate: " + String(resultObj.refDefineModName), false);
				GlobalFunc.SetText(this.baseDefineModName, "define: " + String(resultObj.baseDefineModName), false);
				if(resultObj.hasOwnProperty("baseLastChangeModName"))
          		{
					GlobalFunc.SetText(this.baseLastChangeModName, "lastBaseChange: " + String(resultObj.baseLastChangeModName), false);
           		}
			}
			else
			{
				GlobalFunc.SetText(this.refName, "", false);
				GlobalFunc.SetText(this.refFormType, "", false);
				GlobalFunc.SetText(this.refFormID, "", false);
				GlobalFunc.SetText(this.baseFormID, "", false);
				GlobalFunc.SetText(this.baseDefineModName, "", false);
				GlobalFunc.SetText(this.refDefineModName, "", false);
				GlobalFunc.SetText(this.baseLastChangeModName, "", false);
			}
			if(showExtraInfoWindow)
			{
				var resultArr: Array = root.f4se.plugins.BetterConsole.GetExtraData();
				if(resultArr is Array)
				{
					FirstExtraInfoPanel_mc.List_mc.entryList = resultArr;
					FirstExtraInfoPanel_mc.List_mc.selectedIndex = -1;		 
					FirstExtraInfoPanel_mc.List_mc.InvalidateData();						
					FirstExtraInfoPanel_mc.visible = true;
				}
				else
				{
					FirstExtraInfoPanel_mc.visible = SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
					FirstExtraInfoPanel_mc.List_mc.entryList = SecondExtraInfoPanel_mc.List_mc.entryList = ThirdExtraInfoPanel_mc.List_mc.entryList = null;
					FirstExtraInfoPanel_mc.List_mc.InvalidateData();
					SecondExtraInfoPanel_mc.List_mc.InvalidateData();
					ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
				}
			}
         }
         catch(err:Error)
         {
			trace("Failed to get base data...");
         }
		 
      }
      
      public function set historyCharBufferSize(param1:uint) : *
      {
         this.HistoryCharBufferSize = param1;
      }
      
      public function set historyTextColor(param1:uint) : *
      {
         this.CommandHistory.textColor = param1;
      }
      
      public function set textColor(param1:uint) : *
      {
         this.CommandEntry.textColor = param1;
         this.CurrentSelection.textColor = param1;
      }
      
      public function set textSize(param1:uint) : *
      {
         var _loc2_:TextFormat = null;
		 
         _loc2_ = this.CurrentSelection.defaultTextFormat;
         _loc2_.size = Math.max(1,param1);
         this.CurrentSelection.setTextFormat(_loc2_);
         this.CurrentSelection.defaultTextFormat = _loc2_;
		 
         _loc2_ = this.CommandHistory.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
         this.CommandHistory.setTextFormat(_loc2_);
         this.CommandHistory.defaultTextFormat = _loc2_;
		 
         _loc2_ = this.CommandEntry.defaultTextFormat;
         _loc2_.size = Math.max(1,param1);
         this.CommandEntry.setTextFormat(_loc2_);
         this.CommandEntry.defaultTextFormat = _loc2_;
		 
		 _loc2_ = this.refName.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.refName.setTextFormat(_loc2_);
         this.refName.defaultTextFormat = _loc2_;

         _loc2_ = this.refFormType.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.refFormType.setTextFormat(_loc2_);
         this.refFormType.defaultTextFormat = _loc2_;

         _loc2_ = this.refFormID.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.refFormID.setTextFormat(_loc2_);
         this.refFormID.defaultTextFormat = _loc2_;

         _loc2_ = this.baseFormID.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.baseFormID.setTextFormat(_loc2_);
         this.baseFormID.defaultTextFormat = _loc2_;

         _loc2_ = this.baseDefineModName.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.baseDefineModName.setTextFormat(_loc2_);
         this.baseDefineModName.defaultTextFormat = _loc2_;

         _loc2_ = this.refDefineModName.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.refDefineModName.setTextFormat(_loc2_);
         this.refDefineModName.defaultTextFormat = _loc2_;
		 		
         _loc2_ = this.baseLastChangeModName.defaultTextFormat;
         _loc2_.size = Math.max(1,param1 - 2);
		 _loc2_.align = "right";
         this.baseLastChangeModName.setTextFormat(_loc2_);
         this.baseLastChangeModName.defaultTextFormat = _loc2_;

		 
         this.PositionTextFields();
      }
      
      public function set size(param1:Number) : *
      {
         this.ScreenPercent = param1;
         param1 = param1 / 100;
         this.Background.height = stage.stageHeight * param1 //* 2;
         this.PositionTextFields();
		 
		 this.FirstExtraInfoPanel_mc.y = this.SecondExtraInfoPanel_mc.y = ThirdExtraInfoPanel_mc.y = 10 - stage.stageHeight;
		 this.FirstExtraInfoPanel_mc.height = this.SecondExtraInfoPanel_mc.height = this.ThirdExtraInfoPanel_mc.height = stage.stageHeight - Background.height - 10;
		 this.FirstExtraInfoPanel_mc.width = this.SecondExtraInfoPanel_mc.width = this.ThirdExtraInfoPanel_mc.width = FirstExtraInfoPanel_mc.height / 2;
		
		 this.SecondExtraInfoPanel_mc.x = this.FirstExtraInfoPanel_mc.x + this.FirstExtraInfoPanel_mc.width * 1.05;
		 this.ThirdExtraInfoPanel_mc.x = this.SecondExtraInfoPanel_mc.x + this.SecondExtraInfoPanel_mc.width * 1.05;	

      }
      
      public function PositionTextFields() : *  
      {
         this.CurrentSelection.y = this.CurrentSelectionYOffset - this.Background.height;
         this.CommandHistory.y = this.CurrentSelection.y + this.CurrentSelection.height;
         this.CommandHistory.height = this.CommandEntry.y - this.CommandHistory.y;
		 
 		 baseLastChangeModName.height = baseDefineModName.height = refDefineModName.height = baseFormID.height = refFormID.height = refFormType.height = refName.height =  stage.stageHeight / 28;
		 this.refName.y = this.CurrentSelection.y + this.CurrentSelection.height;
		 this.refFormType.y = this.refName.y + this.refName.height * 1.1;
		 this.refFormID.y = this.refFormType.y + this.refFormType.height * 1.1;
		 this.baseFormID.y = this.refFormID.y + this.refFormID.height * 1.1;
		 this.refDefineModName.y = this.baseFormID.y + this.baseFormID.height * 1.1;		
		 this.baseDefineModName.y = this.refDefineModName.y + this.refDefineModName.height * 1.1;		
		 this.baseLastChangeModName.y = this.baseDefineModName.y + this.baseDefineModName.height * 1.1;		

      }
      
      public function Show() : *
      {
         if(!this.Animating)
         {
            parent.y = this.OriginalHeight;
            (parent as MovieClip).gotoAndPlay("show_anim");
            stage.focus = this.CommandEntry;
            this.Animating = true;
            this.CommandEntry.setSelection(this.CommandEntry.length,this.CommandEntry.length);
         }
      }
      
      public function ShowComplete() : *
      {
         this.Shown = true;
         this.Animating = false;
      }
      
      public function Hide() : *
      {
         if(!this.Animating)
         {
            (parent as MovieClip).gotoAndPlay("hide_anim");
            stage.focus = null;
            this.ResetCommandEntry();
            this.Animating = true;
            this.Hiding = true;
         }
      }
      
      public function HideComplete() : *
      {
         this.Shown = false;
         this.Animating = false;
         this.Hiding = false;
         this.BGSCodeObj.onHideComplete();
      }
      
      public function Minimize() : *
      {
         parent.y = this.OriginalHeight - this.CommandHistory.y;
      }
      
      public function PreviousCommand() : *
      {
         if(this.PreviousCommandOffset < this.Commands.length)
         {
            this.PreviousCommandOffset++;
         }
         if(0 != this.Commands.length && 0 != this.PreviousCommandOffset)
         {
            GlobalFunc.SetText(this.CommandEntry,this.Commands[this.Commands.length - this.PreviousCommandOffset],false);
            this.CommandEntry.setSelection(this.CommandEntry.length,this.CommandEntry.length);
         }
      }
      
      public function NextCommand() : *
      {
         if(this.PreviousCommandOffset > 1)
         {
            this.PreviousCommandOffset--;
         }
         if(0 != this.Commands.length && 0 != this.PreviousCommandOffset)
         {
            GlobalFunc.SetText(this.CommandEntry,this.Commands[this.Commands.length - this.PreviousCommandOffset],false);
            this.CommandEntry.setSelection(this.CommandEntry.length,this.CommandEntry.length);
         }
      }
      
      public function AddHistory(param1:String) : *
      {
         GlobalFunc.SetText(this.CommandHistory,this.CommandHistory.text + param1,false);
         if(this.CommandHistory.text.length > this.HistoryCharBufferSize)
         {
            GlobalFunc.SetText(this.CommandHistory,this.CommandHistory.text.substr(-this.HistoryCharBufferSize),false);
         }
         this.CommandHistory.scrollV = this.CommandHistory.maxScrollV;
      }
      
      public function SetCommandPrompt(param1:String) : *
      {
         GlobalFunc.SetText(this.CommandPrompt_tf,param1,false);
         this.CommandEntry.x = this.CommandPrompt_tf.x + this.CommandPrompt_tf.getLineMetrics(0).width + 10;
      }
      
      public function ClearHistory() : *
      {
         this.CommandHistory.text = "";
      }
      
      public function ResetCommandEntry() : *
      {
         this.CommandEntry.text = "";
         this.PreviousCommandOffset = 0;
      }
      
      public function onKeyUp(param1:KeyboardEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NUMPAD_ENTER)
         {
            if(this.Commands.length >= this.PREVIOUS_COMMANDS)
            {
               this.Commands.shift();
            }
            this.Commands.push(this.CommandEntry.text);
			try
			{
				this.BGSCodeObj.executeCommand(this.CommandEntry.text);
            	this.ResetCommandEntry();
				root.f4se.plugins.BetterConsole.WriteLog("Execute command.");		
			}
			catch(e:Error)
			{
				trace("Failed to write log.");
			}
         }
         else if(param1.keyCode == Keyboard.PAGE_UP)
         {
            _loc2_ = this.CommandHistory.bottomScrollV - this.CommandHistory.scrollV;
            _loc3_ = this.CommandHistory.scrollV - _loc2_;
            this.CommandHistory.scrollV = _loc3_ > 0?int(_loc3_):0;
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN)
         {
            _loc2_ = this.CommandHistory.bottomScrollV - this.CommandHistory.scrollV;
            _loc3_ = this.CommandHistory.scrollV + _loc2_;
            this.CommandHistory.scrollV = _loc3_ <= this.CommandHistory.maxScrollV?int(_loc3_):int(this.CommandHistory.maxScrollV);
			trace("page down key is pressed...");
         }
		 else if(param1.keyCode == Keyboard.SHIFT)
		 {
			 showExtraInfoWindow = !showExtraInfoWindow;
			 if(showExtraInfoWindow)
			 {
					try
					{
						var resultArr: Array = root.f4se.plugins.BetterConsole.GetExtraData();
						if(resultArr is Array)
						{
							SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
							SecondExtraInfoPanel_mc.List_mc.entryList = ThirdExtraInfoPanel_mc.List_mc.entryList = null;
							FirstExtraInfoPanel_mc.List_mc.entryList = resultArr;
							FirstExtraInfoPanel_mc.List_mc.selectedIndex = -1;		 
							FirstExtraInfoPanel_mc.List_mc.InvalidateData();						
							SecondExtraInfoPanel_mc.List_mc.InvalidateData();
							ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
							FirstExtraInfoPanel_mc.visible = true;
						}
						else
						{
							FirstExtraInfoPanel_mc.visible = SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
							FirstExtraInfoPanel_mc.List_mc.entryList = SecondExtraInfoPanel_mc.List_mc.entryList = ThirdExtraInfoPanel_mc.List_mc.entryList = null;
							FirstExtraInfoPanel_mc.List_mc.InvalidateData();
							SecondExtraInfoPanel_mc.List_mc.InvalidateData();
							ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
						}
					}
					catch(e:Error)
					{
						trace("Failed.");
					}
			 }
			 else
			 {
				  FirstExtraInfoPanel_mc.visible = SecondExtraInfoPanel_mc.visible = ThirdExtraInfoPanel_mc.visible = false;
				  FirstExtraInfoPanel_mc.List_mc.entryList = SecondExtraInfoPanel_mc.List_mc.entryList = ThirdExtraInfoPanel_mc.List_mc.entryList = null;
				  FirstExtraInfoPanel_mc.List_mc.InvalidateData();
				  SecondExtraInfoPanel_mc.List_mc.InvalidateData();
				  ThirdExtraInfoPanel_mc.List_mc.InvalidateData();
			 } 
		 }
      }
      
      public function onResize() : *
      {
        this.Background.width = stage.stageWidth;
        this.CommandEntry.width = this.CommandHistory.width = this.CurrentSelection.width = stage.stageWidth - this.TextXOffset * 2;
		this.refName.x = stage.stageWidth - this.refName.width - this.CommandPrompt_tf.x;
		this.refFormType.x = stage.stageWidth - this.refFormType.width - this.CommandPrompt_tf.x;
		this.refFormID.x = stage.stageWidth - this.refFormID.width - this.CommandPrompt_tf.x;
		this.baseFormID.x = stage.stageWidth - this.baseFormID.width - this.CommandPrompt_tf.x;
		this.refDefineModName.x = stage.stageWidth - this.refDefineModName.width - this.CommandPrompt_tf.x;	
		this.baseDefineModName.x = stage.stageWidth - this.baseDefineModName.width - this.CommandPrompt_tf.x;	
		this.baseLastChangeModName.x = stage.stageWidth - this.baseLastChangeModName.width - this.CommandPrompt_tf.x;
		 
        this.size = this.ScreenPercent;
      }
   }
}

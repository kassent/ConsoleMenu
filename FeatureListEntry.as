package 
{
	import Shared.AS3.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class FeatureListEntry extends Shared.AS3.BSScrollingListEntry
	{
		public function FeatureListEntry()
		{
			super();
			return;
		}

		public override function SetEntryText(arg1:Object, arg2:String):*
		{
			super.SetEntryText(arg1, arg2);
			this.EquipIcon_mc.visible = arg1.applied;
			var loc1:*=this.EquipIcon_mc.transform.colorTransform;
			loc1.redOffset = this.selected ? -255 : 0;
			loc1.greenOffset = this.selected ? -255 : 0;
			loc1.blueOffset = this.selected ? -255 : 0;
			this.EquipIcon_mc.transform.colorTransform = loc1;
			return;
		}

		public var EquipIcon_mc:flash.display.MovieClip;
	}
}

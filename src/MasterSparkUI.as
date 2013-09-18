/**
 * MasterSpark UI (MonoUI 2)
 * 2013-05-13
 */
package
{	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import test.*;
	
	[SWF(width="640", height="480", backgroundColor="0xffffff", frameRate="30")]
	
	public class MasterSparkUI extends Sprite
	{
		public function MasterSparkUI()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//this.addChild(new TestButton());
			//this.addChild(new TestTextInput());
			//this.addChild(new TestToggle());
			this.addChild(new TestToggleGroup());
		}
	}
}
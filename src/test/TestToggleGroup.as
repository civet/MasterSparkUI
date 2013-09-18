package test
{
	import com.dreamana.controls.*;
	import com.dreamana.controls.skins.*;
	import com.dreamana.gui.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class TestToggleGroup extends Sprite
	{		
		public function TestToggleGroup()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var group:ToggleGroup = new ToggleGroup();
			
			var item:Toggle;
			var label:Label;
			var numItems:int = 3;
			for(var i:int=0; i < numItems; ++i)
			{
				item = new Toggle();
				//item.skin = new CheckBoxSkin();
				item.x = i * 100;
				
				this.addChild(item);
								
				group.addItem(item);
				
				label = new Label("Choice " + (i+1));
				label.x = 100 - label.width >> 1;
				item.addChild(label);
			}
			
			group.addEventListener(Event.SELECT, onItemSelect);
			group.selectedIndex = 0;
		}
		
		private function onItemSelect(event:Event):void
		{
			var group:ToggleGroup = event.currentTarget as ToggleGroup;
			
			trace(group.selectedIndex);
		}	
	}
}
package test
{
	import com.dreamana.controls.*;
	import com.dreamana.controls.skins.*;
	import com.dreamana.gui.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class TestToggleGroup extends Sprite
	{		
		private var group:ToggleGroup;
		
		public function TestToggleGroup()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			group = new ToggleGroup();
			
			var item:Toggle;
			var label:Label;
			var numItems:int = 3;
			for(var i:int=0; i < numItems; ++i)
			{
				item = new Toggle();
				item.skin = new CheckBoxSkin();
				item.x = i * 100;
				
				this.addChild(item);
								
				group.addItem(item);
				
				label = new Label("Choice " + (i+1));
				label.x = 100 - label.width >> 1;
				item.addChild(label);
			}
			
			group.addEventListener(Event.SELECT, onItemSelect);
			group.selectedIndex = 0;
			
			group.addEventListener(Event.CHANGE, onItemChange);
			
			
			//toolbar
			var btn:Button;
			
			btn = new Button();
			btn.name = "buttonEnabler";
			btn.addChild(new Label("Disabled/Enabled"));
			btn.x = 540;
			btn.y = 0;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onItemSelect(event:Event):void
		{
			var group:ToggleGroup = event.currentTarget as ToggleGroup;
			
			//trace("selected: " + group.selectedIndex);
		}
		
		private function onItemChange(event:Event):void
		{
			var group:ToggleGroup = event.currentTarget as ToggleGroup;
			
			trace("changed: " + group.selectedIndex);
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			switch(event.currentTarget.name)
			{
				case "buttonEnabler":
					group.enabled = !group.enabled;
					break;
				
			}
		}
	}
}
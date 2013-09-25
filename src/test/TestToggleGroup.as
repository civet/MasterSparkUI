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
				//item.skin = new CheckBoxSkin();
				item.x = i * 100;
				
				this.addChild(item);
								
				group.addItem(item);
				
				label = new Label("Choice " + (i+1));
				label.x = 100 - label.width >> 1;
				item.addChild(label);
			}
			
			group.addEventListener(Event.SELECT, onItemSelect);
			group.addEventListener(Event.CHANGE, onItemChange);
			
			group.multiselectable = false;
			group.deselectable = true;
			group.selectedIndex = 1;
			
			
			//toolbar
			var btn:Button;
			var tgl:Toggle;
			
			tgl = new Toggle();
			tgl.name = "buttonEnabler";
			tgl.addChild(new Label("Disabled"));
			tgl.x = 540;
			tgl.y = 0;
			this.addChild(tgl);
			tgl.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			tgl = new Toggle();
			tgl.name = "buttonDeselect";
			tgl.addChild(new Label("Deselectable"));
			tgl.x = 540;
			tgl.y = 30;
			this.addChild(tgl);
			tgl.addEventListener(MouseEvent.CLICK, onButtonClick);
			tgl.selected = true;
			
			tgl = new Toggle();
			tgl.name = "buttonMultiselect";
			tgl.addChild(new Label("MultiSelectable"));
			tgl.x = 540;
			tgl.y = 60;
			this.addChild(tgl);
			tgl.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonSkin";
			btn.addChild(new Label("Change Skin"));
			btn.x = 540;
			btn.y = 90;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onItemSelect(event:Event):void
		{
			var group:ToggleGroup = event.currentTarget as ToggleGroup;
			
			trace("selectedIndex: " + group.selectedIndex
				+ ", selectedIndices: " + group.selectedIndices);
		}
		
		private function onItemChange(event:Event):void
		{
			var group:ToggleGroup = event.currentTarget as ToggleGroup;
			
			trace("changed to: " + group.selectedIndex);
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			var target:Object = event.currentTarget;
			
			switch(event.currentTarget.name)
			{
				case "buttonEnabler":
					group.enabled = !Toggle(target).selected;
					break;
				
				case "buttonDeselect":
					group.deselectable = Toggle(target).selected;
					break;
				
				case "buttonMultiselect":
					group.multiselectable = Toggle(target).selected;
					break;
				
				case "buttonSkin":
					var numItems:int = group.numItems;
					for(var i:int=0; i < numItems; ++i)
					{
						var item:Toggle = group.getItem(i);
						if(item.skin is ToggleButtonSkin) {
							item.skin = new CheckBoxSkin();
						}
						else {
							item.skin = new ToggleButtonSkin();
						}
					}
					break;
			}
		}
	}
}
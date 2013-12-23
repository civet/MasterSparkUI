package test
{
	import com.dreamana.controls.List;
	import com.dreamana.controls.Scroller;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestList extends Sprite
	{
		public function TestList()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var data:Array = [
				{label:"Item 1", data:0},
				{label:"Item 2", data:1},
				{label:"Item 3", data:2},
				{label:"Item 4", data:3},
				{label:"Item 5", data:4},
				{label:"Item 6", data:5}
			];
			
			var list:List = new List();
			list.data = data;
			this.addChild(list);
			list.setItemRenderer(CustomListItem);
			//list.enabled = false;
			
			var scroller:Scroller = new Scroller();
			scroller.container.addChild(list);
			scroller.setSize(200, 200);
			scroller.dragDogear = true;
			scroller.autoHideScrollBar = true;
			this.addChild(scroller);
			//scroller.enabled = false;
		}
		
	}
}

import com.dreamana.controls.ListItem;

class CustomListItem extends ListItem
{
	public function CustomListItem()
	{
		super();
		
		this.setSize(200, 40);
	}
}
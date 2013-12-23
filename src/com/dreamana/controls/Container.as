package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class Container extends UIComponent
	{
		public function Container()
		{
			this.addEventListener(Event.ADDED, onAdded);
			this.addEventListener(Event.REMOVED, onRemoved);
		}
		
		protected function updateSize():void
		{
			var w:int = 0;//bug fixed
			var h:int = 0;//bug fixed
			var num:int = this.numChildren;
			for(var i:int = 0; i < num; ++i) {
				var child:DisplayObject = this.getChildAt(i);
				
				if(child.width > w) w = child.width;
				if(child.height > h) h = child.height;
			}
			
			this.setSize(w, h);
		}
		
		//--- Event Handlers ---
				
		protected function onAdded(event:Event):void
		{
			if(event.target == this) return;
			
			//updateSize();
			var w:int = _width;
			var h:int = _height;
			var child:DisplayObject = event.target as DisplayObject;
			if(child) {
				if(child.width > w) w = child.width;
				if(child.height > h) h = child.height;
				
				this.setSize(w, h);
			}
			
			var comp:UIComponent = event.target as UIComponent;
			if(comp) comp.addEventListener(Event.RESIZE, onChildResize);
		}
		
		protected function onRemoved(event:Event):void
		{
			if(event.target == this) return;
			
			updateSize();
			
			var comp:UIComponent = event.target as UIComponent;
			if(comp) comp.removeEventListener(Event.RESIZE, onChildResize);
		}
		
		protected function onChildResize(event:Event):void
		{
			updateSize();
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
		
			//set children enabled | disabled state
			var i:int = this.numChildren;
			while(i--) {
				var content:Object = this.getChildAt(i);
				if(content && content.hasOwnProperty("enabled")) content["enabled"] = value;
			}
		}
	}
}
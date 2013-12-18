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
		
		/*
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var child:DisplayObject = super.addChild(child);
			applyChange();
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var child:DisplayObject = super.addChildAt(child, index);
			applyChange();
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var child:DisplayObject = super.removeChild(child);
			applyChange();
			
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			applyChange();
			
			return child;
		}*/
		
		/* buggy: cause deferred rendering 
		protected function applyChange():void
		{
			//update size
			var bounds:Rectangle = this.getBounds( this.parent );
			_width = bounds.width;
			_height = bounds.height;
			
			//trace(_width, _height);
			
			//notify change
			if(this.hasEventListener(Event.CHANGE)) this.dispatchEvent(new Event(Event.CHANGE));
		}*/
		
		protected function updateSize():void
		{
			var w:int = _width;
			var h:int = _height;
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
		}
		
		protected function onRemoved(event:Event):void
		{
			if(event.target == this) return;
			
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
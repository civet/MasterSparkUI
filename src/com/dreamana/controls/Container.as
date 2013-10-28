package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class Container extends UIComponent
	{
		
		public function Container()
		{
			super();
		}
		
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
		}
		
		protected function applyChange():void
		{
			//update size
			var bounds:Rectangle = this.getBounds( this.parent );
			_width = bounds.width;
			_height = bounds.height;
			
			//notify change
			if(this.hasEventListener(Event.CHANGE)) this.dispatchEvent(new Event(Event.CHANGE));
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
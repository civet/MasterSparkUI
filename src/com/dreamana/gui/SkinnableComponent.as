package com.dreamana.gui
{
	import com.dreamana.utils.OrderedObject;
	
	import flash.display.DisplayObject;

	public class SkinnableComponent extends UIComponent
	{
		protected var _skinClass:Class;
		protected var _skin:UISkin;
		
		
		public function SkinnableComponent()
		{
			
		}
		
		protected function addChildren():void
		{
			if(_skinClass) _skin = new _skinClass();
			
			this.attachSkin();
		}
		
		protected function attachSkin( startIndex:int=0 ):void
		{
			if(!_skin) return;
				
			//reset skin size
			_skin.setSize(_width, _height);
			
			//reset skin state
			_skin.state = _state;
			
			//this.addChild(_skin);
			//CHANGED: in order to simplify displaylist, add each part as child
			
			var index:int = startIndex;
			var elements:Object = _skin.elements;
			for(var key:String in elements)
			{
				var part:DisplayObject = elements[key];
				if(part) {
					this.addChildAt(part, index);
					index++;
					
					partAdded(key, part);
				}
			}
		}
		
		protected function detachSkin():void
		{
			if(!_skin) return;
			
			//if(this.contains(_skin)) this.removeChild(_skin);
						
			var elements:Object = _skin.elements;
			for(var key:String in elements)
			{
				var part:DisplayObject = elements[key];
				if(part) {
					if(this.contains(part)) this.removeChild(part);
					
					partRemoved(key, part);
				}
			}
		}
		
		protected function partAdded(partName:String, instance:Object):void
		{
			//Overriden in subclasses
		}
		
		protected function partRemoved(partName:String, instance:Object):void
		{
			//Overriden in subclasses
		}
		
		override public function adjustSize():void
		{
			_skin.setSize(_width, _height);
			
			super.adjustSize();
		}
		
		//--- Getter/Setters ---
		
		override public function set state(value:String):void
		{
			super.state = value;
			
			if(_skin) _skin.state = value;
		}
		
		public function get skin():UISkin { return _skin; }
		public function set skin(value:UISkin):void {
			
			var startIndex:int = 0;
			var part:DisplayObject = _skin.getPartByIndex(0) as DisplayObject;
			if(this.contains(part)) startIndex = this.getChildIndex(part);
			
			detachSkin();
			
			_skin = value;
			attachSkin( startIndex );
		}
	}
}
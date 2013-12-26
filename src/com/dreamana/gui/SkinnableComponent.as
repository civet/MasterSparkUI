package com.dreamana.gui
{
	import com.dreamana.utils.OrderedObject;
	
	import flash.display.DisplayObject;
	
	/**
	 * Skinnable GUI Component
	 * 
	 * @author civet (dreamana.com)
	 */	
	public class SkinnableComponent extends UIComponent
	{
		protected var _skin:UISkin;
		protected var _skinClass:Class;
		protected var _skinProps:Object;
		
		
		public function SkinnableComponent()
		{
			//set skin class and state
			
			//add skin
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
			
			//reset skin drawing props
			_skin.setDrawingProps(_skinProps);
			
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
		
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			if(_skin) _skin.setSize(w, h, deferred);
			
			super.setSize(w, h, deferred);
		}
		
		protected function updateSkinProps():void
		{			
			if(_skin) _skin.setDrawingProps( _skinProps );
		}
				
		//--- Getter/Setters ---
		
		public function get skin():UISkin { return _skin; }
		public function set skin(value:UISkin):void {
			
			var startIndex:int = 0;
			var part:DisplayObject = _skin.getPartByIndex(0) as DisplayObject;
			if(part && this.contains(part)) startIndex = this.getChildIndex(part);
			
			detachSkin();
			
			_skin = value;
			attachSkin( startIndex );
		}
	}
}
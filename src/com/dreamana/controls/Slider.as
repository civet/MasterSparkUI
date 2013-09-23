package com.dreamana.controls
{
	import com.dreamana.controls.skins.SliderSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class Slider extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DISABLED:String = "disabled";
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		protected var _value:Number = 0.0;
		protected var _orientation:String;
		protected var _mouseState:String;
		
		protected var _track:Sprite;
		protected var _handle:Sprite;
		
		
		public function Slider()
		{
			//default setting
			_width = 100;
			_height = 20;
			_mouseState = STATE_NORMAL;
			_orientation = HORIZONTAL;
			_skinState = _mouseState + "|" + _orientation;
			_skinClass = SliderSkin;
			
			//view
			this.addChildren();
		}
		
		override public function adjustSize():void
		{
			super.adjustSize();
			
			//BUG 1 FIXED
			_skin.redraw();
			positionHandle();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "handle") {
				_handle = instance as Sprite;
				_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			
				//BUG 1 FIXED
				_skin.redraw();
				positionHandle();
			}			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(partName == "handle") {
				_handle = instance as Sprite;
				_handle.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
		}
		
		//--- Event Handlers ---
		
		protected var _draggableBounce:Rectangle = new Rectangle();
		
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			
			if(_orientation == HORIZONTAL) {
				_draggableBounce.width = _width - _handle.width;
				_draggableBounce.height = 0;
			}
			else {
				_draggableBounce.width = 0;
				_draggableBounce.height = _height - _handle.height;
			}
			
			_handle.startDrag(false, _draggableBounce);
		}
		
		protected function onDrop(event:MouseEvent):void
		{
			if(stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			}
			
			stopDrag();
		}
		
		protected function onSlide(event:MouseEvent):void
		{
			if(_orientation == HORIZONTAL) {
				_value = _handle.x / (_width - _handle.width);
			}
			else {
				_value = _handle.y / (_height - _handle.height);
			}
			
			//dispatch
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		//--- Private Method ---
		
		override protected function changeState(mouseState:String):void
		{
			_mouseState = mouseState;
			
			_skinState = _mouseState + "|" + _orientation;
			
			if(_skin) _skin.state = _skinState;
		}
		
		protected function positionHandle():void
		{
			if(!_handle) return;
			
			if(_orientation == HORIZONTAL) {
				_handle.x = Math.round( (_width - _handle.width) * value );
				_handle.y = 0;
			}
			else {
				_handle.x = 0;
				_handle.y =  Math.round( (_height - _handle.height) * value );
			}
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled(up) | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
		
		public function get value():Number { return _value; }
		public function set value(value:Number):void
		{
			_value = value;
			
			//set handle position
			//BUG 1: the size of handle is 0 when init
			positionHandle();
		}
				
		public function get orientation():String { return _orientation; }
		public function set orientation(value:String):void
		{
			//if changed..
			if(_orientation != value) {
				_orientation = value;
				
				//swap
				var w:int = _width;
				var h:int = _height;
				this.setSize(h, w);
				
				_skinState = _mouseState + "|" + _orientation;
								
				if(_skin) _skin.state = _skinState;
			}
		}
		
	}
}
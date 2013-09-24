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
		
		protected var _track:Sprite;
		protected var _handle:Sprite;
		protected var _handleWidth:int;
		protected var _handleHeight:int;
				
		
		public function Slider()
		{
			//default setting
			_width = 100;
			_height = 20;
			_handleWidth = 20;
			_handleHeight = 20;
			_orientation = HORIZONTAL;
			_skinProps = {
				state: STATE_NORMAL, 
				orientation: _orientation,
				handleWidth: _handleWidth,
				handleHeight: _handleHeight
			};
			_skinClass = SliderSkin;
			
			//view
			this.addChildren();
		}
		
		/* HACK */		
		override public function adjustSize():void
		{
			if(_orientation == Slider.HORIZONTAL) {
				_handleWidth = _height;
				_handleHeight = _height;
			}
			else {
				_handleWidth = _width;
				_handleHeight = _width;
			}
			_skinProps["handleWidth"] = _handleWidth;
			_skinProps["handleHeight"] = _handleHeight;
						
			super.adjustSize();
			
			positionHandle();		
		}
				
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "handle") {
				_handle = instance as Sprite;
				_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
				
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
		
		protected function changeState(state:String):void
		{
			_skinProps["state"] = state;
			this.updateSkinProps();
		}
		
		protected function changeOrientation(orientation:String):void
		{
			_skinProps["orientation"] = orientation;
			this.updateSkinProps();
		}
		
		protected function changeHandleSize():void
		{
			_skinProps["handleWidth"] = _handleWidth;
			_skinProps["handleHeight"] = _handleHeight;
			this.updateSkinProps();
		}
		
		protected function positionHandle():void
		{
			if(!_handle) return;
			
			if(_orientation == HORIZONTAL) {
				_handle.x = Math.round( (_width - _handleWidth) * value );
				_handle.y = 0;
			}
			else {
				_handle.x = 0;
				_handle.y =  Math.round( (_height - _handleHeight) * value );
			}
		}
		
		//--- Event Handlers ---
		
		protected var _draggableBounce:Rectangle = new Rectangle();
		
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			
			if(_orientation == HORIZONTAL) {
				_draggableBounce.width = _width - _handleWidth;
				_draggableBounce.height = 0;
			}
			else {
				_draggableBounce.width = 0;
				_draggableBounce.height = _height - _handleHeight;
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
			var v:Number = _value;
			
			if(_orientation == HORIZONTAL) {
				_value = _handle.x / (_width - _handleWidth);
			}
			else {
				_value = _handle.y / (_height - _handleHeight);
			}
			
			//dispatch
			if(_value != v) this.dispatchEvent(new Event(Event.CHANGE));
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
			
			positionHandle();
		}
				
		public function get orientation():String { return _orientation; }
		public function set orientation(value:String):void
		{
			//if changed..
			if(_orientation != value) {
				_orientation = value;
				
				//swap width & height
				var w:int = _width;
				var h:int = _height;
				setSize(h, w);
				
				//update handle size
				if(_orientation == Slider.HORIZONTAL) {
					_handleWidth = _height;
					_handleHeight = _height;
				}
				else {
					_handleWidth = _width;
					_handleHeight = _width;
				}
				changeHandleSize();
				
				//apply orientation
				changeOrientation(_orientation);
			}
		}
		
	}
}
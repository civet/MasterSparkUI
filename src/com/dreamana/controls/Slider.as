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
		protected var _percent:Number = 0.0;
		
		protected var _track:Sprite;
		protected var _handle:Sprite;
		
		protected var _orientation:String;
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
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			super.setSize(w, h, deferred);
			
			//calculate handle size
			var minLength:int;
			var length:int, thickness:int;
			if(_orientation == Slider.HORIZONTAL) {
				
				thickness = _height;
				minLength = _height;
				length = Math.max(minLength, _width * _percent);
				
				changeHandleSize(length, thickness);
			}
			else {
				
				thickness = _width;
				minLength = _width;
				length = Math.max(minLength, _height * _percent);
				
				changeHandleSize(thickness, length);
			}
			
			//reset handle position
			positionHandle();
		}
				
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "handle") {
				_handle = instance as Sprite;
				_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
				
				//set handle position
				positionHandle();
			}
			else if(partName == "track") {
				_track = instance as Sprite;
				if(_trackClickEnabled) _track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackClick);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(partName == "handle") {
				_handle = instance as Sprite;
				_handle.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
			else if(partName == "track") {
				_track = instance as Sprite;
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackClick);
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
		
		protected function changeHandleSize(w:int, h:int):void
		{
			_handleWidth = w;
			_handleHeight = h;
			
			_skinProps["handleWidth"] = w;
			_skinProps["handleHeight"] = h;
			
			this.updateSkinProps();
		}
		
		protected function positionHandle():void
		{
			if(!_handle) return;
			
			if(_orientation == HORIZONTAL) {
				_handle.x = Math.round( (_width - _handleWidth) * _value );
				_handle.y = 0;
			}
			else {
				_handle.x = 0;
				_handle.y = Math.round( (_height - _handleHeight) * (1.0 - _value) );
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
				_value = 1.0 - _handle.y / (_height - _handleHeight);
			}
						
			if(isNaN(_value)) { _value = v; return; }//Bug fix: NaN != NaN always evaluates to true.
						
			//dispatch
			if(_value != v) this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onTrackClick(event:MouseEvent):void
		{
			var v:Number = _value;
			
			var mx:int = event.localX;
			var my:int = event.localY;
						
			if(_orientation == HORIZONTAL) {
				var px:Number = Math.max(Math.min(mx - _handleWidth * .5, _width - _handleWidth), 0);
				_handle.x = Math.round(px);
				_value = _handle.x / (_width - _handleWidth);
			}
			else {
				var py:Number = Math.max(Math.min(my - _handleHeight * .5, _height - _handleHeight), 0);
				_handle.y = Math.round(py);
				_value = 1.0 - _handle.y / (_height - _handleHeight);
			}
			
			if(isNaN(_value)) { _value = v; return; }//Bug fix: NaN != NaN always evaluates to true.
			
			//dispatch
			if(_value != v) this.dispatchEvent(new Event(Event.CHANGE));
			
			//onDrag(null);
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
		
		public function get value():Number { return _value; }
		public function set value(v:Number):void
		{
			_value = v;
			
			//set handle position
			positionHandle();
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			
			//update size
			this.setSize(_width, _height);	
		}
				
		public function get orientation():String { return _orientation; }
		public function set orientation(value:String):void
		{
			//if changed..
			if(_orientation != value) {
				_orientation = value;
				
				//swap width & height
				var w:int, h:int;
				w = _width;
				h = _height;
				setSize(h, w);
				
				//swap width & height of handle
				//w = _handleWidth;
				//h = _handleHeight;
				//changeHandleSize(h, w);
				
				//new orientation
				changeOrientation(_orientation);
			}
		}
		
		protected var _trackClickEnabled:Boolean;
		
		public function get trackClickEnabled():Boolean { return _trackClickEnabled; }
		public function set trackClickEnabled(value:Boolean):void
		{
			_trackClickEnabled = value;
			
			if(_track && _trackClickEnabled)
				_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackClick);
			else 
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackClick);
		}
	}
}
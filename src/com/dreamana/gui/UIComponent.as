package com.dreamana.gui
{
	import com.dreamana.utils.Broadcaster;
	import com.dreamana.utils.EnterFrameDispatcher;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="resize", type="flash.events.Event")]
	
	/**
	 * Base Class of MasterSpark GUI Component
	 * 
	 * inspired by MinimalComps (https://github.com/minimalcomps)
	 * 
	 * @author civet (dreamana.com)
	 */
	public class UIComponent extends Sprite
	{
		protected static var enterFrameDispatcher:EnterFrameDispatcher = new EnterFrameDispatcher();//holder, avoid GC.
		protected static var enterFrame:Broadcaster = enterFrameDispatcher.enterFrame;
		
		protected var _x:int = 0;
		protected var _y:int = 0;
		protected var _positionChanged:Boolean = false;
		
		protected var _width:int = 0;
		protected var _height:int = 0;
		protected var _sizeChanged:Boolean = false;
		
		protected var _isDirty:Boolean = false;
		
		protected var _enabled:Boolean = true;
				
		
		public function UIComponent()
		{
		}
				
		//--- Public Methods ---		
		
		/**
		 * Set the position of the component.
		 * @param px		The x of the component.
		 * @param py		The y of the component.
		 * @param deferred	Use Deferred Rendering or not.
		 */
		public function setPosition(px:Number, py:Number, deferred:Boolean=true):void
		{
			_positionChanged = (_x != px || _y != py);
			
			//pixel-aligned (pixel perfect)
			_x = Math.round(px);
			_y = Math.round(py);
			
			deferred ? invalidate(false) : update();
		}
		
		/**
		 * Set the size of the component.
		 * @param w			The width of the component.
		 * @param h			The height of the component.
		 * @param deferred	Use Deferred Rendering or not.
		 */
		public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			_sizeChanged = (_width != w || _height != h);
			
			_width = w;
			_height = h;
						
			if(deferred) {
				invalidate(_sizeChanged);
			}
			else {
				//BUG FIXED
				if(!_isDirty && _sizeChanged) _isDirty = true;
				
				update();
			}
		}
								
		//--- Rendering Methods ---
		
		/**
		 * Update on the next frame (Deferred Rendering).
		 * @dirty
		 */		
		public function invalidate(dirty:Boolean=true):void
		{
			//BUG FIXED: once isDirty is setted true, do not change it until redraw. 
			if(!_isDirty && dirty) _isDirty = true;
			
			//this.addEventListener(Event.ENTER_FRAME, onInvalidate);
			enterFrame.add(update, true);
		}
		
		/**
		 * Update
		 */
		public function update():void
		{
			//this.removeEventListener(Event.ENTER_FRAME, onInvalidate);
			
			//call only when position changed
			if(_positionChanged) {
				_positionChanged = false;
				super.x = _x;
				super.y = _y;
			}
					
			//call only when size changed
			if(_sizeChanged) {
				_sizeChanged = false;
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			
			//call if dirty
			if(_isDirty) {
				_isDirty = false;
				redraw();
			}
		}
		
		/**
		 * Redraw
		 */
		protected function redraw():void
		{
			//Overriden in subclasses
		}
				
		//--- Getter/setters ---
		
		/* pixel-aligned (pixel perfect) */
		override public function set x(value:Number):void {
			super.x = Math.round(value);
		}
		override public function set y(value:Number):void {
			super.y = Math.round(value);
		}
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			setSize(value, _height);
		}
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			setSize(_width, value);
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			_enabled = value;
			
			this.mouseEnabled = _enabled;
			this.mouseChildren = _enabled;
			this.tabEnabled = _enabled;
		}
	}
}
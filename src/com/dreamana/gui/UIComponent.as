package com.dreamana.gui
{
	import com.dreamana.utils.Broadcaster;
	import com.dreamana.utils.EnterFrameDispatcher;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="resize", type="flash.events.Event")]
	
	/**
	 * Base Class of MasterSpark GUI Component
	 * @author civet (dreamana.com)
	 * 
	 * based on MinimalComps' Component Class (https://github.com/minimalcomps) 
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
		
		protected var _enabled:Boolean = true;
				
		
		public function UIComponent()
		{
		}
				
		//--- Public Methods ---		
		
		/**
		 * Overriden in subclasses
		 */
		public function adjustSize():void
		{
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Overriden in subclasses
		 */
		public function redraw():void
		{
			
		}
		
		/**
		 * Dirty, need redraw on next frame.
		 */		
		public function invalidate():void
		{
			//this.addEventListener(Event.ENTER_FRAME, onInvalidate);
			enterFrame.add(onInvalidate, true);
		}
		
		/**
		 * Sets the component to the specified position. (directly)
		 * @param px The x position to place the component.
		 * @param py The y position to place the component.
		 */
		public function setPosition(px:Number, py:Number):void
		{
			_x = Math.round(px);
			_y = Math.round(py);
			
			super.x = _x;
			super.x = _y;
		}
		
		/**
		 * Sets the component position. (deferred)
		 * @param px
		 * @param py
		 */		
		public function setPosition2(px:Number, py:Number):void
		{
			_x = Math.round(px);
			_y = Math.round(py);
			
			_positionChanged = true;
			invalidate();
		}
		
		/**
		 * Sets the size of the component. (deferred)
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			
			_sizeChanged = true;
			invalidate();
		}
								
		//--- Event Handlers ---
		
		/**
		 * validate
		 */
		protected function onInvalidate():void
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
				adjustSize();
			}
			
			//always call
			redraw();
		}
		
		//--- Getter/setters ---
				
		/**
		 * always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void {
			_x = Math.round(value);
			super.x = _x;
		}
		
		/**
		 * always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void {
			_y = Math.round(value);
			super.y = _y;
		}
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			_width = value;
			_sizeChanged = true;
			invalidate();
		}
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			_height = value;
			_sizeChanged = true;
			invalidate();
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
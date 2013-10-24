package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Scroller extends UIComponent
	{
		public var hscrollbar:ScrollBar;
		public var vscrollbar:ScrollBar;
		public var dogear:Sprite;
		protected var _contentRoot:Sprite;
		protected var _contentMask:Shape;
		
				
		public function Scroller()
		{
			//default setting
			_width = 100;
			_height = 100;
			
			//view
			this.addChildren();
			this.redraw();
		}
		
		protected function addChildren():void
		{
			_contentRoot = new Sprite();
			_contentMask = new Shape();
			
			this.addChild(_contentRoot);
			this.addChild(_contentMask);
			_contentRoot.mask = _contentMask;
			
			hscrollbar = new ScrollBar();
			vscrollbar = new ScrollBar();
			vscrollbar.orientation = ScrollBar.VERTICAL;
			vscrollbar.value = 1.0;
			
			dogear = new Sprite();
			
			this.addChild(dogear);
			this.addChild(hscrollbar);
			this.addChild(vscrollbar);
			
			hscrollbar.addEventListener(Event.CHANGE, onHScrollBarChange);
			vscrollbar.addEventListener(Event.CHANGE, onVScrollBarChange);
		}
		
		override protected function redraw():void
		{
			var g:Graphics = _contentMask.graphics;
			g.clear();
			g.beginFill(0x0);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
			
			var dogearWidth:int = vscrollbar.width;
			var dogearHeight:int = hscrollbar.height;
			g = dogear.graphics;
			g.clear();
			g.beginFill(0xffffff);
			g.drawRect(0, 0, dogearWidth, dogearHeight);
			g.endFill();
			/*
			g.lineStyle(1, 0x999999);
			g.moveTo(dogearWidth*3/4 +0.5, dogearHeight/4 +0.5);
			g.lineTo(dogearWidth/4 +0.5, dogearHeight*3/4 +0.5);
			g.moveTo(dogearWidth*3/4 +0.5, dogearHeight/2 +0.5);
			g.lineTo(dogearWidth/2 +0.5, dogearHeight*3/4 +0.5);
			g.moveTo(dogearWidth*3/4 +0.5 +0.5, dogearHeight*3/4 -0.5 +0.5);
			g.lineTo(dogearWidth*3/4 -0.5 +0.5, dogearHeight*3/4 +0.5 +0.5);
			
			g.lineStyle(1, 0xcccccc);
			g.moveTo(dogearWidth*3/4, dogearHeight/4);
			g.lineTo(dogearWidth/4, dogearHeight*3/4);
			g.moveTo(dogearWidth*3/4, dogearHeight/2);
			g.lineTo(dogearWidth/2, dogearHeight*3/4);
			g.moveTo(dogearWidth*3/4 +0.5, dogearHeight*3/4 -0.5);
			g.lineTo(dogearWidth*3/4 -0.5, dogearHeight*3/4 +0.5);
			*/
			dogear.x = _width - dogear.width;
			dogear.y = _height - dogear.height;
			
			//reset scrollbar position and size
			readjustScrollBars();
			
			//reset content position
			positionContent();
		}
		
		protected function readjustScrollBars():void
		{
			hscrollbar.width = _width - vscrollbar.width;
			vscrollbar.height = _height - hscrollbar.height;
			hscrollbar.y = _height - hscrollbar.height;
			vscrollbar.x = _width - vscrollbar.width;
			
			var hPercent:Number, vPercent:Number;
			if(_contentRoot.width >= _width - vscrollbar.width) {
				hPercent = (_width - vscrollbar.width) / _contentRoot.width;
			}
			else {
				hPercent = 1.0;
			}
			
			if(_contentRoot.height >= _height - hscrollbar.height) {
				vPercent = (_height - hscrollbar.height) / _contentRoot.height;
			}
			else {
				vPercent = 1.0;
			}
			
			if(_autoHideScrollBar) {
				//auto hide
				if(hPercent == 1.0 && vPercent < 1.0) {
					vPercent = _height / _contentRoot.height;
					
					vscrollbar.height = _height;
				}
				else if(vPercent == 1.0 && hPercent < 1.0) {
					hPercent = _width / _contentRoot.width;
					
					hscrollbar.width = _width;
				}
				hscrollbar.visible = (hPercent < 1.0);
				vscrollbar.visible = (vPercent < 1.0);
			}
			else {
				if(!hscrollbar.visible) hscrollbar.visible = true;
				if(!vscrollbar.visible) vscrollbar.visible = true;
			}
			
			hscrollbar.percent = hPercent;
			vscrollbar.percent = vPercent;
		}
		
		protected function positionContent():void
		{
			if(vscrollbar.visible) {
				if(hscrollbar.percent == 1.0) _contentRoot.x = 0;
				else _contentRoot.x = -hscrollbar.value * (_contentRoot.width - (_width - vscrollbar.width));
			}
			else {
				_contentRoot.x = 0;
			}
			
			if(hscrollbar.visible) {
				if(vscrollbar.percent == 1.0) _contentRoot.y = 0;
				else _contentRoot.y = -(1.0 - vscrollbar.value) * (_contentRoot.height - (_height - hscrollbar.height));
			}	
			else {
				_contentRoot.y = 0;
			}
		}
		
		public function addContent(content:DisplayObject):void
		{
			_contentRoot.addChild(content);
			
			invalidate();
		}
		
		public function removeContent(content:DisplayObject):void
		{
			_contentRoot.removeChild(content);
			
			invalidate();
		}
		
		/* for content dragging */
		
		protected var _dragBounds:Rectangle = new Rectangle();
		
		public function getDragBounds():Rectangle
		{
			var w:int =  _width - _contentRoot.width;
			if(vscrollbar.visible)  w -= vscrollbar.width;
			if(w > 0) w = 0;
			
			var h:int =  _height - _contentRoot.width;
			if(hscrollbar.visible)  h -= hscrollbar.height;
			if(h > 0) h = 0;
			
			_dragBounds.width = w;
			_dragBounds.height = h;
			return _dragBounds;
		}
		
		public function updateScollBars():void
		{
			if(hscrollbar.percent < 1.0) {
				if(vscrollbar.visible) 
					hscrollbar.value = - _contentRoot.x / (_contentRoot.width - (_width - vscrollbar.width));
				else 
					hscrollbar.value = - _contentRoot.x / (_contentRoot.width - _width);
			}
			
			if(vscrollbar.percent < 1.0) {
				if(hscrollbar.visible)
					vscrollbar.value = 1.0 + _contentRoot.y / (_contentRoot.height - (_height - hscrollbar.height));
				else 
					vscrollbar.value = 1.0 + _contentRoot.y / (_contentRoot.height - _height);
			}
		}
		
		//--- Event Handlers ---
		
		protected function onHScrollBarChange(event:Event):void
		{
			if(vscrollbar.visible) 
				_contentRoot.x = -hscrollbar.value * (_contentRoot.width - (_width - vscrollbar.width));
			else 
				_contentRoot.x = -hscrollbar.value * (_contentRoot.width - _width);
		}
		
		protected function onVScrollBarChange(event:Event):void
		{
			if(hscrollbar.visible)
				_contentRoot.y = -(1.0 - vscrollbar.value) * (_contentRoot.height - (_height - hscrollbar.height));
			else 
				_contentRoot.y = -(1.0 - vscrollbar.value) * (_contentRoot.height - _height);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_contentRoot.startDrag( false, getDragBounds() );
		}
		
		protected function onUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_contentRoot.stopDrag();
		}
		
		protected function onMove(event:MouseEvent):void
		{
			updateScollBars();
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			hscrollbar.enabled = _enabled;
			vscrollbar.enabled = _enabled;
		}
		
		protected var _autoHideScrollBar:Boolean = false;

		public function get autoHideScrollBar():Boolean { return _autoHideScrollBar; }
		public function set autoHideScrollBar(value:Boolean):void
		{
			_autoHideScrollBar = value;
			invalidate();		
		}
		
		protected var _dragContent:Boolean = false;
		
		public function get dragContent():Boolean { return _dragContent; }
		public function set dragContent(value:Boolean):void
		{
			_dragContent = value;
			
			if(_dragContent) _contentRoot.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			else _contentRoot.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		public function get contentRoot():Sprite { return _contentRoot; }
	}
}
package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	public class Scroller extends UIComponent
	{
		public var hscrollbar:ScrollBar;
		public var vscrollbar:ScrollBar;
		public var dogear:Sprite;
		protected var _container:Container;
		protected var _containerMask:Shape;
		
		
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
			_container = new Container();
			_containerMask = new Shape();
			
			this.addChild(_container);
			this.addChild(_containerMask);
			_container.mask = _containerMask;
			
			hscrollbar = new ScrollBar();
			vscrollbar = new ScrollBar();
			vscrollbar.orientation = ScrollBar.VERTICAL;
			vscrollbar.value = 1.0;
			
			dogear = new Sprite();
			
			this.addChild(dogear);
			this.addChild(hscrollbar);
			this.addChild(vscrollbar);
			
			_container.addEventListener(Event.CHANGE, onContainerChange);
			hscrollbar.addEventListener(Event.CHANGE, onHScrollBarChange);
			vscrollbar.addEventListener(Event.CHANGE, onVScrollBarChange);
		}
		
		override protected function redraw():void
		{
			var g:Graphics = _containerMask.graphics;
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
			
			if(_dragDogear) {
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
			}
			
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
			if(_container.width >= _width - vscrollbar.width) {
				hPercent = (_width - vscrollbar.width) / _container.width;
			}
			else {
				hPercent = 1.0;
			}
			
			if(_container.height >= _height - hscrollbar.height) {
				vPercent = (_height - hscrollbar.height) / _container.height;
			}
			else {
				vPercent = 1.0;
			}
			
			if(_autoHideScrollBar) {
				//auto hide
				if(hPercent == 1.0 && vPercent < 1.0) {
					vPercent = _height / _container.height;
					
					if(!_dragDogear) vscrollbar.height = _height;
				}
				else if(vPercent == 1.0 && hPercent < 1.0) {
					hPercent = _width / _container.width;
					
					if(!_dragDogear) hscrollbar.width = _width;
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
			//zero it if invisible
			var vscrollbarWidth:int = vscrollbar.visible ? vscrollbar.width : 0;
			var hscrollbarHeight:int = hscrollbar.visible ? hscrollbar.height : 0;
			
			if(_container.width >= _width - vscrollbarWidth) {
				_container.x = -hscrollbar.value * (_container.width - (_width - vscrollbarWidth));
			}
			else {
				_container.x = 0;
			}
			
			if(_container.height >= _height - hscrollbarHeight) {
				_container.y = -(1.0 - vscrollbar.value) * (_container.height - (_height - hscrollbarHeight));
			}
			else {
				_container.y = 0;
			}
		}
				
		/* for content dragging */
		
		protected var _dragBounds:Rectangle = new Rectangle();
		
		public function getDragBounds():Rectangle
		{
			var w:int =  _width - _container.width;
			if(vscrollbar.visible) w -= vscrollbar.width;
			if(w > 0) w = 0;
			
			var h:int =  _height - _container.height;//
			if(hscrollbar.visible) h -= hscrollbar.height;
			if(h > 0) h = 0;
			
			_dragBounds.width = w;
			_dragBounds.height = h;
			return _dragBounds;
		}
		
		public function updateScollBars():void
		{
			if(hscrollbar.percent < 1.0) {
				if(vscrollbar.visible) 
					hscrollbar.value = - _container.x / (_container.width - (_width - vscrollbar.width));
				else 
					hscrollbar.value = - _container.x / (_container.width - _width);
			}
			
			if(vscrollbar.percent < 1.0) {
				if(hscrollbar.visible)
					vscrollbar.value = 1.0 + _container.y / (_container.height - (_height - hscrollbar.height));
				else 
					vscrollbar.value = 1.0 + _container.y / (_container.height - _height);
			}
		}
		
		//--- Event Handlers ---
		
		protected function onContainerChange(event:Event):void
		{
			invalidate();
		}
		
		protected function onHScrollBarChange(event:Event):void
		{
			if(vscrollbar.visible) 
				_container.x = -hscrollbar.value * (_container.width - (_width - vscrollbar.width));
			else 
				_container.x = -hscrollbar.value * (_container.width - _width);
		}
		
		protected function onVScrollBarChange(event:Event):void
		{
			if(hscrollbar.visible)
				_container.y = -(1.0 - vscrollbar.value) * (_container.height - (_height - hscrollbar.height));
			else 
				_container.y = -(1.0 - vscrollbar.value) * (_container.height - _height);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_container.startDrag( false, getDragBounds() );
		}
		
		protected function onUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_container.stopDrag();
		}
		
		protected function onMove(event:MouseEvent):void
		{
			updateScollBars();
		}
		
		protected var _mx:int, _my:int;
		protected function onDogearDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDogearDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDogearMove);
			
			_mx = event.stageX;
			_my = event.stageY;
		}
		
		protected function onDogearDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDogearDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDogearMove);
		}
		
		protected function onDogearMove(event:MouseEvent):void
		{
			var mx:int = event.stageX;
			var my:int = event.stageY;
			
			var offsetX:Number = mx - _mx;
			var offsetY:Number = my - _my;
			
			//change size
			var w:int = _width + offsetX;
			var h:int = _height + offsetY;
			
			//minimum size
			var minWidth:int = dogear.height * 5;//h
			var minHeight:int = dogear.width * 5;//v
			if(w <= minWidth) w = minWidth;
			if(h <= minHeight) h = minHeight;
			
			this.setSize(w, h);
			
			_mx = mx;
			_my = my;
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
			
			if(_dragContent) _container.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			else _container.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		protected var _dragDogear:Boolean = false;
		
		public function get dragDogear():Boolean { return _dragDogear; }
		public function set dragDogear(value:Boolean):void
		{
			_dragDogear = value;
			invalidate();
			
			if(_dragDogear) dogear.addEventListener(MouseEvent.MOUSE_DOWN, onDogearDrag);
			else dogear.removeEventListener(MouseEvent.MOUSE_DOWN, onDogearDrag);
		}

		public function get container():Sprite { return _container; }
	}
}
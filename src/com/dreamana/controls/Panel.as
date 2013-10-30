package com.dreamana.controls
{
	import com.dreamana.controls.skins.PanelSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="select", type="flash.events.Event")]
	
	public class Panel extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DISABLED:String = "disabled";
		
		protected var _titleBar:Sprite;
		protected var _contentArea:Shape;
		protected var _toggle:Toggle;
		protected var _container:Container;
		
		protected var _title:String;
		protected var _titleWidth:int;
		protected var _titleHeight:int;
		protected var _contentWidth:int;
		protected var _contentHeight:int;
		
		
		public function Panel()
		{
			//default setting
			_width = 100;
			_height = 100;
			_titleWidth = 100;
			_titleHeight = 20;
			_contentWidth = 100;
			_contentHeight = 80;
			_title = "";
			_skinProps = {
				state: STATE_NORMAL, 
				titleWidth: _titleWidth, 
				titleHeight: _titleHeight,
				contentWidth: _contentWidth, 
				contentHeight: _contentHeight,
				title: _title
			};
			_skinClass = PanelSkin;
			
			//view
			this.addChildren();
			
			_container = new Container();
			_container.y = _titleHeight;
			this.addChild(_container);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "contentArea") {
				_contentArea = instance as Shape;
			}
			else if(partName == "titleBar") {
				_titleBar = instance as Sprite;
				_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
			else if(partName == "toggle") {
				_toggle = instance as Toggle;
				_toggle.addEventListener(MouseEvent.CLICK, onFold);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(partName == "contentArea") {
				_contentArea = instance as Shape;
			}
			else if(partName == "titleBar") {
				_titleBar = instance as Sprite;
				_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
			else if(partName == "toggle") {
				_toggle = instance as Toggle;
				_toggle.removeEventListener(MouseEvent.CLICK, onFold);
			}
		}
		
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			super.setSize(w, h, deferred);
			
			//keep titleBar height (BUG FIXED: do not change contentHeight when collapsed)
			changeTitleSize(w, _titleHeight);
			changeContentSize(w, _expanded ? h - _titleHeight : _contentHeight);
			
			//update height
			this.updateFoldingState();
			
			//position container
			_container.y = _titleHeight;
		}
		
		protected function changeState(state:String):void
		{
			_skinProps["state"] = state;
			this.updateSkinProps();
		}
		
		protected function changeTitleSize(w:int, h:int):void
		{
			_titleWidth = w;
			_titleHeight = h;
			
			_skinProps["titleWidth"] = w;
			_skinProps["titleHeight"] = h;
			
			this.updateSkinProps();
		}
		
		protected function changeContentSize(w:int, h:int):void
		{
			_contentWidth = w;
			_contentHeight = h;
			
			_skinProps["contentWidth"] = w;
			_skinProps["contentHeight"] = h;
			
			this.updateSkinProps();
		}
		
		protected function changeTitle(s:String):void
		{
			_title = s;
			_skinProps["title"] = s;
			this.updateSkinProps();
		}
		
		protected var _dragBounds:Rectangle = new Rectangle();
		protected function getDragBounds():Rectangle
		{
			if(!stage) return null;
			
			_dragBounds.x = 0;
			_dragBounds.y = 0;
			_dragBounds.width = stage.stageWidth - _width;
			_dragBounds.height = stage.stageHeight - _height;
			
			return _dragBounds;
		}
		
		protected function updateFoldingState():void
		{
			var stateChanged:Boolean = (_container.visible != _expanded);
			if(stateChanged) {
				//simply hide | show
				_container.visible = _expanded;
			
				_contentArea.visible = _expanded;
			}
			
			//update height			
			_height = _expanded ? (_titleHeight + _contentHeight) : _titleHeight;
			
			//dispatch resize event
			if(stateChanged) this.dispatchEvent(new Event(Event.RESIZE));
									
			//fix position
			if(_draggable) {
				var bounds:Rectangle = getDragBounds();
				if(bounds) {
					if(this.y > bounds.height) this.y = bounds.height;
					if(this.y < bounds.y) this.y = bounds.y;
					
					if(this.x > bounds.width) this.x = bounds.width;
					if(this.x < bounds.x) this.x = bounds.x;
				}
			}
		}
		
		public function collapse():void
		{
			if(!_expanded) return;
			
			_expanded = false;
			
			_toggle.selected = _expanded;
			this.updateFoldingState();
		}
		
		public function expand():void
		{
			if(_expanded) return;
			
			_expanded = true;
			
			_toggle.selected = _expanded;
			this.updateFoldingState();
		}
		
		//--- Event Handlers ---
		
		protected function onDrag(event:MouseEvent):void
		{
			if(!_draggable) return;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			this.startDrag(false, getDragBounds());
		}
		
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			this.stopDrag();
		}
		
		protected function onFold(event:MouseEvent):void
		{
			_expanded = _toggle.selected;
			this.updateFoldingState();
			
			//dispatch select event
			//if(_expanded) 
				this.dispatchEvent(new Event(Event.SELECT));
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
			
			_toggle.enabled = value;
			_container.enabled = value;
		}
		
		protected var _draggable:Boolean = true;

		public function get draggable():Boolean { return _draggable; }
		public function set draggable(value:Boolean):void {
			_draggable = value;
			//if(!_draggable) this.stopDrag()
		}
		
		protected var _expanded:Boolean = true;
		
		public function get expanded():Boolean { return _expanded; }
		public function get collapsed():Boolean { return !_expanded; }
		
		public function get title():String { return _title; }
		public function set title(value:String):void {
			changeTitle(value);
		}
		
		public function get titleBarWidth():int{ return _titleWidth; }
		public function get titleBarHeight():int{ return _titleHeight; }
		
		public function get contentWidth():int{ return _contentWidth; }
		public function get contentHeight():int{ return _contentHeight; }
		
		public function get container():Container { return _container; };
	}
}
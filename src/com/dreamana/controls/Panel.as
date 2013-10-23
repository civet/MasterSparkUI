package com.dreamana.controls
{
	import com.dreamana.controls.skins.PanelSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Panel extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DISABLED:String = "disabled";
		
		protected var _titleBar:Sprite;
		protected var _contentArea:Sprite;
		protected var _toggle:Toggle;
		
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
			_skinProps = {
				state: STATE_NORMAL, 
				titleWidth: _titleWidth, 
				titleHeight: _titleHeight,
				contentWidth: _contentWidth, 
				contentHeight: _contentHeight
			};
			_skinClass = PanelSkin;
			
			//view
			this.addChildren();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "contentArea") {
				_contentArea = instance as Sprite;
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
				_contentArea = instance as Sprite;
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
			
			changeTitleSize(w, _titleHeight);
			changeContentSize(w, h - _titleHeight);
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
		
		protected function changeFoldingState(isExpanded:Boolean):void
		{
			//simply hide
			_contentArea.visible = isExpanded;
			
			//update height
			_height = isExpanded ? (_titleHeight + _contentHeight) : _titleHeight;
			
			//fix position
			var bounds:Rectangle = getDragBounds();
			if(_draggable) {
				if(this.y > bounds.height) this.y = bounds.height;
				if(this.y < bounds.y) this.y = bounds.y;
			}
			
		}
		
		public function collapse():void
		{
			_toggle.selected = false;
			
			changeFoldingState(false);
		}
		
		public function expand():void
		{
			_toggle.selected = true;
			
			changeFoldingState(true);
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
			changeFoldingState( _toggle.selected );
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
			
			//TODO: set children enabled
			_toggle.enabled = false;
		}
		
		protected var _draggable:Boolean = true;

		public function get draggable():Boolean { return _draggable; }
		public function set draggable(value:Boolean):void {
			_draggable = value;
			
			//TODO:
		}
	}
}
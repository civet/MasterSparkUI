package com.dreamana.controls.skins
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Spinner;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class SpinnerSkin extends UISkin
	{
		//element
		protected var _incrementButton:Button;
		protected var _decrementButton:Button;
		protected var _incrementArrow:Shape;
		protected var _decrementArrow:Shape;
		
		//style
		protected var _arrowColor:int;
		
		
		public function SpinnerSkin()
		{
			//default setting
			_arrowColor = 0xcccccc;
			
			//elements
			_incrementButton = new Button();
			_decrementButton = new Button();
			
			_incrementArrow = new Shape();
			_decrementArrow = new Shape();
			_incrementButton.addChild(_incrementArrow);
			_decrementButton.addChild(_decrementArrow);
			
			//elementList
			this.addPart("incrementButton", _incrementButton);
			this.addPart("decrementButton", _decrementButton);
		}
		
		/* Hack */
		override public function setDrawingProps(props:Object):void
		{
			var buttonWidth:int = props["buttonWidth"];
			var buttonHeight:int = props["buttonHeight"];
			
			_incrementButton.setSize(buttonWidth, buttonHeight);
			_decrementButton.setSize(buttonWidth, buttonHeight);
			
			super.setDrawingProps(props);			
		}
				
		override protected function redraw():void
		{
			var g:Graphics;
						
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var buttonWidth:int = _props["buttonWidth"];
			var buttonHeight:int = _props["buttonHeight"];
			var orientation:String = _props["orientation"];
				
			if(orientation == Spinner.VERTICAL) {
				_incrementButton.x = w - _decrementButton.width >> 1;
				_incrementButton.y = 0;
				
				_decrementButton.x = w - _decrementButton.width >> 1;
				_decrementButton.y = h - _incrementButton.height;
				
				g = _incrementArrow.graphics;
				g.clear();
				g.beginFill(_arrowColor);
				g.moveTo(int(buttonWidth/2), int(buttonHeight/4));
				g.lineTo(int(buttonWidth/4), int(buttonHeight*3/4));
				g.lineTo(int(buttonWidth*3/4), int(buttonHeight*3/4));
				g.endFill();
				
				g = _decrementArrow.graphics;
				g.clear();
				g.beginFill(_arrowColor);
				g.moveTo(int(buttonWidth/2), int(buttonHeight*3/4));
				g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
				g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
				g.endFill();
			}
			else {
				_decrementButton.x = 0;
				_decrementButton.y = h - _decrementButton.height >> 1;
				
				_incrementButton.x = w - _incrementButton.width;
				_incrementButton.y = h - _incrementButton.height >> 1;
				
				g = _decrementArrow.graphics;
				g.clear();
				g.beginFill(_arrowColor);
				g.moveTo(int(buttonWidth/4), int(buttonHeight/2));
				g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
				g.lineTo(int(buttonWidth*3/4), int(buttonHeight*3/4));
				g.endFill();
				
				g = _incrementArrow.graphics;
				g.clear();
				g.beginFill(_arrowColor);
				g.moveTo(int(buttonWidth*3/4), int(buttonHeight/2));
				g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
				g.lineTo(int(buttonWidth/4), int(buttonHeight*3/4));
				g.endFill();
			}
			
			switch(state) {
				case Spinner.STATE_DISABLED:
					_incrementButton.enabled = false;
					_decrementButton.enabled = false;
					break;
				
				case Spinner.STATE_NORMAL:
				default:
					if(_incrementButton.enabled == false) _incrementButton.enabled = true;
					if(_decrementButton.enabled == false) _decrementButton.enabled = true;
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "arrow-color":
					_arrowColor = value as Number;
					invalidate();
					break;
				
				case "face-color":
					_incrementButton.skin.setStyle("face-color", value as Number);
					_decrementButton.skin.setStyle("face-color", value as Number);
					break;
				
				case "border-color":
					_incrementButton.skin.setStyle("border-color", value as Number);
					_decrementButton.skin.setStyle("border-color", value as Number);
					break;
			}
		}
	}
}
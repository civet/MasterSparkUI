package com.dreamana.controls
{
	import com.dreamana.controls.skins.TextInputSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	
	[Event(name="textInput", type="flash.events.TextEvent")]
	
	public class TextInput extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DISABLED:String = "disabled";
		
		protected var _text:String;
		protected var _textfieldProps:Object;
		
		protected var _textfield:TextField;
		
		
		public function TextInput()
		{
			//default setting
			_width = 100;
			_height = 20;
			_skinProps = {state: STATE_NORMAL};
			_skinClass = TextInputSkin;
			_text = "";
			
			//view
			this.addChildren();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "textfield") {
				_textfield = instance as TextField;
				
				applyTextFieldProps();
				
				_textfield.text = _text;
				
				//_textfield.addEventListener(Event.CHANGE, onTextChange);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(partName == "textfield") {
				_textfield = instance as TextField;
								
				//_textfield.removeEventListener(Event.CHANGE, onTextChange);
				
				_text = _textfield.text;
			}
		}
		
		protected function applyTextFieldProps():void
		{
			if(!_textfield) return;
			
			for(var key:String in _textfieldProps) {
				if(_textfield.hasOwnProperty(key)) _textfield[key] = _textfieldProps[key];
			}
		}
		
		protected function changeState(state:String):void
		{
			_skinProps["state"] = state;
			
			this.updateSkinProps();
		}
		
		//--- PUBLIC METHODS ---
		
		public function setTextFieldProps(params:Object):void
		{
			_textfieldProps = params;
			
			applyTextFieldProps();
		}
		
		public function callTextFieldMethod(methodName:String, ...args):*
		{
			var func:Function = _textfield[methodName];
			return (func != null) ? func.apply(null, args) : null;
		}
						
		//--- EVENT HANDLERS ---
		
		
		
		//--- GETTER/SETTERS ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
		
		public function get text():String
		{
			if(_textfield) _text = _textfield.text;
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			if(_textfield) _textfield.text = _text;
		}
		
		public function get textField():TextField { return _textfield; }
	}
}
package test
{
	import com.dreamana.controls.Autocomplete;
	import com.dreamana.controls.ComboBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestAutocomplete extends Sprite
	{
		public function TestAutocomplete()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			this.stage.color = 0xeeeeee;
			
			var data:Array = [
				{label:"ActionScript", data:0},
				{label:"Assembly language", data:-1},
				{label:"BASIC", data:1},
				{label:"C", data:2},
				{label:"C++", data:3},
				{label:"C#", data:4},
				{label:"CoffeeScript", data:5},
				{label:"Dart", data:6},
				{label:"Erlang", data:7},
				{label:"F#", data:8},
				{label:"Fortran", data:9},
				{label:"Go", data:10},
				{label:"Haxe", data:11},
				{label:"Java", data:12},
				{label:"JavaScript", data:13},
				{label:"Lisp", data:14},
				{label:"Lua", data:15},
				{label:"Machine code", data:16},
				{label:"MATLAB", data:17},
				{label:"Objective-C", data:18},
				{label:"Pascal", data:19},
				{label:"PHP", data:20},
				{label:"Python", data:21},
				{label:"Ruby", data:22},
				{label:"Scala", data:23},
				{label:"TypeScript", data:24}
			];
			
			var autocomplete:Autocomplete = new Autocomplete();
			//var autocomplete:ComboBox = new ComboBox();
			this.addChild(autocomplete);
			
			autocomplete.setSize(240, 20);
			autocomplete.data = data;
			autocomplete.multipleValuesEnabled = true;
			autocomplete.compareFunction = autocomplete.orderedMatch;
		}
	}
}
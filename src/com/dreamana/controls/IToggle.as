package com.dreamana.controls
{
	import flash.events.IEventDispatcher;
	
	public interface IToggle extends IEventDispatcher
	{
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		function get autoToggleEnabled():Boolean;
		function set autoToggleEnabled(value:Boolean):void;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
}
package test
{
	import com.dreamana.controls.Accordion;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestAccordion extends Sprite
	{
		private var accordion:Accordion;
		
		public function TestAccordion()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			accordion = new Accordion();
			this.addChild(accordion);
			
			accordion.collapsible = true;
			
			accordion.addPanel(accordion.createPanel(200, 200, "Section 1"));
			accordion.addPanel(accordion.createPanel(200, 300, "Section 2"));
			accordion.addPanel(accordion.createPanel(200, 400, "Section 3"));
			accordion.addPanel(accordion.createPanel(200, 100, "Section 4"));
			
			accordion.width = 300;
			
			accordion.addEventListener(Event.RESIZE, onAccordionResize);
		}
		
		protected function onAccordionResize(event:Event):void
		{
			//trace(accordion.width, accordion.height);
		}
	}
}
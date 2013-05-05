package com.pocari.view.components 
{
	import com.lifeguard.events.NavigatorEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ControlNavigator extends Sprite 
	{
		public var txtCurrent:TextField;
		public var txtOf:TextField;
		public var txtTotal:TextField;
		public var mcBack:MovieClip;
		public var mcNext:MovieClip;
		
		public function ControlNavigator() 
		{
			mcBack.buttonMode = true;
			mcNext.buttonMode = true;
			
			mcNext.addEventListener(MouseEvent.CLICK, onClick);
			mcBack.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case mcNext:
					dispatchEvent(new NavigatorEvent(NavigatorEvent.SUBMIT, false, true));
					break;
				case mcBack:
					dispatchEvent(new NavigatorEvent(NavigatorEvent.SUBMIT, true, true));
					break;
				default:
			}
		}
		
		public function set total(value:int):void {
			txtTotal.text = value > 9 ? value.toString() : '0' + value;
		}
		public function set current(value:int):void {
			txtCurrent.text = value > 9 ? value.toString() : '0' + value;
		}
		
	}

}
package com.pocari.view.base 
{
	import com.pocari.events.AppEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class Popup extends Sprite implements IView
	{
		public static var app:EventDispatcher;
		
		public function Popup() {
			visible = false;
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			init();
		}
		
		public function init(data:Object = null):void {
			
			
		}
		
		public function show(delay:Number = 0):Number {
			visible = true;
			return delay;
		}
		
		public function hide(delay:Number = 0):Number {
			visible = false;
			return delay;
		}
		
		protected function onClickCloseHandler(e:MouseEvent):void {
			app.dispatchEvent(new AppEvent(AppEvent.HIDE_POPUP, {  }));
		}
		
		public function dispose():void {
			
		}
		
		
	}

}
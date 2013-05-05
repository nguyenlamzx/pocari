package com.pocari.view.base 
{
	import com.pocari.model.clsModel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Screen extends Sprite implements IView {
		
		public static var app:EventDispatcher;
		
		public function Screen() {
			visible = false;
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			}
		}
		
		private function onAddedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
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
		
		public function	getTextById(id:String):String {
			return clsModel.xml.texts.text.(@id == id);
		}
		
		public function dispose():void {
			
		}
		
	}

}
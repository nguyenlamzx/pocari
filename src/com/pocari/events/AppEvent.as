package com.pocari.events 
{
	import flash.events.Event;
	
	public class AppEvent extends Event 
	{
		static public const BUSY					:String = "busy";
		public static const SUBMIT					:String = "pageSubmit";
		static public const FB_INITIALIZED			:String = "fbInitialized";
		static public const HIDE_POPUP				:String = "hidePopup";
		static public const SHOW_POPUP				:String = "showPopup";
		static public const FB_ALBUM_READY			:String = "fbAlbumReady";
		static public const FB_LOGGEDIN				:String = "fbLoggedin";
		static public const SELECTED_IMAGE			:String = "selectedImage";
		
		private var _data:Object;
		
		public function AppEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this._data = data;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public override function clone():Event {
			return new AppEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}

}
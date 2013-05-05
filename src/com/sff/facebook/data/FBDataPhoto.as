package com.sff.facebook.data {
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	
	//import ru.inspirit.net.MultipartURLLoader;
	//import sk.yoz.events.FacebookOAuthGraphEvent;
	//import com.nissan.common.fbconnect.FBEvent;
	//import com.nissan.common.fbconnect.FBProxy;
	//import com.nissan.common.fbconnect.utils.JPEGEncoder;
	//import com.nissan.common.fbconnect.utils.TinyURLEncoder;
	
	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	public class FBDataPhoto extends FBDataMedia {
		
		protected var _post:Object;
		
		function FBDataPhoto(pData:Object = null) {
			super(pData);
		}
		
		public function get source():String {
			return objData.source;
		}
		
		public function get height():String {
			return objData.height;
		}
		
		public function get width():String {
			return objData.width;
		}
		
	}
}

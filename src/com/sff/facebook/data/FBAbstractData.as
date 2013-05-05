package com.sff.facebook.data {
	
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public class FBAbstractData extends EventDispatcher {
		
		protected var objData : Object;		
		
		public function FBAbstractData(pData : Object = null) {
			objData = pData;
		}
		
		public function get id() : String { 
			return objData.id; 
		}
		
		public function get data() : Object { 
			return objData; 
		}
		
	}	
}
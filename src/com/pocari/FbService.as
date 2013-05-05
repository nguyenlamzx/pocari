package com.pocari 
{
	import com.pocari.events.AppEvent;
	import com.sff.facebook.core.FB;
	import com.sff.facebook.core.FBMethod;
	import com.sff.facebook.core.FBPublishType;
	import com.sff.facebook.data.FBDataUser;
	import com.sff.facebook.events.FBEvent;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	
	public class FbService extends EventDispatcher {
		
		private static const APP_ID	:String = '138324459688208';
		
		private static var _instance	:FbService;
		
		private var userprofile			:FBDataUser;
		
		private var fileRef				:FileReference;
		private var bitmapData			:BitmapData;
		
		private var _loggedin			:Boolean;
		private var _initialized		:Boolean;
		
		private var  _loaderContext		:LoaderContext;
		
		public function FbService() {
			FB.init(APP_ID);
			FB.addEventListener(FBEvent.INIT, onInitHandler);
			
			_loaderContext = new LoaderContext();
			_loaderContext.checkPolicyFile = true;
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
		}
		
		private function onInitHandler(e:FBEvent):void {
			FB.removeEventListener(FBEvent.INIT, onInitHandler);
			_initialized = true;
			
			dispatchEvent(new AppEvent(AppEvent.FB_INITIALIZED));
		}
		
		public function login():void {
			FB.login("email, user_photos, publish_stream, read_stream, user_likes, offline_access, photo_upload");
			FB.addEventListener(FBEvent.LOGIN, onLoginHandler);
		}
		
		private function onLoginHandler(evt:FBEvent):void {
			FB.removeEventListener(FBEvent.LOGIN, onLoginHandler);
			
			_loggedin = true;
			
			FB.getProfile();
			FB.addEventListener(FBEvent.GET_USERPROFILE, onGetUserProfileComplete);
		}
		
		private function onGetUserProfileComplete(evt:FBEvent):void {
			FB.removeEventListener(FBEvent.GET_USERPROFILE, onGetUserProfileComplete);
			
			trace(evt.success);
			
			if (evt.success) {
				userprofile = evt.currentData as FBDataUser;
				
				dispatchEvent(new AppEvent(AppEvent.FB_LOGGEDIN));
			}
		}
		
		public function getAlbums():void {
			FB.query(FBPublishType.ALBUMS, userprofile.id, FBMethod.GET, { fields:'photos.fields(picture,source),name,count' } );
			FB.addEventListener(FBEvent.ALBUMS_COMPLETE, onQueryAlbumsComplete);
		}
		
		private function onQueryAlbumsComplete(evt:FBEvent):void {
			FB.removeEventListener(FBEvent.ALBUMS_COMPLETE, onQueryAlbumsComplete);
			
			dispatchEvent(new AppEvent(AppEvent.FB_ALBUM_READY, evt.currentData));
		}
		
		private function browser(e:MouseEvent):void {
			var fileRef:FileReference = new FileReference();
			fileRef.addEventListener(Event.SELECT, onSelectionImage);
			fileRef.browse();
		}
		
		private function onSelectionImage(evt:Event):void {
			ExternalInterface.call('console.log', "onSelectionImage");
			
			fileRef = evt.target as FileReference;
			fileRef.addEventListener(Event.COMPLETE, onLoadFileComplete);
			fileRef.load();
		}
		
		private function onLoadFileComplete(evt:Event):void {
			ExternalInterface.call('console.log', "onLoadFileComplete");
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadContentComplete);
			loader.loadBytes(evt.currentTarget.data as ByteArray);
		}
		
		private function onLoadContentComplete(evt:Event):void {
			var loader:Loader = evt.currentTarget.loader as Loader;
			
			bitmapData = new BitmapData(loader.content.width, loader.content.height);
			bitmapData.draw(loader.content);
		}
		
		private function upload(e:MouseEvent):void {
			var params:Object = { image: bitmapData, message: 'Test Photo', fileName: 'FILE_NAME' };
			
			//FB.call(FBPublishType.PHOTOS, 'me', URLRequestMethod.POST, params);
			//FB.addEventListener(FBEvent.PHOTOS_COMPLETE, onPostPhotosComplete);
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//								POST FUNCTION								//
		//////////////////////////////////////////////////////////////////////////////
		
		public static function get instance():FbService {
			if (!_instance) {
				_instance = new FbService();
			}
			return _instance;
		}
		
		public function get initialized():Boolean {
			return _initialized;
		}
		
		public function get loggedin():Boolean {
			return _loggedin;
		}
		
		public function get loaderContext():LoaderContext {
			return _loaderContext;
		}
		
	}

}
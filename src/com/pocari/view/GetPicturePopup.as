package com.pocari.view 
{
	import com.pocari.events.AppEvent;
	import com.pocari.model.AppConstants;
	import com.pocari.model.clsModel;
	import com.pocari.view.base.Popup;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class GetPicturePopup extends Popup 
	{
		public var btnClose				:SimpleButton;
		public var btnGetFBImage		:SimpleButton;
		public var btnGetLocalImage		:SimpleButton;
		
		public function GetPicturePopup() {
			
		}
		
		override public function init(data:Object = null):void {
			super.init(data);
			
			btnClose.addEventListener(MouseEvent.CLICK, onClickCloseHandler);
			btnGetFBImage.addEventListener(MouseEvent.CLICK, onClickGetFBImageHandler);
			btnGetLocalImage.addEventListener(MouseEvent.CLICK, onClickGetLocalImageHandler);
			
			if (clsModel.fb.initialized) {
				btnGetFBImage.alpha = 0.6;
				btnGetFBImage.mouseEnabled = false;
				
				clsModel.fb.addEventListener(AppEvent.FB_INITIALIZED, onFacebookInitializedHandler);
			}
		}
		
		private function onFacebookInitializedHandler(e:AppEvent):void {
			clsModel.fb.removeEventListener(AppEvent.FB_INITIALIZED, onFacebookInitializedHandler);
			
			btnGetFBImage.alpha = 1;
			btnGetFBImage.mouseEnabled = true;
		}
		
		private function onClickGetFBImageHandler(e:MouseEvent):void {
			ExternalInterface.call('console.log', 'onClickGetFBImageHandler', clsModel.fb.loggedin);
			if (clsModel.fb.loggedin) {
				app.dispatchEvent(new AppEvent(AppEvent.SHOW_POPUP, { popup:AppConstants.BROWSE_ALBUM_FACEBOOK_POPUP }));
			} else {
				app.dispatchEvent(new AppEvent(AppEvent.BUSY, true));
				
				clsModel.fb.login();
				clsModel.fb.addEventListener(AppEvent.FB_LOGGEDIN, onFBLoggedinHandler);
			}
		}
		
		private function onFBLoggedinHandler(e:AppEvent):void {
			ExternalInterface.call('console.log', 'onFBLoggedinHandler');
			clsModel.fb.removeEventListener(AppEvent.FB_LOGGEDIN, onFBLoggedinHandler);
			
			app.dispatchEvent(new AppEvent(AppEvent.BUSY, false));
			
			app.dispatchEvent(new AppEvent(AppEvent.SHOW_POPUP, { popup:AppConstants.BROWSE_ALBUM_FACEBOOK_POPUP }));
		}
		
		private function onClickGetLocalImageHandler(e:MouseEvent):void {
			
		}
		
	}

}
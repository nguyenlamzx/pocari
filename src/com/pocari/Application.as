package com.pocari 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.pocari.events.AppEvent;
	import com.pocari.model.AppConstants;
	import com.pocari.model.clsModel;
	import com.pocari.view.base.IView;
	import com.pocari.view.base.Popup;
	import com.pocari.view.base.Screen;
	import com.pocari.view.ForgotPasswordPopup;
	import com.pocari.view.screen.*;
	import com.pocari.view.SharePopup;
	import com.pocari.view.SignInPopup;
	import com.pocari.view.SignUpPopup;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	
	public class Application extends Sprite
	{
		public var mcLoadingv					:MovieClip;
		public var mcPreventer					:MovieClip;
		public var mcOverlay					:MovieClip;
		
		// popup
		public var mcSharePopup					:SharePopup;
		public var mcSignUpPopup				:SignUpPopup;
		public var mcSignInPopup				:SignInPopup;
		public var mcForgotPasswordPopup		:ForgotPasswordPopup;
		
		// screen
		public var mcCastScreen					:CastScreen;
		public var mcShareScreen				:ShareScreen;
		public var mcCharacterEditor			:CharacterEditor;
		
		private var view						:IView;
		
		private var popups						:Object;
		private var screens						:Object;
		private var stackPopups					:Array;
		
		public function Application() {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//stage.addChild(new OUP());
			
			Security.loadPolicyFile('http://api.facebook.com/crossdomain.xml');
			Security.allowDomain('http://profile.ak.fbcdn.net');
			Security.allowInsecureDomain('http://profile.ak.fbcdn.net');
			
			var xmlpath:String = 'xml/data.xml';
			if (loaderInfo.parameters.xmlpath) {
				xmlpath = loaderInfo.parameters.xmlpath;
			}
			loadData(xmlpath);
			
			FbService.instance;
		}
		
		public function loadData(url:String) {
			trace('Main.loadData', url);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onCompleteLoadXmlHandler);
			loader.load(new URLRequest(url));
		}
		
		private function onCompleteLoadXmlHandler(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadXmlHandler);
			
			//now parseData
			clsModel.parseData(new XML(e.currentTarget.data));
			
			startup();
		}
		
		private function startup():void {
			Popup.app = this;
			Screen.app = this;
			
			addEventListener(AppEvent.BUSY, onPageBusy);
			addEventListener(AppEvent.SUBMIT, onPageSubmit);
			
			addEventListener(AppEvent.SHOW_POPUP, onShowPopup);
			addEventListener(AppEvent.HIDE_POPUP, onHidePopup);
			
			addEventListener(AppEvent.SELECTED_IMAGE, onSelectedImageHandler);
			
			mcOverlay.visible = false;
			
			popups = { };
			screens = { };
			
			// popups
			popups[AppConstants.SHARE_POPUP] = mcSharePopup;
			popups[AppConstants.SIGNUP_POPUP] = mcSignUpPopup;
			popups[AppConstants.SIGNIN_POPUP] = mcSignInPopup;
			popups[AppConstants.FORGOT_PASSWORD_POPUP] = mcForgotPasswordPopup;
			popups[AppConstants.GET_PICTURE_POPUP] = mcGetPicturePopup;
			popups[AppConstants.BROWSE_ALBUM_FACEBOOK_POPUP] = mcPhotoAlbum;
			
			// screens
			screens[AppConstants.CASTS_SCREEN] = mcCastScreen;
			screens[AppConstants.CHARACTER_EDITOR] = mcCharacterEditor;
			
			stackPopups = [];
			
			var time:Number = 0;
			
			view = mcCastScreen;
			time = view.show();
			
			TweenMax.delayedCall(time, showPageComplete);
		}
		
		private function onSelectedImageHandler(e:AppEvent):void {
			popups[AppConstants.GET_PICTURE_POPUP].hide();
			popups[AppConstants.BROWSE_ALBUM_FACEBOOK_POPUP].hide();
			
			//dispatchEvent(new AppEvent(AppEvent.SUBMIT, e.data ));
			
			onPageSubmit(e);
		}
		
		private function onShowPopup(e:AppEvent):void {
			var popup:Popup = popups[e.data.popup];
			
			if (!popup) {
				return;
			}
			stackPopups.push(popup);
			
			addChild(mcOverlay);
			addChild(popup);
			
			mcOverlay.alpha = 1;
			mcOverlay.visible = true;
			
			popup.show();
		}
		
		private function onHidePopup(e:AppEvent):void {
			var popup:Popup;
			var delay:Number = 0;
			
			popup = stackPopups.pop() as Popup;
			
			if (!popup) {
				return;
			}
			delay = popup.hide();
			
			TweenMax.delayedCall(delay, hidePopopComplete);
		}
		
		private function hidePopopComplete():void {
			var popup:Popup = stackPopups.pop() as Popup;
			
			if (!popup) {
				mcOverlay.alpha = 0;
				mcOverlay.visible = false;
				return;
			}
			
			addChild(mcOverlay);
			addChild(popup);
		}
		
		private function onPageBusy(e:AppEvent):void {
			busy = e.data;
		}
		
		private function onPageSubmit(e:AppEvent):void {
			var time:Number = 0;
			var data:Object = e.data;
			
			busy = true;
			if (view) {
				time = view.hide();
			}
			
			switch (data.sender) {
				case mcCastScreen:
					view = mcCharacterEditor;
					break;
					
				case mcCharacterEditor:	
					view = mcShareScreen;
					break;
					
				//case mcFaceAlignmentScreen:
					//view = mcChooseSceneScreen;
					//break;
					//
				//case mcChooseSceneScreen:
					//view = mcFaceAlignmentScreen;
					//break;
					
				default:
			}
			
			if (!view) {
				return;
			}
			time = view.show(time);
			
			TweenMax.delayedCall(time, showPageComplete);
		}
		
		private function showPageComplete():void {
			TweenMax.killAll();
			busy = false;
		}
		
		public function set busy(value:Boolean):void {
			if (value) {
				mcLoading.show();
				mcPreventer.visible = true;
				TweenMax.to(mcPreventer, 0.6, { alpha:0.3, ease:Linear.easeNone });
			} else {
				TweenMax.to(mcPreventer, 0.6, { alpha:0, ease:Linear.easeNone, onComplete:hidePreventerCompolete });
			}
		}
		
		private function hidePreventerCompolete():void {
			mcLoading.hide();
			mcPreventer.visible = false;
		}
		
	}

}
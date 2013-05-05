package com.pocari.view 
{
	import com.pocari.events.AppEvent;
	import com.pocari.FbService;
	import com.pocari.view.base.Popup;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SignUpPopup extends Popup
	{
		private var defaults			:Object = {
			email: 'Email',
			password: 'Mật khẩu',
			confirmPassword: 'Xác nhận mật khẩu'
		};
		
		public var txtEmail				:TextField;
		public var txtPassword			:TextField;
		public var txtConfirmPassword	:TextField;
		
		public var chbMen				:MovieClip;
		public var chbWomen				:MovieClip;
		
		public var chbAge1				:MovieClip;
		public var chbAge2				:MovieClip;
		public var chbAge3				:MovieClip;
		public var chbAge4				:MovieClip;
		
		public var chbAnswer1			:MovieClip;
		public var chbAnswer2			:MovieClip;
		public var chbAnswer3			:MovieClip;
		public var chbAnswer4			:MovieClip;
		public var chbAnswer5			:MovieClip;
		
		public var chbDisagree			:MovieClip;
		
		public var btnClose				:SimpleButton;
		public var btnSubmit			:SimpleButton;
		public var btnLoginFacebook		:SimpleButton;
		
		public function SignUpPopup() {
			
		}
		
		public override function init(data:Object = null):void {
			super.init();
			
			this.tabChildren = false;
			
			chbMen.buttonMode = true;
			chbMen.mcHit.width = 50;
			chbMen.addEventListener(MouseEvent.CLICK, onClickGenderCheckbox);
			
			chbWomen.buttonMode = true;
			chbWomen.mcHit.width = 40;
			chbWomen.addEventListener(MouseEvent.CLICK, onClickGenderCheckbox);
			
			chbAge1.buttonMode = true;
			chbAge1.mcHit.width = 86;
			chbAge1.addEventListener(MouseEvent.CLICK, onClickAgeCheckbox);
			
			chbAge2.buttonMode = true;
			chbAge2.mcHit.width = 110;
			chbAge2.addEventListener(MouseEvent.CLICK, onClickAgeCheckbox);
			
			chbAge3.buttonMode = true;
			chbAge3.mcHit.width = 104;
			chbAge3.addEventListener(MouseEvent.CLICK, onClickAgeCheckbox);
			
			chbAge4.buttonMode = true;
			chbAge4.mcHit.width = 84;
			chbAge4.addEventListener(MouseEvent.CLICK, onClickAgeCheckbox);
			
			chbAnswer1.buttonMode = true;
			chbAnswer1.mcHit.width = 84;
			chbAnswer1.addEventListener(MouseEvent.CLICK, onClickAnswerCheckbox);
			
			chbAnswer2.buttonMode = true;
			chbAnswer2.mcHit.width = 130;
			chbAnswer2.addEventListener(MouseEvent.CLICK, onClickAnswerCheckbox);
			
			chbAnswer3.buttonMode = true;
			chbAnswer3.mcHit.width = 106;
			chbAnswer3.addEventListener(MouseEvent.CLICK, onClickAnswerCheckbox);
			
			chbAnswer4.buttonMode = true;
			chbAnswer4.mcHit.width = 166;
			chbAnswer4.addEventListener(MouseEvent.CLICK, onClickAnswerCheckbox);
			
			chbAnswer5.buttonMode = true;
			chbAnswer5.mcHit.width = 110;
			chbAnswer5.addEventListener(MouseEvent.CLICK, onClickAnswerCheckbox);
			
			chbDisagree.buttonMode = true;
			chbDisagree.addEventListener(MouseEvent.CLICK, onClickDisagreeCheckbox);
			
			btnClose.addEventListener(MouseEvent.CLICK, onClickCloseFacebook);
			
			btnSubmit.addEventListener(MouseEvent.CLICK, onClickSubmitFacebook);
			
			btnLoginFacebook.addEventListener(MouseEvent.CLICK, onClickLoginViaFacebook);
			
			if (FbService.instance.initialized) {
				btnLoginFacebook.alpha = 0.6;
				btnLoginFacebook.mouseEnabled = false;
				
				FbService.instance.addEventListener(AppEvent.FB_INITIALIZED, onFacebookInitializedHandler);
			}
		}
		
		private function onFacebookInitializedHandler(e:AppEvent):void {
			btnLoginFacebook.alpha = 1;
			btnLoginFacebook.mouseEnabled = true;
		}
		
		private function onClickGenderCheckbox(e:MouseEvent):void {
			if (chbMen == e.currentTarget) {
				chbMen.gotoAndStop(2);
				chbWomen.gotoAndStop(1);
			} else {
				chbMen.gotoAndStop(1);
				chbWomen.gotoAndStop(2);
			}
		}
		
		private function onClickAgeCheckbox(e:MouseEvent):void {
			chbAge1.gotoAndStop(1);
			chbAge2.gotoAndStop(1);
			chbAge3.gotoAndStop(1);
			chbAge4.gotoAndStop(1);
			
			e.currentTarget.gotoAndStop(2);
		}
		
		private function onClickAnswerCheckbox(e:MouseEvent):void {
			chbAnswer1.gotoAndStop(1);
			chbAnswer2.gotoAndStop(1);
			chbAnswer3.gotoAndStop(1);
			chbAnswer4.gotoAndStop(1);
			chbAnswer5.gotoAndStop(1);
			
			e.currentTarget.gotoAndStop(2);
		}
		
		private function onClickDisagreeCheckbox(e:MouseEvent):void {
			if (chbDisagree.currentFrame == 1) {
				chbDisagree.gotoAndStop(2);
			} else {
				chbDisagree.gotoAndStop(1);
			}
		}
		
		private function onClickCloseFacebook(e:MouseEvent):void {
			
		}
		
		private function onClickSubmitFacebook(e:MouseEvent):void {
			
		}
		
		private function onClickLoginViaFacebook(e:MouseEvent):void {
			FbService.instance.login();
		}
		
	}

}
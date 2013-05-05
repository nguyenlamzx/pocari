package com.pocari.view 
{
	import com.pocari.view.base.Popup;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SignInPopup extends Popup 
	{
		
		
		public var txtEmail				:TextField;
		public var txtPassword			:TextField;
		
		public var btnClose				:SimpleButton;
		public var btnSubmit			:SimpleButton;
		public var btnLoginFacebook		:SimpleButton;
		public var btnForgotPassword	:SimpleButton;
		
		public function SignInPopup() {
			
		}
		
		override public function init(data:Object = null):void {
			super.init(data);
			
			btnClose.addEventListener(MouseEvent.CLICK, onClickClose);
			btnSubmit.addEventListener(MouseEvent.CLICK, onClickSubmit);
			btnLoginFacebook.addEventListener(MouseEvent.CLICK, onClickLoginFacebook);
			btnForgotPassword.addEventListener(MouseEvent.CLICK, onClickForgotPassword);
		}
		
		private function onClickClose(e:MouseEvent):void {
			
		}
		
		private function onClickSubmit(e:MouseEvent):void {
			
		}
		
		private function onClickLoginFacebook(e:MouseEvent):void {
			
		}
		
		private function onClickForgotPassword(e:MouseEvent):void {
			
		}
	}

}
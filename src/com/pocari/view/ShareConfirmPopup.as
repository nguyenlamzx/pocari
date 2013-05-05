package com.pocari.view 
{
	import com.pocari.view.base.Popup;
	import com.pocari.view.components.Button;
	import flash.events.MouseEvent;
	
	public class ShareConfirmPopup extends Popup 
	{
		public var btnClose:Button;
		public var btnSignUp:Button;
		public var btnSignIn:Button;
		
		public function ShareConfirmPopup() {
			
		}
		
		override public function init(data:Object = null):void {
			super.init(data);
			
			btnClose.addEventListener(MouseEvent.CLICK, onClickCloseButton);
			btnSignUp.addEventListener(MouseEvent.CLICK, onClickSignUpButton);
			btnSignIn.addEventListener(MouseEvent.CLICK, onClickSignInButton);
		}
		
		private function onClickCloseButton(e:MouseEvent):void {
			
		}
		
		private function onClickSignUpButton(e:MouseEvent):void {
			
		}
		
		private function onClickSignInButton(e:MouseEvent):void {
			
		}
		
	}

}
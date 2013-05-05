package com.pocari.view 
{
	import com.pocari.view.base.Popup;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SharePopup extends Popup 
	{
		
		public var txtEmail1	:TextField;
		public var txtEmail2	:TextField;
		public var txtEmail3	:TextField;
		public var txtEmail4	:TextField;
		public var txtEmail5	:TextField;
		
		public var btnClose		:SimpleButton;
		public var btnSubmit	:SimpleButton;
		
		public function SharePopup() {
			
		}
		
		override public function init(data:Object = null):void {
			super.init(data);
			
			btnClose.addEventListener(MouseEvent.CLICK, onClickClose);
			btnSubmit.addEventListener(MouseEvent.CLICK, onClickSubmit);
		}
		
		private function onClickClose(e:MouseEvent):void {
			
		}
		
		private function onClickSubmit(e:MouseEvent):void {
			
		}
		
	}

}
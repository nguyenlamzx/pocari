package com.pocari.view.screen 
{
	import com.pocari.view.base.Screen;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	public class ShareScreen extends Screen 
	{
		public var mcPreviewer					:MovieClip;
		public var mcBackgroundContentShare		:MovieClip;
		
		public var btnEmail						:SimpleButton;
		public var btnCancel					:SimpleButton;
		public var btnContinue					:SimpleButton;
		public var btnFacebook					:SimpleButton;
		
		public var txtShareContent				:TextField;
		
		public function ShareScreen() {
			super();
			
		}
		
	}

}
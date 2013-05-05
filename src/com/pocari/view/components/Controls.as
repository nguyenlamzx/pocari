package com.pocari.view.components 
{
	import com.lifeguard.model.GlobalModel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Controls extends Sprite 
	{
		public var mcRotateLeft		:MovieClip;
		public var mcRotateRight	:MovieClip;
		public var mcZoomIn			:MovieClip;
		public var mcZoomOut		:MovieClip;
		public var mcMoveLeft		:MovieClip;
		public var mcMoveUp			:MovieClip;
		public var mcMoveDown		:MovieClip;
		public var mcMoveRight		:MovieClip;
		
		public function Controls() 
		{
			mcRotateLeft.buttonMode = true;
			mcRotateRight.buttonMode = true;
			mcZoomIn.buttonMode = true;
			mcZoomOut.buttonMode = true;
			mcMoveLeft.buttonMode = true;
			mcMoveUp.buttonMode = true;
			mcMoveDown.buttonMode = true;
			mcMoveRight.buttonMode = true;
			
			//click
			mcRotateLeft.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcRotateRight.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcZoomIn.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcZoomOut.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcMoveLeft.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcMoveUp.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcMoveDown.addEventListener(MouseEvent.CLICK, onClickHandler);
			mcMoveRight.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			//over
			mcRotateLeft.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcRotateRight.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcZoomIn.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcZoomOut.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcMoveLeft.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcMoveUp.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcMoveDown.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			mcMoveRight.addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			
			//out
			mcRotateLeft.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcRotateRight.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcZoomIn.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcZoomOut.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcMoveLeft.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcMoveUp.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcMoveDown.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			mcMoveRight.addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			
		}
		
		private function onOutHandler(e:MouseEvent):void 
		{
			e.currentTarget.mcBG.gotoAndStop(1);
		}
		
		private function onOverHandler(e:MouseEvent):void 
		{
			e.currentTarget.mcBG.gotoAndStop(2);
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case mcRotateLeft:
					GlobalModel.currentScene.rotationZ -= 2;
					break;
				case mcRotateRight:
					GlobalModel.currentScene.rotationZ += 2;
					break;
				case mcZoomIn:
					GlobalModel.currentScene.scaleX += 0.06;
					GlobalModel.currentScene.scaleY += 0.06;
					break;
				case mcZoomOut:
					if(GlobalModel.currentScene.scaleX >= 0.2 && GlobalModel.currentScene.scaleY >= 0.2){
						GlobalModel.currentScene.scaleX -= 0.06;
						GlobalModel.currentScene.scaleY -= 0.06;
					}
					break;
				case mcMoveLeft:
					GlobalModel.currentScene.x -= 5;
					break;
				case mcMoveRight:
					GlobalModel.currentScene.x += 5;
					break;
				case mcMoveUp:
					GlobalModel.currentScene.y -= 5;
					break;
				case mcMoveDown:
					GlobalModel.currentScene.y += 5;
					break;
				default:
					break;
			}
		}
		
		
		
	}

}
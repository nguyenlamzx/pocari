package com.pocari.view.components 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	public class ScrollController 
	{
		private var direction		:int;
		private var moveDistance	:int = 5;
		private var yOffset			:Number;
		
		private var oldYPos			:Number;
		private var oldYPosSeek		:Number;
		private var isActive		:Boolean;
		
		private var timer			:Timer;
		
		private var stage			:Stage;
		
		private var _btnUp			:Sprite;
		private var _btnDown		:Sprite;
		private var _btnSeek		:Sprite;
		private var _hasResizeSeek	:Boolean;
		
		private var track			:Sprite;
		private var masker			:Sprite;
		private var target			:Sprite;
		
		public function ScrollController() {
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, onTimerEventHandler);
		}
		
		public function init(target:Sprite, masker:Sprite, options:Object):void {
			if (!target || !(target.stage) || !masker) {
				throw new Error("Error!!");
			}
			
			this.target = target;
			this.masker = masker;
			
			options = options || { };
			
			this.track = options.track || this.masker;
			this.moveDistance = options.moveDistance || this.moveDistance;
			
			_btnSeek = options.seek || (new Sprite);
			_btnSeek.buttonMode = true;
			_btnSeek.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSeekButtonHandler);
			
			_btnUp = options.up || (new Sprite);
			_btnUp.buttonMode = true;
			_btnUp.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDownArrowHandler);
			
			_btnDown = options.down || (new Sprite);
			_btnDown.buttonMode = true;
			_btnDown.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownUpArrowHandler);
			
			_hasResizeSeek = options.hasResize || false;
			
			_btnUp.buttonMode = true;
			_btnDown.buttonMode = true;
			_btnSeek.buttonMode = true;
			
			stage = this.target.stage;
			this.target.mask = this.masker;
		}
		
		public function update():void {
			
			_btnSeek.y = this.track.y;
			this.target.y = this.masker.y;
			
			//yMin = 0;
			//yMax = this.masker.height - _btnSeek.height;
			ExternalInterface.call('console.log', target.height > masker.height);
			isActive = (target.height > masker.height);
			
			track.visible = isActive;
			_btnUp.visible = isActive;
			_btnDown.visible = isActive;
			_btnSeek.visible = isActive;
			
			if (isActive == false) {
				return;
			}
			
			if (_hasResizeSeek) {
				var heightSeeker:int = masker.height * track.height / target.height;
			
				this.btnSeek.height = Math.max(heightSeeker, btnSeek.height / btnSeek.scaleY);
			}
			
			
			
			this.moveDistance = moveDistance;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//						SEEK BUTTON EVENT LISTENER							//
		//////////////////////////////////////////////////////////////////////////////
		private function onMouseDownSeekButtonHandler(evt:MouseEvent):void {
			oldYPos = evt.stageY;
			oldYPosSeek = btnSeek.y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStageHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUpStageHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStageHandler);
		}
		
		private function onMouseMoveStageHandler(evt:MouseEvent):void {
			updatetarget(evt.stageY - oldYPos);
			//oldYPos = evt.stageY;
		}
		
		private function onMouseUpStageHandler(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStageHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUpStageHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStageHandler);
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//					UP / DOWN ARROW EVENT LISTENER							//
		//////////////////////////////////////////////////////////////////////////////
		private function onMouseDownDownArrowHandler(evt:MouseEvent):void {
			direction = -1;
			timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			timer.start();
			
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, onMouseUpArrowHandler);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_UP, onMouseUpArrowHandler);
		}
		
		private function onMouseDownUpArrowHandler(evt:MouseEvent):void {
			direction = 1;
			timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			timer.start();
			
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, onMouseUpArrowHandler);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_UP, onMouseUpArrowHandler);
		}
		
		private function onMouseUpArrowHandler(evt:MouseEvent):void {
			timer.stop();
			
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUpArrowHandler);
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpArrowHandler);
		}
		
		/**
		 * 
		 * Update target position according to seek button's position
		 * 
		 */
		private function updatetarget(distance:int = 0):void {
			btnSeek.y = oldYPosSeek + distance;
			
			if (btnSeek.y < track.y) {
				btnSeek.y = track.y;
			} else if (btnSeek.y > track.height - btnSeek.height + track.y) {
				btnSeek.y = track.height - btnSeek.height + track.y;
			}
			
			// calculate new position of target
			var percent:Number = (btnSeek.y - track.y) / (track.height - btnSeek.height);
			var yPos:Number = -percent * (target.height - masker.height) + masker.y;
			
			target.y = yPos;
			//TweenLite.to(target, 0.5, {y:yPos, ease:Linear.easeInOut});
			//Tweener.addTween(target, { y:yPos, time:0.5, transition:"easeOutCubic" } );
		}
		
		private function onTimerEventHandler(e:TimerEvent):void {
			oldYPosSeek = btnSeek.y;
			updatetarget(direction * moveDistance);
		}
		
		public function dispose():void {
			btnSeek.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSeekButtonHandler);
			btnUpArrow.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDownArrowHandler);
			btnDownArrow.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownUpArrowHandler);
			timer.removeEventListener(TimerEvent.TIMER, onTimerEventHandler);
		}
		
		public function get btnUpArrow():Sprite {
			return _btnUp;
		}
		
		public function set btnUpArrow(value:Sprite):void {
			_btnUp = value;
		}
		
		public function get btnDownArrow():Sprite {
			return _btnDown;
		}
		
		public function set btnDownArrow(value:Sprite):void {
			_btnDown = value;
		}
		
		public function get btnSeek():Sprite {
			return _btnSeek;
		}
		
		public function set btnSeek(value:Sprite):void {
			_btnSeek = value;
		}
		
	}

}
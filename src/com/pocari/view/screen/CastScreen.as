package com.pocari.view.screen
{
	import com.pocari.events.AppEvent;
	import com.pocari.model.AppConstants;
	import com.pocari.model.CharacterItem;
	import com.pocari.model.clsModel;
	import com.pocari.view.base.Screen;
	import com.pocari.view.components.CharacterView;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class CastScreen extends Screen 
	{
		public var mcTab1 		:MovieClip;
		public var mcTab2 		:MovieClip;
		public var mcCasters	:MovieClip;
		
		public var btnNext		:SimpleButton;
		public var btnFinish	:SimpleButton;
		public var btnCancel	:SimpleButton;
		
		public function CastScreen() {
			
		}
		
		override public function init(data:Object = null):void {
			super.init(data);
			
			mouseChildren = false;
			
			mcTab1.mcTabButton.buttonMode = true;
			mcTab1.btnFinish.addEventListener(MouseEvent.CLICK, onClickFinishHandler);
			mcTab1.btnCreateCharacter.addEventListener(MouseEvent.CLICK, onClickCreateCharacterHandler);
			mcTab1.mcTabButton.addEventListener(MouseEvent.CLICK, onClickTab1Handler);
			mcTab1.mcItems.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownItemHandler);
			
			mcTab2.visible = false;
			mcTab2.mcTabButton.buttonMode = true;
			mcTab2.mcTabButton.addEventListener(MouseEvent.CLICK, onClickTab2Handler);
			mcTab2.mcItems.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownItemHandler);
			
			btnNext.addEventListener(MouseEvent.CLICK, onClickNextHandler);
			btnFinish.addEventListener(MouseEvent.CLICK, onClickFinishHandler);
			btnCancel.addEventListener(MouseEvent.CLICK, onClickCancelHandler);
		}
		
		private function onClickCreateCharacterHandler(e:MouseEvent):void {
			app.dispatchEvent(new AppEvent(AppEvent.SHOW_POPUP, { popup:AppConstants.GET_PICTURE_POPUP }));
		}
		
		/**
		 * DRAG AND DROP CHARACTERS
		 */
		private function onMouseDownItemHandler(e:MouseEvent):void {
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		private function onMouseUpHandler(e:MouseEvent):void {
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			
			//var point:Point = this.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			
			//var arrObject:Array = this.getObjectsUnderPoint(point);
			//trace(areInaccessibleObjectsUnderPoint(point);
			//trace(arrObject[0].parent);
		}
		
		private function onMouseMoveHandler(e:MouseEvent):void {
			
		}
		/* END DRAG AND DROP CHARACTERS */
		
		/**
		 * Change Tab
		 */
		private function onClickTab1Handler(e:MouseEvent = null):void {
			addChild(mcTab1);
			
			mcTab1.mcTabButton.gotoAndStop(2);
			mcTab2.mcTabButton.gotoAndStop(1);
		}
		
		private function onClickTab2Handler(e:MouseEvent = null):void {
			addChild(mcTab2);
			
			mcTab1.mcTabButton.gotoAndStop(1);
			mcTab2.mcTabButton.gotoAndStop(2);
		}
		/* END CHANGE TAB */
		
		/**
		 * LOAD ASSETS
		 */
		private function loadCasters():void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadCastersHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadCastersHandler);
			loader.load(new URLRequest(clsModel.xml.casters));
		}
		
		private function onCompleteLoadCastersHandler(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadCastersHandler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadCastersHandler);
			
			var casters:MovieClip = (e.currentTarget.content as MovieClip);
			
			mcCasters.addChild(casters);
			
			if (clsModel.listMyCharacters.length > 0) {
				loadNextContentTab2(-1);
				onClickTab1Handler();
			} else {
				loadNextContentTab1(-1);
			}
		}
		
		private function onErrorLoadCastersHandler(e:IOErrorEvent):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadCastersHandler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadCastersHandler);
			
			if (clsModel.listMyCharacters.length > 0) {
				loadNextContentTab2(-1);
				onClickTab1Handler();
			} else {
				loadNextContentTab1(-1);
			}
		}
		
		private function loadContentTab2(index:Number):void {
			var loader:Loader = new Loader();
			loader.name = index.toString();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadContentTab2Handler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadContentTab2Handler);
			loader.load(new URLRequest(clsModel.listCharactersSample[index].url), clsModel.fb.loaderContext);
		}
		
		private function onCompleteLoadContentTab2Handler(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadContentTab2Handler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadContentTab2Handler);
			
			var index:int = parseInt(e.currentTarget.loader.name);
			var image:Bitmap = e.currentTarget.content as Bitmap;
			var characterItem:CharacterItem = clsModel.listCharactersSample[index] as CharacterItem;
			
			characterItem.image = image.bitmapData;
			
			addModel(mcTab2, image);
			
			loadNextContentTab2(index);
		}
		
		public function addModel(tab:MovieClip, image:Bitmap):void {
			var characterView:CharacterView = new CharacterView();
			
			characterView.image = image.bitmapData;
			
			characterView.x = tab.mcItems.numChildren * (characterView.width + 3);
			tab.mcItems.addChild(characterView);
		}
		
		private function loadNextContentTab2(index:int):void {
			index++;
			
			if (index < clsModel.listCharactersSample.length) {
				loadContentTab2(index);
			} else if (clsModel.listMyCharacters.length > 0) {
				loadNextContentTab1(-1);
				onClickTab1Handler();
			} else {
				start();
			}
		}
		
		private function onErrorLoadContentTab2Handler(e:IOErrorEvent):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadContentTab2Handler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadContentTab2Handler);
			
			var index:int = parseInt(e.currentTarget.loader.name);
			loadNextContentTab2(index);
		}
		
		private function loadContentTab1(index:int):void {
			var loader:Loader = new Loader();
			loader.name = index.toString();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadContentTab1Handler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadContentTab1Handler);
			loader.load(new URLRequest(clsModel.listMyCharacters[index].url), clsModel.fb.loaderContext);
		}
		
		private function onCompleteLoadContentTab1Handler(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadContentTab1Handler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadContentTab1Handler);
			
			var index:int = parseInt(e.currentTarget.loader.name);
			var image:Bitmap = e.currentTarget.content as Bitmap;
			var characterItem:CharacterItem = clsModel.listMyCharacters[index] as CharacterItem;
			characterItem.image = image.bitmapData;
			
			addModel(mcTab1, image);
			
			loadNextContentTab1(index);
		}
		
		private function onErrorLoadContentTab1Handler(e:IOErrorEvent):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadContentTab1Handler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadContentTab1Handler);
			
			var index:int = parseInt(e.currentTarget.loader.name);
			loadNextContentTab1(index);
		}
		
		private function loadNextContentTab1(index:int):void {
			index++;
			
			if (index < clsModel.listMyCharacters.length) {
				loadContentTab1(index);
			} else {
				start();
			}
		}
		/* END LOAD ASSETS */
		
		private function start():void {
			mouseChildren = true;
		}
		
		override public function show(delay:Number = 0):Number {
			
			onClickTab2Handler();
			
			loadCasters();
			
			return super.show(delay);
		}
		
		private function onClickNextHandler(e:MouseEvent):void {
			
		}
		
		private function onClickFinishHandler(e:MouseEvent):void {
			
		}
		
		private function onClickCancelHandler(e:MouseEvent):void {
			
		}
		
	}

}
package com.pocari.view
{
	import com.greensock.TweenLite;
	import com.pocari.events.AppEvent;
	import com.pocari.model.clsModel;
	import com.pocari.model.FBDataAlbum;
	import com.pocari.view.base.Popup;
	import com.pocari.view.components.ScrollController;
	import com.sff.utils.TextFieldUtils;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	public class PhotoAlbum extends Popup
	{
		private var scroller:ScrollController;
		private var arrImages:Array;
		
		public function PhotoAlbum() {
		
		}
		
		override public function init(data:Object = null):void {
			super.init(data);
			
			if (!scroller) {
				scroller = new ScrollController();
				scroller.init(mcItems, mcMask, {seek: mcSeeker, track: mcTrack});
			}
			scroller.update();
			
			btnBack.visible = false;
			btnBack.addEventListener(MouseEvent.CLICK, hadleClickButtons);
			btnClose.addEventListener(MouseEvent.CLICK, onClickCloseHandler);
		}
		
		override public function show(delay:Number = 0):Number {
			clsModel.fb.getAlbums();
			clsModel.fb.addEventListener(AppEvent.FB_ALBUM_READY, onReadyFbAlbumHandler);
			
			return super.show(delay);
		}
		
		private function onReadyFbAlbumHandler(e:AppEvent):void {
			clsModel.fb.removeEventListener(AppEvent.FB_ALBUM_READY, onReadyFbAlbumHandler);
			
			var album:FBDataAlbum;
			var result:Object = e.data as Object;
			var i:int = 0;
			
			clsModel.clearAlbums();
			
			for each (var item:Object in result) {
				clsModel.addAlbum(new FBDataAlbum(item));
				i++;
			}
			
			reinit(clsModel.albums);
		}
		
		private function reinit(items:Array, child:Boolean = false):void {
			ExternalInterface.call('console.log', "reinit", items.length);
			
			btnClose.visible = !child;
			btnBack.visible = child;
			
			removeAllChilds();
			
			var data:Object;
			var item:MovieClip;
			var countX:Number = 0;
			var countY:Number = -1;
			var posY:Number = 0;
			var maxHeight:Number = 0;
			
			arrImages = [];
			for (var i:int = 0; i < items.length; i++) {
				data = items[i] as Object;
				
				if (child) {
					item = new PhotoItem();
					ExternalInterface.call('console.log', "reinit", data.source);
					arrImages.push( { target:item, url:data.source } );
					
					item.addEventListener(MouseEvent.CLICK, handleSelectedItem);
				} else {
					item = new AlbumItem();
					
					if (data.photos.length > 0) {
						arrImages.push( { target:item, url:data.photos[0].source } );						
					}
					
					item.txtName.text = data.name;
					item.txtCount.text = data.count + ' Photos';
					item.addEventListener(MouseEvent.CLICK, handleClickItem);
					
					TextFieldUtils.cutDownTextByWidth(item.txtName, item.txtName.width);
				}
				item.data = data;
				item.name = data.id;
				item.buttonMode = true;
				item.mouseChildren = false;
				
				item.alpha = 0.6;
				item.mouseEnabled = false;
				
				if ((i % 4) == 0) {
					countX = 0;
					item.x = 0;
					
					countY++;
					posY = maxHeight + 10;
				} else {
					countX++;
					item.x = countX * (item.width + 10);
				}
				
				item.y = posY;
				
				maxHeight = posY + item.height;
				
				mcItems.addChild(item);
				
			}
			
			if (arrImages.length > 0) {
				loadImages();
			}
			scroller.update();
			
			if (child) {
				txtName.text = 'Album\n' + data.name;
				txtName.y = 22;
			} else {
				txtName.text = 'Album Ảnh';
				txtName.y = 44;
			}
			
			mcItems.visible = true;
		}
		
		private function removeAllChilds():void {
			var item:MovieClip;
			
			while (mcItems.numChildren) {
				item = mcItems.removeChildAt(0) as MovieClip;
				item.data = null;
				item.removeEventListener(MouseEvent.CLICK, handleClickItem);
			}
		}
		
		private function loadImages():void {
			if (arrImages.length <= 0) {
				start();
				return;
			}
			var item:Object = arrImages[0] as Object;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadImageHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadImageHandler);
			loader.load(new URLRequest(item.url), clsModel.fb.loaderContext);
		}
		
		private function onErrorLoadImageHandler(e:IOErrorEvent):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadImageHandler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadImageHandler);
			ExternalInterface.call('console.log', "loadImages error");
			loadImages();
		}
		
		private function onCompleteLoadImageHandler(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoadImageHandler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadImageHandler);
			
			
			var item:Object = arrImages.shift() as Object;
			var image:Bitmap = e.currentTarget.content as Bitmap;
			var mcMask:MovieClip = (item.target.mcMask) as MovieClip;
			var mcImage:MovieClip = (item.target.mcImage) as MovieClip;
			
			if (item.data is PhotoItem) {
				item.data.bitmapData = image.bitmapData;
			}
			item.target.alpha = 1;
			item.target.mouseEnabled = true;
			
			mcImage.addChild(image);
			
			if (mcImage.width > mcMask.width) {
				mcImage.width = mcMask.width;
				mcImage.scaleY = mcImage.scaleX;
			}
			if (mcImage.height > mcMask.height) {
				mcImage.height = mcMask.height;
				mcImage.scaleX = mcImage.scaleY;
			}
			mcImage.x = (mcMask.width - mcImage.width) / 2;
			mcImage.y = (mcMask.height - mcImage.height) / 2;
			
			loadImages();
		}
		
		private function start():void {
			
		}
		
		private function handleSelectedItem(e:MouseEvent):void {
			var item:MovieClip;
			item = e.currentTarget as MovieClip;
			
			app.dispatchEvent(new AppEvent(AppEvent.SELECTED_IMAGE, { data:item.data.bitmapData, sender:this } ));
		}
		
		private function handleClickItem(e:MouseEvent):void {
			var item:MovieClip = e.currentTarget as MovieClip;
			TweenLite.delayedCall(0.5, reinit, [item.data.photos, true]);
			
			mcItems.visible = false;
		}
		
		private function hadleClickButtons(e:MouseEvent):void {
			mcItems.visible = false;
			TweenLite.delayedCall(0.5, reinit, [clsModel.albums]);
		}
	
	}

}
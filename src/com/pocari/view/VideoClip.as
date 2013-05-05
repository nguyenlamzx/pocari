package com.pocari.view 
{
	import com.pocari.view.components.ScrollController;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author 
	 */
	public class VideoClip extends MovieClip 
	{
		private var scroller:ScrollController;
		
		private var netStream				:NetStream;
		private var video					:Video;
		private var videoInfo				:Object;
		private var isPlaying				:Boolean;
		private var curVideoIndex			:int;
		private var arrImages				:Array = [];
		
		private var arrVideos				:Array = [  { video:'../www/flvs/video01.flv', image:'../www/images/imgVideo1.jpg', name:'video 1'},
														{ video:'../www/flvs/video02.flv', image:'../www/images/imgVideo2.jpg',name:'video 2' },
														{ video:'../www/flvs/video03.flv', image:'../www/images/imgVideo3.jpg',name:'video 3' },
														{ video:'../www/flvs/video04.flv', image:'../www/images/imgVideo4.jpg',name:'video 4' }
													];
													
		
		public function VideoClip() 
		{
			initialize();
		}
		
		private function initialize():void {
			txtName.autoSize = TextFieldAutoSize.LEFT;
			
			mcVideoHit.btnPlayPause.addEventListener(MouseEvent.CLICK, handleClickButton);
			
			mcVideoHit.buttonMode = true;
			mcVideoHit.addEventListener(MouseEvent.MOUSE_OVER,handleVideoHitEvent)
			mcVideoHit.addEventListener(MouseEvent.MOUSE_OUT,handleVideoHitEvent)
			
			initVideo();
			
			addItems();
			
			if (!scroller) {
				scroller = new ScrollController ();
				scroller.init(mcItems, mcMask, { seek: mcSeeker,track:mcTrack });
		    }
		   
		    scroller.update();
		   
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//								VIDEO ITEM									//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Add video items
		 */
		private function addItems():void {
			var item:MovieClip;
			
			for (var i:int = 0; i < 4; i++) 
			{
				item = new McItem();
				item.name = i.toString();
				
				item.y = i * (item.height + 5);
				
				item.buttonMode = true;
				item.mouseChildren = false;
				item.addEventListener(MouseEvent.CLICK, handleClickItem);
					
				mcItems.addChild(item);
			}
			
			activeVideo(0);
		}
		
		
		/**
		 * Handle click video item
		 * @param	e
		 */
		private function handleClickItem(e:MouseEvent):void 
		{
			var index:int = parseInt(e.currentTarget.name);
			
			if (curVideoIndex == index) {
				return;
			}
			
			curVideoIndex = index;
			
			netStream.pause();
			activeVideo(curVideoIndex);
		}
		
		private function activeVideo(index:int):void {
			loadImage(index);
			txtName.text = arrVideos[index].name;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//									IMAGE									//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Load image
		 * @param	path
		 */
		private function loadImage(index:int):void {
			if (arrImages[index]) {
				showImage(arrImages[index]);
			}else if (arrVideos[index].image) {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageErrorHandler);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImageCompleteHandler);
				loader.load(new URLRequest(arrVideos[index].image));
			}
		}
		
		/**
		 * Load image error
		 * @param	evt
		 */
		private function onLoadImageErrorHandler(evt:IOErrorEvent):void {
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onLoadImageErrorHandler);
		}
		
		/**
		 * Load image complete
		 * @param	evt
		 */
		private function onLoadImageCompleteHandler(evt:Event):void {
			evt.currentTarget.removeEventListener(Event.COMPLETE, onLoadImageCompleteHandler);
			
			var img:Bitmap = evt.currentTarget.content as Bitmap;
			arrImages.push(evt.currentTarget.content as Bitmap);
			
			showImage(img);
			
		}
		
		private function showImage(img:Bitmap):void {
			img.smoothing = true;
			img.width = mcVideoMask.width;
			img.height = mcVideoMask.height;
			img.smoothing = true;
			
			mcImage.addChild(img);
			
			showThumbVideo();
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//									VIDEO									//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Load video
		 * @param	path
		 */
		private function initVideo():void {
			
			var netConn:NetConnection = new NetConnection();
			netConn.connect(null);

			netStream  = new NetStream(netConn);
			netStream.bufferTime = 2;
			netStream.client = new Object();
			netStream.client.onMetaData = onMetaDataHandler;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);

			video = new Video(mcVideoMask.width, mcVideoMask.height);
			
			video.visible = false;
			video.smoothing = true;
			mcVideo.addChild(video);
			video.attachNetStream(netStream);
		}
		
		/**
		 * Event listener for meta data
		 * 
		 * @param	info
		 */
		private function onMetaDataHandler(info:Object):void {
			videoInfo = info;
			
			video.visible = true;
			
			setVolume(1);
		}
		
		/**
		 * Event listener for Net Status
		 * 
		 * @param	evt
		 */
		private function onNetStatusHandler(evt:NetStatusEvent):void {
			switch (evt.info.code) {
				case "NetStream.Play.Start":
					mcVideo.visible = true;
					mcImage.visible = false;
					break;
				
				case "NetStream.Play.Stop":
					if (Math.floor(netStream.time - videoInfo.duration) <= 1) {
						showThumbVideo();
						
					}
					
					break;
			}
		}
		
		private function showThumbVideo():void {
			isPlaying = false;
			mcVideoHit.btnPlayPause.gotoAndStop("play");
			mcVideoHit.btnPlayPause.visible = true;
			
			mcVideo.visible = false;
			mcImage.visible = true;
		}
		
		/**
		 * Set volume
		 * @param	vol
		 */
		private function setVolume(vol:Number):void {
			if (vol > 1) vol = 1;
			if (vol < 0) vol = 0;
			
			var sTransform:SoundTransform = new SoundTransform();
			sTransform.volume = vol;
			
			netStream.soundTransform = sTransform;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//									BUTTON									//
		//////////////////////////////////////////////////////////////////////////////
		private function handleClickButton(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
					case mcVideoHit.btnPlayPause:
						
						if (e.currentTarget.currentLabel == "play") {
							if (!isPlaying) {
								netStream.play(arrVideos[curVideoIndex].video);	
							} else {
								netStream.resume();
							}
							mcVideoHit.btnPlayPause.gotoAndStop("pause");
							isPlaying = true;
							
						} else {
							if (netStream!=null) {
								netStream.pause();
							}
							
							e.currentTarget.gotoAndStop("play");
						}
						
						break;
			}
		}
		
		private function handleVideoHitEvent(e:MouseEvent):void 
		{
			switch(e.type) {
				case MouseEvent.MOUSE_OVER:
					mcVideoHit.btnPlayPause.visible = true;
					break;
					
				case MouseEvent.MOUSE_OUT:
					mcVideoHit.btnPlayPause.visible = false;
					break;
			}
		}
		
	}

}
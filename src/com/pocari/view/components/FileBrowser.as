package com.pocari.view.components 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	public class FileBrowser {
		
		private var file:FileReference;
		
		public function FileBrowser() {
			file = new FileReference();
            configureListeners(file);
            file.browse(getTypes());
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.CANCEL, cancelHandler);
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(Event.SELECT, selectHandler);
            dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
        }

        private function getTypes():Array {
            var allTypes:Array = new Array(getImageTypeFilter(), getTextTypeFilter());
            return allTypes;
        }

        private function getImageTypeFilter():FileFilter {
            return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
        }

        private function getTextTypeFilter():FileFilter {
            return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
        }

        private function cancelHandler(event:Event):void {
            trace("cancelHandler: " + event);
        }

        private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
        }

        private function uploadCompleteDataHandler(event:DataEvent):void {
            trace("uploadCompleteData: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            var file:FileReference = FileReference(event.target);
            trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private function selectHandler(event:Event):void {
            var file:FileReference = FileReference(event.target);
            trace("selectHandler: name=" + file.name + " URL=" + uploadURL.url);
            //file.upload(uploadURL);
        }
	}

}
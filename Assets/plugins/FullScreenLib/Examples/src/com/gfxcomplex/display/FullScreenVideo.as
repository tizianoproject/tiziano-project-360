package com.gfxcomplex.display 
{
	import com.gfxcomplex.display.events.VideoStatusEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author Josh Chernoff | josh@gfxcomplex.com
	 * @version beta 1  2/22/09
	 * @usage FullScreenVideo will take any supported video and scale it in a number of ways to fit the whole screen
	 * @example var video:FullScreenVideo = new FullScreenVideo("iStock_000004476203HD720.mp4", FullScreenAlign.BOTTOM_RIGHT, true);
	 */
	
	public class FullScreenVideo extends Sprite
	{
		private var _bitmapSmoothing	:Boolean;
		private var _contentHolder		:Sprite;		
		private var _initStage			:Boolean = false;
		private var _initLoad			:Boolean = false;		
		private var _align				:String;
		private var _loop				:int;
		private var _looped				:int = 1;

		
		
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var video:Video;	
		
		public function FullScreenVideo(url:String, align:String = "TL", buffer:Number = 0.1, loop:int = 0, bitmapSmoothing:Boolean = false) 
		{
			_align = align;	
			_bitmapSmoothing = bitmapSmoothing;
			_loop = loop;
			_contentHolder = new Sprite();
				
			addChild(_contentHolder);
			
			var customClient:Object = new Object();
                //customClient.onMetaData = onMetaDataHandler;  
				//customClient.onPlayStatus = onPlayStatusHandler;
				customClient.netStatus = onNetStatusHandler;
		
			
			nc = new NetConnection();
				nc.connect(null);			
			
			ns = new NetStream(nc);
				ns.bufferTime = buffer;
				ns.client = customClient;
				ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function():void { } );
				ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);

			
			
			video = new Video();						
				video.smoothing = bitmapSmoothing;			
				video.attachNetStream(ns);
			
			ns.play(url);
			
			_contentHolder.addChild(video);	

			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onNetStatusHandler(netStatus:Object):void
		{
			trace(netStatus.info);
		}
		
		private function onPlayStatusHandler(playStatus:Object):void
		{
			trace(playStatus, "onPlayStatusHandler");
		}
		
		private function onStatus(e:NetStatusEvent):void 
		{
			//trace(e.info.code);
			//trace(ns.bytesTotal, ns.bufferLength, ns.bufferTime, ns.bytesLoaded);
			
			switch(e.info.code) {
				case "NetStream.Play.Start":
					this.dispatchEvent(new VideoStatusEvent(VideoStatusEvent.ON_STATUS, "Started"));
					break;
				case "NetStream.Buffer.Flush":
					this.dispatchEvent(new VideoStatusEvent(VideoStatusEvent.ON_STATUS, "Buffer.Flush"));
					break;
				case "NetStream.Buffer.Full":
					this.dispatchEvent(new VideoStatusEvent(VideoStatusEvent.ON_STATUS, "Buffer.Full"));
					break;
				case "NetStream.Play.Stop":
					if (_loop == 0) {
						ns.seek(0);
						this.dispatchEvent(new VideoStatusEvent(VideoStatusEvent.ON_STATUS, "Looping"));
						return
					} else if (_looped == _loop) {					
						this.dispatchEvent(new VideoStatusEvent(VideoStatusEvent.ON_STATUS, "Completed"));
						return;
					} else {					
						ns.seek(0);
						_looped++;
						this.dispatchEvent(new VideoStatusEvent(VideoStatusEvent.ON_STATUS, "Looping"));
						return
					}
					
			}

		}
		public function distroy():void {
			
		}	
		public function onMetaDataHandler(imageData:Object):void {
				video.width = imageData.width;
				video.height = imageData.height;
				onStageResize(null);
            }

		
		//STAGE EVENTS				
		private function onAddedToStage(e:Event):void 
		{
			_initStage = true;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			stage.addEventListener(Event.RESIZE, onStageResize); //listen to stage for scale chages.	
			
			onStageResize(null); //initlize image scaling.			
			if (_initLoad && _initStage){
				onStageResize(null);
			}
		}
		private function onRemovedFromStage(e:Event):void 
		{
			stage.removeEventListener(Event.RESIZE, onStageResize); //listen to stage for scale chages.	
		}
		
		private function onStageResize(e:Event):void 
		{
			if (  _contentHolder is Sprite) {
				
				var sH:Number = stage.stageHeight;
				var sW:Number = stage.stageWidth;
				
				switch(_align) {
					
					case "TL":						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;
						
					case "T":						
						video.x = -(video.width >> 1);
						_contentHolder.x = sW;
						
						_contentHolder.x = sW >> 1;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;	
				
					case "TR":						
						video.x = -(video.width);
						_contentHolder.x = sW;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;	
					case "CL":
						video.y = -(video.height >> 1);
						_contentHolder.y = sH >> 1;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;	
						
					case "C":
						video.y = -(video.height >> 1);
						video.x = -(video.width >> 1);
						
						_contentHolder.y = sH >> 1;
						_contentHolder.x = sW >> 1;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;
					case "CR":

						video.y = -(video.height >> 1);
						video.x = -(video.width);
						
						_contentHolder.y = sH >> 1;
						_contentHolder.x = sW;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;
					case "BL":

						video.y = -(video.height);
						
						_contentHolder.y = sH;
												
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;
					case "B":

						video.y = -(video.height);
						video.x = -(video.width >> 1);
						
						_contentHolder.y = sH;
						_contentHolder.x = sW >> 1;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;						
					case "BR":

						video.y = -(video.height);
						video.x = -(video.width);
						
						_contentHolder.y = sH;
						_contentHolder.x = sW;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;						
				}
			}			
		}
	}	
}
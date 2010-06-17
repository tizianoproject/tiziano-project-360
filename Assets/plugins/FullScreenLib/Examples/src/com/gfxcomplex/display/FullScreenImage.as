package com.gfxcomplex.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author Josh Chernoff | josh@gfxcomplex.com
	 * @version 1.3 - 12/01/09
	 * @usage FullScreenImage will take any displayObject and scale it in a number of ways to fit the whole screen
	 * @link http://gfxcomlpex.com/labs/full-screen-image
	 */
	
	public class FullScreenImage extends Sprite
	{
		private var _bitmapSmoothing	:Boolean;
		private var _contentHolder		:Sprite;		
		private var _initStage			:Boolean = false;
		private var _initLoad			:Boolean = false;		
		private var _align				:String;
		private var _loader				:Loader;
		private var _loaderContext		:LoaderContext;
			
		public function FullScreenImage(align:String = "TL", bitmapSmoothing:Boolean = false) 
		{		
			_align 				= align;				
			_bitmapSmoothing 	= bitmapSmoothing;					
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function load(url:String):void {
			_loader = new Loader();
			_loaderContext = new LoaderContext(_bitmapSmoothing);
			configureListeners(_loader.contentLoaderInfo);		
			_loader.load(new URLRequest(url), _loaderContext);
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
				var image:DisplayObject = _contentHolder.getChildAt(0);
				
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
						
						image.x = -(image.width >> 1);
						_contentHolder.x = sW >> 1;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;
						
					case "TR":
						image.x = -(image.width);
						_contentHolder.x = sW;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;	
						
					case "CL":
						image = _contentHolder.getChildAt(0);
						image.y = -(image.height >> 1);
						_contentHolder.y = sH >> 1;
						
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;	
						
					case "C":
						image.y = -(image.height >> 1);
						image.x = -(image.width >> 1);
						
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
						image.y = -(image.height >> 1);
						image.x = -(image.width);
						
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
						image.y = -(image.height);
						
						_contentHolder.y = sH;
												
						_contentHolder.width = sW;
						_contentHolder.scaleY = _contentHolder.scaleX;
						
						if (_contentHolder.height < sH) {
							_contentHolder.height = sH;
							_contentHolder.scaleX = _contentHolder.scaleY;
						}						
						break;
						
					case "B":
						image.y = -(image.height);
						image.x = -(image.width >> 1);
						
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
						image.y = -(image.height);
						image.x = -(image.width);
						
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
		
		//LOADER EVENTS
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, onLoadComplete);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
           
        }
		private function deconfigureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, onLoadComplete);
            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.removeEventListener(Event.INIT, initHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.removeEventListener(Event.OPEN, openHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
           
        }
		
		private function onLoadComplete(e:Event):void 
		{
			this.dispatchEvent(e);			
			_initLoad = true;
			_contentHolder = new Sprite();
			
			addChild(_contentHolder);
			
			if(_bitmapSmoothing){				
				var bitmap:Bitmap = e.target.loader.content as Bitmap;
				bitmap.smoothing = _bitmapSmoothing;				
				_contentHolder.addChild(bitmap);				
			}else {
				_contentHolder.addChild(e.target.loader as Loader);				
			}
			
			if (_initLoad && _initStage){
				onStageResize(null);
			}
			
			deconfigureListeners(_loader.contentLoaderInfo);
			_loader = null;
			
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			this.dispatchEvent(e);
		}
        private function httpStatusHandler(e:HTTPStatusEvent):void {
            this.dispatchEvent(e);
        }
        private function initHandler(e:Event):void {
			this.dispatchEvent(e);
        }
        private function ioErrorHandler(e:IOErrorEvent):void {
            this.dispatchEvent(e);
        }
        private function openHandler(e:Event):void {
            this.dispatchEvent(e);
        }
		
		public function get align():String { return _align; }		
		public function set align(value:String):void 
		{
			_align = value;
		}

	}	
}
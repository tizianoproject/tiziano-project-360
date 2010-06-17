package com.gfxcomplex.display 
{

	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author Josh Chernoff | GFX Complex ~ copyright 2009
	 */
	public class PanningFullScreenImage extends Sprite
	{
		private var _url:String;
		private var _smoothing:Boolean;
		private var _loader:Loader;
		private var _loaderContext:LoaderContext;
		
		private var _contentHolder:Sprite = new Sprite();
		
		private var _stageWidth:Number;
        private var _stageHeight:Number;		
		
		private var _xG:Boolean;
	
		
		//Testing vars 
		private var maxContentScale:Number = 1;
		protected var XminSize:int = 400;
		
		private var yPos:Number = 0;
		private var xPos:Number = 0;
		
		private var _img_prop:Number = 0;
		
		
		private var myTween:TweenLite;
		
		
		public function PanningFullScreenImage(url:String, smoothing:Boolean = false) 
		{
			_url = url;
			_smoothing = smoothing;
			
			_loaderContext 	= new LoaderContext(_smoothing);
			_loader			= new Loader();		
			
			configureListeners(_loader.contentLoaderInfo);	
			
			_loader.load(new URLRequest(_url), _loaderContext);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			stage.removeEventListener(Event.RESIZE, onStageResize);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var sP:Number;
			
			if (_xG)
			{				
		
				var xR:Number = _contentHolder.width - _stageWidth;
				sP = e.stageX / _stageWidth;
				var rX:Number = xR * sP;			
				
				myTween = TweenLite.to(_contentHolder, 2, { x: -rX } );
				
            }
			else 
			{				
				var yR:Number = _contentHolder.height - _stageHeight;
				sP = e.stageY / _stageHeight;				
				var rY:Number = yR * sP;
				
				myTween = TweenLite.to(_contentHolder, 2, {y:-rY});
            }		
		}
		
		private function onStageResize(e:Event):void 
		{
		
			_stageWidth = stage.stageWidth;
            _stageHeight = stage.stageHeight;	
			
			if (_stageHeight / _stageWidth > _contentHolder.height / _contentHolder.width)
			{				
				_xG = true;

				_contentHolder.height = _stageHeight;
				_contentHolder.scaleX = _contentHolder.scaleY;
				_contentHolder.y = 0;
				_contentHolder.x = -((_contentHolder.width - _stageWidth) >> 1)
				
            }
			else 
			{
				_xG = false;
		
               _contentHolder.width = _stageWidth;
               _contentHolder.scaleY = _contentHolder.scaleX;
			   _contentHolder.x = 0;
			   _contentHolder.y = -((_contentHolder.height - _stageHeight) >> 1);
			  
            }		
		}
		
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
			
			addChild(_contentHolder);
			
			if(_smoothing){				
				var bitmap:Bitmap = e.target.loader.content as Bitmap;
				bitmap.smoothing = _smoothing;				
				_contentHolder.addChild(bitmap);	
				bitmap.cacheAsBitmap = true;
			}else {
				var tempHolder:Loader = e.target.loader as Loader;
				tempHolder.cacheAsBitmap = true;
				_contentHolder.addChild(tempHolder);
				
			}
			_contentHolder.cacheAsBitmap = true;
			onStageResize(null);
			deconfigureListeners(_loader);
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function initHandler(e:Event):void 
		{
			this.dispatchEvent(e);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function openHandler(e:Event):void 
		{
			this.dispatchEvent(e);
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			this.dispatchEvent(e);
		}

		
		public function get url():String { return _url; }		
		public function get smoothing():Boolean { return _smoothing; }
		
	}
	
}
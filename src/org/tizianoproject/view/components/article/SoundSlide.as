package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.AVM1Movie;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.SwfLoad;
	import org.tizianoproject.view.CompositeView;
	
	public class SoundSlide extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 34, 110 );
		private static const DEFAULT_WIDTH:Number = 451;
		private static const DEFAULT_HEIGHT:Number = 375;
		

		private var loaderContext:LoaderContext;
		private var swfLoader:SwfLoad;
		private var swfLoad:Loader;
		private var swf:AVM1Movie;
		private var swfMask:Sprite
		private var container:Sprite
		
		public function SoundSlide()
		{ 
			loaderContext = new LoaderContext( true );
			
			x = DEFAULT_POS.x;
			y = DEFAULT_POS.y;
		}

		private function showSoundSlide():void
		{
			/************
			 * History:
			 * When SoundSlides loads, it loads as a 640 x 550 file which covers up  
			 * prev_btn && next_btn so give it a mask
			************/
			//Create a new Mask
			swfMask = new Sprite();
			swfMask.name = "swfMask";	
			ShowHideManager.addContent( (this as SoundSlide), swfMask );
			//Place the Soundslide in a container
			container = new Sprite();
			container.name = "container";
			container.mask = swfMask;
			ShowHideManager.addContent( container, swfLoad );
			//Draw a mask for the container
			redrawMask();
			//Add the container to the stage
			ShowHideManager.addContent( (this as SoundSlide), container );
		}
		
		private function redrawMask():void {
			with ( swfMask.graphics ) {
				beginFill( 0xffcc00, 1 );
				drawRect( container.x, container.y, DEFAULT_WIDTH, DEFAULT_HEIGHT );
				endFill();
			}
		}

		public function load( path:String ):void
		{
			/*
			swfLoader = new SwfLoad( new URLRequest( path ), loaderContext );
			swfLoader.addEventListener( LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			swfLoader.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			swfLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			swfLoader.start();
			*/
			swfLoad = new Loader();
			swfLoad.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			swfLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			swfLoad.addEventListener( IOErrorEvent.NETWORK_ERROR, onErrorHandler, false, 0, true );
			swfLoad.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onCompleteHandler, false, 0, true );
			swfLoad.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onCompleteHandler, false, 0, true );
			swfLoad.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true );
			swfLoad.load( new URLRequest( path ), loaderContext );
		}
		
		override protected function unload():void
		{
			trace( "SoundSlide::unload:" );	
			//Stop any possible sounds
			SoundMixer.stopAll();

			//Unload the Loader
			if( swf ){ swf = null; } 
			if( swfLoader ) swfLoader = null;
			if( container ) container = null;
			if( swfMask ) swfMask = null;
			if( swfLoad ) { 
				try{
					swfLoad.close();					
				} catch (e:Error){
					trace( "SoundSlide::unload:", e.message );
					swfLoad = null;
				}
			}
			
			ShowHideManager.unloadContent( (this as SoundSlide) ) 
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		override protected function onAddedHandler(e:Event):void
		{
			//Destroy the swfLoader once the SoundSlide has been loaded
			//if( e.target.name == "container" ) 	swfLoader.destroy();
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			//trace( "SoundSlide::onCompleteHandler:" );
			//swf = SwfLoad(e.currentTarget).contentAsAvm1Movie;
			//swf = e.currentTarget.content as AVM1Movie;
			if( stage ) showSoundSlide();
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "SoundSlide::onErrorHandler:" );
		}		
	}
}
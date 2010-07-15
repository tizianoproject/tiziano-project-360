package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.AVM1Movie;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class SoundSlide extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 34;
		private static const DEFAULT_Y_POS:Number = 110;

		private var loaderContext:LoaderContext;
		private var ssLoader:Loader;
		private var ssMask:Sprite
		private var container:Sprite
		
		public function SoundSlide()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function init():void
		{			
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
		}
		
		private function initSoundSlide():void
		{
			trace( "SoundSlide::initSoundSlide:" );
			/************
			 * History:
			 * When SoundSlides loads, it loads as a 640 x 550 file which covers up  
			 * prev_btn && next_btn so give it a mask
			************/
			//Create a new Mask
			ssMask = new Sprite();
			ssMask.name = "ssMask";	
			ShowHideManager.addContent( (this as SoundSlide), ssMask );
			//Place the Soundslide in a container
			container = new Sprite();
			container.name = "container";
			container.mask = ssMask;
			ShowHideManager.addContent( container, ssLoader );
			//Draw a mask for the container
			redrawMask()
			//Add the container to the stage
			ShowHideManager.addContent( (this as SoundSlide), container );
		}
		
		private function redrawMask():void {
			with ( ssMask.graphics ) {
				beginFill( 0xffcc00, 1 );
				drawRect( container.x, container.y, 451, 375 );
				endFill();
			}
		}		
		
		public function load( path:String ):void
		{
			loaderContext = new LoaderContext( true );
			ssLoader = new Loader();
			ssLoader.name = "ssLoader";
			ssLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true );
			ssLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			ssLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			ssLoader.load( new URLRequest( path ), loaderContext );
		}
		
		private function unload():void
		{
			trace( "SoundSlide::unload:" );	
			//Stop any possible sounds
			SoundMixer.stopAll();
			//Unload the Loader
			if( ssLoader ){
				ssLoader.unload();
				ShowHideManager.removeContent( container, "ssLoader" );
				ssLoader = null;
			}
			
			ShowHideManager.unloadContent( (this as SoundSlide ) );
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onCompleteHandler( e:Event ):void
		{
			trace( "SoundSlide::onCompleteHandler:" );
			if( stage ) initSoundSlide();
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "SoundSlide::onErrorHandler:" );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
			trace( "SoundSlide::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
			trace( "SoundSlide::onRemovedFromStageHandler:" );
		}		
		
	}
}
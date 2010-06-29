/** -----------------------------------------------------------
 * Tiziano Project 360 Main Class  
 * -----------------------------------------------------------
 * Description: Central Nervous System
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: Always
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 *
 */

package 
{

	import com.chrisaiv.utils.ShowHideManager;
	import com.gskinner.utils.SWFBridgeAS3;
	import com.millermedeiros.swffit.SWFFit;
	import com.millermedeiros.swffit.SWFFitEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.adm.runtime.ModeCheck;
	import org.casalib.util.LoadUtil;
	import org.casalib.util.LocationUtil;
	import org.tizianoproject.controller.Controller;
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.Model;
	import org.tizianoproject.view.*;
	import org.tizianoproject.view.ArticleView;
	import org.tizianoproject.view.components.FullScreen;
	import org.tizianoproject.view.components.Overlay;
	
	public class Main extends Sprite
	{
		private static const SWF_PATH:String = "http://demo.chrisaiv.com/swf/tiziano/wall.swf";
		private static const SWF_LOCAL_PATH:String = "wall.swf";

		private static const SWF_BRIDGE:String = "swfBridge";
		private static const SWF_BRIDGE_ON_SCREEN_RESIZE:String = "onScreenResize";
		private static const SWF_BRIDGE_CONNECT:String = "swfBridgeConnect";
		
		private var context:LoaderContext;
		private var loader:Loader;
		
		private var swfBridge:SWFBridgeAS3;
		
		private var model:IModel;
		private var controller:IController;
		
		//Views
		public var wall_mc:MovieClip;
		public var header_mc:MovieClip;
		public var footer_mc:MovieClip;
		
		private var appStage:Stage;		
		private var compositeView:CompositeView;
		private var articleView:ArticleView;
		private var studentsView:ListingBrickView;
		private var mentorsView:ListingBrickView;
		
		//MonsterDebugger is like Firebug but for Flash
		private var monster:MonsterDebugger;

		public function Main()
		{		
			//Debugger
			monster = new MonsterDebugger( this );

			//Model
			model = new Model();
			//Controller
			controller = new Controller( model );

			//Views
			appStage = stage;
			appStage.align = StageAlign.TOP_LEFT;
			appStage.scaleMode = StageScaleMode.NO_SCALE;
			appStage.addEventListener( Event.RESIZE, onStageResizeHandler, false, 0, true );

			var online:Boolean = true;
			if( online ){				
				//Determine whether to run locally or from the live server
				var path:String = ( LocationUtil.isIde() ) ? SWF_LOCAL_PATH : SWF_PATH;  
				
				swfBridge = new SWFBridgeAS3( SWF_BRIDGE, this )
				swfBridge.addEventListener( Event.CONNECT, onConnectHandler );
	
				context = new LoaderContext( true );
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
				loader.load( new URLRequest( path ), context );
				ShowHideManager.addContent( wall_mc, loader );
			}
				

			//Views
			compositeView = new CompositeView( model, controller );			
			//showStudentsView();			
			initArticleView();
			//initSWFFit();
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "onErrorEventHandler:", e.type );
		}

		/**********************************
		 * SWFFIT
		 **********************************/
		private function initSWFFit():void
		{
			SWFFit.addEventListener(SWFFitEvent.CHANGE, swfFitHandler);
			
			//add the custom swffit event "startFit" to the swffit object
			SWFFit.addEventListener(SWFFitEvent.START_FIT, swfFitHandler);
			
			//add the custom swffit event "stopFit" to the swffit object
			SWFFit.addEventListener(SWFFitEvent.STOP_FIT, swfFitHandler);
		}
		
		private function swfFitHandler( e:SWFFitEvent ):void
		{
			trace( "Main::swfFitHandler:", e.type );	
		}

		/**********************************
		 * SWFBridge Handlers
		 **********************************/
		public function onConnectHandler( e:Event ):void
		{
			swfMessage( "connect" );
		}
		
		public function swfMessage( message:String ):void
		{
			switch( message ){
				case "fullScreen":
					swfBridge.send( SWF_BRIDGE_ON_SCREEN_RESIZE, message );					
					break;
				case "normal":
					swfBridge.send( SWF_BRIDGE_ON_SCREEN_RESIZE, message );
					break;
				case "connect":
					swfBridge.send( SWF_BRIDGE_CONNECT, "Sent From:", loaderInfo.url.substr(loaderInfo.url.lastIndexOf("/")) );
					break;
			}
		}
		
		public function onPressThumb( param1:*, param2:* ):void
		{
			trace( "Main::onPressThumb:", param1, param2 );
			wall_mc.mouseEnabled = false;
			showView( articleView );
		}

		public function onRollOverThumb( param1:*, param2:* ):void
		{
			//trace( "Main::onRollOverThumb:", param1.description, param2 );
			updateFooterText( param1.description );

		}

		public function onRollOutThumb( param1:*, param2:* ):void
		{
			//trace( "Main::onRollOutThumb:", param1.description, param2 );	
			updateFooterText( "" );
		}

		//This indicates that the AS2 wall is connected
		public function swfBridgeConnect( param1:String, param2:String ):void
		{
			trace( "Main::swfBridgeConnect: ", param1, param2 );
		}		
		
		/**********************************
		 * Article View
		 **********************************/
		private function initArticleView():void
		{
			//Add an Article Page
			articleView = new ArticleView( model, controller );
			articleView.name = "articleView";
			articleView.addEventListener( BaseViewEvent.CLOSE, hideView );
			compositeView.add( articleView );
		}
		
		private function showStudentsView():void
		{
			studentsView = new ListingBrickView( model, controller );
			studentsView.name = "studentsView";
			articleView.addEventListener( BaseViewEvent.CLOSE, hideView );
			compositeView.add( articleView );
			showView( studentsView );
		}
				
		/**********************************
		 * Show | Hide
		 **********************************/
		private function showView( view:DisplayObject ):void
		{
			ShowHideManager.addContent( (this as Main), view );
		}
		
		//Generic view hider
		private function hideView( e:BaseViewEvent ):void
		{
			//BaseView.results will pass the name of the view to hide.
			//trace( "Main::hideView:", e.results.viewName );
			ShowHideManager.removeContent( (this as Main), e.results.viewName );			
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onStageResizeHandler( e:Event ):void
		{
			trace( "onStageResizeHandler:", appStage.displayState, appStage.stageHeight );
			
			//Notify the Wall
			swfMessage( appStage.displayState );
			
			if( appStage.displayState == FullScreenEvent.FULL_SCREEN ){
				//Reposition
				(this as Main).x = appStage.stageWidth / 2 - ( (this as Main).width /2 );
				(this as Main).y = appStage.stageHeight / 2 - ( (this as Main).height /2 );				
			} else {
				//Reposition
				(this as Main).x = 0;
				(this as Main).y = 0;
				
				repositionFooter();
			}
		}
		
		private function ioErrorHandler( e:Event ):void
		{
			trace( "Main::ioErrorHandler" );
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			trace( "Main::onCompleteHandler: The Wall has been loaded" );
		}
		
		/**********************************
		 * Footer Update
		 **********************************/
		private function repositionFooter():void
		{
			footer_mc.y = appStage.stageHeight - footer_mc.height;
		}
		
		private function updateFooterText( value:String ):void
		{
			footer_mc.title_txt.text = value;		
		}

	}
}
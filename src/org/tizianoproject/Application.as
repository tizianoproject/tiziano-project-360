/**
 * -------------------------------------------------------
 * Tiziano Project Minisite
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: chrisaiv@gmail.com
 * Modified: 7/18/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * 
 * */

package org.tizianoproject
{
	import caurina.transitions.TweenListObj;
	
	import com.chargedweb.swfsize.SWFSize;
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.greensock.TweenLite;
	import com.gskinner.utils.SWFBridgeAS3;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
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
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.adm.runtime.ModeCheck;
	import org.casalib.util.LoadUtil;
	import org.casalib.util.LocationUtil;
	import org.tizianoproject.Application;
	import org.tizianoproject.controller.Controller;
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.MainObjectParams;
	import org.tizianoproject.model.Model;
	import org.tizianoproject.model.XMLLoader;
	import org.tizianoproject.model.vo.Story;
	import org.tizianoproject.view.*;
	import org.tizianoproject.view.ArticleView;
	import org.tizianoproject.view.components.Background;
	import org.tizianoproject.view.components.FullScreen;
	import org.tizianoproject.view.components.Overlay;
	
	public class Application extends Sprite
	{
		private static const XML_PATH:String = "http://demo.chrisaiv.com/xml/tiziano/schema.xml";	
		private static const XML_DATA_LOCAL_PATH:String = "http://localhost:8080/xml/tiziano/schema.xml";		
		
		private static const SWF_PATH:String = "http://demo.chrisaiv.com/swf/tiziano/wall.swf";
		private static const SWF_LOCAL_PATH:String = "wall.swf";
		
		private static const SWF_BRIDGE:String = "swfBridge";
		private static const SWF_BRIDGE_ON_SCREEN_RESIZE:String = "onScreenResize";
		private static const SWF_BRIDGE_CONNECT:String = "swfBridgeConnect";
		
		private var context:LoaderContext;
		private var swfLoader:Loader;
		private var swfBridge:SWFBridgeAS3;
				
		//Model
		private var model:IModel;
		private var xmlLoader:XMLLoader;
		private var controller:IController;
		
		//Views
		private var mainObjectParams:MainObjectParams;		
		private var compositeView:CompositeView;
		private var headerView:HeaderView;
		private var footerView:FooterView;
		private var articleView:ArticleView;
		private var wallView:WallView;
		private var studentsView:ListingBrickView;
		private var mentorsView:ListingBrickView;
		private var bg:Background;
		
		//MonsterDebugger is like Firebug but for Flash
		private var monster:MonsterDebugger;

		//Browser Resiz Notifier
		private var swfSizer:SWFSize;
		
		private var randomColor:Number = Math.random() * 0xffffff;
		
		public function Application( main:DisplayObject, params:MainObjectParams )
		{
			loadXML( );
			
			mainObjectParams = params;

			//Debugger
			monster = new MonsterDebugger( this );

			//Model
			model = new Model();

			//Controller
			controller = new Controller( model );

			//Views
			compositeView = new CompositeView( model, controller );			

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//SWF Sizer must go first in order to record the browser
			initSwfSizer();

			initSwfBridge();

			//initStudentsView();
			initChrome( mainObjectParams );
			initArticleView();

			var online:Boolean = true;
			if( online ){
				//Determine whether to run locally or from the live server
				var path:String = ( LocationUtil.isIde() ) ? SWF_LOCAL_PATH : SWF_PATH;
				//initWall( SWF_PATH );
			} else {
				showView( articleView );
			}
		}
		
		private function loadXML( ):void
		{
			xmlLoader = new XMLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, onXMLCompleteHandler, false, 0, true );
			//xmlLoader.load( XML_PATH );			
			xmlLoader.load( ( LocationUtil.isIde() ) ? XML_DATA_LOCAL_PATH : XML_PATH );			
		}
		
		private function onXMLCompleteHandler( e:Event ):void
		{
			//trace( "Application::onXMLCompleteHandler:" )
			//trace( xmlLoader.getOtherArticlesByArticleID( 1 ) );
			//trace( xmlLoader.getArticleByArticleID( 1 ) );
			var currentIndex:Number = 1;
			var stories:Array = xmlLoader.getAllArticlesByArticleID( currentIndex );
			
			updateArticleView( currentIndex, stories );
			showView( articleView );
		}

		private function initSwfBridge():void
		{
			//SWF Bridge
			swfBridge = new SWFBridgeAS3( SWF_BRIDGE, this )
			swfBridge.addEventListener( Event.CONNECT, onConnectHandler );			
		}
		
		private function initWall( path:String ):void
		{
			wallView = mainObjectParams.wallView;
			swfSizer.addEventListener(SWFSizeEvent.INIT, wallView.swfSizerHandler, false, 0, true );
			swfSizer.addEventListener(SWFSizeEvent.RESIZE, wallView.swfSizerHandler );				
			wallView.loadWall( path );
		}
		
		private function initSwfSizer():void
		{
			swfSizer = SWFSize.getInstance();
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
				case "connect":
					swfBridge.send( SWF_BRIDGE_CONNECT, "Sent From:", loaderInfo.url.substr(loaderInfo.url.lastIndexOf("/")) );
					break;
			}
		}
		
		public function onPressThumb( param1:*, param2:* ):void
		{
			trace( "Main::onPressThumb:", param1.id );
			var currentIndex:Number = param1.id;
			var stories:Array = xmlLoader.getAllArticlesByArticleID( currentIndex );
			
			updateArticleView( currentIndex, stories );
			showView( articleView );
		}
		
		public function onRollOverThumb( param1:*, param2:* ):void
		{
			//trace( "Main::onRollOverThumb:", param1.description, param2 );
			footerView.updateText( param1.description, param2 );
			footerView.stopTimer();
			footerView.showFooter();
		}
		
		public function onRollOutThumb( param1:*, param2:* ):void
		{
			//trace( "Main::onRollOutThumb:", param1.description, param2 );	
			footerView.updateText( "", "" );
			footerView.startTimer();
		}
		
		//This indicates that the AS2 wall is connected
		public function swfBridgeConnect( param1:String, param2:String ):void
		{
			trace( "Main::swfBridgeConnect: ", param1, param2 );
		}		
		
		/**********************************
		 * VIews
		 **********************************/
		private function initChrome( params:MainObjectParams ):void
		{
			//HeaderView is already present on the stage
			bg  = params.bg;
			swfSizer.addEventListener(SWFSizeEvent.INIT, bg.swfSizerHandler, false, 0, true );
			swfSizer.addEventListener(SWFSizeEvent.RESIZE, bg.swfSizerHandler );							
			
			headerView	= params.headerView;
			swfSizer.addEventListener(SWFSizeEvent.INIT, headerView.swfSizerHandler, false, 0, true );
			swfSizer.addEventListener(SWFSizeEvent.RESIZE, headerView.swfSizerHandler );
			
			footerView	= params.footerView;
			swfSizer.addEventListener(SWFSizeEvent.INIT, footerView.swfSizerHandler, false, 0, true );
			swfSizer.addEventListener(SWFSizeEvent.RESIZE, footerView.swfSizerHandler );
		}
		
		private function initTempData():Array
		{
			var vimeoConsumerKey:String = "dba8f8dd0a80ed66b982ef862f75383d";
			var vimeoID:Number = 12618396;
			
			var video:Story = new Story();
				video.authorName = "Jon Vidar";
				video.title = "Vimeo Video";
				video.storyType = "video"
				video.vimeoConsumerKey = vimeoConsumerKey;
				video.vimeoID = vimeoID;
			
			var path:String = "http://demo.chrisaiv.com/swf/tiziano/360/Iraq-sdawood-noel/soundslider.swf?size=2&format=xml";
			var soundslide:Story = new Story();
				soundslide.authorName = "Tory Fine";
				soundslide.title = "SoundSlide";
				soundslide.storyType = "soundslide";
				soundslide.path = path;
			
			var text:Story = new Story();
				text.authorName = "chris mendez";
				text.title = "Text Story";
				text.authorType = "student"
				text.storyType = "text";
				text.content = "Soluta nobis eleifend option congue nihil imperdiet doming id " + 
					"feugait nulla facilisi nam liber. Decima et quinta decima eodem modo typi qui nunc nobis videntur parum " + 
					"clari fiant sollemnes in. Feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim! Amet " + 
					"consectetuer adipiscing elit sed diam nonummy nibh euismod tincidunt ut. Insitam est usus legentis in iis " + 
					"qui facit eorum claritatem Investigationes. Eum iriure dolor in hendrerit in vulputate velit esse molestie " + 
					"consequat vel illum dolore. Gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis " + 
					"per et sans seacula quarta.";
			
			var flickr:Story = new Story();
				flickr.authorName = "Grant Slater";
				flickr.authorType = "mentor";
				flickr.title = "Flickr Story";
				flickr.storyType = "slideshow";
				flickr.flickrKey = "4415d421495d5b59d8537c0937fcce38";
				flickr.flickrPhotoset = "72157624151203417";
			
			return new Array( soundslide, video, flickr, text );
		}
		
		private function initArticleView():void
		{			
			var stories:Array = initTempData();
			
			//Add an Article Page
			articleView = new ArticleView( model, controller );
			articleView.name = "articleView";
			articleView.addEventListener( BaseViewEvent.CLOSE, hideView );
			compositeView.add( articleView );
			swfSizer.addEventListener(SWFSizeEvent.INIT, articleView.swfSizerHandler, false, 0, true );
			swfSizer.addEventListener(SWFSizeEvent.RESIZE, articleView.swfSizerHandler );
		}
		
		private function updateArticleView( id:Number, array:Array ):void
		{
			trace( "Application::updateArticleView:", id, array.length() );
			articleView.stories = array;
			articleView.currentIndex = id;
			articleView.loadStory( );
		}
		
		private function initStudentsView():void
		{
			studentsView = new ListingBrickView( model, controller );
			studentsView.name = "studentsView";
			articleView.addEventListener( BaseViewEvent.CLOSE, hideView );
			compositeView.add( studentsView );
			showView( studentsView );
		}
		
		/**********************************
		 * Show | Hide
		 **********************************/
		private function showView( view:DisplayObject ):void
		{
			ShowHideManager.addContent( (this as Application), view );
			
			footerView.hideFooter( 0.5 );
			
			if( wallView ) wallView.hideWall( );
		}
		
		//Generic view hider
		private function hideView( e:BaseViewEvent ):void
		{
			//BaseView.results will pass the name of the view to hide.
			//trace( "Main::hideView:", e.results.viewName );
			ShowHideManager.removeContent( (this as Application), e.results.viewName );
			
			if( wallView ) wallView.showWall( );
		}		

		/**********************************
		 * Event Handlers
		 **********************************/
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
		}
	}
}
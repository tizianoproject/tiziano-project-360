﻿/** * ------------------------------------------------------- * Tiziano Project Minisite * ------------------------------------------------------- *  * Version: 1 * Created: chrisaiv@gmail.com * Modified: 7/18/2010 *  * ------------------------------------------------------- * Notes: *  *  * */package org.tizianoproject{	import caurina.transitions.TweenListObj;		import com.asual.swfaddress.SWFAddress;	import com.asual.swfaddress.SWFAddressEvent;	import com.chargedweb.swfsize.SWFSize;	import com.chargedweb.swfsize.SWFSizeEvent;	import com.chrisaiv.utils.ShowHideManager;	import com.greensock.TweenLite;	import com.gskinner.utils.SWFBridgeAS3;		import flash.display.DisplayObject;	import flash.display.InteractiveObject;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.ErrorEvent;	import flash.events.Event;	import flash.events.FullScreenEvent;	import flash.events.IOErrorEvent;	import flash.events.MouseEvent;	import flash.events.SecurityErrorEvent;	import flash.external.ExternalInterface;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundLoaderContext;	import flash.media.SoundMixer;	import flash.net.URLRequest;	import flash.system.LoaderContext;	import flash.system.Security;		import nl.demonsters.debugger.MonsterDebugger;		import org.casalib.util.LocationUtil;	import org.tizianoproject.Application;	import org.tizianoproject.events.ArticleViewEvent;	import org.tizianoproject.events.BaseViewEvent;	import org.tizianoproject.model.IModel;	import org.tizianoproject.model.MainObjectParams;	import org.tizianoproject.model.XMLLoader;	import org.tizianoproject.model.vo.Author;	import org.tizianoproject.model.vo.Story;	import org.tizianoproject.model.vo.Test;	import org.tizianoproject.utils.DeepLink;	import org.tizianoproject.view.ArticleView;	import org.tizianoproject.view.CompositeView;	import org.tizianoproject.view.InfoView;	import org.tizianoproject.view.DirectoryView;	import org.tizianoproject.view.FooterView;	import org.tizianoproject.view.HeaderView;	import org.tizianoproject.view.ProfileView;	import org.tizianoproject.view.WallView;	import org.tizianoproject.view.components.Background;	import org.tizianoproject.view.components.FullScreen;	import org.tizianoproject.view.components.Overlay;	import org.tizianoproject.view.components.article.Feature;
		public class Application extends CompositeView	{		private static const XML_PATH:String = "http://360.tizianoproject.org/schema.xml";			private static const XML_DATA_LOCAL_PATH:String = XML_PATH;		//private static const XML_DATA_LOCAL_PATH:String = "http://localhost:8080/xml/tiziano/schema-080310.xml";				private static const SWF_PATH:String = "http://360.tizianoproject.org/swf/wall.swf";		private static const SWF_LOCAL_PATH:String = "wall.swf";				private static const SWF_BRIDGE:String = "swfBridge";		private static const SWF_BRIDGE_ON_SCREEN_RESIZE:String = "onScreenResize";		private static const SWF_BRIDGE_CONNECT:String = "swfBridgeConnect";				private static const DEFAULT_TWEEN_SPEED:Number = 0.5;				private var context:LoaderContext;		private var swfLoader:Loader;		private var swfBridge:SWFBridgeAS3;		private var swfAddress:SWFAddress;						//Model		private var model:IModel;				//Views		private var mainObjectParams:MainObjectParams;				private var compositeView:CompositeView;		private var headerView:HeaderView;		private var profileView:ProfileView		private var footerView:FooterView;		private var articleView:ArticleView;		private var infoView:InfoView;		private var wallView:WallView;		private var directoryView:DirectoryView;		private var bg:Background;				//MonsterDebugger is like Firebug but for Flash		private var monster:MonsterDebugger;		//Browser Resiz Notifier		private var swfSizer:SWFSize;		//SWF Address		private var deepLink:DeepLink;		private var randomColor:Number = Math.random() * 0xffffff;				private var sound:Sound;						public function Application( main:DisplayObject, params:MainObjectParams )		{								//Load the Model			loadModel();						//These are the objects found laying around on the Flash stage			mainObjectParams = params;			//Debugger			monster = new MonsterDebugger( this );		}						override protected function init():void		{			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;						//SWF Sizer must go first in order to record the browser			initChrome( mainObjectParams );						initSwfBridge();									//Determine whether to run locally or from the live server			initWall( SWF_PATH );						//Deep Linking			initDeepLinking();		}				//Load the XML Data		private function loadModel():void		{			model = new XMLLoader();			model.addEventListener( Event.COMPLETE, onXMLCompleteHandler, false, 0, true );			model.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );			model.addEventListener( IOErrorEvent.NETWORK_ERROR, onErrorHandler, false, 0, true );			model.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );			model.load( ( LocationUtil.isIde() ) ? XML_DATA_LOCAL_PATH : XML_PATH );		}				/**********************************		 * Init		 **********************************/		//Composite View is how we update Browser Changes through SWFSizer		private function initCompositeView():void		{			//Composite View will update the Browser and Stage changes			compositeView = new CompositeView();			compositeView.add( articleView );			compositeView.add( directoryView );			compositeView.add( profileView );			compositeView.add( headerView );			compositeView.add( footerView );			compositeView.add( bg );			compositeView.add( infoView );			compositeView.add( wallView );						initSwfSize();		}				//Catch Browser Changes and Dispatch them to all the Children of CompositeView		private function initSwfSize():void		{			swfSizer = SWFSize.getInstance();			swfSizer.addEventListener( SWFSizeEvent.INIT, compositeView.swfSizerHandler, false, 0, true );			swfSizer.addEventListener( SWFSizeEvent.RESIZE, compositeView.swfSizerHandler );					}		//SWFBridge Connects the AS3 SWF with the AS2 file		private function initSwfBridge():void		{			swfBridge = new SWFBridgeAS3( SWF_BRIDGE, this )			swfBridge.addEventListener( Event.CONNECT, onConnectHandler );					}				//On Item Roll over, play sound		private function initSound( path:String ):void		{			var soundBuffer:Number = 100;			sound = new Sound();			sound.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );			sound.addEventListener(Event.COMPLETE, onSoundCompleteHandler, false, 0, true );			sound.load( new URLRequest( path ), new SoundLoaderContext( soundBuffer, true ) );			sound.play( );		}				private function initWall( path:String ):void		{			wallView = mainObjectParams.wallView;			wallView.loadWall( path );		}				private function initDeepLinking():void		{			//Init Deep Linking			deepLink = new DeepLink();			SWFAddress.addEventListener( SWFAddressEvent.INIT, onSwfAddressHandler );			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, onSwfAddressHandler );		}				private function onSwfAddressHandler( e:SWFAddressEvent ):void		{			//The URL is something other than /			trace( "SWFAddress::change:", e.type, e.value );			if( e.value != "/" ){				//If so, then evaluate if it's a relevant "string" or Number				deepLink.evaluateParam( e.value.substr(1).toLocaleLowerCase() );								if( model.isLoaded() ){					trace( "Model is Already Loaded" );					switch( deepLink.type ){						case DeepLink.DIRECTORY:							if( deepLink.param ) updateDirectoryView( deepLink.param );							break;						case DeepLink.STORY:							if( deepLink.id ) updateArticleStory( deepLink.id );							break;					}				}			}		}						/**********************************		 * SWFBridge Handlers		 **********************************/		public function onConnectHandler( e:Event ):void		{			swfMessage( "connect" );		}				public function swfMessage( message:String ):void		{			if( message == "connect" ) swfBridge.send( SWF_BRIDGE_CONNECT, "Sent From:", loaderInfo.url.substr(loaderInfo.url.lastIndexOf("/")) );		}				public function onPressThumb( param1:*, param2:* ):void		{			var storyID:Number = param1.id;			var stories:Array = model.getAllAuthorArticlesByID( storyID );			//trace( "Application::onPressThumb:", stories.length, stories[0].id );			//Deep Link			deepLink.updateAddress( storyID );			updateArticleView( stories );		}				public function onRollOverThumb( param1:*, param2:* ):void		{			//trace( "Application::onRollOverThumb:", param1.description, param1.sound, param2 );			initSound( param1.sound );						footerView.updateText( param1.description, param1.subheadline );			footerView.stopTimer();			footerView.showFooter( DEFAULT_TWEEN_SPEED );		}				public function onRollOutThumb( param1:*, param2:* ):void		{			SoundMixer.stopAll();			//trace( "Application::onRollOutThumb:", param1.description, param2 );				footerView.updateText( "", "" );			footerView.startTimer();		}				//This indicates that the AS2 wall is connected		public function swfBridgeConnect( param1:String, param2:String ):void		{			//trace( "Application::swfBridgeConnect: ", param1, param2 );		}						/**********************************		 * VIews		 **********************************/		//Connect the items on the Flash stage to their respective instances		private function initChrome( params:MainObjectParams ):void		{						bg  = params.bg;			//Load the Initial Background			bg.load();						headerView	= params.headerView;			headerView.addEventListener( MouseEvent.CLICK, onHeaderClickHandler, false, 0, true );						footerView	= params.footerView;		}						//DirectoryView is accessed by pressing "Mentors" or "Reporters"		private function initDirectoryView( ):void		{			directoryView = new DirectoryView( model );			directoryView.name = "directoryView";			directoryView.addEventListener( BaseViewEvent.CLOSE, hideView, false, 0, true );			directoryView.addEventListener( BaseViewEvent.OPEN, onBaseViewHandler, false, 0, true );						//Load a Directory			if( deepLink.param ) updateDirectoryView( deepLink.param );		}						private function initArticleView( ):void		{									//Initialize the Article View			articleView = new ArticleView( model );			articleView.name = "articleView";			articleView.addEventListener( ArticleViewEvent.LOAD_BG, onArticleViewHandler, false, 0, true );			articleView.addEventListener( BaseViewEvent.CLOSE, hideView, false, 0, true );			articleView.addEventListener( BaseViewEvent.OPEN, onBaseViewHandler, false, 0, true );						//////////////////////////////////////			//SWFAddress Test			//////////////////////////////////////			var storyIDs:Array = new Array( "160", "155", "149", "151" );						//deepLink.id = storyIDs[3];			//Now what we have a bonafide Number, let's see if it's a story ID			if( deepLink ) if( deepLink.id ) updateArticleStory( deepLink.id );			//////////////////////////////////////		}				//Check that deepLink.id is indeed a Story(story).id		private function updateArticleStory( storyID:Number ):void		{			var s:Story;			//Attempt to find a story with this id:Number			try{				//trace( "1" );				//This will either become a story.id or a -1				s = model.getArticleByArticleID( storyID );			} catch( e:Error ){				//trace( "2", e.message );				s.id = -1;			}						//The DeepLink.id and the Story.id are in sync and neither is a -1			if( storyID > -1 && storyID == s.id ){				//trace( "3" );				//Get all the author's stories				var stories:Array = model.getAllAuthorArticlesByID( storyID );				//trace( "4" );				//Deep Link				deepLink.updateTitle( s.title );				//Launch the Article View				updateArticleView( stories );			}					}				private function updateArticleView( array:Array ):void		{			SoundMixer.stopAll();						//trace( "Application::updateArticleView" );			articleView.authorStories = array;			articleView.currentIndex = 0;			articleView.loadStory();			//Display ArticleView			showView( articleView );		}		private function initProfileView( ):void		{			profileView = new ProfileView( model );			profileView.name = "profileView";			profileView.addEventListener(MouseEvent.CLICK, onProfileClickHandler, false, 0, true );			profileView.addEventListener( BaseViewEvent.CLOSE, hideView, false, 0, true );			profileView.addEventListener( BaseViewEvent.OPEN, onBaseViewHandler, false, 0, true );			//updateProfileView( "Savina Dawood" );		}				private function updateProfileView( name:String ):void		{			var author:Author = model.getAuthorByName( name );				profileView.vo = author;				profileView.load();				//showView( profileView );		}				private function initInfoView():void		{			infoView = new InfoView();			infoView.name = "infoView";			infoView.addEventListener( BaseViewEvent.CLOSE, hideView, false, 0, true );		}				/**********************************		 * Show | Hide		 **********************************/		private function showView( view:DisplayObject ):void		{			ShowHideManager.addContent( (this as Application), view );						//Hide the Footer			if( footerView ) footerView.hideFooter( );			//Hide the Wall			if( wallView ) if( wallView.alpha > 0 ) wallView.hideWall( );		}				//Generic view hider		private function hideView( e:BaseViewEvent ):void		{			if( e.type == BaseViewEvent.CLOSE ){				//BaseView.results will pass the name of the view to hide.				//trace( "Application::hideView:", e.results.viewName );				ShowHideManager.removeContent( (this as Application), e.results.viewName );				//Show the Wall				if( wallView ) if( wallView.alpha <= 0 ) wallView.showWall( );							}		}				/**********************************		 * Event Handlers		 **********************************/		private function onSoundCompleteHandler( e:Event ):void		{			//trace( "Application::onSoundCompleteHandler" );			}				private function onErrorHandler( e:ErrorEvent ):void		{			trace( "Application::onErrorHandler", e.text );		}				private function onArticleViewHandler( e:ArticleViewEvent ):void		{			//trace( "Application::onArticleViewHandler:", e.results.data );			switch( e.type ){				case ArticleViewEvent.LOAD_BG:					bg.load( e.results.data );					break;				case ArticleViewEvent.CLOSE:					break;			}					}				//Launch the Directories		private function onHeaderClickHandler( e:MouseEvent ):void		{			if( e.target is FullScreen ){				//Do Nothing			}else if( e.target is SimpleButton ){				//Unload everything				ShowHideManager.unloadContent( (this as Application ) );				//Load Directory				updateDirectoryView( e.target.name );			}		}				private function updateDirectoryView( viewName:String ):void		{			//Backup Plan			if( !directoryView ) initDirectoryView();						switch( viewName ){				case "mentorsBtn":					directoryView.query = "Mentor";					deepLink.updateTitle( "Mentors" );						deepLink.updateAddress( "mentors" );					showView( directoryView );					break;				case "reportersBtn":					directoryView.query = "Reporter";					deepLink.updateTitle( "Reporters" );					deepLink.updateAddress( "reporters" );					showView( directoryView );					break;				case "infoBtn":					showView( infoView );					break;			}						}				private function onProfileClickHandler( e:MouseEvent ):void		{			//trace( "C", e.target.name, e.target );			var story:Story;			var otherStories:Array;			var regExp:RegExp = new RegExp("feature");			if( regExp.test(e.target.name) ){				var feature:Feature = Feature(e.target);				var stories:Array = model.getAllAuthorArticlesByID( feature.vo.id );				updateArticleView( stories );			} else if( e.target.name == "imageLoader" ){				var f:Feature = Feature(e.target.parent.parent);				var stories:Array = model.getAllAuthorArticlesByID( f.vo.id );				updateArticleView( stories );			}		}				private function onBaseViewHandler( e:BaseViewEvent ):void		{			//trace( "Application::onBaseViewHandler:", e.results.view );			ShowHideManager.removeContent( (this as Application), "infoView" );			ShowHideManager.removeContent( (this as Application), "articleView" );			ShowHideManager.removeContent( (this as Application), "profileView" );			ShowHideManager.removeContent( (this as Application), "directoryView" );			switch( e.results.view ){				case "articleView":					var story:Story = e.results.data as Story;					var otherStories:Array = model.getAllAuthorArticlesByID( story.id );						//Deep Link						deepLink.updateAddress( story.id );						deepLink.updateTitle( story.title );						//Show						updateArticleView( otherStories );					break;				case "profileView":					profileView.vo = e.results.data as Author;					//trace( "onBaseViewHandler:", e.results.data as Author );					profileView.load();					showView( profileView );					break;			}		}				private function onXMLCompleteHandler( e:Event ):void		{			//Enable the Reporter and Mentor Buttons			headerView.enableButtons();						initArticleView( );			initInfoView();			initDirectoryView()			initProfileView();						initCompositeView();		}				}}
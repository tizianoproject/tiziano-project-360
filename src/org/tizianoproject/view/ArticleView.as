/** -----------------------------------------------------------
 * Article View
 * -----------------------------------------------------------
 * Description: Display either a Text-based story, a Photogallery, or Video 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: 
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 * Notes: 
 * var currentIndex:Number keeps track of all the authorStories:Array
 * var story.id is the uniqueID of the story:Story
 *
 */

package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.CSSFormatter;
	import com.chrisaiv.utils.ShowHideManager;
	import com.tis.utils.components.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.casalib.util.NumberUtil;
	import org.casalib.util.StringUtil;
	import org.casalib.util.TextFieldUtil;
	import org.tizianoproject.events.ArticleViewEvent;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.XMLLoader;
	import org.tizianoproject.model.vo.Author;
	import org.tizianoproject.model.vo.Story;
	import org.tizianoproject.view.components.article.Feature;
	import org.tizianoproject.view.components.article.FeatureHolder;
	import org.tizianoproject.view.components.article.Scroller;
	import org.tizianoproject.view.components.article.Slideshow;
	import org.tizianoproject.view.components.article.SoundSlide;
	import org.tizianoproject.view.components.article.Text;
	import org.tizianoproject.view.components.article.Video;
	
	public class ArticleView extends CompositeView
	{
		//This is the Default Width + Close Button
		private static const MIN_WIDTH:Number = 900;
		//This is the Default Height
		private static const MIN_HEIGHT:Number = 600;
		
		private static const DEFAULT_TITLE:String = "DEFAULT_TITLE";
		private static const DEFAULT_AUTHOR:String = "DEFAULT_AUTHOR";

		//This is the height of the Top Header
		private static const DEFAULT_POS:Point = new Point( 0, 71 ); 
		
		private var iModel:IModel;
		
		//Views
		public var baseView_mc:BaseView;
		public var title_txt:TextField;
		public var author_txt:TextField;
		
		public var authorType_mc:MovieClip;
		public var prev_btn:MovieClip;
		public var next_btn:MovieClip;

		private var text:Text;
		private var slideshow:Slideshow;
		private var video:Video;
		private var soundslide:SoundSlide;

		private var feature:Feature;
		private var featureHolder:FeatureHolder;		
		private var featureScrollBar:Scroller;
		
		private var browserWidth:Number;
		private var browserHeight:Number;

		private var _currentStory:Story;
		private var _currentIndex:Number;		
		private var _authorStories:Array;

		public function ArticleView( m:IModel )
		{			
			iModel = m;

			prev_btn.buttonMode = true;
			prev_btn.text_txt.selectable = false;
			//prev_btn.text_txt.autoSize = TextFieldAutoSize.LEFT;
			prev_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			
			next_btn.buttonMode = true;
			next_btn.text_txt.selectable = false;
			//prev_btn.text_txt.autoSize = TextFieldAutoSize.RIGHT;
			next_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
		}
		
		/**********************************
		 * Model
		 **********************************/
		private function getAuthor( authorName:String ):Author
		{
			return iModel.getAuthorByName( authorName );
		}
		
		private function getArticle( uniqueID:Number ):Story
		{
			return iModel.getArticleByArticleID( uniqueID );
		}
		
		private function getAllArticles( uniqueID:Number ):Array
		{
			return iModel.getAllAuthorArticlesByID( uniqueID );
		}
		
		/**********************************
		 * Init
		 **********************************/
		override protected function init():void
		{
			//trace( "ArticleView::init:", stage.displayState );
			updatePosition();

			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );
		}
		
		override protected function unload():void{
			//Dump the Stories
			unloadStories();
		}		

		public function loadStory( ):void
		{	
			currentStory = authorStories[currentIndex] as Story
			//trace( "ArticleView::loadStory", currentStory.bgImage );
			
			//Insurance: Make sure there are no double writes
			if( featureHolder ){
				if( featureHolder.numChildren > 0 ) unloadFeatures();
			}
			
			if( currentStory ){
				//Load a Background Image
				loadBackground();
				
				//Display Title
				writeTitle( currentStory.title );
				//Display Author Name
				writeAuthor( currentStory.authorName );
				
				//Display Author Type
				showAuthorType( currentStory.authorType );
				
				//trace( "ArticleView::loadStory:", currentStory.storyType );
				//Switch Story
				switchStory( )
				
				//Add new Related Features
				if( currentStory.related.length > 0 ) initFeatures( currentStory.related );
			}
			displayButtons();
		}
		
		private function switchStory( ):void
		{
			switch( currentStory.storyType ){
				case "article":
					initText( currentStory );
					break;
				case "slideshow":
					initSlideshow( currentStory );
					break;
				case "video":
					if( video ){
						video.load( currentStory.id );
						video.visible = true;
					} else {
						initVideo( currentStory );						
					}
					break;
				case "soundslide":
					initSoundSlide( currentStory );
					break;
				case "photo":
					initSoundSlide( currentStory );
					break;
			}			
		}
		
		private function writeTitle( value:String ):void
		{
			title_txt.text = value;
			if( TextFieldUtil.hasOverFlow( title_txt ) ) TextFieldUtil.removeOverFlow( title_txt, "..." );
		}
		
		private function writeAuthor( value:String ):void
		{
			author_txt.htmlText = "<a href='event:" + value + "'>" + value + "</a>";
			author_txt.styleSheet = CSSFormatter.simpleUnderline();
			author_txt.addEventListener(TextEvent.LINK, onTextLinkHandler, false, 0, true );
		}
		
		private function displayButtons():void
		{
			//It's just easier to turn this on
			next_btn.visible = true;
			prev_btn.visible = true;
			
			if ( authorStories.length < 2 ){
				next_btn.visible = false;
				prev_btn.visible = false;
			} else {
				//Next Button
				if( authorStories.length > 1 && currentIndex + 1 <= authorStories.length - 1 ) next_btn.text_txt.text = authorStories[currentIndex+1].title;
				else next_btn.visible = false;
				//Previous Button
				if( currentIndex - 1 >= 0) prev_btn.text_txt.text = authorStories[currentIndex-1].title;
				else prev_btn.visible = false;
			}
		}
		
		private function loadBackground():void
		{
			if( currentStory.bgImage ) dispatchEvent( new ArticleViewEvent( ArticleViewEvent.LOAD_BG, { data: currentStory.bgImage } ) );
		}
		
		/**********************************
		 * Story Types
		 **********************************/
		private function initText( story:Story ):void
		{
			text = new Text();
			text.name = "text";
			text.load( story.content );
			ShowHideManager.addContent( (this as ArticleView), text );
		}
		
		private function initSlideshow( story:Story ):void
		{
			slideshow = new Slideshow();
			slideshow.name = "slideshow";
			slideshow.load( story.flickrKey, story.flickrPhotoset );
			ShowHideManager.addContent( (this as ArticleView), slideshow );			
		}
		
		private function initVideo( story:Story ):void
		{
			video = new Video();
			video.name = "video";
			video.consumerKey = story.vimeoConsumerKey;
			video.load( story.vimeoID );
			ShowHideManager.addContent( (this as ArticleView), video );
		}
		
		private function initSoundSlide( story:Story ):void
		{
			//trace( "ArticleView::initSoundSlide:", story.path );
			soundslide = new SoundSlide();
			soundslide.name = "soundslide";
			soundslide.load( story.path );
			ShowHideManager.addContent( (this as ArticleView), soundslide );
		}
		
		/**********************************
		 * Features
		 **********************************/
		private function initFeatureHolder():void
		{
			//Collect all the Features in an Array
			featureHolder = new FeatureHolder();
			featureHolder.name = "featureHolder";
			ShowHideManager.addContent( (this as ArticleView), featureHolder );							
		}
		
		private function initFeatures( array:Array ):void
		{			
			//Features Holder holds the features
			initFeatureHolder();
			
			var totalFeatures:Number = array.length;
			var columns:Number = 1;
			for( var i:Number = 0; i < totalFeatures; i++ ){
				var xx:Number = i%columns;
				var yy:Number = Math.floor(i/columns);
				
				//Get the Story based on the Reponse ID
				feature = new Feature( );
				feature.vo = getArticle( array[i] ) as Story;
				feature.name = "feature" + i;
				feature.addEventListener(MouseEvent.CLICK, onFeatureClickHandler, false, 0, true );
				//Feature.y is overriden to include DEFAULT_Y_POS
				feature.y = (i * feature.height);
				ShowHideManager.addContent( featureHolder, feature );					
			}
			
			//If there are more than 5 features, add a Scroll Bar
			if( totalFeatures > 5 ) initFeatureScrollBar();
		}
		
		private function initFeatureScrollBar():void
		{
			//Create the Features Holder
			featureScrollBar = new Scroller( featureHolder );
			featureScrollBar.name = "featureScrollBar";
			ShowHideManager.addContent( (this as ArticleView), featureScrollBar );
		}
		
		private function showAuthorType( value:String ):void
		{
			authorType_mc.gotoAndStop( value.toLowerCase() );
		}

		/**********************************
		 * Clean Up
		 **********************************/
		private function cycleStories( ):void
		{			
			unloadStories();
			loadStory();			
		}
		
		private function unloadStories( ):void
		{
//!!!
			//Video
			if ( video ) video.visible = false;
			unloadFeatures();
			
			ShowHideManager.removeContent( (this as ArticleView), "soundslide" );
			ShowHideManager.removeContent( (this as ArticleView), "text" );
			ShowHideManager.removeContent( (this as ArticleView), "slideshow" );
		}
		
		private function unloadFeatures():void
		{
			ShowHideManager.removeContent( (this as ArticleView), "featureHolder"  );
			ShowHideManager.removeContent( (this as ArticleView), "featureScrollBar" );			
		}

		/**********************************
		 * Resize
		 **********************************/		
		override public function browserResize(e:SWFSizeEvent):void
		{
			browserWidth = e.rightX;
			browserHeight = e.bottomY;
			//trace( "ArticleView::swfSizerHandler:", browserWidth, browserHeight );
			
			if( stage ) updatePosition();
		}
		
		override protected function resize(e:FullScreenEvent):void
		{
			if( stage ){
				updatePosition();				
			} 
		}
		
		private function updatePosition(  ):void
		{
			//trace( "ArticleView::updatePosition:", stage.displayState );
			if( stage.displayState == StageDisplayState.FULL_SCREEN ){
				x = stage.fullScreenWidth / 2 - ( MIN_WIDTH / 2 );
				y = stage.fullScreenHeight / 2 - ( MIN_HEIGHT / 2 );
			} else {
				//trace( "ArticleView::updatePosition:", browserWidth, browserHeight );
				if( browserWidth && browserHeight ){
					var dynWidth:Number = ( browserWidth > MIN_WIDTH) ? browserWidth : MIN_WIDTH;
					x = ( dynWidth / 2) - ( MIN_WIDTH / 2 );
				
					var dynHeight:Number = ( browserHeight > MIN_HEIGHT ) ? browserHeight : MIN_HEIGHT ;
					var yPos:Number = ( dynHeight / 2) - ( MIN_HEIGHT / 2 );
					y = ( yPos > + DEFAULT_POS.y ) ? yPos : DEFAULT_POS.y;					
				} else {
					x = ( stage.stageWidth / 2) - ( MIN_WIDTH / 2 );
					y = ( ( stage.stageHeight - DEFAULT_POS.y ) / 2) - ( MIN_HEIGHT / 2 ) + DEFAULT_POS.y;
				}
			}
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/		
		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			//trace( e.results.name, "::onBaseCloseHandler:" );
			dispatchEvent( e );
		}	
		
		private function onTextLinkHandler( e:TextEvent ):void
		{
			//trace( "ArticleView::onTextLinkHandler:", e.text );
			var object:Object = new Object();
				object.view = "profileView";
				object.data = getAuthor( e.text );
				sendToApp( object );
		}
		
		private function sendToApp( obj:Object ):void
		{
			dispatchEvent( new BaseViewEvent( BaseViewEvent.OPEN, obj ) );
		}
		
		private function onFeatureClickHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView:onClickFeatureHandler" );			
			//Get the Selected Author's Stories
			authorStories = getAllArticles( (e.currentTarget as Feature).vo.id );
			//Start the Story at the one the User Selected
			currentIndex = 0;
			//Start
			cycleStories();
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView::onMouseClickHandler:", authorStories.length );
			//Change the Index to Flip Stories
			switch( e.currentTarget.name ){
				case "next_btn":
					if( currentIndex == authorStories.length - 1 ) currentIndex = 0;
					else currentIndex++;
					break;
				case "prev_btn":
					if( currentIndex == 0 ) currentIndex = authorStories.length - 1;
					else currentIndex--;
					break;
			}
			//You must have more than one story to cycle through
			if( authorStories.length > 1 ) cycleStories();	
		}
				
		/**********************************
		 * Getters Setters
		 **********************************/
		public function set authorStories( value:Array ):void
		{
			_authorStories = value;
		}
		
		public function get authorStories():Array
		{
			return _authorStories;
		}
		
		public function set currentIndex( value:Number ):void
		{
			_currentIndex = value;
		}
		
		public function get currentIndex():Number
		{
			return _currentIndex;
		}
		
		private function set currentStory( story:Story ):void
		{
			_currentStory = story;
		}
		
		private function get currentStory():Story
		{
			return _currentStory;
		}
		
	}
}
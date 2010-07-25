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
 * var currentIndex:Number keeps track of all the stories:Array
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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import org.casalib.util.NumberUtil;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.XMLLoader;
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
		private static const DEFAULT_TITLE:String = "DEFAULT_TITLE";
		private static const DEFAULT_AUTHOR:String = "DEFAULT_AUTHOR";

		//This is the height of the Top Header
		private static const DEFAULT_Y_POS:Number = 71;	

		//This is the Default Width + Close Button
		private static const MIN_WIDTH:Number = 900;
		//This is the Default Height
		private static const MIN_HEIGHT:Number = 600;
		
		private var iModel:IModel;
		
		//Views
		public var baseView_mc:BaseView;
		public var title_txt:TextField;
		public var author_txt:TextField;
		
		public var authorType_mc:MovieClip;
		public var prev_btn:SimpleButton;
		public var next_btn:SimpleButton;

		private var text:Text;
		private var slideshow:Slideshow;
		private var video:Video;
		private var soundslide:SoundSlide;

		private var feature:Feature;
		private var featureHolder:FeatureHolder;		
		private var featureScrollBar:Scroller;
		
		private var browserWidth:Number;
		private var browserHeight:Number;
		private var defaultWidth:Number;
		private var defaultHeight:Number;

		private var _currentStory:Story;
		private var _currentIndex:Number;		
		private var _stories:Array;

		public function ArticleView( m:IModel )
		{			
			iModel = m;

			prev_btn.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler, false, 0, true );
			prev_btn.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler, false, 0, true );
			prev_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			
			next_btn.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler, false, 0, true );
			next_btn.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler, false, 0, true );
			next_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
		}
		
		override protected function init():void
		{
			//Position the ArticleView
			defaultWidth  = stage.stageWidth;
			defaultHeight = stage.stageHeight;
			
			updatePosition( );
			
			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );
		}
		
		override protected function unload():void{
			unloadStories();
		}		

		public function loadStory( ):void
		{	
			currentStory = stories[currentIndex] as Story
				
			if( currentStory ){
				//Display Title
				writeTitle( currentStory.title );
				//Display Author Name
				writeAuthor( currentStory.authorName );
				
				//Display Author Type
				showAuthorType( currentStory.authorType );
				
				//trace( "ArticleView::loadStory:", currentStory.storyType );
				//Display Story
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
						break
				}
								
				//Add new Related Features
				
				if( currentStory.related.length > 0 ) initFeatures( currentStory.related );
			}
		}
		
		private function writeTitle( value:String ):void
		{
			title_txt.text = value;
		}
		
		private function writeAuthor( value:String ):void
		{
			author_txt.htmlText = "<a href='event:" + value + "'>" + value + "</a>";
			author_txt.styleSheet = CSSFormatter.simpleUnderline();
			author_txt.addEventListener(TextEvent.LINK, onTextLinkHandler, false, 0, true );
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
			trace( "ArticleView::initSoundSlide:", story.path );
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
				var story:Story = iModel.getArticleByArticleID( array[i] );
					//Create a new Feature
					feature = new Feature( story );
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
			authorType_mc.gotoAndStop( value );
		}

		//Get the Story that the User Clicked on
		private function getAuthorStories( feature:Feature ):Array
		{
			var primaryStory:Story = iModel.getArticleByArticleID( feature.vo.id );
			var otherStories:Array = iModel.getOtherArticlesByAuthorName( primaryStory.authorName, primaryStory.id );
			otherStories.unshift( primaryStory );
			
			return otherStories;
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
			//Video
			//if ( video ) video.visible = false;
			
			ShowHideManager.removeContent( (this as ArticleView), "featureHolder"  );
			ShowHideManager.removeContent( (this as ArticleView), "featureScrollBar" );

			ShowHideManager.removeContent( (this as ArticleView), "text" );
			ShowHideManager.removeContent( (this as ArticleView), "slideshow" );
			ShowHideManager.removeContent( (this as ArticleView), "soundslide" );
		}

		/**********************************
		 * Update Position
		 **********************************/
		override protected function resize():void
		{
			//trace( "ArticleView::onFullScreenHandler:", stage.fullScreenWidth, stage.fullScreenHeight );
			updatePosition();			
		}
		
		private function updatePosition( ):void
		{
			if( stage ){
				if( stage.displayState == "fullScreen" ){
					x = stage.fullScreenWidth / 2 - ( MIN_WIDTH / 2 );
					y = stage.fullScreenHeight / 2 - ( MIN_HEIGHT / 2 );
				} else {
					if( browserWidth && browserHeight ){
						var dynWidth:Number = ( browserWidth > MIN_WIDTH) ? browserWidth : MIN_WIDTH;
						var dynHeight:Number = ( browserHeight > MIN_HEIGHT ) ? browserHeight : MIN_HEIGHT ;
						var yPos:Number = ( dynHeight / 2) - ( MIN_HEIGHT / 2 );
						x = ( dynWidth / 2) - ( MIN_WIDTH / 2 );
						y = ( yPos > + DEFAULT_Y_POS ) ? yPos : DEFAULT_Y_POS;
					}
						//App is loading without a browser
					else {
						x = (defaultWidth / 2) - ( MIN_WIDTH / 2 );
						y = ( (defaultHeight - DEFAULT_Y_POS) / 2) - ( MIN_HEIGHT / 2 ) + DEFAULT_Y_POS;
					}
				}
			}
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			browserWidth = e.windowWidth;
			browserHeight = e.bottomY;
			
			trace( "ArticleView::swfSizerHandler:" );
			updatePosition( );
		}
		
		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			//trace( e.results.name, "::onBaseCloseHandler:" );
			dispatchEvent( e );
		}	
		
		private function onTextLinkHandler( e:TextEvent ):void
		{
			trace( "ArticleView::onTextLinkHandler:", e.text, e.text.length );
			trace( 	iModel.getAuthorByName( e.text ) );
		}
		
		private function onFeatureClickHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView:onClickFeatureHandler" );			
			//Assign New Stories
			//Get the Selected Author's Stories
			stories = getAuthorStories( (e.currentTarget as Feature) );
			//Start the Story at the one the User Selected
			currentIndex = 0;
			//Start
			cycleStories();
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//Change the Index to Flip Stories
			switch( e.currentTarget.name ){
				case "next_btn":
					if( currentIndex == stories.length - 1 ) currentIndex = 0;
					else currentIndex++;
					break;
				case "prev_btn":
					if( currentIndex == 0 ) currentIndex = stories.length - 1;
					else currentIndex--;
					break;
			}
			cycleStories();	
		}
		
		private function onRollOverHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView::onRollOverHandler:", e.currentTarget.name );
		}
		
		private function onRollOutHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView::onRollOutHandler:", e.currentTarget.name );
		}
		
		/**********************************
		 * Getters Setters
		 **********************************/
		public function set stories( value:Array ):void
		{
			_stories = value;
		}
		
		public function get stories():Array
		{
			return _stories;
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
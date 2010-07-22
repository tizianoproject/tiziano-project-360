/** -----------------------------------------------------------
 * Article View
 * -----------------------------------------------------------
 * Description: Display either a Text-based story, a Photogallery, or Video 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
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
	import com.chrisaiv.utils.ShowHideManager;
	import com.tis.utils.components.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.casalib.util.NumberUtil;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.XMLLoader;
	import org.tizianoproject.model.vo.Story;
	import org.tizianoproject.view.components.Feature;
	import org.tizianoproject.view.components.FeatureHolder;
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

			//trace( "CHRIS:", iModel.getArticleByArticleID( 2 ) );
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
				title_txt.text = currentStory.title;
				//Display Author Name
				author_txt.text = currentStory.authorName;
				
				//Display Author Type
				showAuthorType( currentStory.authorType );
				
				//Display Story
				switch( currentStory.storyType ){
					case "text":
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
				}
				
				//Features Holder holds the features
				initFeatureHolder();
				
				//Add new Related Features
				//trace( "ArticleView::loadStory::", currentStory.related );
				if( currentStory.related.length > 0 ) initFeatures( currentStory.related );
			}
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
			featureHolder.addEventListener(Event.REMOVED, onFeatureHolderRemovedHandler, false, 0, true );
			ShowHideManager.addContent( (this as ArticleView), featureHolder );			
		}
		
		private function initFeatures( array:Array ):void
		{			
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
			if( featureHolder.numChildren > 5 ) initFeatureScrollBar();
		}
		
		private function initFeatureScrollBar():void
		{
			trace( "ArticleView::initFeatureScrollBar:" );
			//Create the Features Holder
			featureScrollBar = new Scroller( featureHolder );
			featureScrollBar.name = "featureScrollBar";
			ShowHideManager.addContent( (this as ArticleView), featureScrollBar );
		}
		
		private function showAuthorType( value:String ):void
		{
			authorType_mc.gotoAndStop( value );
		}

		private function gatherStories( e:Event ):Array
		{
			var feature:Feature = e.currentTarget as Feature;
			var primaryStory:Story = iModel.getArticleByArticleID( feature.storyID );
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
			//Delete any Story on the stage
			ShowHideManager.removeContent( (this as ArticleView), "text" );
			ShowHideManager.removeContent( (this as ArticleView), "slideshow" );
			
//			ShowHideManager.removeContent( (this as ArticleView), "video" );
			if ( video ) video.visible = false;
			ShowHideManager.removeContent( (this as ArticleView), "soundslide" );
			ShowHideManager.removeContent( (this as ArticleView), "featureScrollBar" );

			//Delete any feature in the featureHolder
			//ShowHideManager.unloadContent( featureHolder );
			ShowHideManager.removeContent( (this as ArticleView), "featureHolder" );			
		}

		/**********************************
		 * Update Position
		 **********************************/
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
		
		override protected function onFullScreenHandler( e:FullScreenEvent ):void
		{
			//trace( "ArticleView::onFullScreenHandler:", stage.fullScreenWidth, stage.fullScreenHeight );
			updatePosition();
		}		

		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			//trace( e.results.name, "::onBaseCloseHandler:" );
			dispatchEvent( e );
		}	

		private function onFeatureClickHandler( e:MouseEvent ):void
		{
			trace( "ArticleView:onClickFeatureHandler" );
			
			//Assign New Stories
			stories = gatherStories( e );
			currentIndex = 0;
			
			cycleStories();
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{			
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
		
		private function onFeatureHolderRemovedHandler( e:Event ):void
		{
			//trace( "ArticleView::onFeatureHolderRemovedHandler:", featureHolder.numChildren );
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
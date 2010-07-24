package org.tizianoproject.view
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	import org.casalib.util.ArrayUtil;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.vo.Author;
	import org.tizianoproject.view.components.Feature;
	import org.tizianoproject.view.components.FeatureHolder;
	import org.tizianoproject.view.components.article.Scroller;
	import org.tizianoproject.view.components.profile.RelatedAuthor;

	public class ProfileView extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 65, 71 );
		private static const DEFAULT_AVATAR_POS:Point = new Point( 11, 11 );
		private static const MAX_OTHER_AUTHORS:Number = 6;
		
		private var iModel:IModel;
		private var _vo:Author;
		
		public var baseView_mc:BaseView;

		public var avatar_mc:MovieClip;		
		public var name_txt:TextField;
		public var location_txt:TextField;
		public var aux_txt:TextField;
		public var text_txt:TextField;
		public var title_txt:TextField;
		public var other_txt:TextField;
		
		private var loaderContext:LoaderContext
		private var imageLoad:ImageLoad;
		private var avatar:Bitmap;
		
		private var relatedAuthorHolder:MovieClip;
		private var relatedAuthor:RelatedAuthor;
		
		private var featureHolder:MovieClip;
		private var feature:Feature;
		private var featureScrollBar:Scroller;
		
		public function ProfileView( m:IModel )
		{
			x = DEFAULT_POS.x;
			y = DEFAULT_POS.y;

			iModel = m;
		}

		override protected function init():void
		{
			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );
		}

		override protected function unload():void
		{
			writeName( "" );
			writeLocation( "" );
			writeAux( "" );
			writeIntro( "" );			
		}
	
		public function load(  ):void
		{
			//trace( "ProfileView::load:", vo.name );
			writeName( vo.name );
			writeIntro( vo.intro );
			writeLocation( vo.city + " " + vo.region );
			writeTitle( vo.name );
			
			if( vo.type == "Mentor" ){
				writeOther( "Other Mentors" );
				//Mentors: University, Students:Age 
				writeAux( vo.age );
			} else {
				writeOther( "Other Students" );				
				//Mentors: University, Students:Age 
				writeAux( vo.age );
			}
			
			imageLoad = new ImageLoad( new URLRequest( vo.avatar ), loaderContext );
			imageLoad.addEventListener(LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			imageLoad.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			imageLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			imageLoad.start();
			
			initFeatureHolder();
			
			var articles:Array = iModel.getAllArticlesByAuthorName( vo.name );
			loadArticles( articles );
			
			initAuthorHolder();
			var otherAuthors:Array = iModel.getAuthorsByType( vo.type, vo.name );
			for (var i:uint = 0; i <= MAX_OTHER_AUTHORS; i++){
				relatedAuthor = new RelatedAuthor();
				relatedAuthor.name = "relatedAuthor" + i;
				relatedAuthor.x = i;
				relatedAuthor.vo = otherAuthors[i];
				relatedAuthor.load( otherAuthors[i].avatar );
				relatedAuthor.addEventListener( MouseEvent.CLICK, onRelatedAuthorClickHandler, false, 0, true );
				ShowHideManager.addContent( relatedAuthorHolder, relatedAuthor );
			}
		}
		
		private function initFeatureHolder():void
		{
			//Collect all the Features in an Array
			featureHolder = new FeatureHolder();			
			featureHolder.name = "featureHolder";
			featureHolder.addEventListener(Event.REMOVED, onFeatureHolderRemovedHandler, false, 0, true );
			ShowHideManager.addContent( (this as ProfileView), featureHolder );			
		}
		
		private function initAuthorHolder():void
		{
			relatedAuthorHolder = new MovieClip();
			relatedAuthorHolder.name = "relatedAuthorHolder";
			relatedAuthorHolder.x = 45;
			relatedAuthorHolder.y = 510;
			ShowHideManager.addContent( (this as ProfileView), relatedAuthorHolder );
		}
		
		private function loadArticles( array:Array):void
		{
			var totalFeatures:Number = array.length;
			var columns:Number = 1;
			for( var i:Number = 0; i < totalFeatures; i++ ){
				var xx:Number = i%columns;
				var yy:Number = Math.floor(i/columns);
				
				feature = new Feature( array[i] );
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
			//trace( "ProfileView::initFeatureScrollBar:" );
			//Create the Features Holder
			featureScrollBar = new Scroller( featureHolder );
			featureScrollBar.name = "featureScrollBar";
			ShowHideManager.addContent( (this as ProfileView), featureScrollBar );
		}

		
		private function writeName( value:String ):void
		{
			name_txt.text = value;
		}
		
		private function writeLocation( value:String ):void
		{
			location_txt.text = value;
		}
		
		private function writeAux( value:String ):void
		{
			aux_txt.text = value;
		}
		
		private function writeIntro( value:String ):void
		{
			text_txt.htmlText = value;
		}
		
		private function writeOther( value:String ):void
		{
			other_txt.text = value;
		}
		
		private function writeTitle( value:String ):void
		{
			title_txt.text = value + "'s Stories";
		}
		
		private function drawImage():void
		{
			avatar = imageLoad.contentAsBitmap;
			avatar.x = DEFAULT_AVATAR_POS.x;
			avatar.y = DEFAULT_AVATAR_POS.y;
			ShowHideManager.addContent( avatar_mc, avatar );			
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onCompleteHandler( e:LoadEvent ):void
		{
			//trace( "ProfileView::onCompleteHandler:" );
			drawImage();
		}
		
		private function onErrorHandler( e:ErrorEvent ):void
		{
			trace( "ProfileView::onErrorHandler:", e.text );	
		}
		
		private function onRelatedAuthorClickHandler( e:Event ):void
		{
//			trace( "ProfileView::onRelatedAuthorClickHandler:"  );
			var ra:RelatedAuthor = e.currentTarget as RelatedAuthor;
			//change the Data Information
			vo = ra.vo;
			//Delete the current image
			avatar.bitmapData.dispose();
			//Load New Profile
			ShowHideManager.unloadContent( featureHolder );
			ShowHideManager.unloadContent( relatedAuthorHolder );
			//
			load();			
		}
		
		private function onFeatureClickHandler( e:MouseEvent ):void
		{
			trace( "ProfileView::onFeatureClickHandler:" );
			dispatchEvent( e );
		}

		private function onFeatureHolderRemovedHandler( e:Event ):void
		{
			//trace( "ArticleView::onFeatureHolderRemovedHandler:", featureHolder.numChildren );
		}

		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			dispatchEvent( e );
		}		
		/**********************************
		 * Read Write Accessors
		 **********************************/
		public function set vo( value:Author ):void
		{
			_vo = value;
		}
		
		public function get vo():Author
		{
			return _vo;
		}
	}
}
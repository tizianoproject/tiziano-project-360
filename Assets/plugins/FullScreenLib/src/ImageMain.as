package 
{
	import com.gfxcomplex.display.FullScreenAlign;
	import com.gfxcomplex.display.FullScreenImage;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * This is an example of how you would use the fullScreenImage class. 
	 * @author Josh Chernoff
	 */
	public class ImageMain extends Sprite 
	{
		//This is a list of the urls 
		private var imagesURL:Array = new Array();
		
		//This is the current image of the urls list array. 
		private var i:int = 0;
		
		//This is a holder to contain the images as they are placed on stage. 
		private var imageHolder:MovieClip;
		
		//This is the time used to change from image to image. 
		private var timer:Timer;
		
		//This is used to store every instace of the fullscreen class so that the images are cached
		private var fullScreenImages:Array = new Array();
		
		//contructor function 
		public function ImageMain():void 
		{
			//Heres the list of urls. You could make somthing that feed this via xml. 
			imagesURL.push("http://farm3.static.flickr.com/2573/4151019457_bc67d3db3f_b.jpg");
			imagesURL.push("http://farm3.static.flickr.com/2523/3766693063_e2513f7501_o.jpg");
			imagesURL.push("http://farm3.static.flickr.com/2577/3766692609_1955c3472e_o.jpg");	
			imagesURL.push("http://farm3.static.flickr.com/2517/3935147835_fcb530847e_o.png");
			imagesURL.push("http://farm3.static.flickr.com/2427/3941999596_d32c700ba5_o.png");
			
			//Created the time to slide the images. 
			timer = new Timer(5000);
			timer.addEventListener(TimerEvent.TIMER, onTick);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//Remove stage add event. 
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Create holder for the fullscreen images
			imageHolder = new MovieClip();
			addChildAt(imageHolder, 0);
			
			//Make an instance per url 			
			for (var i:int = 0; i < imagesURL.length; i++) {
				var image:FullScreenImage = new FullScreenImage(FullScreenAlign.CENTER , true);
				image.addEventListener(Event.COMPLETE, onComplete);
				image.addEventListener(ProgressEvent.PROGRESS, onProgress);					
				
				fullScreenImages.push({image:image, init:false});
			}
		
			//init timer tick
			onTick();
			
			
		}
		
		private function onTick(e:TimerEvent = null):void 
		{
			//Hold timer till image loads
			timer.stop();
						
			//Get the fullscreen instance from the list and check if it's been loaded. 
			if (fullScreenImages[i].init) {	
				
				//restart timer
				timer.start();
				
				fullScreenImages[i].image.alpha = 0;
				TweenLite.to(fullScreenImages[i].image, 3, { alpha:1 } );
				
			}else{ //if the image has not been loaded, load the image. 	
							
				//Set init to true to show that it has been loaded. 
				fullScreenImages[i].init = true;			
				
				//Load image in to fullscreen instance
				fullScreenImages[i].image.load(imagesURL[i]);
				
				//show preloader
				preloader_txt.visible = true;
				preloader_txt.text = "loading";				
							
				//Set to alpha 0 so that the image can be faded in. 
				fullScreenImages[i].image.alpha = 0;	
			}
			
			//Place on top level in image holder.
			imageHolder.addChild(fullScreenImages[i].image);
		
			
			//Only have 2 images at once in the holder. 
			if (imageHolder.numChildren == 3) {
				imageHolder.removeChildAt(0);
			}
			
			//Change the "i" index to point to the next image in the lest or point to the first image if the list is at the end. 
			i++;
			if (i == imagesURL.length) {
				i = 0;
			}
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			var percent:Number = e.bytesLoaded / e.bytesTotal;
			preloader_txt.text = "loading " + String(Math.round((percent * 100)));
		}
		
		private function onComplete(e:Event):void 
		{
			//restart timer
			timer.start();
			
			//tween alpha back to 1
			TweenLite.to(e.currentTarget, 3, { alpha:1 } );		
			
			//Hide preloader. 
			preloader_txt.visible = false;
			
			//Remove listeners once loaded. 
			e.currentTarget.removeEventListener(Event.COMPLETE, onComplete);
			e.currentTarget.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
	}
	
}
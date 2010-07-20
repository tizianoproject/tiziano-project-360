/**
 * -------------------------------------------------------
 * Test Object
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

package org.tizianoproject.model.vo
{
	public class Test extends Object
	{
		private var vimeoConsumerKey:String = "dba8f8dd0a80ed66b982ef862f75383d";
		private var vimeoID:Number = 12618396;
		
		public static function Test()
		{
		}
		
		public static function video():Story
		{
			var video:Story = new Story();
			video.authorName = "Jon Vidar";
			video.title = "Vimeo Video";
			video.storyType = "video"
			video.vimeoConsumerKey = vimeoConsumerKey;
			video.vimeoID = vimeoID;
			return video;
		}
		
		public static function soundslide():Story
		{
			var path:String = "http://demo.chrisaiv.com/swf/tiziano/360/Iraq-sdawood-noel/soundslider.swf?size=2&format=xml";
			var soundslide:Story = new Story();
			soundslide.authorName = "Tory Fine";
			soundslide.title = "SoundSlide";
			soundslide.storyType = "soundslide";
			soundslide.path = path;
			return soundslide;
		}
		
		public static function text():Story
		{
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
		}
		
		public static function slideshow():Story
		{
			var flickr:Story = new Story();
			flickr.authorName = "Grant Slater";
			flickr.authorType = "mentor";
			flickr.title = "Flickr Story";
			flickr.storyType = "slideshow";
			flickr.flickrKey = "4415d421495d5b59d8537c0937fcce38";
			flickr.flickrPhotoset = "72157624151203417";
		}
	}
}

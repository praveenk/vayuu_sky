package preload  
{  
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	public class CustomPreloader extends DownloadProgressBar {  
		
		private var bgSprite:Sprite= new Sprite();
		private var pBar:Sprite= new Sprite();
		private var maskBar:Sprite= new Sprite();
		private var txtBox:TextField =  new TextField();
		private var txtFormat:TextFormat = new TextFormat();
		private var loader:Loader;
		private var swfLoader:Loader;
		[Embed(source="blackBar.swf", mimeType="application/octet-stream")]
		public var WelcomeScreenGraphic:Class;
				
		[Embed(source="logo.png", mimeType="application/octet-stream")]
		public var WelcomeScreenSwf:Class;
		
		
		public function CustomPreloader()
		{  
			
			//background color of preloader
			//bgSprite.graphics.beginFill(0xFFFFFF);
			bgSprite.graphics.drawRect(0,0,200,200)  
			bgSprite.graphics.endFill();
			
			this.addChild(bgSprite);
			
			loader= new Loader();
			swfLoader= new Loader();
			
			
			loader.loadBytes( new WelcomeScreenGraphic() as ByteArray ); 
			swfLoader.loadBytes( new WelcomeScreenSwf() as ByteArray );
			
			txtFormat.font="Arial";
			txtFormat.bold = true;
			txtBox.textColor=0x000000;
			txtBox.height = 25;
			
			this.addChild(swfLoader);
			this.addChild(pBar);
			this.addChild(txtBox);  
			pBar.addChild(loader);
			pBar.addChild(maskBar);  
			pBar.mask=maskBar;
		
		}  
		
	
		override public function set preloader( preloader:Sprite ):void   
		{
			var centerX:Number=(stage.fullScreenWidth -200) / 2;
			var centerY:Number=(stage.fullScreenHeight - 200) / 2;
	
			swfLoader.x = centerX - 23;
			swfLoader.y = centerY - 100;
			pBar.x = centerX - pBar.width/2;
			pBar.y = centerY - txtBox.height; //+ 170;
			txtBox.x = centerX + 70;
			txtBox.y = centerY;
			
			bgSprite.width = stage.fullScreenWidth;
			bgSprite.height = stage.fullScreenHeight;
			
			preloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, initComplete);  
		}  
		public function initComplete(event: Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onProgress( e:ProgressEvent ):void 
		{  
			var percent:Number = Math.ceil(e.bytesLoaded/e.bytesTotal*100);
			maskBar.graphics.beginFill(0xff0000);
			maskBar.graphics.drawRect(0,0,percent*2,200);
			maskBar.graphics.endFill();
			txtBox.text = "Loading "+percent.toString()+"%";
			//txtFormat = new TextFormat();
			//txtFormat.font="Arial, Verdana, Helvetica";
			txtBox.setTextFormat(txtFormat); 
		}
		
	}  
}  
package  
{
	import com.greensock.TweenMax;
	import fl.video.FLVPlayback;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import components.ImprovedSeekbar;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Main extends Sprite 
	{
		public var flvPlayer:FLVPlayback;
		public var controls:Sprite;
		public var seekbar:Sprite;
		public var playPause:Sprite;
		public var muteButton:Sprite;
		private var hideTimer:Timer;
		
		public function Main() 
		{
			playPause = controls.getChildByName("playPause") as Sprite;
			muteButton = controls.getChildByName("muteButton") as Sprite;
			// This loads the flv path from a flashvar called 'flvpath';
			// You could also specify it using FLVplayback.play('SomeString');
			var flvpath:String = root.loaderInfo.parameters['flvpath'];
			if (flvpath != null) {
				flvPlayer.play(flvpath);
				flvPlayer.getVideoPlayer(flvPlayer.activeVideoPlayerIndex).smoothing = true;
				flvPlayer.seekBar = seekbar;
				flvPlayer.playPauseButton = playPause;
				flvPlayer.muteButton = muteButton;
				
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, showControls);
			hideTimer = new Timer(2000, 1);
			hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideControls);
			hideTimer.start();
			new ImprovedSeekbar(flvPlayer, controls["seekbarImproved"]);
		}
		
		private function hideControls(e:TimerEvent):void 
		{
			TweenMax.to(controls, 0.5, { autoAlpha:0 } );
		}
		
		private function showControls(e:MouseEvent):void 
		{			
			TweenMax.to(controls, 0.5, { autoAlpha:1 } );			
			hideTimer.reset();
			hideTimer.start();
		}
		
	}

}
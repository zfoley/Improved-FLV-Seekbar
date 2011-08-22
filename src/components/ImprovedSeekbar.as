package components 
{
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import fl.video.VideoPlayer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Zach Foley
	 */
	public class ImprovedSeekbar 
	{
		private var _player:FLVPlayback;
		private var _seekbar:Sprite;
		private var handle:Sprite;
		private var loadProgress:Sprite;
		private var playProgress:Sprite;
		private var bg:Sprite;
		private var seek_width:Number;
		private var updateTimer:Timer;
		private var _scrubbing:Boolean;
		/**
		 * 
		 * @param	flvPlayer : any cromuletn FLVPlayback instance
		 * @param	seekbarArt : SeekbarArt must have children named "loadProgress", "playProgress", "handle", and "bg";
		 */
		public function ImprovedSeekbar(flvPlayer:FLVPlayback, seekbarArt:Sprite) 
		{
			player = flvPlayer;
			seekbar = seekbarArt;
			updateTimer = new Timer(100, 0);
			updateTimer.addEventListener(TimerEvent.TIMER, updateSeekbar);
			updateTimer.start();
			
			//seekbar.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{			
			seekbar.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);		
			_scrubbing = false;
			var video:VideoPlayer = player.getVideoPlayer(player.activeVideoPlayerIndex)	
			var seekPosition:Number = (seekbar.mouseX / seek_width) * video.totalTime;
			handle.x = playProgress.width = Math.min(loadProgress.width, seekbar.mouseX);
			player.seek(seekPosition);
			player.play();
		}
		private function onMouseDown(e:MouseEvent):void 
		{
			_scrubbing = true;
			seekbar.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			player.pause();
			
		}
				
		private function updateSeekbar(e:TimerEvent):void 
		{
			var video:VideoPlayer = player.getVideoPlayer(player.activeVideoPlayerIndex)
			if(!_scrubbing){
				var w:Number = (video.playheadTime / video.totalTime) * seek_width;
				playProgress.width = w;
				handle.x = w;
				
			} else {			
				handle.x = playProgress.width = Math.min(loadProgress.width, seekbar.mouseX);
				var seekPosition:Number = (seekbar.mouseX / seek_width) * video.totalTime;
				if (updateTimer.currentCount % 5 == 0) {
					//trace("update.seekPosition", seekPosition);
					player.seek(seekPosition);
				}
			}
			loadProgress.width = (video.bytesLoaded / video.bytesTotal) *seek_width;
		}
		
		public function get seekbar():Sprite 
		{
			return _seekbar;
		}
		/**
		 * Seekbar must have children named "loadProgress", "playProgress", "handle", and "bg";
		 */
		public function set seekbar(value:Sprite):void 
		{
			if (_seekbar != null) {
				seekbar.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				try {
					seekbar.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}catch (e:Error) {
					// seekbar may not be on stage when called.
				}
			}
			_seekbar = value;
			loadProgress = _seekbar.getChildByName("loadProgress") as Sprite;
			playProgress = _seekbar.getChildByName("playProgress") as Sprite;
			handle = _seekbar.getChildByName("handle") as Sprite;
			bg = _seekbar.getChildByName("bg") as Sprite;
			seek_width = bg.width;
			seekbar.buttonMode = true;
			seekbar.mouseChildren = true;
			seekbar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function get player():FLVPlayback 
		{
			return _player;
		}
		
		public function set player(value:FLVPlayback):void 
		{
			if (_player != null) {
				try {
					_player.removeEventListener(VideoEvent.READY, onVideoReady);
					_player.removeEventListener(VideoEvent.COMPLETE, onVideoComplete);
					_player.removeEventListener(VideoEvent.PLAYING_STATE_ENTERED, onVideoPlaying);
					_player.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayheadUpdate);
				}catch (e:Error) {
					// Can't even imagine how this might cause an eror... but WTF, right?
				}
			}
			_player = value;
			_player.addEventListener(VideoEvent.READY, onVideoReady);
			_player.addEventListener(VideoEvent.COMPLETE, onVideoComplete);
			_player.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, onVideoPlaying);
			_player.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayheadUpdate);
			
		}
		
		private function onVideoComplete(e:VideoEvent):void 
		{
			//updateTimer.start();
		}
		
		private function onPlayheadUpdate(e:VideoEvent):void 
		{
			
		}
		
		private function onVideoPlaying(e:VideoEvent):void 
		{
			//updateTimer.start();
		}
		
		private function onVideoReady(e:VideoEvent):void 
		{
			//updateTimer.start();
		}
		/**
		 * Kill: Stop all timers and remove all listener. Null all referenes. 
		 * After this is called this object is no longer usable.
		 * @param	e
		 */
		public function kill(e:Event = null):void 
		{
			_player.removeEventListener(VideoEvent.READY, onVideoReady);
			_player.removeEventListener(VideoEvent.COMPLETE, onVideoComplete);
			_player.removeEventListener(VideoEvent.PLAYING_STATE_ENTERED, onVideoPlaying);
			_player.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayheadUpdate);

			seekbar.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			updateTimer.stop();
			updateTimer = null;
			_player = null;
			_seekbar = null;
			handle = null;
			playProgress = null;
			loadProgress = null;
			bg = null;
			seek_width = NaN;
		}
		
	}

}
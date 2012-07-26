/*
xPlayer v1.0
特性:
	1.文件大小 9.78kb;
	2.可以自定义皮肤;
	3.支持 http 和 rtmp 视频;
	4.音量调节,全屏播放,拖拽播放;
作者:胡俊
邮箱:whuthj@163.com;
Code license:GNU Lesser GPL;
说明:
	由于 Flex 自带视频播放器体积过于笨重,
	所以自己开发了一个轻量级的视频播放器 xPlayer 希望对大家有用,
	本源码可以随意传播或者修改完善,旨在方便开发者使用.
*/
package com.xplayer 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.xplayer.event.XPlayerEvent;
	
	/**
	 * ...
	 * @author hujun
	 */
		/**
	 * 事件声明
	 * */
	public class XPlayer extends Sprite implements IXPlayer
	{
		/**
		 * 变量声明
		 * */
		private var _stage:Stage = null;
		
		public var _corePlayer:CorePlayer;
		private var _info:Object = { };
		private var _logoUrl:String;
		 
		private var _padding:Number = 10;
		private var _barwidth:Number = 0;
		 
		private var _background:XMovieClip;
		private var _over:XMovieClip;
		private var _video:Video;
		private var _logo:XMovieClip;
		private var _buffering:XMovieClip;
		
		private var _bar:XMovieClip;
		private var _play:XMovieClip;
		private var _pause:XMovieClip;
		private var _seeker:XMovieClip;
		private var _box:XMovieClip;
		private var _progressBar:XMovieClip;
		private var _playingBar:XMovieClip;
		private var _time:XMovieClip;
		private var _volumeBar:XMovieClip;
		private var _fullScreen:XMovieClip;
		
		
		/**
		 * 属性
		 * */
		public function get source():String
		{
			return _corePlayer.Source;
		}
		
		public function set source(val:String):void
		{
			_corePlayer.Source = val;
		}
		
		public function get logoUrl():String
		{
			return _logoUrl;
		}
		
		public function set logoUrl(val:String):void
		{
			_logoUrl = val;
			var imgLogo:MovieClip = _corePlayer.Logo(_logoUrl);
			this._logo.skin = imgLogo;
		}
		
		/**
		 * 接口实现
		 * */
		public function play(val:String = null):void 
		{
			_corePlayer.Play(val);
			this._play.visible = false;
			this._pause.visible = true;
		}
		
		//构造函数
		public function XPlayer(stage:Stage) 
		{
			super();
			_stage = stage;
			_corePlayer = new CorePlayer();
			initSkin();
			initEventListeners();
			
			_corePlayer.StatusHandler = this.statusHandler;
		}
		
		private function initSkin():void
		{
			this._background = new XMovieClip(new BackgroundSkin());
			this._video = _corePlayer.Vid(this._stage.stageWidth, this._stage.stageHeight);
			this._logo = new XMovieClip(null);
			this._over = new XMovieClip(new OverSkin(),true);
			this._buffering = new XMovieClip(new BufferingSkin());
			
			this._bar = new XMovieClip(new BarSkin());
			this._seeker = new XMovieClip(new SeekerKin());
			this._time = new XMovieClip(new TimeSkin());
			this._volumeBar = new XMovieClip(new VolumeBarSkin());
			this._play = new XMovieClip(new PlaySkin(), true);
			this._pause = new XMovieClip(new PauseSkin(), true);
			this._progressBar = new XMovieClip(new ProgressBarSkin());
			this._playingBar = new XMovieClip(new PlayingBarSkin());
			this._box = new XMovieClip(new ContainerSkin());
			this._fullScreen = new XMovieClip(new FullScreenSkin());
			
			this.addChild(this._background);
			this._background.addChild(this._video);
			this.addChild(this._bar);
			this.addChild(this._seeker);
			this.addChild(this._fullScreen);
			this.addChild(this._time);
			this.addChild(this._volumeBar);
			this.addChild(this._play);
			this.addChild(this._pause);
			this.addChild(this._box);
			this.addChild(this._progressBar);
			this.addChild(this._playingBar);
			this.addChild(this._logo);
			this.addChild(this._buffering);
			this.addChild(this._over);
			
			this._seeker.visible = false;
			layout(this._stage.stageWidth, this._stage.stageHeight);
		}
		
		//布局控制
		private function layout(w:Number,h:Number):void
		{
			this._background.layout(0, 0, w, h);
			this._video.width = w;
			this._video.height = h;
			this._logo.layout(0, 0);
			this._over.layout((w - this._over.width) * .5, (h - this._over.height) / 2);
			this._buffering.layout((w - this._buffering.width) * .5, (h - this._buffering.height) / 2);
			this._bar.layout(0, h - this._bar.height, w);
			this._play.layout(this._bar.x+_padding, this._bar.y + (this._bar.height - this._play.height) * .5);
			this._pause.layout(this._bar.x + _padding, this._bar.y + (this._bar.height - this._pause.height) * .5);
			this._volumeBar.layout(this._pause.x + this._pause.width + _padding, this._bar.y + (this._bar.height - this._volumeBar.height) * .5);
			var n:Number = this._play.width + this._time.width + this._volumeBar.width + this._fullScreen.width + 7 * _padding;
			this._box.layout(this._volumeBar.x+this._volumeBar.width + _padding, this._bar.y + (this._bar.height - this._box.height) * .5, w - n);
			this._seeker.layout(this._box.x, this._box.y - this._seeker.height);
			this._playingBar.layout(this._box.x + 2, this._bar.y + (this._bar.height - this._playingBar.height) * .5,0);
			this._progressBar.layout(this._playingBar.x, this._playingBar.y,0);
			this._time.layout(this._box.x + this._box.width + _padding, this._bar.y + (this._bar.height - this._time.height) * .5);
			this._fullScreen.layout(this._time.x + this._time.width + _padding, this._bar.y + (this._bar.height - this._fullScreen.height) * .5);
			
			_barwidth = this._box.width - (this._playingBar.x - this._box.x) * 2;
		}
		
		private function initEventListeners():void
		{
			this._stage.addEventListener(Event.RESIZE, resizeHandler);
			this._stage.addEventListener(Event.FULLSCREEN, resizeHandler);
			
			this._fullScreen.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void { 
				_corePlayer.Fullscreen(_stage);
			} );
			
			this._progressBar.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				var point:Number =  evt.localX * _info.progress;
				var seekpoint:Number = (point / 100) * _info.duration;
				_corePlayer.Seek(seekpoint);
			});
			
			this._playingBar.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				var point:Number =  evt.localX * _info.playing;
				var seekpoint:Number = (point / 100) * _info.duration;
				_corePlayer.Seek(seekpoint);
			});
			
			this._pause.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				var b:Boolean = _corePlayer.Pause();
				if (b) {
					_pause.visible = false;
					_play.visible = true;
				}else {
					_pause.visible = true;
					_play.visible = false;
				}
			} );
			
			var playHandler:Function = function(evt:MouseEvent):void {
				if (_info.playing)
				{
					_corePlayer.Pause();
				}
				else
				{
					_corePlayer.Play();
				}
				_play.visible = false;
				_pause.visible = true;
			};
			
			this._play.addEventListener(MouseEvent.CLICK, playHandler);
			this._over.addEventListener(MouseEvent.CLICK, playHandler);
			
			var setVolume:Function = function(newVolume:Number):void{
				_corePlayer.Volume(newVolume);
				_volumeBar.skin.mute.gotoAndStop((newVolume > 0)?1:2);
				_volumeBar.skin.volumeOne.gotoAndStop((newVolume >= 0.2)?1:2);
				_volumeBar.skin.volumeTwo.gotoAndStop((newVolume >= 0.4)?1:2);
				_volumeBar.skin.volumeThree.gotoAndStop((newVolume >= 0.6)?1:2);
				_volumeBar.skin.volumeFour.gotoAndStop((newVolume >= 0.8)?1:2);
				_volumeBar.skin.volumeFive.gotoAndStop((newVolume == 1)?1:2);
			};
			
			var volumeEvent:Function = function(e:MouseEvent):void {
				if(e.buttonDown || e.type == 'click')
				switch (e.currentTarget) {
					case _volumeBar.skin.mute : setVolume(0);break;
					case _volumeBar.skin.volumeOne :   setVolume(.2);break;
					case _volumeBar.skin.volumeTwo :   setVolume(.4);break;
					case _volumeBar.skin.volumeThree : setVolume(.6);break;
					case _volumeBar.skin.volumeFour :  setVolume(.8);break;
					case _volumeBar.skin.volumeFive :  setVolume(1);break;
				}
			};
			_volumeBar.skin.mute.addEventListener(MouseEvent.CLICK, volumeEvent);
			_volumeBar.skin.volumeOne.addEventListener(MouseEvent.CLICK, volumeEvent);
			_volumeBar.skin.volumeTwo.addEventListener(MouseEvent.CLICK, volumeEvent);
			_volumeBar.skin.volumeThree.addEventListener(MouseEvent.CLICK, volumeEvent);
			_volumeBar.skin.volumeFour.addEventListener(MouseEvent.CLICK, volumeEvent);
			_volumeBar.skin.volumeFive.addEventListener(MouseEvent.CLICK, volumeEvent);
		}
		
		private function resizeHandler(evt:Event):void
		{
			layout(_stage.stageWidth,_stage.stageHeight);
		}
		
		private function statusHandler(obj:Object):void
		{
			_info = obj;
			this._progressBar.width = (_info.progress * _barwidth);
			this._playingBar.width = (_info.playing * _barwidth);
			this._seeker.x = this._playingBar.x + (_info.playing * _barwidth);
			this._time.skin.txt.text = _corePlayer.FormatTime(_info.time).toString() + "/" + _corePlayer.FormatTime(_info.duration);
			this._seeker.skin.currentTime.text=_corePlayer.FormatTime(_info.time).toString();
			switch(_info.status){
				case "NetStream.Play.Start" :
					this._seeker.visible = true;
					this._over.visible = false;
				break;
				case "NetStream.Buffer.Empty" :
					this._buffering.visible = true;
				break;
				case "NetStream.Buffer.Full" :
					this._buffering.visible = false;
				break;
				case "NetStream.Play.Stop" :
					_corePlayer.Stop();
					this._over.visible = true;
					this._buffering.visible = false;
					this._play.visible = true;
					this._pause.visible = false;
					this.dispatchEvent(new Event(XPlayerEvent.PLAY_COMPLETE));
				break;
			}
		}
		
	}

}
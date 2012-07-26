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
package 
{
	import com.xplayer.event.XPlayerEvent;
	import com.xplayer.XPlayer;
	import com.xplayer.XPlayer;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author hujun
	 */
	[SWF(width="590",height="450",backgroundColor="0x000000")]
	public class Main extends MovieClip 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var xplayer:XPlayer = new XPlayer(stage);
			xplayer.width = stage.stageWidth;
			xplayer.height = stage.stageHeight;
			this.addChild(xplayer);
			
			//设置视频源
			xplayer.source = "http://cssrc.org:8080/robot_manage/flv/2012/0719/085903458.flv";
			//播放视频
			xplayer.play();
			//视频播放器logo
			xplayer.logoUrl = "http://www.cssrc.org/vid/vid/logo.png";
			
			//侦听视频播放完成事件
			xplayer.addEventListener(XPlayerEvent.PLAY_COMPLETE, function(evt:Event):void {
				xplayer.source = "rtmp://192.168.2.21:1935/vod/sample.flv";
				xplayer.play();
			} );
		}
		
	}
	
}
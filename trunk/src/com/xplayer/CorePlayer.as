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
	/**
	*引入外部类和接口
	*/
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.Bitmap;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import com.adobe.images.PNGEncoder;
	
	/**
	* 视频播放器实现
	* 版本:v1.0
	* 作者:胡俊
	* 邮箱:whuthj@163.com
	* 日期:2012-07-24
	* 修改日期:2012-07-24
	*/
	internal final class CorePlayer implements ICorePlayer
	{
		/**
		*变量声明
		*/
		
		//网络连接
		private var nc:NetConnection;
		//网络流
		private var ns:NetStream;
		//视频组件
		private var vid:Video;
		//声音控制
		private var st:SoundTransform;
		//暂停
		private var togglepause:Boolean = false;
		//音量缓存
		private var volcache:int = 0;
		//视频总时间
		private var duration:int;
		//视频尺寸
		private var vidWidth:int;
		//视频尺寸
		private var vidHeight:int;
		//状态
		private var status:String;
		//视频播放信息回调
		private var statusHandler:Function;
		//视频Url
		private var vidUrl:String;
		//是否为流媒体
		private var isRtmp:Boolean;
		//实例
		private var instance:CorePlayer;
		//播放器状态计时器
		private var timer:Timer;
		//流媒体服务器地址
		private var rtmpServerUrl:String;
		
		/**
		*属性
		*/
		
		//视频Url写者
		public function set Source(val:String):void
		{
			vidUrl=val;
			this.CheckRtmp();
		}
		
		//视频Url读者
		public function get Source():String
		{
			return vidUrl;
		}
		
		//是否为流媒体
		public function get IsRtmp():Boolean
		{
			return isRtmp;
		}
		
		//回调视频播放状态
		public function set StatusHandler(val:Function):void
		{
			this.statusHandler = val;
		}

		//构造函数
		public function CorePlayer()
		{
			instance=this;
			st = new SoundTransform();
			timer=new Timer(100);
			nc  = new NetConnection();
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			nc.client=this;
		}
		
		//视频播放器状态更新计时器事件
		private function timerHandler(evt:TimerEvent):void
		{
			var info:Object = Info();
			var n1:Number=ns.time;
			var n2:Number=info.duration;
			if(n1-n2>=0&&n2>0){
				timer.stop();
				info.status="NetStream.Play.Stop";
				info.total=0;
				info.loaded=0;
				info.progress=0;
				info.time=0;
				info.playing=0;
			}
			statusHandler(info);
		}
		
		//视频播放数据
		public function onMetaData(info:Object):void
		{
			duration = info.duration;
			vidWidth = info.width;
			vidHeight = info.height;
		}
		
		//视频信息
		private function Info():Object
		{
			var playing:Number = new Number(( ns.time / duration ).toFixed(2));
			var obj:Object=new Object();
			obj.width=vidWidth;
			obj.height=vidHeight;
			if(this.isRtmp)
			{
				obj.total=1;
				obj.loaded=1;
				obj.progress="1.00";
			}
			else
			{
				obj.total=ns.bytesTotal;
				obj.loaded=ns.bytesLoaded;
				obj.progress=( ns.bytesLoaded / ns.bytesTotal ).toFixed(2);
			}
			obj.duration=duration;
			obj.time=ns.time;
			obj.playing= ( playing > 1 ? 1 : playing );
			obj.status=status;
			return obj;
		}
		
		//视频播放器控件
		public function Vid(w:int,h:int):Video
		{
			vid = new Video(w,h);
			vid.smoothing = true;
			return vid;
		}
		
		//服务器回调
		public function onBWDone():void
		{
			
		}

		//播放视频
		public function Play(val:String=null):void
		{
			if(val)
			{
				this.Source=val;
			}
			if(!nc.hasEventListener(NetStatusEvent.NET_STATUS))
			{
				var ncEvent:Function=function(evt:NetStatusEvent):void{
					if(evt.info.code=="NetConnection.Connect.Success"){
						ns = new NetStream(nc);
						var nsEvent:Function = function(e:NetStatusEvent):void {
							if(status != e.info.code){
								if(e.info.code!="NetStream.Play.Stop")
								{
									status=e.info.code;
								}
							}
							var info:Object = Info();
							statusHandler(info);
						};
						ns.addEventListener(NetStatusEvent.NET_STATUS, nsEvent);
						ns.bufferTime = 5;
						ns.client = instance;
						ns.play(vidUrl);
						vid.attachNetStream(ns);
						timer.start();
					}
				};
				nc.addEventListener(NetStatusEvent.NET_STATUS,ncEvent);
			}
			if(this.isRtmp)
			{
				nc.connect(this.rtmpServerUrl);
			}
			else
			{
				nc.connect(null);
			}
		}
		
		//暂停
		public function Pause():Boolean
		{	
			if (togglepause)
			{
				togglepause = false;
				ns.resume();
				timer.start();
			}
			else
			{
				togglepause = true;
				ns.pause();
				timer.stop();
			}
			return togglepause;
		}
		
		//停止
		public function Stop():void
		{
			ns.close();
		}
		
		//调节音量
		public function Volume(vol:Number):void
		{
			st.volume = vol;
			ns.soundTransform = st;
		}
		
		//静音
		public function Mute():int
		{
			if (volcache)
			{
				st.volume = volcache;
				ns.soundTransform = st;
			}
			else
			{
				volcache = st.volume;
				st.volume = 0;
				ns.soundTransform = st;
			}
			return st.volume;
		}
		
		//全屏
		public function Fullscreen(stage:Stage):Boolean
		{
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
				return true;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
				return false;
			}
		}
		
		//查找播放
		public function Seek(point:int):void
		{
			ns.seek(point);
		}
		
		//缩略图
		public function Thumbnail(image:String):MovieClip
		{
			var mc:MovieClip = new MovieClip();
			var loader:Loader = new Loader();
			var loaderEvent:Function = function(event:Event):void {
				var image:Bitmap = loader.content as Bitmap;
				mc.addChild(image);
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderEvent);
			loader.load(new URLRequest(image));
			return mc;
		}
		
		//Logo
		public function Logo(image:String):MovieClip
		{
			var mc:MovieClip = new MovieClip();
			var loader:Loader = new Loader();
			var loaderEvent:Function = function(event:Event):void {
				var image:Bitmap = loader.content as Bitmap;
				mc.addChild(image);
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderEvent);
			loader.load(new URLRequest(image));
			return mc;
		}
		
		//截图
		public function Screenshot():void
		{
			var bitmapData:BitmapData = new BitmapData(vid.width,vid.height,true,0xffffff);
			bitmapData.draw(vid);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			var pngStream:ByteArray = PNGEncoder.encode(bitmapData);
			var f:FileReference=new FileReference();
			f.save(pngStream,"Screenshot.png");
		}
		
		//检查是否为流媒体
		private function CheckRtmp():void
		{
			var str:String=this.vidUrl.toLowerCase();
			var n:int=str.indexOf("rtmp");
			this.isRtmp=n>=0?true:false;
			if(this.isRtmp){
				var index:int=str.lastIndexOf("/");
				this.rtmpServerUrl=str.substring(0,index);
				this.vidUrl=str.substring(index+1,str.length-4);
			}
		}
		
		//格式化时间
		public function FormatTime(time:Number):String 
		{
			if (time>0) {
				var integer:String = String((time/60)>>0);
				var decimal:String = String((time%60)>>0);
				return ((integer.length<2)?"0"+integer:integer)+":"+((decimal.length<2)?"0"+decimal:decimal);
			} else {
				return String("00:00");
			}
		}
	}
}
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
package com.xplayer {
	
	/**
	*引入外部类和接口
	*/
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.media.Video;
	
	/**
	* 视频播放器接口
	* 版本:v1.0
	* 作者:胡俊
	* 邮箱:whuthj@163.com
	* 日期:2012-07-24
	* 修改日期:2012-07-24
	*/
	internal interface ICorePlayer 
	{
		/**
		*属性功能(可以包含回调功能)
		*/
		
		//视频Url
		function get Source():String;
		function set Source(val:String):void;
		
		//是否为流媒体
		function get IsRtmp():Boolean;
		
		//视频播放状态回调方法
		function set StatusHandler(val:Function):void;
		
		/**
		* 行为功能
		*/
		//初始化视频播放器
		function Vid(w:int,h:int):Video;
		//播放视频
		function Play(val:String=null):void;
		//暂停
		function Pause():Boolean;
		//停止播放
		function Stop():void;
		//调节音量
		function Volume(vol:Number):void;
		//静音
		function Mute():int;
		//全屏
		function Fullscreen(stage:Stage):Boolean;
		//查找播放
		function Seek(point:int):void;
		//缩略图
		function Thumbnail(image:String):MovieClip;
		//Logo
		function Logo(image:String):MovieClip;
		//截图
		function Screenshot():void;
		//格式化时间
		function FormatTime(val:Number):String;
		
		/**
		* 回调功能
		*/
	}
}

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
	import flash.events.MouseEvent;
	import skin_fla.mute_18;
	
	/**
	 * ...
	 * @author hujun
	 */
	public class XMovieClip extends MovieClip 
	{
		private var _skin:MovieClip;
		private var _asButton:Boolean;
		
		public function get skin():MovieClip
		{
			return _skin;
		}
		
		public function set skin(val:MovieClip):void
		{
			_skin = val;
			if (_skin)
			{
				this.addChild(this._skin);
				if (_asButton)
				{
					this._skin.stop();
					initEventListeners();
				}
			}
		}
		
		public function XMovieClip(skin:MovieClip,asButton:Boolean=false) 
		{
			super();
			this._asButton = asButton;
			if (skin)
			{
				this._skin = skin;
				this.addChild(this._skin);
				if (asButton)
				{
					this._skin.stop();
					initEventListeners();
				}
			}
		}
		
		public function layout(x:Number,y:Number,w:Number=undefined,h:Number=undefined):void
		{
			this.x = x;
			this.y = y;
			if (w)
			{
				this._skin.width = w;
			}
			if (h)
			{
				this._skin.height = h;
			}
		}
		
		private function initEventListeners():void
		{
			this._skin.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			this._skin.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			this._skin.gotoAndStop(2);
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			this._skin.gotoAndStop(1);
		}
	}

}
//
//  IJKFFOptionsModel.m
//  ijkplayerTest
//
//  Created by ydd on 2018/11/22.
//  Copyright © 2018 ydd. All rights reserved.
//

#import "IJKFFOptionsModel.h"

@implementation IJKFFOptionsModel

// 获取 ijk 默认设置
+ (IJKFFOptions *)getDefaultIJKFFOptions
{
  IJKFFOptions *options = [[IJKFFOptions alloc] init];
  /** 最大帧率 */
  [options setPlayerOptionIntValue:30     forKey:@"max-fps"];
  /** 丢帧开关 */
  [options setPlayerOptionIntValue:1      forKey:@"framedrop"];
  /** 视频的 Frame_Queue 最大为3 */
  [options setPlayerOptionIntValue:3      forKey:@"video-pictq-size"];
  /** 视频解码方式 0：软解， 1：硬解 */
  [options setPlayerOptionIntValue:1      forKey:@"videotoolbox"];
  //  [options setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer]; // 开启硬编码
  /** def 960 */
  [options setPlayerOptionIntValue:640    forKey:@"videotoolbox-max-frame-width"];
  /** 自动转屏开关 */
  [options setFormatOptionIntValue:0                  forKey:@"auto_convert"];
  /** 重连次数 */
  [options setFormatOptionIntValue:1                  forKey:@"reconnect"];
  /** 超时时间 */
  [options setFormatOptionIntValue:30 * 1000 * 1000   forKey:@"timeout"];
  [options setFormatOptionValue:@"ijkplayer"          forKey:@"user-agent"];
  
  options.showHudView   = NO;
  return options;
}

// ijk 设置示例
+ (IJKFFOptions *)getIJKOptions
{
  IJKFFOptions * options = [IJKFFOptions optionsByDefault];
  [options setPlayerOptionIntValue:29.97 forKey:@"r"]; // 帧速率（fps）可以改，确认非标准帧率会导致音画不同步，所以只能设定为15或者29.97）
  
  [options setPlayerOptionIntValue:255 forKey:@"vol"]; // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推)
  
  
  [options setPlayerOptionValue:@"0" forKey:@"an"]; //静音设置
  
  [options setPlayerOptionIntValue:15 forKey:@"max-fps"]; // 最大fps
  
  [options setPlayerOptionIntValue:1 forKey:@"framedrop"]; // 跳帧开关
  
  [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"]; // 开启硬编码 （默认是 0 ：软解）
  
  [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"]; // 指定最大宽度
  
  [options setFormatOptionIntValue:0 forKey:@"auto_convert"]; // 自动转屏开关
  
  [options setFormatOptionIntValue:1 forKey:@"reconnect"]; // 重连开启 BOOL
  
  [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"]; // 超时时间，timeout参数只对http设置有效，若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。rtmp的timeout参数含义和http的不一样。
  
  [options setFormatOptionValue:@"udp" forKey:@"rtsp_transport"];// 如果使用rtsp协议，可以优先用tcp（默认udp）
  
  [options setFormatOptionIntValue:1024 * 16 forKey:@"probesize"];//播放前的探测Size，默认是1M, 改小一点会出画面更快
  
  [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];//开启环路滤波（0比48清楚，但解码开销大，48基本没有开启环路滤波，清晰度低，解码开销小）
  
  [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
  
  // param for living
  [options setPlayerOptionIntValue:15000 forKey:@"max_cached_duration"];   // 最大缓存大小是3秒，可以依据自己的需求修改
  [options setPlayerOptionIntValue:1 forKey:@"infbuf"];  // 无限读
  //  关闭播放器缓冲 (如果频繁卡顿，可以保留缓冲区，不设置默认为1)
  [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
  return options;
}


@end

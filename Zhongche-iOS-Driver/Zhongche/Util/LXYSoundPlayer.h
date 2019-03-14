//
//  LXYSoundPlayer.h
//  VoiceDemo
//
//  Created by lxy on 16/8/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LXYSoundPlayer : NSObject
{
    NSMutableDictionary* soundSet;  //声音设置
    NSString* path;  //配置文件路径
}
@property(nonatomic,assign)float rate;   //语速
@property(nonatomic,assign)float volume; //音量
@property(nonatomic,assign)float pitchMultiplier;  //音调
@property(nonatomic,assign)BOOL autoPlay;  //自动播放

+ (LXYSoundPlayer*)soundPlayerInstance;

- (void)play:(NSString*)text;

- (void)setDefault;

- (void)writeSoundSet;

- (void)setSoundWithRate:(float)rate WithPitchMultiplier:(float)pitchMultiplier WithVolume:(float)volume;

@end

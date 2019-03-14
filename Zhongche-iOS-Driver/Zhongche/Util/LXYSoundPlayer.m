//
//  LXYSoundPlayer.m
//  VoiceDemo
//
//  Created by lxy on 16/8/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "LXYSoundPlayer.h"

@implementation LXYSoundPlayer

static LXYSoundPlayer * soundplayer=nil;


+(LXYSoundPlayer*)soundPlayerInstance
 {
    if(soundplayer==nil)
    {
        soundplayer=[[LXYSoundPlayer alloc]init];
        [soundplayer initSoundSet];
    }
    return soundplayer;
}

 //播放声音
 -(void)play:(NSString*)text
 {
    if(![text isEqualToString:@""])
    {
            AVSpeechSynthesizer* player=[[AVSpeechSynthesizer alloc]init];
            AVSpeechUtterance* u=[[AVSpeechUtterance alloc]initWithString:text];//设置要朗读的字符串
            u.voice =[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
            u.volume = self.volume;//设置音量（0.0~1.0）默认为1.0
            u.rate = self.rate;//设置语速
            u.pitchMultiplier = self.pitchMultiplier;//设置语调
            [player speakUtterance:u];
    }
}

//初始化配置
 -(void)initSoundSet
 {
    path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SoundSet.plist"];
    soundSet=[NSMutableDictionary dictionaryWithContentsOfFile:path];
        soundSet=[NSMutableDictionary dictionary];
        [soundplayer setDefault];
        [soundplayer writeSoundSet];
}

 //恢复默认设置
-(void)setDefault {

    self.volume=0.7;
    self.rate=0.4;
    self.pitchMultiplier=1;
}


//设置基本属性
- (void)setSoundWithRate:(float)rate WithPitchMultiplier:(float)pitchMultiplier WithVolume:(float)volume {
    self.volume=volume;
    self.rate=rate;
    self.pitchMultiplier=pitchMultiplier;

}

//将设置写入配置文件
-(void)writeSoundSet {

    [soundSet setValue:[NSNumber numberWithBool:self.autoPlay] forKey:@"autoPlay"];
    [soundSet setValue:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
    [soundSet setValue:[NSNumber numberWithFloat:self.rate] forKey:@"rate"];
    [soundSet setValue:[NSNumber numberWithFloat:self.pitchMultiplier] forKey:@"pitchMultiplier"];
    [soundSet writeToFile:path atomically:YES];
}


@end

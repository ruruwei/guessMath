//
//  ViewController.m
//  Feaking Math1
//
//  Created by ruru on 16/3/31.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];//隐藏导航栏
    self.num.font=[UIFont boldSystemFontOfSize:35];
    self.gameName.font=[UIFont italicSystemFontOfSize:35];
    self.gameName1.font=[UIFont italicSystemFontOfSize:26];
    self.goBtn.layer.cornerRadius=8;
    //SnapsTaste
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Startgame:(id)sender {
    SecondViewController *page=[[SecondViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
    [self playSoundEffect:@"Click.wav"];
//    TestViewController * test = [[TestViewController alloc] init];
//    [self.navigationController pushViewController:test animated:YES];
}

-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}


@end

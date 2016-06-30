//
//  SecondViewController.m
//  Feaking Math1
//
//  Created by ruru on 16/3/31.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "SecondViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SecondViewController ()

@end

@implementation SecondViewController{
    UIView * errorTips;
    
    int randomNumber1;
    int randomNumber2;
    int randomNumber3;
    int score;
    int hightScore;
    int i;
    NSTimer *gameTimer;
    NSTimer *pTimer;
    
    float progressTime;
    float useTime;
    
    NSTimer * shakeTimer;
    int shakeCount;
    CGRect viewFrame;
}

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES];
    score=0;
    hightScore=0;
    i=0;
    useTime=2;
    progressTime=0;
    viewFrame = self.view.frame;
    [self guessRigth];
    [super viewDidLoad];

    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"tipsError" owner:self options:nil];
    errorTips = arr[0];
    [self.view addSubview:errorTips];
    CGRect frame = errorTips.frame;
    frame.origin.y = errorTips.frame.size.height/3;
    frame.origin.x = (self.view.frame.size.width-errorTips.frame.size.width)/2;
    errorTips.frame = frame;
    
    errorTips.alpha = 0;
    NSLog(@"%@",errorTips);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Right:(id)sender {
    if (randomNumber1+randomNumber2==randomNumber3) {
        score++;
        [self guessRigth];
        [self playSoundEffect:@"change1.wav"];
        
    }else{
        [self guessError];
        [self playSoundEffect:@"error.mp3"];
    }
}
- (IBAction)Error:(id)sender {
    if (randomNumber1+randomNumber2!=randomNumber3) {
        score++;
        [self guessRigth];
        [self playSoundEffect:@"change1.wav"];
    }else{
        [self guessError];
        [self playSoundEffect:@"error.mp3"];
    }
}

- (IBAction)restart:(id)sender {
    score=0;
    self.score.text=@"0";
    CGRect oldFrame=self.progressIn.frame;
    oldFrame.size.width=0;
    self.progressIn.frame=oldFrame;//进度条显示为0
    [self guessRigth];
    [self tipHidden];
    UIColor *coler1=[[UIColor alloc]initWithRed:0.1 green:0.3 blue:0.5 alpha:1];
    UIColor *coler2=[[UIColor alloc]initWithRed:0.2 green:0.2 blue:0.6 alpha:1];
    UIColor *coler3=[[UIColor alloc]initWithRed:0.5 green:0.6 blue:0.6 alpha:1];
    UIColor *coler4=[[UIColor alloc]initWithRed:0.7 green:0.3 blue:0.7 alpha:1];
    UIColor *coler5=[[UIColor alloc]initWithRed:0.8 green:0.4 blue:0.1 alpha:1];
    NSArray *array=[[NSArray alloc]initWithObjects:coler1,coler2,coler3,coler4,coler5, nil];
    i=arc4random()%4;
    self.view.backgroundColor=[array objectAtIndex:i];
    self.rightbtn.enabled=YES;
    self.errorbtn.enabled=YES;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
    [self tipHidden];
}
-(void)guessRigth{
    randomNumber1=arc4random() % 9+1;
    randomNumber2=arc4random() % 9+1;
    randomNumber3=randomNumber1+randomNumber2;
    if (arc4random()%9+1>5) {
        randomNumber3=randomNumber1+randomNumber2+arc4random()%6-3;
    }
    self.show.text=[NSString stringWithFormat:@"%d + %d",randomNumber1,randomNumber2];
    self.show1.text=[NSString stringWithFormat:@"=%d",randomNumber3];
    self.score.text=[NSString stringWithFormat:@"%d",score];
    NSLog(@"r1=%d r2=%d r3=%d",randomNumber1,randomNumber2,randomNumber3);
    
    if (score!=0) {
        [gameTimer invalidate];
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:useTime target:self selector:@selector(guessError) userInfo:nil repeats:NO];
        
        [pTimer invalidate];
        progressTime = 0;
        pTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
}
-(void)progressChange{
    if (progressTime<useTime) {
        progressTime+=0.05;
        float progress=progressTime*self.progressOut.frame.size.width/useTime;
        CGRect oldFrame=self.progressIn.frame;
        oldFrame.size.width=progress;
        self.progressIn.frame=oldFrame;
    }else{
        [gameTimer invalidate];
    }
}
-(void)guessError{
    if (hightScore<score) {
        hightScore=score;
    }
    errorTips.hidden=NO;
    self.gameOver.text=@"游戏结束";
    self.gameScore.text=[NSString stringWithFormat:@"得分：%d",score];
    self.hightScore.text=[NSString stringWithFormat:@"最高分：%d",hightScore];

    errorTips.alpha=0;
    CGRect oldFrame=errorTips.frame;
    oldFrame.origin.y-=200;
    errorTips.frame=oldFrame;
    [UIView animateWithDuration:0.2 animations:^{
        errorTips.alpha=1;
        CGRect oldFrame=errorTips.frame;
        oldFrame.origin.y+=200;
        errorTips.frame=oldFrame;
    }];

    self.show.text=nil;
    self.show1.text=nil;
    self.rightbtn.enabled=NO;  //Button为禁用状态
    self.errorbtn.enabled=NO;
    progressTime=0;
    [gameTimer invalidate];
    [pTimer invalidate];

    shakeCount = 0;
    shakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(shake) userInfo:nil repeats:YES];
}
-(void)shake{
    shakeCount++;
    if (shakeCount>=30) {
        [shakeTimer invalidate];
        shakeCount = 0;
        self.view.frame = viewFrame;
        return;
    }
//
//    if(shakeCount%2==1){
//        self.view.alpha = 0.4;
//    }else{
//        self.view.alpha = 1.0;
//    }
    int mod = shakeCount%8;
    int x=0,y=0;
    switch (mod) {
        case 0:x=-1;y=-1;break;
        case 1:x=-1;y=0;break;
        case 2:x=-1;y=1;break;
        case 3:x=-0;y=1;break;
            
        case 4:x=1;y=1;break;
        case 5:x=1;y=0;break;
        case 6:x=1;y=-1;break;
        case 7:x=1;y=-1;break;
        default:break;
    }
    CGRect newFrame = viewFrame;
    newFrame.origin.x += x*6;
    newFrame.origin.y += y*6;
    self.view.frame= newFrame;
}


-(void)tipHidden{
    [UIView animateWithDuration:0.2 animations:^{
        errorTips.alpha=0;
        CGRect oldFrame=errorTips.frame;
        oldFrame.origin.y-=200;
        errorTips.frame=oldFrame;
    } completion:^(BOOL finished) {
        CGRect oldFrame=errorTips.frame;
        oldFrame.origin.y+=200;
        errorTips.frame=oldFrame;
    }];
}
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);//播放音效
//    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

@end

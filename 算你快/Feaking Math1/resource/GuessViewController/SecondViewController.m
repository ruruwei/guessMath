//
//  SecondViewController.m
//  Feaking Math1
//
//  Created by ruru on 16/3/31.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "SecondViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define RGB(color)        [UIColor colorWithRed:(color>>16)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:1]
#define RGBA(color,alpha) [UIColor colorWithRed:(color>>16)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:alpha]

@interface SecondViewController ()

@end
@implementation SecondViewController{
    UIView * errorTips;
    int randomNumber1;
    int randomNumber2;
    int randomNumber3;
    int score;
    int HightScore;
    NSTimer *gameTimer;
    NSTimer *pTimer;
    float progressTime;
    float useTime;
    
    NSTimer * shakeTimer;
    int shakeCount;
    CGRect viewFrame;
    CGRect oldFramenumberView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self readNSUserDefaultes];//读取最高分
    useTime=1.2;
    progressTime=0;
    viewFrame = self.view.frame;
    [self refreshData];

    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"tipsError" owner:self options:nil];
    errorTips = arr[0];
    [self.view addSubview:errorTips];
    CGRect frame = errorTips.frame;
    frame.origin.y = errorTips.frame.size.height/3;
    frame.origin.x = (self.view.frame.size.width-errorTips.frame.size.width)/2;
    errorTips.frame = frame;
    
    errorTips.alpha = 0;
    NSLog(@"%@",errorTips);
    
    errorTips.layer.cornerRadius = 8;
    self.errorbtn.layer.cornerRadius = 4;
    self.rightbtn.layer.cornerRadius = 4;
    self.startBtn.layer.cornerRadius=4;
    self.backHomeBtn.layer.cornerRadius=4;
    [self setFontFamily:@"SnapsTaste" forView:self.view andSubViews:YES];
}
-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews{//设置字体
    if ([view isKindOfClass:[UILabel class]]){
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    if (isSubViews){
        for (UIView *sview in view.subviews){
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Right:(id)sender {
    if (randomNumber1+randomNumber2==randomNumber3) {
        score++;
        [self guessRigth];
        [self playSoundEffect:@"Yes.wav"];
        
    }else{
        [self guessError];
    }
    [self changeBgColor];
}
- (IBAction)Error:(id)sender {
    if (randomNumber1+randomNumber2!=randomNumber3) {
        score++;
        [self guessRigth];
        [self playSoundEffect:@"Yes.wav"];

    }else{
        [self guessError];
    }
    [self changeBgColor]; 
}
- (IBAction)restart:(id)sender {
    score=0;
    int bgColorIndex;
    self.scorelab.text=@"0";
    CGRect oldFrame=self.progressIn.frame;
    oldFrame.size.width=0;
    self.progressIn.frame=oldFrame;//进度条显示为0
    [self guessRigth];
    [self tipHidden];
    [self changeBgColor];
    self.rightbtn.enabled=YES;
    self.errorbtn.enabled=YES;
}
-(void)changeBgColor{
    int bgColorIndex;
    NSArray *array=@[RGB(0x7A2C9C),RGB(0xC8428D),RGB(0x25A24D),RGB(0x2C3F6E),
                     RGB(0x483291),RGB(0xFC5B07),RGB(0x1595ED)];
    bgColorIndex=arc4random()%[array count];
    self.view.backgroundColor=array[bgColorIndex];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true ];
    [self tipHidden];
}
-(void)guessRigth{
    [self numberViewOut];
    if (score!=0) {
        [gameTimer invalidate];
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:useTime target:self selector:@selector(guessError) userInfo:nil repeats:NO];
        
        [pTimer invalidate];
        progressTime = 0;
        pTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
}
-(void)refreshData{
    randomNumber1=arc4random() % 9+1;
    randomNumber2=arc4random() % 9+1;
    randomNumber3=randomNumber1+randomNumber2;
    if (arc4random()%9+1>5) {
        randomNumber3=randomNumber1+randomNumber2+arc4random()%3;
    }
    self.show.text=[NSString stringWithFormat:@"%d + %d",randomNumber1,randomNumber2];
    self.show1.text=[NSString stringWithFormat:@"=%d",randomNumber3];
    self.scorelab.text=[NSString stringWithFormat:@"%d",score];
    NSLog(@"r1=%d r2=%d r3=%d",randomNumber1,randomNumber2,randomNumber3);

}
-(void)progressChange{
    if (progressTime<useTime) {
        progressTime+=0.03;
        float progress=progressTime*self.progressOut.frame.size.width/useTime;
        CGRect oldFrame=self.progressIn.frame;
        oldFrame.size.width=progress;
        self.progressIn.frame=oldFrame;
    }else{
        [gameTimer invalidate];
    }
}
-(void)guessError{
    if (HightScore<score) {
        HightScore=score;
    [self saveNSUserDefaults];//存储最高分
    }
    [self playSoundEffect:@"over.wav"];
    errorTips.hidden=NO;
    self.gameOver.text=@"Game Over";
    self.gameScore.text=[NSString stringWithFormat:@"Score：   %d",score];
    self.hightScorelab.text=[NSString stringWithFormat:@"Highest：   %d",HightScore];
    
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
    shakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(shake) userInfo:nil repeats:YES];
    
    
}
-(void)shake{
    shakeCount++;
    if (shakeCount>=30) {
        [shakeTimer invalidate];
        shakeCount = 0;
        self.view.frame = viewFrame;
        return;
    }
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
    newFrame.origin.x += x*2;  
    newFrame.origin.y += y*2;
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
}
#pragma mark==saveData
-(void)saveNSUserDefaults{
    NSUserDefaults *userscore=[NSUserDefaults standardUserDefaults];
    [userscore setInteger:HightScore forKey:@"HightSroceKey"];
    [userscore synchronize];
    NSLog(@"save the hightScore=%d",HightScore);
}
-(void)readNSUserDefaultes{
    NSUserDefaults *userScore=[NSUserDefaults standardUserDefaults];
    HightScore =(int)[userScore integerForKey:@"HightSroceKey"];
    NSLog(@"read the hightScore=%d",HightScore);
    
}

-(void)numberViewOut{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        oldFramenumberView=self.numberView.frame;
        oldFramenumberView.origin.x-=(self.view.frame.size.width-self.numberView.frame.size.width)/2+self.numberView.frame.size.width;
        self.numberView.frame=oldFramenumberView;

    } completion:^(BOOL finished) {
        [self numberViewInto];
    }];
}
-(void)numberViewInto{
    [self refreshData];
    oldFramenumberView.origin.x=self.view.frame.size.width;
    self.numberView.frame=oldFramenumberView;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        oldFramenumberView.origin.x=(self.view.frame.size.width-self.numberView.frame.size.width)/2;
        self.numberView.frame=oldFramenumberView;
    } completion:nil];
}

@end

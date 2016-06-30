//
//  SecondViewController.h
//  Feaking Math1
//
//  Created by ruru on 16/3/31.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *scorelab;
@property (strong, nonatomic) IBOutlet UILabel *show;
@property (strong, nonatomic) IBOutlet UILabel *show1;
@property (strong, nonatomic) IBOutlet UIView *numberView;

- (IBAction)Right:(id)sender;
- (IBAction)Error:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *rightbtn;
@property (strong, nonatomic) IBOutlet UIButton *errorbtn;
@property (strong, nonatomic) IBOutlet UIView *progressOut;
@property (strong, nonatomic) IBOutlet UIView *progressIn;



@property (strong, nonatomic) IBOutlet UILabel *hightScorelab;
@property (strong, nonatomic) IBOutlet UILabel *gameScore;
@property (strong, nonatomic) IBOutlet UILabel *gameOver;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIButton *backHomeBtn;

- (IBAction)restart:(id)sender;
- (IBAction)back:(id)sender;
@end

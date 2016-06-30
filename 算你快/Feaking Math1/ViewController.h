//
//  ViewController.h
//  Feaking Math1
//
//  Created by ruru on 16/3/31.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *num;

@property (strong, nonatomic) IBOutlet UILabel *gameName;
@property (strong, nonatomic) IBOutlet UILabel *gameName1;

@property (strong, nonatomic) IBOutlet UIButton *goBtn;

- (IBAction)Startgame:(id)sender;
@end


//
//  QiuView.m
//  StudyForDymanic
//
//  Created by ss-iOS-LLY on 16/9/8.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "QiuView.h"

@implementation QiuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.layer.cornerRadius = frame.size.width / 2.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 2.f;
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

@end

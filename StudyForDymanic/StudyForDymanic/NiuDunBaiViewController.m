//
//  NiuDunBaiViewController.m
//  StudyForDymanic
//
//  Created by ss-iOS-LLY on 16/9/8.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "NiuDunBaiViewController.h"
#import "NewtonsCradle.h"

@interface NiuDunBaiViewController ()


@end

@implementation NiuDunBaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NewtonsCradle *newView = [[NewtonsCradle alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:newView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DRViewController.m
//  DRTools
//
//  Created by 3257468284@qq.com on 03/05/2020.
//  Copyright (c) 2020 3257468284@qq.com. All rights reserved.
//

#import "DRViewController.h"
#import "DRToolsHeader.h"

@interface RedModel : NSObject
@property (nonatomic, copy) NSString *redId;
@property (nonatomic, copy) NSString *redSex;
@property (nonatomic, copy) NSString *redAge;
@end

@implementation RedModel

@end

@interface DRViewController ()

@end

@implementation DRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[LFFMDBManager sharedManager] createTableWithTableName:@"red" modelClass:[RedModel class]];
    
    RedModel *model1 = [[RedModel alloc] init];
    model1.redAge = @"1";
    model1.redId = @"1";
    model1.redSex = @"1";
    
    RedModel *model2 = [[RedModel alloc] init];
    model2.redAge = @"2";
    model2.redId = @"2";
    model2.redSex = @"2";
    
    RedModel *model3 = [[RedModel alloc] init];
    model3.redAge = @"3";
    model3.redId = @"3";
    model3.redSex = @"3";
    
    [[LFFMDBManager sharedManager] insertModel:model1 tableName:@"red"];
    
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < 5000; i++) {
        [array addObject:model1];
    }
    [[LFFMDBManager sharedManager] insertModels:array tableName:@"red"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

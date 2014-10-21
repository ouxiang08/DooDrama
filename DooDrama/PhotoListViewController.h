//
//  PhotoListViewController.h
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *photoListTabeView;
@property (strong, nonatomic) NSMutableArray *photoList;

@end

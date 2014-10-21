//
//  ViewController.h
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface TakePhotoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (strong, nonatomic) IBOutlet UIButton *uploadPhotoBtn;


@end


//
//  ViewController.m
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "CoreDataManager.h"

@interface TakePhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

    CoreDataManager *_coreDataManaer;
}

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _coreDataManaer = [[CoreDataManager alloc] init];
    _coreDataManaer.entityName = kPhotoEntityName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takePhoto:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"你没有摄像头"
                              delegate:nil
                              cancelButtonTitle:@"Drat!"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)uploadPhoto:(id)sender {
    
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary           *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
    
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imgV.image = image;
}

@end

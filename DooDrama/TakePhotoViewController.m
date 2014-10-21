//
//  ViewController.m
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "CoreDataManager.h"
#import "FileTools.h"
#import "Photo.h"

@interface TakePhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

    CoreDataManager *_coreDataManaer;
    NSError *error;
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

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
    
//    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]){
//    
//        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    }else if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]){
//    
//        NSString* path = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//    }

    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imgV.image = image;
    [self savaImgToLoacalFile:image];
    
}


-(void)savaImgToLoacalFile:(UIImage *)image{
    
    CoreDataManager *photoDataManager = _coreDataManaer;
    
    NSData *data;
    if (UIImagePNGRepresentation(image)) {
        data = UIImageJPEGRepresentation(image, 0.75);
    }else{
    
        data = UIImagePNGRepresentation(image);
    }
    
    //文件夹
    NSString *serialNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"playNum"];
    NSString *fileName = nil;
    if (!serialNum) {
        fileName = [NSString stringWithFormat:@"play%@",@"1"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"playNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        fileName = [NSString stringWithFormat:@"play%@",serialNum];
    }
    
    NSString *filePath  = [NSString stringWithFormat:@"%@/%@",[FileTools getDocPath],fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
        if(!success){
            NSLog(@"Error %@",  error);
        }else{
            NSLog(@"Success");
        }
    }
    
    //图片
    NSString *imageName = nil;
    NSString *actNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"actNum"];
    if (!serialNum) {
        imageName = [NSString stringWithFormat:@"play%@",@"1"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        imageName = [NSString stringWithFormat:@"play%@",actNum];
    }
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",filePath,imageName];
    BOOL result = [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
    if (result) {
        Photo *photo = [[Photo alloc] init];
        photo.pid = [NSNumber numberWithInt:[serialNum intValue]];
        photo.pname = imageName;
        photo.ppath = imagePath;
        photo.pdoc = filePath;
        
        photoDataManager.managedObject = photo;
        [photoDataManager insert];
    }
}

@end

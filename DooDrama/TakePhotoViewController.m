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
#import "Catalog.h"

@interface TakePhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

    CoreDataManager *_fileCoreDataManaer;
    CoreDataManager *_catalogCoreDataManaer;
    
    NSString *serialNum;
    NSString *actNum;
    NSError *error;
}

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    serialNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"playNum"];
    actNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"actNum"];
    
    if (serialNum) {
        self.navigationItem.title = [NSString stringWithFormat:@"第%@场第%@幕",serialNum,actNum];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"第1场第1幕"];
    }
    
    _fileCoreDataManaer = [[CoreDataManager alloc] init];
    _fileCoreDataManaer.entityName = kPhotoEntityName;
    
    
    _catalogCoreDataManaer = [[CoreDataManager alloc] init];
    _catalogCoreDataManaer.entityName = kCatelogEntityName;
    
    self.takePhotoBtn.layer.cornerRadius = 8.0f;
    self.takePhotoBtn.backgroundColor = [UIColor blueColor];
    
    self.uploadPhotoBtn.layer.cornerRadius = 8.0f;
    self.uploadPhotoBtn.backgroundColor = [UIColor blueColor];
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
        
        // 摄像头
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^(void){}];
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
    
    CoreDataManager *photoManager = _fileCoreDataManaer;
    
    NSData *data;
//    if (UIImagePNGRepresentation(image)) {
//        data = UIImageJPEGRepresentation(image, 0.75);
//    }else{
//    
//        data = UIImagePNGRepresentation(image);
//    }
     data = UIImageJPEGRepresentation(image, 0.75);
    
    //文件夹
    serialNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"playNum"];
    actNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"actNum"];

    NSString *fileName = nil;
    if (!serialNum) {
        serialNum = @"1";
        fileName = [NSString stringWithFormat:@"play%@",serialNum];
        [[NSUserDefaults standardUserDefaults] setObject:serialNum forKey:@"playNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        
        if ([actNum isEqualToString:@"4"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[serialNum intValue]+1] forKey:@"playNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
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
    
    if (!actNum) {
        actNum = @"1";
        imageName = [NSString stringWithFormat:@"act%@.jpg",actNum];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        imageName = [NSString stringWithFormat:@"act%d.jpg",[actNum intValue]+1];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[actNum intValue]+1] forKey:@"actNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"第%@场第%@幕",serialNum,actNum];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",filePath,imageName];
    BOOL result = [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
    if (result) {
        Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:photoManager.entityName inManagedObjectContext:photoManager.managedObjectContext];
        photo.pid = [NSNumber numberWithInt:[serialNum intValue]];
        photo.pname = imageName;
        photo.ppath = imagePath;
        photo.pdoc = filePath;
        
        photoManager.managedObject = photo;
        [photoManager insert];
    }
}

- (NSArray *)getPlayCatelog{

    CoreDataManager *cagelogManager = _catalogCoreDataManaer;
    NSArray *cagelogList = [cagelogManager query];
    return cagelogList;
}

- (void)addCatelogInfo:(Catalog *)catalog{
    CoreDataManager *cagelogManager = _catalogCoreDataManaer;

    
}

- (void)updaeCateInfo:(Catalog *)catalog{
    CoreDataManager *cagelogManager = _catalogCoreDataManaer;
    
}


@end

^{
    <#code#>
}//
//  PhotoListViewController.m
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import "PhotoListViewController.h"
#import "CoreDataManager.h"
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"
#import "ToastViewAlert.h"
#import "Photo.h"

#define DefualtHomeUrl @"http://example.com/upload"


@interface PhotoListViewController ()<UITableViewDataSource, UITableViewDelegate>{

    CoreDataManager *photoDataManager;
}



@end

@implementation PhotoListViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.photoList = [NSMutableArray arrayWithArray:[photoDataManager query]];
    [self.photoListTabeView reloadData];
    
    int multiplier = 7;
    int (^myBlock)(int) = ^(int num) {
        return num * multiplier;
    };
    
    
    void(^loggerBlock)(NSString *) = ^(NSString *){
    
        
    };
    
    printf("%d", myBlock(3));
    // prints "21"

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    photoDataManager = [[CoreDataManager alloc] init];
    photoDataManager.entityName = kPhotoEntityName;
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
    self.navigationItem.title = @"待上传的图片列表";
    
    self.seletedPhotoList = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        [self.seletedPhotoList addObject:[NSNull null]];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPic)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)uploadPic{
    
//    if (self.seletedPhotoList.count>0) {
//    
//        for (Photo *photo in self.seletedPhotoList) {
//            if (![photo isKindOfClass:[NSNull class]]) {
//                
//                NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:DefualtHomeUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:photo.ppath] name:@"file" fileName:photo.pname mimeType:@"image/jpeg" error:nil];
//                } error:nil];
//                
//                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//                NSProgress *progress = nil;
//                
//                NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//                    if (error) {
//                        NSLog(@"Error: %@", error);
//                    } else {
//                        NSLog(@"%@ %@", response, responseObject);
//                        [self deleteImageFile:photo.ppath];
//                    }
//                }];
//                [uploadTask resume];
//            }
//        }
//
//    }else{
//    
//        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请选择要上传的图片！"];
//    }
//
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(self.seletedPhotoList.count, queue, ^(size_t i) {
        
        Photo *photo = [self.seletedPhotoList objectAtIndex:i];
        if (![photo isKindOfClass:[NSNull class]]) {
            
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:DefualtHomeUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:photo.ppath] name:@"file" fileName:photo.pname mimeType:@"image/jpeg" error:nil];
            } error:nil];
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSProgress *progress = nil;
            
            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", response, responseObject);
                    [self modifyPhotoInfo:photo];
                }
            }];
            [uploadTask resume];
            
            //[self.photoListTabeView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryView = progress;
        }
    });
}

- (void)modifyPhotoInfo:(Photo *)photo{
    
    photo.pisupload = [NSNumber numberWithInt:1];
    photoDataManager.managedObject = photo;
    BOOL flag = [photoDataManager update];
    
    if (flag) {
        [self deleteImageFile:photo.ppath];
    }else{
    
    }
}

- (void)deleteImageFile:(NSString *)path{

    NSError *error;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (result) {
        NSLog(@"success!");
    }else{
        NSLog(@"Error :%@",error);
    }
}
#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 10;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.photoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Photo *photo = [self.photoList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = photo.pname;
    cell.imageView.image = [UIImage imageWithContentsOfFile:photo.ppath];
    
    if ([self.seletedPhotoList objectAtIndex:indexPath.row]!=[NSNull null]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Photo *photo = [self.photoList objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.seletedPhotoList replaceObjectAtIndex:indexPath.row withObject:photo];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.seletedPhotoList replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

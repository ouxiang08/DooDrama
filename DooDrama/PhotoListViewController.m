//
//  PhotoListViewController.m
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import "PhotoListViewController.h"
#import "CoreDataManager.h"
#import "Photo.h"

@interface PhotoListViewController ()<UITableViewDataSource, UITableViewDelegate>



@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CoreDataManager *photoDataManager = [[CoreDataManager alloc] init];
    photoDataManager.entityName = kPhotoEntityName;
    
    self.photoList = [NSMutableArray arrayWithArray:[photoDataManager query]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

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
    
    return cell;
}

#pragma mark - UITableViewDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

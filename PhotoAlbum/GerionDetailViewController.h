//
//  GerionDetailViewController.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GerionCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

// UIScrollViewDelegate プロトコルに適合
@interface GerionDetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) NSURL *assetUrlFromSegue;
- (IBAction)rightSwiped:(id)sender;
- (IBAction)leftSwiped:(id)sender;

@end

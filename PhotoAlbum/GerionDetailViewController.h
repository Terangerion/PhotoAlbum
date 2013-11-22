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

@interface GerionDetailViewController : UIViewController
@property (nonatomic) NSURL *assetUrlFromSegue;
- (IBAction)handlePinchGesture:(id)sender;
- (IBAction)handleSwiped:(UISwipeGestureRecognizer *)sender;

@end

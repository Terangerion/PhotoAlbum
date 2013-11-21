//
//  GerionCollectionViewCell.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GerionThumbnailImageView.h"

@interface GerionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet GerionThumbnailImageView *imageView;

@end

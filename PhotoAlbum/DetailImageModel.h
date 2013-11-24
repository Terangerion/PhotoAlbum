//
//  DetailImageModel.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/24.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DetailImageModel : NSManagedObject

@property (nonatomic, retain) NSString * assetUrl;
@property (nonatomic, retain) NSNumber * referenceCount;
@property (nonatomic, retain) NSSet *tagModels;
@end

@interface DetailImageModel (CoreDataGeneratedAccessors)

- (void)addTagModelsObject:(NSManagedObject *)value;
- (void)removeTagModelsObject:(NSManagedObject *)value;
- (void)addTagModels:(NSSet *)values;
- (void)removeTagModels:(NSSet *)values;

@end

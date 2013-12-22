//
//  FirstViewController.m
//  iOSInterviewQuestion
//
//  Created by forrest on 13-12-21.
//  Copyright (c) 2013年 Design4Apple. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (NSComparisonResult)sort1{
   
    return NSOrderedAscending;
}

- (void)testSortArray{
    NSArray *inputArray = @[@"1",@"5",@"3",@"0",@"7"];
    
    //use caseInsensitiveCompare
    NSArray *outputArray1 = [inputArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSLog(@"output %@",outputArray1);
    
    NSArray *outputArray2 = [inputArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    NSLog(@"output %@",outputArray2);
    
    NSLog(@"input %@",inputArray);
}

- (void)testSortDescriptor{
    //First create the array of dictionaries
    NSString *last = @"lastName";
    NSString *first = @"firstName";
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *sortedArray;
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Jo", first, @"Smith", last, nil];
    [array addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Joe", first, @"Smith", last, nil];
    [array addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Joe", first, @"Smythe", last, nil];
    [array addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Joanne", first, @"Smith", last, nil];
    [array addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Forrest", first, @"zShi", last, nil];
    [array addObject:dict];
    
    //Next we sort the contents of the array by last name then first name
    
    // The results are likely to be shown to a user
    // Note the use of the localizedCaseInsensitiveCompare: selector
    NSSortDescriptor *lastDescriptor =
    [[NSSortDescriptor alloc] initWithKey:last
                                ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor *firstDescriptor =
    [[NSSortDescriptor alloc] initWithKey:first
                                ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:first ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = (NSString*)obj1;
        NSString *s2 = (NSString*)obj2;
        return [s1 compare:s2 options:NSCaseInsensitiveSearch];
    }];
    
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor,des, nil];
    sortedArray = [array sortedArrayUsingDescriptors:descriptors];
    
    NSLog(@"sorted array %@",sortedArray);
}


- (NSArray*)intersectArray:(NSArray*)arr1 withArray:(NSArray*)arr2{
    CFTimeInterval startT = CACurrentMediaTime();
    
    NSMutableSet *ms = [NSMutableSet setWithArray:arr1];
    [ms intersectSet:[NSSet setWithArray:arr2]];
    
    NSLog(@"took seconds %f", (CACurrentMediaTime()- startT));
    return [NSArray arrayWithArray:[ms allObjects]];
}

- (NSArray*)intersectArray2:(NSArray*)arr1 withArray:(NSArray*)arr2{
    CFTimeInterval startT = CACurrentMediaTime();
    
    NSMutableArray *ma = [NSMutableArray array];
    
    
//    [arr1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSInteger i1 = (NSInteger)obj;
//        NSLog(@"*****arr1 %d", idx);
//        [arr2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSInteger i2 = (NSInteger)obj;
//                    NSLog(@"arr2 %d", idx);
//            if (i1 == i2 ) {
//                [ma addObject:@(i1)];
//                *stop = YES;
//            }
//        }];
//    }];
    
    for (id obj in arr1) {
        int v1 = [obj integerValue];
        for (id obj2 in arr2) {
            int v2 = [obj2 integerValue];
            
            if (v1 == v2) {
                if (![ma containsObject:@(v2)]) {
                    [ma addObject:@(v2)];
                    break;
                }
            }
        }
    }
    
    
    
//    for (int i = 0 ; i < arr1.count; i++ ) {
//        int v1 = [[arr1 objectAtIndex:i] integerValue];
//        
//        for (int j = 0 ; j < arr2.count ; j++ ) {
//            int v2 = [[arr2 objectAtIndex:j ] integerValue];
//            
//            if (v1 == v2 ) {
//                [ma addObject:@(v1)];
//                break;
//            }
//        }
//    }
    
    NSLog(@"took seconds %f", (CACurrentMediaTime()- startT));
    return ma;
}

- (NSArray*)intersectArray3:(NSArray*)arr1 withArray:(NSArray*)arr2{
    
    NSArray *a1 = [self sortArray:arr1];
    NSArray *a2 = [self sortArray:arr2];

    CFTimeInterval startT = CACurrentMediaTime();

    //NSLog(@"sorted array %@", a1);
    
    NSMutableArray *ms = [NSMutableArray array];
    
    int i = 0 , j = 0 ;
    while (i < a1.count && j < a2.count ) {
        id obj1 = [a1 objectAtIndex:i];
        id obj2 = [a2 objectAtIndex:j];
        NSComparisonResult result = [obj1 compare:obj2];
        
        switch (result) {
            case NSOrderedAscending:
                i++;
                break;
                
            case NSOrderedDescending:
                j++;
                break;
            
            case NSOrderedSame:
                [ms addObject:obj1];
                i++;
                j++;
            default:
                break;
        }
        
    }
    
    
    NSLog(@"took seconds %f", (CACurrentMediaTime()- startT));
    return ms;
}

- (NSArray*)sortArray:(NSArray*)arr{
//    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        int v1 = (NSInteger)obj1;
//        int v2 = (NSInteger)obj2;
//        
//        if (v1 > v2 ) {
//            return NSOrderedDescending;
//        }else if (v1 < v2 ) {
//            return NSOrderedAscending;
//        }else {
//            return NSOrderedSame;
//        }
//        
//    }];
    
    NSArray *sortedArr = [arr sortedArrayUsingSelector:@selector(compare:)];
    return sortedArr;
}

const int N = 10000;

- (NSArray*)generateRandomNoDuplicatedArray{
    
    NSMutableArray *ma = [NSMutableArray array];

    while (ma.count < N ) {
        int rv = random()%(N*2);
        if (![ma containsObject:@(rv)]) {
            [ma addObject:@(rv)];
        }
    }
    
    NSLog(@"end generating %d", ma.count);
    
    return [NSArray arrayWithArray:ma];
    
}


- (void)testSet1{

    NSMutableSet *ms1 = [NSMutableSet setWithArray:@[@(1),@(12),@(13)]];
    NSMutableSet *ms2 = [NSMutableSet setWithArray:@[@(4),@(2),@(3)]];
    
    
    NSLog(@"intersect %@",[self intersectArray:[ms1 allObjects]  withArray:[ms2 allObjects]]);
    
}

- (void)testIntersectArray1{
    NSArray *a1 = [self generateRandomNoDuplicatedArray];
    NSArray *a2 = [self generateRandomNoDuplicatedArray];
    
    NSArray *sa = [self intersectArray:a1 withArray:a2];
    NSLog(@"intersect array count %d",sa.count);

    NSArray *sa2 = [self intersectArray2:a1 withArray:a2];
    NSLog(@"intersect array count %d",sa2.count);
    
    NSArray *sa3 = [self intersectArray3:a1 withArray:a2];
    NSLog(@"intersect array count %d",sa3.count);

}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[self testSortArray];
   // [self testSortDescriptor];
   // [self testSet1];
    [self testIntersectArray1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

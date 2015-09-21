#import <UIKit/UIKit.h>

NSString *const SXSortDidChangeNotification = @"SXSortDidChangeNotification";
NSString *const SXCurrentSortKey = @"SXCurrentSortKey";

NSString *const SXCategoryDidChangeNotification = @"SXCategoryDidChangeNotification";
NSString *const SXCurrentCategoryKey = @"SXCurrentCategoryKey";
NSString *const SXCurrentCategoryIndexKey = @"SXCurrentCategoryIndexKey";



/** 城市改变的通知 */
NSString *const SXCityDidChangeNotification = @"SXCityDidChangeNotification";
/** 通过这个key可以取出当前的城市模型 */
NSString *const SXCurrentCityKey = @"SXCurrentCityKey";

/** 区域改变的通知 */
NSString *const SXDistrictDidChangeNotification = @"SXDistrictDidChangeNotification";
/** 通过这个key可以取出当前的区域模型 */
NSString *const SXCurrentDistrictKey = @"SXCurrentDistrictKey";
/** 通过这个key可以取出当前子区域的索引 */
NSString *const SXCurrentSubdistrictIndexKey = @"SXCurrentSubdistrictIndexKey";

/** cell遮盖点击的通知 */
NSString *const SXCellCoverDidClickNotification = @"SXCellCoverDidClickNotification";

// 数值
CGFloat const SXScreenMaxWH = 1024;
CGFloat const SXScreenMinWH = 768;
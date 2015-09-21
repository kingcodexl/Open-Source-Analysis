#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const SXSortDidChangeNotification;
UIKIT_EXTERN NSString *const SXCurrentSortKey;

UIKIT_EXTERN NSString *const SXCategoryDidChangeNotification;
UIKIT_EXTERN NSString *const SXCurrentCategoryKey;
UIKIT_EXTERN NSString *const SXCurrentCategoryIndexKey;


/** 城市改变的通知 */
UIKIT_EXTERN NSString *const SXCityDidChangeNotification;
/** 通过这个key可以取出当前的城市模型 */
UIKIT_EXTERN NSString *const SXCurrentCityKey;

/** 区域改变的通知 */
UIKIT_EXTERN NSString *const SXDistrictDidChangeNotification;
/** 通过这个key可以取出当前的区域模型 */
UIKIT_EXTERN NSString *const SXCurrentDistrictKey;
/** 通过这个key可以取出当前子区域的索引 */
UIKIT_EXTERN NSString *const SXCurrentSubdistrictIndexKey;

// 数值
UIKIT_EXTERN CGFloat const SXScreenMaxWH;
UIKIT_EXTERN CGFloat const SXScreenMinWH;

/** cell遮盖点击的通知 */
UIKIT_EXTERN NSString *const SXCellCoverDidClickNotification;
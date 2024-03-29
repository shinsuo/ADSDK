//
//  PBHardwareUtil.h
//
//  Created by PunchBox.
//  Copyright 2011 PunchBox. All rights reserved.
//

#import <UIKit/UIKit.h>


// Platforms
// iFPGA	 ->	??
// iPhone1,1 ->	iPhone 1G
// iPhone1,2 ->	iPhone 3G
// iPhone2,1 ->	iPhone 3GS
// iPhone3,1 ->	iPhone 4/AT&T
// iPhone3,2 ->	iPhone 4/Other Carrier?
// iPhone3,3 ->	iPhone 4/Other Carrier?
// iPhone4,1 ->	??iPhone 5
// iPod1,1   -> iPod touch 1G 
// iPod2,1   -> iPod touch 2G 
// iPod2,2   -> ??iPod touch 2.5G
// iPod3,1   -> iPod touch 3G
// iPod4,1   -> iPod touch 4G
// iPod5,1   -> ??iPod touch 5G
// iPad1,1   -> iPad 1G, WiFi
// iPad1,?   -> iPad 1G, 3G <- needs 3G owner to test
// iPad2,1   -> iPad 2G (iProd 2,1)

// i386, x86_64 -> iPhone Simulator


// This must match up with device_string_names char array.
/*!	\enum UIDevicePlatform
 *	\brief This enum contains all available apple devices and is used for various UIDeviceExtend extension methods.
 *
 */
typedef enum UIDevicePlatform
{
	UIDeviceUnknown,
	UIDeviceiPhoneSimulator,
	UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
	UIDeviceiPhoneSimulatoriPad,
    
	UIDevice1GiPhone,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4iPhone,
	UIDevice5iPhone,
    
	UIDevice1GiPod,
	UIDevice2GiPod,
	UIDevice3GiPod,
	UIDevice4GiPod,
    
	UIDevice1GiPad, // both regular and 3G
	UIDevice2GiPad,
    UIDevice3GiPad,
    
    UIDeviceAppleTV2,
    UIDeviceUnknownAppleTV,
    
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
	UIDeviceUnknowniPad,
	UIDeviceIFPGA,
    
	UIDeviceMAX,
} UIDevicePlatform;


/*!	\category UIDeviceExtend(Hardware)
 *	\brief Extension category for UIDeviceExtend, used for querying more specific device data.
 *
 */
@interface UIDeviceExtend : NSObject {
    UIDevice *currentDev;
    
}


@property(nonatomic,readonly,retain) NSString    *name;              // e.g. "My iPhone"
@property(nonatomic,readonly,retain) NSString    *model;             // e.g. @"iPhone", @"iPod touch"
@property(nonatomic,readonly,retain) NSString    *systemName;        // e.g. @"iOS"
@property(nonatomic,readonly,retain) NSString    *systemVersion;     // e.g. @"4.0"
@property(nonatomic,readonly) UIDeviceOrientation orientation;       // return current device orientation.  this will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
@property(nonatomic,readonly,retain) NSString    *PBIdentifier;  // a string unique to each device based on various hardware info.

+ (UIDeviceExtend*)currentDevice;

- (void)beginGeneratingDeviceOrientationNotifications;      // nestable
- (void)endGeneratingDeviceOrientationNotifications;


/*!	\fn platform
 *	\brief Returns a the hardware platform that the device is running on.
 *  
 *  \return A string that describes the hardware platform that the device is running on.
 */
- (NSString*) platform;

/*!	\fn hwmodel
 *	\brief Returns the device name of the current device.
 *  
 *  \return A string containing the device name of the current device.
 */
- (NSString*) hwmodel;

/*!	\fn platformType
 *	\brief Returns the device type as enumerated by #UIDevicePlatform of the current device.
 *  
 *  \return An integer value representing a device type as enumerated by #UIDevicePlatform of the current device.
 */
- (NSUInteger) platformType;

/*!	\fn platformString
 *	\brief Returns the name of the current device.
 *  
 *  \return A string containing a descriptive name of the current device.
 */
- (NSString*) platformString;

- (NSString*) platformCode;

- (NSUInteger) cpuFrequency;

- (NSUInteger) busFrequency;

- (NSUInteger) totalMemory;

- (NSUInteger) userMemory;

- (NSNumber*) totalDiskSpace;

- (NSNumber*) freeDiskSpace;

- (NSString*) macaddress;

//add by ShinSuo
- (NSString *)uniqueIdentifier;
- (BOOL)isJailBroken;
- (NSString *)getMacAddress;

@end

//
//  CRBeaconManagerEnums.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/17/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

typedef NS_ENUM(NSInteger, CRBluetoothState) {
    CRBluetoothStateUnkown = 0,
    CRBluetoothStateResetting,
    CRBluetoothStateUnsupported,
    CRBluetoothStateUnauthorized,
    CRBluetoothStatePoweredOff,
    CRBluetoothStatePoweredOn,
};

typedef NS_ENUM(NSInteger, CREventType) {
    CREventTypeEnter = 0,
    CREventTypeExit,
};

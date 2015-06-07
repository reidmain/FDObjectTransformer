@import XCTest;

#import "FDDeclaredPropertyTestModel.h"
#import "FDDeclaredPropertyTestModelSubclass.h"
#import "NSObject+DeclaredProperty.h"
#import "FDKeypath.h"


@interface FDDeclaredPropertyTests : XCTestCase

@end

@implementation FDDeclaredPropertyTests

- (void)testName
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqualObjects(@keypath(testModel.charProperty), [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.charProperty)].name);
	XCTAssertEqualObjects(@keypath(testModel.intProperty), [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.intProperty)].name);
	XCTAssertEqualObjects(@keypath(testModel.shortProperty), [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.shortProperty)].name);
}

- (void)testObjectClass
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqualObjects(nil, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.charProperty)].objectClass);
	XCTAssertEqualObjects([NSObject class], [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.objectProperty)].objectClass);
	XCTAssertEqualObjects([NSString class], [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.stringProperty)].objectClass);
	XCTAssertEqualObjects(nil, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.weakProperty)].objectClass);
	XCTAssertEqualObjects(nil, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.classProperty)].objectClass);
}

- (void)testTypeEncodings
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingChar, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.charProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingInt, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.intProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingShort, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.shortProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingLongLong, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.longProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingLongLong, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.longLongProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingUnsignedChar, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.unsignedCharProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingUnsignedInt, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.unsignedIntProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingUnsignedShort, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.unsignedShortProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingUnsignedLongLong, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.unsignedLongProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingUnsignedLongLong, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.unsignedLongProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingFloat, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.floatProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingDouble, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.doubleProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingBool, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.boolProperty)].typeEncoding);
//	XCTAssertEqual(FDDeclaredPropertyTypeEncodingVoid, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.voidProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingCharacterString, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.characterStringProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingObject, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.objectProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingObject, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.copiedProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingObject, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.weakProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingClass, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.classProperty)].typeEncoding);
	XCTAssertEqual(FDDeclaredPropertyTypeEncodingSelector, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.selectorProperty)].typeEncoding);
}

- (void)testMemoryManagementPolicy
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqual(FDDeclaredPropertyMemoryManagementPolicyAssign, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.charProperty)].memoryManagementPolicy);
	XCTAssertEqual(FDDeclaredPropertyMemoryManagementPolicyRetain, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.strongProperty)].memoryManagementPolicy);
	XCTAssertEqual(FDDeclaredPropertyMemoryManagementPolicyAssign, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.weakProperty)].memoryManagementPolicy);
	XCTAssertEqual(FDDeclaredPropertyMemoryManagementPolicyCopy, [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.copiedProperty)].memoryManagementPolicy);
}

- (void)testWeakReference
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertFalse([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.strongProperty)].isWeakReference);
	XCTAssertTrue([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.weakProperty)].isWeakReference);
}

- (void)testReadonly
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertFalse([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.notReadonlyProperty)].isReadOnly);
	XCTAssertTrue([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.readonlyProperty)].isReadOnly);
}

- (void)testNonAtomic
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertFalse([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.atomicProperty)].isNonAtomic);
	XCTAssertTrue([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.nonAtomicProperty)].isNonAtomic);
}

- (void)testDynamic
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertFalse([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.synthesizedProperty)].isDynamic);
	XCTAssertTrue([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.dynamicProperty)].isDynamic);
}

- (void)testBackingInstanceVariable
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqualObjects(@"_synthesizedProperty", [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.synthesizedProperty)].backingInstanceVariableName);
	XCTAssertNil([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.dynamicProperty)].backingInstanceVariableName);
}

- (void)testCustomGetter
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqualObjects(@"myCustomGetter", [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.customGetterProperty)].customGetterSelectorName);
	XCTAssertNil([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.synthesizedProperty)].customGetterSelectorName);
}

- (void)testCustomSetter
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	XCTAssertEqualObjects(@"myCustomSetter:", [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.customSetterProperty)].customSetterSelectorName);
	XCTAssertNil([FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.synthesizedProperty)].customSetterSelectorName);
}

- (void)testEquality
{
	FDDeclaredPropertyTestModel *testModel = nil;
	
	FDDeclaredProperty *declaredPropertyFromKey = [FDDeclaredPropertyTestModel fd_declaredPropertyForName: @keypath(testModel.testModel)];
	FDDeclaredProperty *declaredPropertyFromKeyPath = [FDDeclaredPropertyTestModel fd_declaredPropertyForKeyPath: @keypath(testModel.testModel.testModel.testModel)];
	XCTAssertEqualObjects(declaredPropertyFromKey, declaredPropertyFromKeyPath);
}

- (void)testPropertyCount
{
	NSArray *allDeclaredPropertiesOnTestModel = [FDDeclaredPropertyTestModel fd_declaredPropertiesUntilSuperclass: nil];
	NSArray *allDeclaredPropertiesOnTestModelAltMethod = [FDDeclaredPropertyTestModel fd_declaredPropertiesUntilSuperclass: [NSObject class]];
	XCTAssertEqual(32, [allDeclaredPropertiesOnTestModel count]);
	XCTAssertEqual([allDeclaredPropertiesOnTestModel count], [allDeclaredPropertiesOnTestModelAltMethod count]);
	
	NSArray *allDeclaredPropertiesOnTestModelSubclass = [FDDeclaredPropertyTestModelSubclass fd_declaredPropertiesUntilSuperclass: nil];
	XCTAssertEqual(35, [allDeclaredPropertiesOnTestModelSubclass count]);
	
	NSArray *declaredPropertiesOnTestModelSubclass = [FDDeclaredPropertyTestModelSubclass fd_declaredPropertiesUntilSuperclass: [FDDeclaredPropertyTestModel class]];
	XCTAssertEqual([allDeclaredPropertiesOnTestModelSubclass count] - [allDeclaredPropertiesOnTestModel count], [declaredPropertiesOnTestModelSubclass count]);
	
	// TODO: Need to add a test using a object that adheres to a protocol that adheres to NSObject so the scenario where properties on the NSObject protocol will appear.
}

- (void)testPerformance
{
    [self measureBlock: ^
		{
			for (NSUInteger i=0; i < 50000; i++)
			{
				[FDDeclaredPropertyTestModel fd_declaredPropertiesUntilSuperclass: nil];
			}
		}];
}


@end

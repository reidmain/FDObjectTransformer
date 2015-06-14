# Overview
An framework to allow developers to easily change any instance of a class A into an instance of class B.

# Installation
There are two supported methods for FDObjectTransformer. Both methods assume your Xcode project is using modules.

## 1. Subprojects
1. Add the "FDObjectTransformer" project, inside the "Framework Project" directory, as a subproject or add it to your workspace.
2. Add "FDObjectTransformer (iOS/Mac)" to the "Target Dependencies" section of your target.
3. Use "@import FDObjectTransformer" inside any file that will be using FDObjectTransformer.

## 2. CocoaPods
Simply add `pod "FDObjectTransformer", "~> 1.0"` to your Podfile.

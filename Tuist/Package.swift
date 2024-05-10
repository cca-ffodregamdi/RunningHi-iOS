// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [
            "Moya" : .framework,
            "Alamofire" : .framework,
            "SnapKit" : .framework,
            "RxSwift" : .framework,
            "ReactorKit" : .framework,
            "Kingfisher" : .framework,
            "RxCocoa" : .framework,
            "RxKakaoSDKAuth" : .framework,
            "RxKakaoSDKUser" : .framework,
            "KakaoSDKAuth" : .framework,
            "KakaoSDKUser" : .framework,
            "KakaoSDKCommon" : .framework,
            "RxKakaoSDKCommon" : .framework,
        ]
    )
#endif

let package = Package(
    name: "RunningHi",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.7.0")),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "3.2.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/kakao/kakao-ios-sdk-rx.git", .upToNextMajor(from: "2.22.1"))
    ]
)

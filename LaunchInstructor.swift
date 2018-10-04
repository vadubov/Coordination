import UIKit

struct LaunchInstructorConfiguration {
    let onboardingWasShown: Bool

    static func current() -> LaunchInstructorConfiguration {
        let onboardingWasShown = Defaults.onboardingWasShown
        return LaunchInstructorConfiguration(onboardingWasShown: onboardingWasShown)
    }
}

enum LaunchInstructor {
    case onboarding, main

    static func configure(configuration: LaunchInstructorConfiguration = LaunchInstructorConfiguration.current()) -> LaunchInstructor {
        if !configuration.onboardingWasShown {
            return .onboarding
        }
        return .main
    }
}

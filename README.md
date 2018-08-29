# GYGDemo

## Introduction
Thanks for giving me the opportunity to work on your coding challenge. So here's the final solution. Hope you enjoy reviewing it and feel free to reach out to me in case of any questions.

## Installation
There is no team selected yet for code signing. This will work fine in the simulator but not when testing on the device. So please select a team and a device to run the app.

## Architecture and general approach
- The general pattern used for the architecture is MVVM. This together with a coordinator/presenter approach is the foundation for the overall app navigation.
- The app uses quite a lot of protocols to improve handling for cell reusing/providing, connecting view model and controller, caching table view cell heights, etc.
- The APIClient uses generics to return a matching domain object model type depending one the endpoint being queried. The model objects are being created on the background queue for the reason that the field 'title' and 'message' in the rating comment contain html entities which need to be converted to regular string by turning them into and NSAttributedString first. This is a quite intensive operation and therefore should not block the main thread for the sake of scroll performance.
- Several options have been provided for the user to customise and filter the rating comments being displayed: Only show rating comments of a certain rating, sort by date of review or rating, sort the result ascending or descending as well as hide rating comments written in a foreign language. Those settings are being persisted in the user defaults.
- A view controller, view model and presentation route for the creation of a new rating comment has been added to the project but not yet fully implemented.

## Third party frameworks and resources
- HCSStarRatingView (https://github.com/hsousa/HCSStarRatingView) has been used via Cocoapods to display the star rating.
- Icons for bar button items were taken from https://icons8.de/ios

## Known issues and potential improvements
- Opening the settings popover while content is loading might lead to the star rating in the table view cells being displayed with a grey color instead of the expected yellow/golden one once the loading finished and the content is being shown on screen. Scrolling the cell out of the view port and back in to force a redraw fixes that issue.
- Simulator scrolling performance is really poor. At least that's my impression. Work great on the device though. Stronly encourage you to test the app on an actual device.
- Handling the empty state in case of either no content could be loaded or the filter settings lead to no content being displayed at all.
- Guess we don't really need to talk about how 'pretty' app icon and launch screen are. I see huge potential for improvements there =)

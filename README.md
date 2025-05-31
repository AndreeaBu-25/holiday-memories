# Holiday-memories

iOS application, developed using SwiftUI and MapKit in Xcode. It features an interactive white world map (generated from a GeoJSON file), where users can tap on any country to add travel details such as: location name, start and end dates, number of people, travel companions, transportation method, trip photos, personal notes, and a 5-star rating. Users can also customize the color of visited countries directly on the map. Each trip is saved and linked to the selected country, tracking the number of visits. A separate view displays all trip details, making this app ideal for travel enthusiasts who want to document and visualize their journeys.

## How it works

- The app starts with a white world map displayed on screen
- When the user taps on a country, a new entry screen opens where they can add a location with the following details:
    - Location name
    - Start and end date of the trip
    - Transportation method
    - The number of companions
    - The names of the companions, if there are any
    - Some thoughts about the trip 
    - Photos from the trip
    - Rating
- Each location is saved under the selected country
- After adding a visited location, the user can color the corresponding country with a custom color of their choice
- TThe app keeps track of how many times the user has visited each country
- All added locations can be viewed later with their full details
- All data is stored locally on the device

## Future improvements 

- iCloud sync
- trip sharing
- wish list
- bug fixing 

## Technology used

- Swift
- SwiftUI
- Xcode

## Requirements

- macOS with Xcode installed
- iOS device or simulator running iOS 15+

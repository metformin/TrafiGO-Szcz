# TrafiGO Szcz
An application that will allow you to check the public transport timetable in Szczecin.<br>
Fully coded in Swift using the Combine framework and MVVM design pattern.
<br>
<br>
Most of the public transport tracking apps available do not include Szczecin. This is due to the fact that the Road and Public Transport Authority in Szczecin does not provide a friendly API for developers. This application uses the WebKit framework to retrieve data and convert it into JSON objects.
<br>
1. The app on the home screen shows pins with all public transport stops in Szczecin.
<br>
<p align="center"><img src="https://user-images.githubusercontent.com/45921300/134822415-85658b4a-291a-4219-917d-de5ef58e4a44.png" width="300"> <img src="https://user-images.githubusercontent.com/45921300/134822583-e686a917-4bcf-41c5-a5af-4425fddf6314.png" width="300"></p>
<br>

2. After selecting a specific stop, the application displays the planned arrivals of public transport. Live data is downloaded (if the vehicle has a GPS module installed), if not, arrivals are displayed by timetable.
<br>
<p align="center"><img src="https://user-images.githubusercontent.com/45921300/134822613-c4aca49f-e748-4af9-9995-9e11b8a1a32c.png" width="300"> <img src="https://user-images.githubusercontent.com/45921300/134822624-6d08a1fa-8d8d-4f19-b8b0-5a023bd63201.png" width="300"></p>
<br>

3. The user can also search for a bus stop by his name. After clicking on the name, the map centers on the stop and displays the timetable.
<br>
<p align="center"><img src="https://user-images.githubusercontent.com/45921300/134822797-6e70c45b-91fb-4adb-a336-6508f5f07b62.png" width="300"> <img src="https://user-images.githubusercontent.com/45921300/134822801-7e2abfdb-4874-483d-9518-95c4848a8934.png" width="300"></p>
<br>

Full tech stack used in project:

| Name | Description          |
| ------------- | ----------- |
| Combine      | Handling of asynchronous events by combining event-processing operators.|
| WebKit     | Framework used to loads the web content and download data from a website using JavaScript.   |
| MapKit     | Used to display map within app, call out points of stops, and determine annotations about timetable.   |
| CoreLocation    | Used to track changes in the user’s current location. Allows to center the map to the user's position.   |
| SwiftSoup     | Framework used to find and extract HTML data about timetable and converting it to Swift objects. |


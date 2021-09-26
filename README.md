# TrafiGO Szcz
An application that will allow you to check the public transport timetable in Szczecin.<br>
Fully coded in Swift using the Combine framework and MVVM design pattern.
<br>
<br>
Most of the public transport tracking apps available do not include Szczecin. This is due to the fact that the Road and Public Transport Authority in Szczecin does not provide a friendly API for developers. This application uses the WebKit framework to retrieve data and convert it into JSON objects.
<br>
1. The app on the home screen shows pins with all public transport stops in Szczecin.
<br>
<p align="center"><img src="" width="300"> <img src="https://user-images.githubusercontent.com/45921300/133325307-356ae6b3-d774-43b4-9e41-5a68d1830280.PNG" width="300"></p>
<br>

2. After selecting a specific stop, the application displays the planned arrivals of public transport. Live data is downloaded if possible (if the vehicle has a GPS module installed).
<br>

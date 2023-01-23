# TravelEzy

# About

This is a demo iOS app created in Swift using Xcode13 which aims to help people who are travelling to a new city. This app will provide the users with some basic information of the place which they are planning to visit.

# Installation

This app uses some external dependencies and the list of libraries can be found in the Pod file. Run the following command in terminal to install all dependencies.

$ pod install

# Features

- The app will display the local Date and Time of the selected city.
- The app will display the current temperature, wind and humidity. It also displays the weather for the next 5 days which would help the users in planning their vacation.
- The app shows some popular places of the selected city. This would include the description, ratings, images along with map view for each place.
- The app shows a list of Restaurants in the city with the information such as restaurant name, address, average cost, cuisine type opening times, ratings along with the images of the menu items. Users can also search for specific restaurants using the search functionality available.
- The app also shows a list of Hotels in the city with the information such as hotel name, address, description, ratings along with image. In addition, the list of facilities and the different types of rooms (along with their prices) available in the hotel is also displayed in the segmented view.
- Users can also sort and filter the list of hotels based on the options provided. In the Filter screen, users can filter based on the price range affordable, hotel ratings and the list of hotel amenities they would prefer.

# How to use

- In the Login Screen, user needs to select “Continue As A Guest” button and proceed as a guest user only. As of now, the login feature is disabled and it is allowed only for Service Providers to feed the required app data such as places, hotels and restaurants. Note that all the app data is stored and fetched from Firebase.
- In the Select City Dropdown - User needs to select the following -> Country: United States, State: California, City: Cupertino. By selecting the ‘Cupertino’ City, user would be able to see all the data in the app since data has been uploaded in the Firebase console for this particular city only.

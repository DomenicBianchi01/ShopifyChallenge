This project was made with Xcode 9.3 and Swift 4.1

The app supports all orientations on iPhone and iPad

In the "Entities" folder, for classes like "Product" and "Variant" only the required fields for the purpose of this challenge are stored. However, by conforming to "Decodable", it is easy to add additional properties in the future.

The idea behind "JSONService" is if the app was to expand its functionality and additional API requests are required, a new "Service" class (like "ProductService") could be created and inherit "JSONService" which does all the heavy lifting for sending the request and decoding the response. Even though the scope of the challenge only requires GET requests, I have included the other types of requests in "JSONService" to show the usefulness of the class.

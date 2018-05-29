# Project 43 - Bartinder 

Log:


May 12 : Ingredients selection complete, using alamofire request to cocktaildb api + basic error handling

May 12 : (Automatic) matching for drinks based on ingredients, api is unable to select multiple ingredients at once?

May 13 : Drink detail screen. Navigate to Ingredient -> Alcohol -> Click on the image to display information about the drink/method/other ingredients/amount.

May 13: Add Firebase db connection and Firebase Authentication with a Pre-Built auth screen. Providers allowed are Email/Password and Google

May 13-18: 
  - Merged Firebase commits.
  - Reworked DrinkDetailController - image bounce, navigationBar is now translucent.
  - Added buttons -> swiping in DrinkMatchingController for ease of access -> Can be easily changed to navigation bar later on, but it's done.
  - Added image placeholder incase of network lag when displaying the image.
  - Drinks are now swipeable, able to view them by swiping left/right. Selection is still the same.
  - Added pull to refresh to IngredientSelectionScreen
  - Displayed a dedicated view for network errors on IngredientSelectionScreen.
  - Added search to IngredientSelectionScreen.
  - Transparent tutorial is now visible for a first time user : Only visible when using DrinkMatchingScreen.
  - Fixed the API displaying blank ingredients by checking for empty " ", "%20", "\r", "\r\n".
  - Useless but pretty animations
  
  May 21-22: Add "Friends" and "Add Friends" screens.
  
  
  May 28: Added proper tinder-like swipe. 

May 30:
- Drink Matching now comes from Random API
- Swipe right adds to favorites list
- Drink Detail now brings down data from the API
- Refactored API to service class
- New Friend Service for connectring to friends in db
- Users now show up on Add Friend screen
- Friends added now show on the Friends Screen
- Tapping on a Friend shows that friends drinks

# Flix

Flix is an app that allows users to browse movies from the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

## Flix Part 2

### User Stories

- [x] User can tap a cell to see more details about a particular movie.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.
- [x] User can tap a poster in the collection view to see a detail screen of that movie.
- [x] In the detail view, when the user taps the poster, a new screen is presented modally where they can view the trailer.

### App Walkthrough GIF

<img src="https://i.imgur.com/KXXetoi.gif" width=250><br>


### Notes
Obtaining the trailers for the movies was a challenge. This was done by requesting the json from the selected movie and then saving the data as dictionaries. Using the array of trailers, the default first trailer in the array was used to open a webview.

---

## Flix Part 1

### User Stories

- [X] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view and scroll through a list of movies now playing in theaters.
- [x] User can view the movie poster image for each movie.
- [x] User can view the app on various device sizes and orientations.
- [x] Run your app on a real device.

### App Walkthrough GIF
<img src="https://i.imgur.com/nTnc6CS.gif" width=250><br>

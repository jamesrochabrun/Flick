# Flick

# Project 1 - *My Movie App*

**Flick** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **8** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [ ] For the large poster, load the low-res image first, switch to high-res when complete.
- [ ] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x ] List anything else that you can get done to improve the app functionality!
- App build with just one CollectionView class for the main screen of the App.
- Using collection view layout dynamic change to show grid and list
- Use autolayout programatically to achieve dynamic changes of layout.
- Use autolayout programatically to layout full app
- Use protocols
- Use MVVM
- Use basic animation
- Create custom views
- Custom tab bar 
- create a custom cachable protocol to show placeholder image on loading from server
- create protocol to make easier to improve reusability of reusable object (collectionviews)
- Cells resize dynamically based on the content of the movie overview.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/emI1B9m.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
I decide to use a different approach in order to get the functionality of changing grid to list layout, by changing dynamically the layout of the Uicollectionlayout and of the cell, I am only using one class of CollectionviewController and one cell and make them reusable just by updating the constraints with animation. It needs some adjustment.

## License

    Copyright [2017] [James Rochabrun]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

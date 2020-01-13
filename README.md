# Elm App PWA

# Why

We are looking at building a cross-browser and devices application which can also work offline.
Elm has become our default choice for front-end development and using Progressive Web App features
will enhance the application by making it usable offline.

# What

## A Single Page Application build with Elm
  
<img src="https://user-images.githubusercontent.com/6057298/71968230-62f58a80-31fc-11ea-86db-8c64f8dd76b3.png" width="100">

The entry point and only file returned by the backend is the index.html.
This file defines the basic html tags (head and body) which contains links to the css and js code.
The most important file included in the `index.html` is `elm.js` file which defines all the logic of the application.

Learn more about Elm at https://github.com/dwyl/learn-elm

## A Progressive Web App

<img src="https://user-images.githubusercontent.com/6057298/71970060-d220ae00-31ff-11ea-9faa-3d8beed3c6da.png" width="100">

To make the application progressive,
we need to add two files:
- `manifest.json`: This file contains the application description (eg: name, logo, main colour,...)
- `service_worker.js`: This file contains the logic for the application to work offline, ie which requests should be cached.

These two files should be enough to have a PWA:

![image](https://user-images.githubusercontent.com/6057298/71974614-cfc35180-3209-11ea-8cca-27a6dec7d545.png)

![image](https://user-images.githubusercontent.com/6057298/71974641-e79ad580-3209-11ea-89c6-ad474c891d1c.png)

We still want the ability to save data when the application is offline.
LocalStorage and cookies are not supported by service workers.
A solution when we want to save data with a PWA is to use [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
and in our exemple we are more specifically using [PouchDB](https://pouchdb.com/).
PouchDB is a database built on top of IndexedDB and which is easier to use.

To `install` PouchDB we just need to add the following script to our html:
```html
<script src="//cdn.jsdelivr.net/npm/pouchdb@7.1.1/dist/pouchdb.min.js"></script>
```

Then the `pouchdb.js` file contains the logic to save information and retrieve all the data, using the `put` and `allDocs` API.
The documentation for PouchDB is accessible at the following url: https://pouchdb.com/guides/documents.html

Learn more about Progressive Web App at https://github.com/dwyl/learn-progressive-web-apps

# How

## Deployement on Heroku

We are looking to make the deployement process as easy and quick as possible to allow
other people to play and run the application.
After first using [Github Pages](https://pages.github.com/) then Heroku and [http-server](https://www.npmjs.com/package/http-server) (as a nodejs application backend to render the index.html file),
we found out that keeping Heroku but using the [heroku-buildpack-static](https://github.com/heroku/heroku-buildpack-static) tool to serve the index file is the easiest deployement solution at the moment.

Clone this repository: `git clone git@github.com:dwyl/elm-pwa-example.git`

Before deploying the applicaiton make sure to compile the Elm code with `elm make src/Main.elm --output elm.js --optimize`. This will create the `elm.js` file

Create a new Heroku application. Read https://github.com/dwyl/learn-heroku which describe how to do this.

Add the buildpack to Heroku. In the settings of the Heroku application click "Add buildpack" and add the following git url: https://github.com/heroku/heroku-buildpack-static.git

![image](https://user-images.githubusercontent.com/6057298/71976123-79581200-320d-11ea-9152-1ab9bd045db2.png)

You are now ready to deploy the application, connect Heroku to your cloned repository and deploy manually the branch:

![image](https://user-images.githubusercontent.com/6057298/71976326-f4b9c380-320d-11ea-9370-f9e8c6d23473.png)

The application should now be accessible:

![image](https://user-images.githubusercontent.com/6057298/71976383-1c109080-320e-11ea-8296-04fb012ed597.png)
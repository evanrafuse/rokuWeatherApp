# rokuWeatherApp
Roku Weather App for Self-Directed

I built this app while learning Roku (BrightScript/SceneGraph). The photographs are from Unsplash. The logo is terrible (that's how you can tell it was made by me). To use this you'll have to get your own API Key for OpenWeather and put it in api_key.json.

Changelog:

January 16 2023 - Cleaning up.
Removed the RokuBuilder stuff, wasn't necessary. The app still launches from the VS Code. Don't bother with the NPM nonsense. Also removed the RALE stuff.

May 5 2022 (later) - Removed Rendezvous in tasks.
Changed load_feed_task to remove unnecessary rendezvous.

May 5 2022 - Added Config Files.
The app can now be launched with the BrightScript extension, RokuBuilder or RALE.
It will throw an error on launch about TrackerTask. X it and it will launch.
Don't forget to npm install and build install in the root before launching.
Remember to launch with Roku Builder you have to be in the src directory.

April 12 2022 - Added README to git

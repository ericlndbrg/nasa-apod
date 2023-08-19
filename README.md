## A simple command-line Ruby application that downloads the Astronomy Picture of the Day (APOD) from NASA.

This app needs a few things to work. I'm using:
- Ubuntu 22.04.3
- Ruby 3.2.2
- Bundler 2.2.17
- WGET 1.21.2

Smoke Test:
```
git clone <repo_url>
cd nasa-apod/
bundle install
mkdir images
echo 'export NASA_APOD_API_KEY="DEMO_KEY"' >> ~/.bashrc
source ~/.bashrc
ruby app.rb
```

The instuctions above should produce one of two possible results. Either the APOD for today has been downloaded and is saved in the *./images* directory, or a message is displayed in the terminal that tells you that the APOD for today isn't an image (sometimes they're videos/gifs). This app doesn't attempt to download non-image APODs.

Be sure to replace "DEMO_KEY" with an actual [NASA API Key](https://api.nasa.gov/#signUp).

The app can be ran in one of two ways (use *YYYY-MM-DD* date format):
- `ruby app.rb` (attempts to download the APOD for today)
- `ruby app.rb <date>` (attempts to download the APOD for the provided date)

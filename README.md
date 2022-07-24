## This is a simple command line Ruby application that downloads the Astronomy Picture of the Day (APOD) from NASA.

I'm using:
- Ubuntu 20.04.4
- Ruby 3.0.0
- Bundler 2.2.17
- WGET 1.20.3

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

You should have the APOD for today saved in *./images*. If not and no errors are present, today's APOD isn't an image. Run the app again with a date as input until an image appears in */images*. See instructions below for details.

Be sure to replace "DEMO_KEY" with an actual [NASA API Key](https://api.nasa.gov/#signUp).

The app can be ran in the following ways (use *YYYY-MM-DD* date format):
- `ruby app.rb` (downloads the APOD for today)
- `ruby app.rb <date>` (downloads the APOD for the provided date)
- `ruby app.rb <start_date> <end_date>` (downloads the APODs between start_date and end_date inclusive)

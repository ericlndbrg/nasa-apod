# This is a simple command line Ruby application that downloads the Astronomy Picture of the Day (APOD) from NASA.

I'm using:
- Ubuntu 20.04.4
- Ruby 3.0.0
- SQLite 3.31.1
- WGET 1.20.3

Smoke Test:
```
clone the repo
cd nasa_apod/
mkdir images
echo 'export NASA_APOD_API_KEY="DEMO_KEY"' >> ~/.bashrc
ruby app.rb
```

You should have the APOD for today saved in the ./images directory. If not and no errors are present, the APOD for today is not an image. In that case, nothing is downloaded.

Be sure to replace "DEMO_KEY" with an actual [NASA API Key](https://api.nasa.gov/#signUp).

The app can be ran in the following ways (use *YYYY-MM-DD* date format):
- `ruby app.rb` (downloads the APOD for today)
- `ruby app.rb <date>` (downloads the APOD for <date>)
- `ruby app.rb <start_date> <end_date>` (downloads the APODs between <start_date> and <end_date> inclusive)

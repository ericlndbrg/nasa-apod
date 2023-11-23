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
ruby init.rb
```

If all goes well, you should have the APOD for today saved in the *./images* directory and the explanation for the APOD printed in the terminal.

Sometimes, the APOD is not an image. If that's the case, the app does not attempt to download it.

Be sure to replace "DEMO_KEY" with an actual [NASA API Key](https://api.nasa.gov/#signUp).

The app can be ran in one of two ways (use *YYYY-MM-DD* date format):
- `ruby init.rb` (attempts to download the APOD for today)
- `ruby init.rb <date>` (attempts to download the APOD for the provided date)

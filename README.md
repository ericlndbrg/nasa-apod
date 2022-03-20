This is a simple Ruby application that downloads the NASA Astronomy Picture of the Day (APOD).

I'm using:
  Ubuntu 20.04.4
  Ruby 3.0.0
  SQLite 3.31.1
  WGET 1.20.3

The APOD is not always an image, sometimes it's a video.

When you run the app, it does something like this:
  search for a record in the db that corresponds to today's date
  if there is one
    and today's APOD is an image
      check if it's already been downloaded
        if so
          tell that to the user and exit
        if not
          download the image
    and today's APOD is not an image
      tell that to the user and exit
  if there isn't one
    use the NASA APOD API to fetch the data for today's APOD
    if today's APOD is an image
      download the image
    if today's APOD is not an image
      tell that to the user and exit

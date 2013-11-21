# Anima CRAZY!

Generate animated gifs of words and such easier than you ever have!


## System Requirements

* OSX with a ruby development environment
* ImageMagick with freetype and ghostscript installed
* a super attitude

### Installing requirements

If you don't already have homebrew on your machine, make it so.  http://brew.sh

Then

    brew install imagemagick freetype ghostscript

Test it by trying

    identify -version

You should see something like 

    Version: ImageMagick 6.8.0-10 2013-11-21 Q16 http://www.imagemagick.org

If you get there, you're probably in bizness

### Fetch and start up the app


    cd <directory where i put my projects/apps>
    git clone git@github.com:bunnymatic/animacrazy.git
    cd animacrazy
    bundle
    ./rerun.sh

### Make some frames

Hit `http://localhost:9292/generate?words=this+is+going+to+rock`

Try again with different words in the url.

    

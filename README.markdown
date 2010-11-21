Stoplight
===================
A super simple status system
-----------------------------

Use it to to monitor your builds, your scripts, or whether you are in
or out of the office.  
Really it's up to you.

Features
---------

Ultra-volatile datastore, resets whenever I deploy a new one, or
heroku kills my instances.  
Who cares, this is about what's going on right now.. any old messages
are yesterdays news.

Usage
-----

Think of the name of your app, now think of that name when you see the
word 'myapp'

** GET /myapp ** returns green or red or yellow.  
** PUT /myapp?status=green ** sets status green  
** PUT /myapp?status=yellow ** sets status yellow  
** PUT /myapp?status=red ** sets status red  
** POST /myapp ** creates an app if there is none (put does this too)  
** DELETE /myapp ** deletes an app

Need a frontend?
----------------

** GET /myapp/front ** returns a pretty little javascript to keep you
updated on your apps status

Usage Hints!
-------------

add this to your .autotest file, for perpetual greenosity



    `require 'rest_client'                                                                                

    @appname = 'myapp'

    Autotest.add_hook :red do
      RestClient.put "
    <http://stoplightapp.heroku.com/#{@appname}>
    ", :status => 'red'
    end

    Autotest.add_hook :green do
      RestClient.put "
    <http://stoplightapp.heroku.com/#{@appname}>
    ", :status => 'green'
    end`


Need Security?
-----------------

_ POST /myapp?secret=something _ makes a stoplight _ only\_you _ can
change the colour of.. until the app resets( which it does at random)  
** PUT /myapp?status=green ** 403 access denied!  
** PUT /myapp?status=green&secret=something ** updates the status  
** PUT /myapp?status=green&secret=somethingelse ** access denied!  
** DELETE /myapp ** 403 access denied  
** DELETE /myapp?secret=something ** 200 done deal!

How to tell if the server has reset, or you've been snaked
----------------------------------------------------------

if you use a secret on something created without a secret, 410 GONE
because this is not your resource  
if you use a secret on something with a different secret, 403
forbidden and you've been snaked!!


Awesome, how bout some ssl?
-----------------------------

Sorry, no ssl

learn more at:
[<https://github.com/graemeworthy/Stoplight>](http://github.com/graemeworthy/Stoplight)

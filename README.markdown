README
======

Overview
--------

Personal C Assistant (Personal Computer Assistant) is a web app that works
with twilio to create a Google Voice type application.  What makes PCE nice, it
that one can add any feature they'd like, and personalize the application to
fit ones needs.

Multiple Users
--------------

PCE can be used for a single user or multiple, by setting the Rack Environment
"multi\_user" to true.  While in multi\_user mode, users are assigned extension
numbers, and incoming calls will be prompted to enter the three digit extension
before being redirected.

Implemented Features
--------------------

* Each user is associated with a Google Calender magic cookie url.  When a call
  comes in for that user, PCE will poll that url and find out if the user is
  busy with an event.  If so, the call will end, unless the caller insists
  that the call is important.  This can be used to stop annoying call during
  important meetings, or not having business calls after 5pm.

Installation Requirements
------------------------

The main part of PCE is that it is just a Sinatra/Rack app.  Any of the normal
deploy methods will work here.

What one needs:

* A twilio account/number
* A Redis database
* The app deployed to a location twilio can post to

Step-by-step Easy Installation Using Heroku
-------------------------------------------

This is for those that don't want to think about the installation, and can
follow a simple guide.

1. Clone this repository to your local machine ##############
2. install the heroku gem # `sudo gem install heroku`
3. Create a new heroku project # `heroku create`
4. Add the redis-to-go plugin # `heroku addons:add redistogo:nano`
5. Push the code to heroku # `git push heroku master`
6. Create a twilio account #############
7. Point your new number to the newly created heroku project
8. Goto your heroku app, add yourself as a user, and add any numbers
9. Tell everyone to start calling your new PCE number


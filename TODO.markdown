TODO
====

* <**DONE**> Add get_name(number) => Looks up number for a name sudjeted code, "return redis.get(redis.keys('number:*:<number>')[0])['name']
* <**DONE**> Create User class
* Set @user.custom_message to something when call @user.avalible
* Comment/Refactor the code
* Beef up the multi-user capability: Add user sign-on, all keys must be
  associated with a user
* Option to record a message that will be SMSed to the user, when they are free
  next
* Create experimental brach where things may be very broken and save the master
  branch for working code
* Testing, all kinds of testing

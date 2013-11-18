Hackerchat
====

Hacker is a real-time hackable collaboration platform for developers. It's the next-gen hybrid between IRC, Instant Messenger, Google Docs, and BaseCamp.

[http://hackerchat.im](http://hackerchat.im)

## A note on using this
During the hackathon, the database URI and cookie session secret were shamelessly hardcoded into app.coffee.
This was fine because the repository was private. Now that this repo is public, those credentials live in a
module called `secrets.coffee`. If you want to actually run this thing locally, you'll need to create that
file and fill it out with the relevant data. It looks something like this:

    module.exports =
      MONGO_URI = "mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]"
      COOKIE_SECRET = "hack the planet etc"

By the way, those hardcoded credentials were **not** removed from the commit log. The passwords were changed though,
naturally. (But nice try!)

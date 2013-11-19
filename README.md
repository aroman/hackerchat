# Hackerchat

HackerChat is a real-time hackable collaboration platform for developers. It's the next-gen hybrid between IRC, Instant Messenger, Google Docs, and BaseCamp. 1st place winner of the PilotPhilly 2013 hackathon.

Live Demo: [http://hackerchat.im](http://hackerchat.im)

Hacker League: [https://www.hackerleague.org/hackathons/pilotphilly/hacks/hackerchat](https://www.hackerleague.org/hackathons/pilotphilly/hacks/hackerchat)

Blog Post: [http://lablayers.deviantart.com/journal/My-Weekend-at-PilotPhilly-412888323](http://lablayers.deviantart.com/journal/My-Weekend-at-PilotPhilly-412888323)

Feel free to submit your pull requests if you come up with a clever way to add functionality to HackerChat. From /pony commands to a list of online users - you name it! ;)

### A note on using this
During the hackathon, the database URI and cookie session secret were shamelessly hardcoded into app.coffee.
This was fine because the repository was private. Now that this repo is public, those credentials live in a
module called `secrets.coffee`. If you want to actually run this thing locally, you'll need to create that
file and fill it out with the relevant data. It looks something like this:

    module.exports =
      MONGO_URI = "mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]"
      COOKIE_SECRET = "hack the planet etc"

By the way, those hardcoded credentials were **not** removed from the commit log. The passwords were changed though, naturally. (But nice try!)

### Deployment
Heroku: Just add a remote and (force) push your changes. Simple as that!

OpenShift: Just add a remote and (force) push your changes. Simple as that!

AutoDeploy: Enable WebSockets, add a remote and push your changes. Simple as that!

### Dependencies

- express
- jade  (HTML)
- coffee-script  (JS) 
- less-middleware  (CSS)
- mongoose
- colors
- socket.io
- zeroclipboard
    

### APIs

- expresss
- node.js
- mongodb
- backbone
- bootstrap
- heroku
- jquery
- github
- less
- jade
- coffeescript
- javascript
- html
- css
- mongoose
- socket.io
- websockets

# User Guide

### Index View

The welcome page authenticates you using a name and a simple button.

![Welcome View](http://i.imgur.com/LQ67POk.png)

### Chats View

Once you put in your name, you're brought to a screen that lists _only_ the rooms you created, and gives you an option to either join an existing room, create a new room, or log out.

If a user has created a room:

![Room View](http://i.imgur.com/xdLpyju.png)

Else if a user has NOT created a room:

![Room View](http://i.imgur.com/w2KhQjd.png)

### Chat View

If you choose to create a room, a random hash will be generated, and this is what an empty room looks like. You can share the room using the 3 sharing icons or by copying the URL. The room will be private to only those you choose to share the link with.

![Room View](http://i.imgur.com/LSKaMwH.png)

### Chat Features

From there, other users can join your chat, and even modify the chat title in real-time. HTML formatting is supported...

![Room View](http://i.imgur.com/4KCWSDw.png)

Typing in `wget example.com` will bring up a sandboxed iframe of example.com. For example...

![Room View](http://i.imgur.com/FEmqwDE.png)

This is where the chat gets cooler: you can type in `<hack>` in the message bar and you'll gain access to a modal that will allow you to add functionality to the chat! Just click `Propagate Hack` and your hack will be carried out across all of your users.

![Room View](http://i.imgur.com/r94oGkB.png)

For example, you can have a hack that adds some simple javascript output (like math) functionality:

![Room View](http://i.imgur.com/GIrV0sD.png)

### Mobile

Last but not least, HackerChat is compatible across all modern browsers and devices, including an optimized version for mobile. This is what a chat room looks like on an iPhone 5, and if you resize your browser window's width AND height, you'll see what I mean!

![Room View](http://i.imgur.com/fsxjdoI.png)

# Todo

- [ ] Desktop notifications
- [ ] Fix hack propagation bugs
- [ ] Rich media embeds (Embed.ly?)

# Extras

A bunch of CSS3 animations created during the hackathon: [https://gist.github.com/LabLayers/7397184](https://gist.github.com/LabLayers/7397184)

# Credits

**Avi Romanoff**: [http://twitter.com/@aroman](http://twitter.com/@aroman) - [http://aviromanoff.me](http://aviromanoff.me)

**Victor Lourng**: [http://twitter.com/@LabLayers](http://twitter.com/@LabLayers) - [http://victorlourng.com](http://victorlourng.com)

Special thanks go the mentors and organizers of PilotPhilly, as well as the blood, sweat, and tears that were involved in putting all of these other wonderful open source projects together!

(NOTE: The commit logs doesn't represent precisely who did what - it just shows whose laptop the changes were commited on!)
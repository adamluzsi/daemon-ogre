daemon-ogre
===========

Description
-----------

This module made for easy argv based damonize for the app.
100% compatible with any framework


Installation
------------

### [RubyGems](http://rubygems.org/)

    $ gem install 'daemon-ogre'


```ruby

    require 'daemon-ogre'
    DaemonOgre.init

```

after this, the app will check for the following tags in the input:
:d, :daemon, :daemonize for daemonize the app
:k, :kill,   :terminate for terminate already initialized app instance

you can set the output folder if you dont like the default in the system tmp / "#{your_app_folder_name}_daemon"

```ruby

    #> for example
    DaemonOgre::OPTS.tmp_folder_path File.join(File.dirname(__FILE__),"tmp")

```


Copyright
---------

Right to copy and use at your service fellow coder
Copyright (c) 2013 adam.luzsi. See LICENSE.txt for
further details.

daemon-ogre

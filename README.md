daemon-ogre
===========

Installation
------------

### [RubyGems](http://rubygems.org/)

$ gem install 'daemon-ogre'


require 'daemon-ogre'
DaemonOgre.start


but we love config our beloved App!
-----------------------------------


    DaemonOgre.start :name      => "MySuperAppName!",          #this will be the name of the application
                     :log_path  => "./var/log/log_file_name",  #this will be the logfile place and name
                     :pid_path  => "./var/pid/pid_file_name",  #this will be the pidfile place and name
                     :terminate => true                        #this command not let start your code if it's not started
                                                               # with "start" arguments like :
                                                               #                  ruby my_awsome_app.rb start


othere stuffs to use:
---------------------
everybody love: require_relative...
so why should not try require_directory instead all the fuss
you can tell to it if you want some file to be excluded or just delayed loaded,
because you want them loaded in the last place
Example:


    require_directory "some_dir_name_from_here_where_are_multi_dir_levels"

or

    require_directory "some_dir_name_from_here_where_are_multi_dir_levels",
                      :delayed => ["files","to","be","delayed","in","load"],
                      :exclude => ["files","to","be","exclude","in","load"]



Helpers
-------

and ofc what else what we love if not our beloved yml-s
we should use a nice Config constant for this(or at least i love to do)

    CONFIG = require_ymls "some_dir_name_from_here_where_are_the_yml_files_in_multi_dir_level"
the file names will be the hash-key and under that , there will be the yml file datas loaded in

if you need get a free port in a range or from, you can use this:
    get_port(from_nmb,to_nmb,host)

or by simply

    get_port(number)


and if you hate find all the bugs... you can use error_logger at your command like this:


    begin

        your awsome code!

    rescue xyexception => ex
        logger ex,            #error_msg
               prefix,        #this is optionable! but i usualy use: "#{__FILE__}/#{__LINE__}"
               log_file       #this is optionable!
    end


if you need methods from any kind of class without the object methods, you should try this!
    Xyclassname.class_methods


you want make some test script with rnd numbers, strings, dates, bools etc? use the Rnd class at your command
Rnd
-string
-number
-boolean
-date

examples:
    Rnd.number(100)
    Rnd.string(15,2) #for rnd bla bla names


You need get the index of an Array element? you can use:
    array_variable.index_of("something)




in Short:
---------
    require 'daemon-ogre'
    DaemonOgre.start #arguments if you want :)
    your_Super_app_code!




== Contributing to daemon-ogre

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2013 adam.luzsi. See LICENSE.txt for
further details.



daemon-ogre

Mustache
=========

Inspired by [ctemplate][1] and [et][2], Mustache is a
framework-agnostic way to render logic-free views.

As ctemplates says, "It emphasizes separating logic from presentation:
it is impossible to embed application logic in this template language."

For a list of implementations (other than Ruby) and tips, see
<http://mustache.github.com/>.


Overview
--------

Think of Mustache as a replacement for your views. Instead of views
consisting of ERB or HAML with random helpers and arbitrary logic,
your views are broken into two parts: a Ruby class and an HTML
template.

We call the Ruby class the "view" and the HTML template the
"template."

All your logic, decisions, and code is contained in your view. All
your markup is contained in your template. The template does nothing
but reference methods in your view.

This strict separation makes it easier to write clean templates,
easier to test your views, and more fun to work on your app's front end.


Why?
----

I like writing Ruby. I like writing HTML. I like writing JavaScript.

I don't like writing ERB, Haml, Liquid, Django Templates, putting Ruby
in my HTML, or putting JavaScript in my HTML.


Usage
-----

Quick example:

    >> require 'mustache'
    => true
    >> Mustache.render("Hello {{planet}}", :planet => "World!")
    => "Hello World!"

We've got an `examples` folder but here's the canonical one:

    class Simple < Mustache
      def name
        "Chris"
      end

      def value
        10_000
      end

      def taxed_value
        value * 0.6
      end

      def in_ca
        true
      end
    end

We simply create a normal Ruby class and define methods. Some methods
reference others, some return values, some return only booleans.

Now let's write the template:

    Hello {{name}}
    You have just won {{value}} dollars!
    {{#in_ca}}
    Well, {{taxed_value}} dollars, after taxes.
    {{/in_ca}}

This template references our view methods. To bring it all together,
here's the code to render actual HTML;

    Simple.render

Which returns the following:

    Hello Chris
    You have just won 10000 dollars!
    Well, 6000.0 dollars, after taxes.

Simple.


Tag Types
---------

For a language-agnostic overview of Mustache's template syntax, see
the `mustache(5)` manpage or
<http://mustache.github.com/mustache.5.html>.


Escaping
--------

Mustache does escape all values when using the standard double
Mustache syntax. Characters which will be escaped: `& \ " < >`. To
disable escaping, simply use triple mustaches like
`{{{unescaped_variable}}}`.

Example: Using `{{variable}}` inside a template for `5 > 2` will
result in `5 &gt; 2`, where as the usage of `{{{variable}}}` will
result in `5 > 2`.


Dict-Style Views
----------------

ctemplate and friends want you to hand a dictionary to the template
processor. Mustache supports a similar concept. Feel free to mix the
class-based and this more procedural style at your leisure.

Given this template (winner.mustache):

    Hello {{name}}
    You have just won {{value}} bucks!

We can fill in the values at will:

    view = Winner.new
    view[:name] = 'George'
    view[:value] = 100
    view.render

Which returns:

    Hello George
    You have just won 100 bucks!

We can re-use the same object, too:

    view[:name] = 'Tony'
    view.render
    Hello Tony
    You have just won 100 bucks!


Templates
---------

A word on templates. By default, a view will try to find its template
on disk by searching for an HTML file in the current directory that
follows the classic Ruby naming convention.

    TemplatePartial => ./template_partial.mustache

You can set the search path using `Mustache.template_path`. It can be set on a
class by class basis:

    class Simple < Mustache
      self.template_path = File.dirname(__FILE__)
      ... etc ...
    end

Now `Simple` will look for `simple.mustache` in the directory it resides
in, no matter the cwd.

If you want to just change what template is used you can set
`Mustache.template_file` directly:

    Simple.template_file = './blah.mustache'

Mustache also allows you to define the extension it'll use.

    Simple.template_extension = 'xml'

Given all other defaults, the above line will cause Mustache to look
for './blah.xml'

Feel free to set the template directly:

    Simple.template = 'Hi {{person}}!'

Or set a different template for a single instance:

    Simple.new.template = 'Hi {{person}}!'

Whatever works.


Views
-----

Mustache supports a bit of magic when it comes to views. If you're
authoring a plugin or extension for a web framework (Sinatra, Rails,
etc), check out the `view_namespace` and `view_path` settings on the
`Mustache` class. They will surely provide needed assistance.



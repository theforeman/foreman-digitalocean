# Foreman DigitalOcean Plugin

[![Code Climate](https://codeclimate.com/github/theforeman/foreman-digitalocean/badges/gpa.svg)](https://codeclimate.com/github/theforeman/foreman-digitalocean)
[![Gem Version](https://badge.fury.io/rb/foreman_digitalocean.svg)](http://badge.fury.io/rb/foreman_digitalocean)
[![Dependency Status](https://gemnasium.com/theforeman/foreman-digitalocean.svg)](https://gemnasium.com/theforeman/foreman-digitalocean)

```foreman-digitalocean``` enables provisioning and managing of [DigitalOcean](http://digitalocean.com) droplets in [Foreman](http://github.com/theforeman/foreman), all of that under the GPL v3+ license.

* Website: [TheForeman.org](http://theforeman.org)
* ServerFault tag: [Foreman](http://serverfault.com/questions/tagged/foreman)
* Issues: [foreman-digitalocean Redmine](http://projects.theforeman.org/projects/digitalocean/issues)
* Wiki: [Foreman wiki](http://projects.theforeman.org/projects/foreman/wiki/About)
* Community and support: #theforeman for general support, #theforeman-dev for development chat in [Freenode](irc.freenode.net)
* Mailing lists:
    * [foreman-users](https://groups.google.com/forum/?fromgroups#!forum/foreman-users)
    * [foreman-dev](https://groups.google.com/forum/?fromgroups#!forum/foreman-dev)

## Installation

Please see the Foreman manual for appropriate instructions:

* [Foreman: How to Install a Plugin](http://theforeman.org/manuals/latest/index.html#6.1InstallaPlugin)

### Red Hat, CentOS, Fedora, Scientific Linux (rpm)

Set up the repo as explained in the link above, then run

    # yum install ruby193-rubygem-foreman_digitalocean

### Debian, Ubuntu (deb)

Set up the repo as explained in the link above, then run

    # apt-get install ruby-foreman-digitalocean

### Bundle (gem)

Add the following to bundler.d/Gemfile.local.rb in your Foreman installation directory (/usr/share/foreman by default)

    $ gem 'foreman_digitalocean'

Then run `bundle install` from the same directory

-------------------

To verify that the installation was successful, go to Foreman, top bar **Administer > About** and check 'foreman_digitalocean' shows up in the **System Status** menu under the Plugins tab.

## Compatibility


| Foreman Version | Plugin Version |
| --------------- | --------------:|
| <= 1.7.x        | ~> 0.1.x       |
| >= 1.8.0        | ~> 0.2.x       |

## Configuration

Go to **Infrastructure > Compute Resources** and click on "New Compute Resource".

Choose the **DigitalOcean provider**, and fill in all the fields. The API client and secret keys can be retrieved from [the API v1 DigitalOcean site](https://cloud.digitalocean.com/api_access). The secret key will be encrypted in the database.

That's it. You're now ready to create and manage droplets in your new DigitalOcean compute resource.

You should see something like this in the Compute Resource page:

![](http://i.imgur.com/cyFYOWg.png)
![](http://i.imgur.com/CTedBU1.png)

## How to contribute?

Generally, follow the [Foreman guidelines](http://theforeman.org/contribute.html). For code-related contributions, fork this project and send a pull request with all changes. Some things to keep in mind:
* [Follow the rules](http://theforeman.org/contribute.html#SubmitPatches) about commit message style and create a Redmine issue. Doing this right will help reviewers to get your contribution merged faster.
* [Rubocop](https://github.com/bbatsov/rubocop) will analyze your code, you can run it locally with `rake rubocop`.
* All of our pull requests run the full test suite in our [Jenkins CI system](http://ci.theforeman.org/). Please include tests in your pull requests for any additions or changes in functionality


### Latest code

You can get the nightly branch of the plugin by specifying your Gemfile in this way:

    gem 'foreman_digitalocean', :git => "https://github.com/theforeman/foreman-digitalocean.git"

# License

This project started as a [pull request](https://github.com/theforeman/foreman/pull/1978) from Tommy McNeely ([TJM](http://github.com/tjm)). It is licensed as GPLv3 since it is a [Foreman](http://theforeman.org) plugin.

See LICENSE for more details.

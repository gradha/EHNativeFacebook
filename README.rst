========================================
EHNativeFacebook for pre iOS 6.0 devices
========================================

:author: Grzegorz Adam Hankiewicz <gradha@imap.cc>

.. contents::

.. section-numbering::

.. raw:: pdf

   PageBreak oneColumn

The problem
===========

Let's say that you are one of those old geezers with a lawn permanently invaded
by kids with cool iOS devices supporting ARC, iOS6 and social networks like
Facebook. For the sake of completeness, or maybe because you are forced to do
it, you want to support native Facebook posting in your application. However,
you still want to support iOS 3.x devices, and this is the problem: Xcode 4.5
and above break support for armv6, which means compiling only to recent devices
and iOS 4.3 deployment target or above.

What to do? Is it actually possible to still support iOS 3.x and iOS 6.x
features at the same time? You keep your last safe copy of Xcode 4.4 with iOS
3.x support, but you don't have the new Social framework available, so Facebook
support seems out of reach. Why does Apple hate You and Your old perfectly
working devices?


The solution
============

Since you keep a safe Xcode 4.4 version on your machine you can compile
binaries with armv6 support. For the Social framework you can use dynamic code,
aka selectors, to find out if the SLComposeViewController class is available,
which is the workhorse of the Facebook posting feature.

And fortunately you don't even have to resort to dlopen tricks to load the
Social framework. It seems that if you link against the Twitter framework
available on iOS 5.x, devices with iOS 6.x will automatically load the Social
framework for your process, meaning the SLComposeViewController class will be
available if you link against twitter (also, link weakly, since you support iOS
3.x too).

The selector part of the code is contained in the EHNativeFacebook class, which
wrapps around SLComposeViewController, but only for Facebook. You likely have
iOS 5.x compatible twitter code, you can keep it despite Apple deprecating it.
Maybe in some future SDK Apple won't include it as a framework to prevent
people form linking against it, but they won't likely remove it from the OS
since it would break not updated apps.


The kitchen sink
================

This is a very short and concise class to support native facebook in a simple
way for my needs. If you actually want to implement sharing *massively* in your
application I suggest you take a look at https://github.com/ShareKit/ShareKit.


Installation
------------

The files
*********

For the purpose of tracking external source code, I recommend you to create an
``external`` subdirectory at the root of your own project. Then, you can either
download and copy this repository there under the name ``EHNativeFacebook``,
or you can checkout a submodule. For the git submodule you would do::

    cd Your-project
    mkdir external
    git submodule init
    git submodule add \
        git://github.com/gradha/EHNativeFacebook.git \
        external/EHNativeFacebook

These commands would create an ``external`` directory and populate it with the
source code. For the github url of the repo you could use my repo, or you could
fork it and use your own. This is recommended: if I removed my repo, yours
would still live, and it is also more obvious to watch/track different changes
among repositories.

If you are *not* using git, I recommend you to modify the ``README.rst`` file
and make it contain a timestamp, date, or github checkout sha-1 so that in the
future you know if new versions have been released by comparing this mark.


Your Xcode project settings
***************************

Now that the files somehow live inside your project, you have to tell Xcode to
find them. For testing reasons, add the following line to one of your **.m**
files::

    #include "EHNativeFacebook.h"

After this change your project should not build due to errors. In your project
navigator window simply select to add files and click on both the
EHNativeFacebook.m and EHNativeFacebook.h files. That should deal with
dependencies and stuff.


Framework dependencies
**********************

Your application needs to link against the Twitter framework available on iOS
5, this will bring in the Social framework available on iOS 6 for your process
when run on such a device.


Documentation
=============

At the moment the documentation is embedded in comments in the source code.
Included in the source code tree there is an example with iOS 3.x deployment
compatibility. You can compile it with Xcode 4.4 and run the binary on iOS 6
and get the Facebook posting controller. You can also run the binary on an iPod
with iOS 3.0 and get an error alert when you try to post to facebook.


License
=======

Unless otherwise stated, all the source code in this repository is available
under the MIT license (http://www.opensource.org/licenses/mit-license.php)
meaning that you can take what you want and not give back. However, you might
want to thank me buying some comercial program I wrote, and who knows, you
might even like it! You can visit Electric Hands Software at http://elhaso.com/
or the app store at
http://itunes.apple.com/es/artist/electric-hands-software/id325946567.

Here's the license template applied to the source code:

Copyright (c) 2012, Grzegorz Adam Hankiewicz.
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

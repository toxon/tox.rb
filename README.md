::Tox
=====

[![Gem Version](https://badge.fury.io/rb/tox.svg)](http://badge.fury.io/rb/tox)
[![Build Status](https://travis-ci.org/braiden-vasco/tox.rb.svg)](https://travis-ci.org/braiden-vasco/tox.rb)
[![Coverage Status](https://coveralls.io/repos/github/braiden-vasco/tox.rb/badge.svg)](https://coveralls.io/github/braiden-vasco/tox.rb)

Ruby interface for [libtoxcore](https://github.com/TokTok/c-toxcore).
It can be used to create [Tox chat](https://tox.chat) client or bot.
It provides object-oriented interface instead of C-style (raises exceptions
instead of returning error codes, uses classes to represent primitives, etc.)

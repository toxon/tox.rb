::Tox
=====

[![Gem Version](https://badge.fury.io/rb/tox.svg)](http://badge.fury.io/rb/tox)
[![Build Status](https://travis-ci.org/toxon/tox.rb.svg)](https://travis-ci.org/toxon/tox.rb)
[![Coverage Status](https://coveralls.io/repos/github/toxon/tox.rb/badge.svg)](https://coveralls.io/github/toxon/tox.rb)

Ruby interface for [libtoxcore](https://github.com/TokTok/c-toxcore).
It can be used to create [Tox chat](https://tox.chat) client or bot.
The interface is object-oriented instead of C-style (raises exceptions
instead of returning error codes, uses classes to represent primitives, etc.)

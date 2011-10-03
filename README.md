# token_attribute

Small macro to define unique random token generator for ActiveRecord.

## How to Use

```ruby
class User < ActiveRecord::Base
  include TokenAttribute
  token_attribute :access_token
end

user = User.new
user.access_token # => nil
user.generate_access_token
user.access_token # => 'some unique random string'
```

## Install

```
$ gem install token_attribute
```

or

```
gem 'token_attribute'
```

## Supported Versions

Ruby 1.8.7, 1.9.2

Rails 3.0.x, 3.1.x

## Motivation

Someday I felt it's time to stop writing this kind of code in every project.


## Copyright

(The MIT License)

Copyright © 2011 Fujimura Daisuke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
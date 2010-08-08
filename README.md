# Sphinx Search

Adds ThinkingSphinx (<http://ts.freelancing-gods.com>) support to Radiant,
including a paginated search results page.

## Installation

First you'll need to install Sphinx, available via your preferred package
manager or from <http://sphinxsearch.com>.

Installing the extension itself as a gem is preferred. Add to your
`config/environment.rb:`

    config.gem 'radiant-sphinx_search-extension'

After the gem is configured, run `rake db:migrate:extensions` and `rake
radiant:extensions:update_all`. You should at least read the Thinking Sphinx
quickstart guide, but these commands should be enough to get you started:

    rake ts:in
    rake ts:start

## Indexing

SphinxSearch indexes your pages on title and content (parts.) Sphinx
attributes are created for `status_id`, `updated_at`, `virtual`, and
`class_name`.

## Building a Search Page

SphinxSearch adds a new Page subclass, SearchPage. This page serves as both
the search form and the search results display.

There are a number of Radius tags available to the Search page, most of which
are customizable to some extent. You can find the full documentation for these
tags and their options in the tag reference, but a simple search page might
look like this:

    <r:search>
      <r:form />
      <p>Your search for <strong><r:query /></strong> returned <r:count />.</p>
      <r:results paginated="true">
        <r:each>
          <h3><r:link /></h3>
          <p><r:excerpt /></p>
        </r:each>
        <r:pagination />
      </r:results>
    </r:search>

## NoMethodError

If you're using some versions of Radiant (generally <= 0.9.1) or certain
3rd-party extensions, you may see this error:

    NoMethodError
    
    You have a nil object when you didn't expect it!
    You might have expected an instance of Array.
    The error occurred while evaluating nil.<<

This is a load-order problem and it means another extension created a Page
subclass before SphinxSearch had a chance to extend the base class. The
easiest way around this is to simply load SphinxSearch first:

    config.extensions = [:sphinx_search, :all]

------------------------------------------------------------------------------

Copyright (c) 2008 Digital Pulp, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
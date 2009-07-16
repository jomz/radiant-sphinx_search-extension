# Sphinx Search

Adds ThinkingSphinx (<http://ts.freelancing-gods.com>) support to Radiant,
including a paginated search results page.

## Configuration

Requires gems for Thinking Sphinx and Will Paginate, available at:
http://github.com/freelancing-god/thinking-sphinx
http://github.com/mislav/wil_paginate

Once installed, add these lines to environment.rb:

    config.gem 'freelancing-god-thinking-sphinx', :lib => 'thinking_sphinx'
    config.gem 'mislav-will_paginate', :lib => 'will_paginate'

By default, only the first 8kB of any page's content will be indexed. You can 
change this in page_extensions.rb if that's not enough space, or if you wish
to reduce that in order to keep your indexes lean.

This extension defines a Page index for you. Pages will be indexed on title 
and content, with a field boost applied to title. Included attributes are: 
`status_id`, `updated_at`, and a new boolean column called `searchable`. You
can toggle the searchable attribute from within the page edit view if you wish
to restrict certain pages from appearing in the results.

To configure the number of results returned per page, adjust the `@@per_page`
variable within the SearchPage class.

## Getting Search Results

A new Page subclass, SearchPage, will be available when adding a page to the
tree. This page will accept a `query` param and return any matches, provided
they are published and their `searchable` attribute is true.

The following Radius tags are available when building a SearchPage:

 * `results` Opens the search results collection. Use `results:each` to 
   iterate over them.
 * `results:count` The total (unpaginated) number of search results, appended
   with the word "result," pluralized if appropriate.
 * `results:current_page` The current page of search results.
 * `results:total_pages` The total number of pages of results.
 * `results:query` The original query term. This is sanitized for safe 
   display.
 * `results:each` Iterator for the search result collection.
 * `results:pagination` Renders pagination links for the results collection.
   Accepts optional `class`, `previous_label`, `next_label`, `inner_window`, 
   `outer_window`, and `separator` attributes which will be forwarded to
   WillPaginate's link renderer.
 * `results:unless_query` Expands if no `query` parameter was present.
 * `results:if_empty` Expands if the results collection was empty.

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
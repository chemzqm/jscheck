# Javascript syntax check for vim

A vim plugin for checking javascript syntax error only.

It's build for speed, almost 6x faster than [eslint](https://github.com/eslint/eslint) on my machine.

[![faster](http://7b1fyu.com1.z0.glb.clouddn.com/time.png?imageView2/0/w/600)](http://7b1fyu.com1.z0.glb.clouddn.com/time.png)

It uses notifies functions from [syntastic](https://github.com/scrooloose/syntastic), the result looks like:

[![looks](http://7b1fyu.com1.z0.glb.clouddn.com/jscheck.png?imageView2/0/w/600)](http://7b1fyu.com1.z0.glb.clouddn.com/jscheck.png)

Hope it help to improve your experience with coding javascript.

## Install

You should have [node](http://nodejs.org/) installed, it comes with `npm` command.

Add the plugin to your vim plugin management config, for example with [Vundle](https://github.com/gmarik/vundle)

in your .vimrc:

    " If you want to have notifies, [syntastic](https://github.com/scrooloose/syntastic) is needed
    Plugin 'scrooloose/syntastic'
    Plugin 'chemzqm/jscheck'

then install：

    :so ~/.vimrc
    :BundleInstall

You have to empty the javascript checker of syntastic to avoid syntastic check on file save:

    let g:syntastic_javascript_checkers = []

The plugin will prompt you to install the node dependencies only if they are not installed.

## Usage

``` VimL
" Check current file content by command, no need to save
:JSCheck

" disable auto check for javascript files on save
let g:jscheck_no_autocheck = 1
```

## Q&A

Q: Why only one error shown each time?

A: [acorn](https://github.com/ternjs/acorn) was made to throw when it enconter an error in order to have best speed.

Q: How to disable auto jump?

A: I've no idea how the jump happens, but it seems good.

Q: Support asynchronous check?

A: I will have a try.

## license

MIT

Copyright © 2015 yourname

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

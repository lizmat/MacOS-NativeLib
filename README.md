[![Actions Status](https://github.com/lizmat/MacOS-NativeLib/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/MacOS-NativeLib/actions)

NAME
====

MacOS::NativeLib - Make native libs reachable on MacOS

SYNOPSIS
========

```raku
use MacOS::NativeLib 'libgd.3';  # make GD library accessible
use GD::Raw;                     # load raw GD support
```

DESCRIPTION
===========

MacOS has built-in security features that disallow loading native libraries unless they are in a trusted location, or if they are symlinked from a trusted location.

The most common way to install native libraries on MacOS is by using `HomeBrew` with the `brew install` command. The location at which these libraries are installed, are however **NOT** trusted by MacOS.

This module allows one to specify one or more library names that should be made reachable in the `use` statement. A symlink will then be installed if there is none already.

If this module is loaded on any OS other than MacOS, it is simply a no-op.

Any errors will be shown on STDERR, but will **NOT** interrupt the further execution, so that any module actually depending on the reachability of a native library can use its own checks and error reporting.

ensure-symlink-for
==================

    $ ensure-symlink-for libgd.3

This module also installs a command-line interface called `ensure-symlink-for`. It takes the same arguments as in the `use` statement, and will install the necessary symlinks if they did not exist yet.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/MacOS-NativeLib . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.


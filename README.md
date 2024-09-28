[![Actions Status](https://github.com/lizmat/MacOS-NativeLib/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/MacOS-NativeLib/actions)

NAME
====

MacOS::NativeLib - Make native libs reachable on MacOS

SYNOPSIS
========

```raku
use MacOS::NativeLib 'gd';  # make all versions of GD libraries accessible
use GD::Raw;                # load raw GD support
```

DESCRIPTION
===========

MacOS has built-in security features that disallow loading native libraries unless they are in a trusted location, or if they are symlinked from a trusted location.

The most common way to install native libraries on MacOS is by using `HomeBrew` with the `brew install` command. The location at which these libraries are installed, are however **NOT** trusted by MacOS.

This module allows one to specify one or more library names that should be made reachable in the `use` statement. A symlink will then be installed if there is none already.

Library names can be specified with or without the "lib" prefix, so `"gd"` and `"libgd"` would produce the same result. By default, **all** versions of a native library will be made available. You can limit to a specific version by specifying a more specific name, e.g. `"gd.3"` to only make version **3** of the GD library available.

You can have all libraries installed by HomeBrew linked automatically by specifying `"*"` or `*` (aka `Whatever`), although this may not be a wise decision from a security point of view.

If this module is loaded on any OS other than MacOS, it is simply a no-op.

Any errors will be shown on STDERR, but will **NOT** interrupt the further execution, so that any module actually depending on the reachability of a native library can use its own checks and error reporting.

ensure-symlink-for
==================

    $ ensure-symlink-for gd

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


my sub ensure-symlink-for($lib is copy) is export {
    if $*DISTRO.name eq 'macos' {
        $lib ~= ".dylib" unless $lib.ends-with(".dylib");

        my $from = "/opt/homebrew/lib/$lib".IO;
        return "Could not access '$from'" unless $from.r;

        my $to = $*EXECUTABLE.parent.sibling("lib/$lib");
        if $to.r {
            return $from.resolve eq $to.resolve
              ?? Empty     # nothing to do
              !! "Existing symlink resolves incorrectly";
        }

        .message without symlink $from, $to;
    }
}

my sub EXPORT(*@libs) {
    .note for @libs.map: &ensure-symlink-for;
    BEGIN Map.new
}

=begin pod

=head1 NAME

MacOS::NativeLib - Make native libs reachable on MacOS

=head1 SYNOPSIS

=begin code :lang<raku>

use MacOS::NativeLib 'libgd.3';  # make GD library accessible
use GD::Raw;                     # load raw GD support

=end code

=head1 DESCRIPTION

MacOS has built-in security features that disallow loading native libraries
unless they are in a trusted location, or if they are symlinked from a
trusted location.

The most common way to install native libraries on MacOS is by using
C<HomeBrew> with the C<brew install> command.  The location at which these
libraries are installed, are however B<NOT> trusted by MacOS.

This module allows one to specify one or more library names that should be
made reachable in the C<use> statement.  A symlink will then be installed
if there is none already.

If this module is loaded on any OS other than MacOS, it is simply a no-op.

Any errors will be shown on STDERR, but will interrupt the further execution,
so that any module actually depending on the reachability of a native library
can use it's own checks and error reporting.

=head1 ensure-symlink-for

=begin output

$ ensure-symlink-for libgd.3

=end output

This module also installs a command-line interface called
C<ensure-symlink-for>.  It takes the same arguments as in the C<use>
statement, and will install the necessary symlinks if they did not
exist yet.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/MacOS-NativeLib .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4

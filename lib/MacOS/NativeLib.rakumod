my sub ensure-symlink-for($name) is export {
    if $*DISTRO.name eq 'macos' {

        my $dir  := "/opt/homebrew/lib";
        my $root := $name eq '*' || $name ~~ Whatever
          ?? "lib"
          !! $name.starts-with("lib")
            ?? $name
            !! "lib$name";
        my $target := $*EXECUTABLE.parent.sibling("lib");

        my @failures;
        for dir($dir).grep({
            my $base := .basename;
            $base.starts-with($root) && $base.ends-with(".dylib")
        }) -> $from {
            if $from.r {
                my $to := $target.add($from.basename);
                if $to.r {
                    @failures.push(
                      "Existing symlink '$to' resolves incorrectly"
                    ) unless $from.resolve eq $to.resolve;
                }
                else {
                    @failures.push(.message) without symlink $from, $to;
                }
            }
            else {
                @failures.push: "Could not access library '$from'";
            }
        }

        @failures.join("\n") if @failures
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

use MacOS::NativeLib 'gd';  # make all versions of GD libraries accessible
use GD::Raw;                # load raw GD support

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

Library names can be specified with or without the "lib" prefix, so
C<"gd"> and C<"libgd"> would produce the same result.  By default, B<all>
versions of a native library will be made available.  You can limit to
a specific version by specifying a more specific name, e.g. C<"gd.3"> to
only make version B<3> of the GD library available.

You can have all libraries installed by HomeBrew linked automatically
by specifying C<"*"> or C<*> (aka C<Whatever>), although this may not be
a wise decision from a security point of view.

If this module is loaded on any OS other than MacOS, it is simply a no-op.

Any errors will be shown on STDERR, but will B<NOT> interrupt the further
execution, so that any module actually depending on the reachability of a
native library can use its own checks and error reporting.

=head1 ensure-symlink-for

=begin output

$ ensure-symlink-for gd

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

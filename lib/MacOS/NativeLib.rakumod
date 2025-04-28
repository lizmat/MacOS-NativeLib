my sub ensure-symlink-for($name) is export {
    my @failures;

    if $*DISTRO.name eq 'macos' {
        my $prefix := quietly (run <brew config>, :out).out.slurp
          .lines.first(*.starts-with("HOMEBREW_PREFIX:")).substr(17);

        if $prefix {
            my $root := $name eq '*' || $name ~~ Whatever
              ?? "lib"
              !! $name.starts-with("lib")
                ?? $name
                !! "lib$name";
            my $target := $*EXECUTABLE.parent.sibling("lib");

            for dir("$prefix/lib").grep({
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
        }
        else {
            @failures.push: "brew could not be found";
        }
    }

    @failures.join("\n") if @failures
}

my sub EXPORT(*@libs) {
    .note for @libs.map: &ensure-symlink-for;
    BEGIN Map.new
}

# vim: expandtab shiftwidth=4

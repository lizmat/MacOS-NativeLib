my $target := $*EXECUTABLE.parent.sibling("lib");

my sub ensure-symlink-for($name) {
    my @failures;

    my $root := $name eq '*' || $name ~~ Whatever
      ?? "lib"
      !! $name.starts-with("lib")
        ?? $name
        !! "lib$name";

    my sub process(Str:D $dir) {
        my $io := $dir.IO;
        return 0 unless $io.e && $io.d;

        my int $seen;
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
                orwith symlink $from, $to {  # UNCOVERABLE
                    ++$seen;
                }
                else {
                    @failures.push(.message);  # UNCOVERABLE
                }
            }
            else {
                @failures.push: "Could not access library '$from'";  # UNCOVERABLE
            }
        }
        $seen
    }

    if $*DISTRO.name eq 'macos' {
        my $prefix := quietly (run <brew config>, :out).out.slurp
          .lines.first(*.starts-with("HOMEBREW_PREFIX:")).substr(17);

        if $prefix {
            # all ok?
            if process("$prefix/lib") || $root eq 'lib' {
            }

            # attempt linking keg-only libraries
            elsif process("$prefix/opt/$root/lib") {  # UNCOVERABLE
            }

            # alas
            else {
                @failures.push("Library '$root' not found")
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
    BEGIN Map.new: "&ensure-symlink-for" => &ensure-symlink-for
}

# vim: expandtab shiftwidth=4

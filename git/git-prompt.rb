#!/usr/bin/env -S ruby --disable-gems --disable-rubyopt

# slimmed down re-implementation of git-prompt.sh
#
# outputs "(branch)" or "((tag))" or "((hash...))"
# adds a "*" if the current working directory is dirty

$repo_info=`git rev-parse --git-dir --short HEAD 2>/dev/null`
exit(0) if $repo_info.empty?

def branch_name
  dir, hash = $repo_info.split("\n")

  head = File.read("#{dir}/HEAD").strip

  if head.start_with?("ref: refs/heads/")
    "(#{head[16..-1]})"
  else
    tag = `git describe --tags --exact-match HEAD 2>/dev/null`.strip
    tag.empty? ? "((#{hash}...))" : "((#{tag}))"
  end
end

def dirty_state
  `git diff --no-ext-diff --quiet --exit-code`
  $?.exitstatus != 0 ? "*" : ""
end

puts "#{branch_name}#{dirty_state}"

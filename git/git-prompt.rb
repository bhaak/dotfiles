#!/usr/bin/env -S ruby --disable-gems --disable-rubyopt
# frozen_string_literal: true

# slimmed down re-implementation of git-prompt.sh
#
# outputs "(branch)" or "((tag))" or "((hash...))"
# adds a "*" if the working tree differs from the index
# (staged-only changes, untracked files and git errors are ignored)

# never write/refresh the index while rendering a prompt
ENV["GIT_OPTIONAL_LOCKS"] = "0"

begin
  $repo_info = `git rev-parse --git-dir --short HEAD 2>/dev/null`
rescue Errno::ENOENT
  exit(0)
end
exit(0) if $repo_info.empty?

BRANCH_REF_PREFIX = "ref: refs/heads/"

def branch_name
  dir, hash = $repo_info.split("\n")

  head = File.read("#{dir}/HEAD").strip

  if head.start_with?(BRANCH_REF_PREFIX)
    "(#{head.delete_prefix(BRANCH_REF_PREFIX)})"
  else
    tag = `git describe --tags --exact-match HEAD 2>/dev/null`.strip
    tag.empty? ? "((#{hash}...))" : "((#{tag}))"
  end
rescue SystemCallError
  # HEAD disappeared or is unreadable, e.g. during a concurrent checkout
  nil
end

def dirty_state
  `git diff --no-ext-diff --quiet --exit-code 2>/dev/null`
  # exit 1 means "differences", everything else (0, 128, signal) must not
  # be reported as dirty
  $?.exitstatus == 1 ? "*" : ""
end

puts "#{branch_name}#{dirty_state}"

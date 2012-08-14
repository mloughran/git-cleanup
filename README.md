# git-cleanup

A simple interactive command line tool to help you cleanup your git branch detritus.

This is what git-cleanup does:

  1. Iterates over all remote branches (assumes origin), starting with the newest. For each branch:
  2. If the branch has been merged into master it offers to delete it, first remotely then locally.
  3. If the branch has not been merged it shows you all the un-merged commits, and offers to show you a diff (in your `GIT_EDITOR`). This makes it easy to determine whether the branch should be removed or not.  
     Once you have viewed the diff you will be asked whether you wish to delete the branch as before.

**Every destructive operation is interactive** - nothing unexpected will happen to your repo. It's perfectly fine to `Ctrl-C` at any time if you get bored of deleting branches and want to do some real work.

## Usage

Install the gem

    $ gem install git-cleanup

Inside a git repo, just run git-cleanup

    $ git-cleanup

Use `--skip-unmerged` to ignore un-merged branches

    $ git-cleanup --skip-unmerged
    
Use `--only` to only consider branch names that have this substring

    $ git-cleanup --only myname

Be careful, if you delete a critical branch it's not my fault. Piping in `yes` is a bad idea.

## Hacking

There are no tests, this was a quick hack to get the job done.

Pragmatic patches welcome, please open an issue first to discuss.

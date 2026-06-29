# Git Cheatsheet 📚

Quick reference for rebasing + comprehensive Git command guide.

---

## 🔄 Rebase Quick Reference

### Basic Rebase Operations

```bash
# Rebase current branch onto master
git rebase master

# Rebase specific branch onto master
git rebase master feature-branch

# Rebase with explicit syntax
git rebase --onto master master feature-branch

# Continue after resolving conflicts
git rebase --continue

# Skip current commit
git rebase --skip

# Abort rebase
git rebase --abort
```

### Interactive Rebase

```bash
# Interactive rebase last N commits
git rebase -i HEAD~3

# Interactive rebase onto branch
git rebase -i master

# Interactive rebase from specific commit
git rebase -i abc123^
```

### Interactive Rebase Commands

In the editor, use these commands:

```
p, pick   = use commit as-is
r, reword = use commit, but edit message
e, edit   = use commit, but stop for amending
s, squash = use commit, combine with previous
f, fixup  = like squash, discard message
d, drop   = remove commit
```

### Pull with Rebase

```bash
# Pull and rebase (instead of merge)
git pull --rebase

# Pull and rebase from specific remote/branch
git pull --rebase origin master

# Configure to always rebase on pull
git config pull.rebase true
git config --global pull.rebase true
```

### Rebase Conflict Resolution

```bash
# During conflict, check status
git status

# View conflicted files
git diff

# After resolving, stage files
git add <file>

# Continue rebase
git rebase --continue

# Or abort if needed
git rebase --abort

# Keep their version
git checkout --theirs <file>

# Keep your version
git checkout --ours <file>
```

### Common Rebase Workflows

```bash
# Update feature branch with latest master
git checkout feature-branch
git rebase master

# Clean up commits before merging
git rebase -i HEAD~5
# squash/fixup WIP commits

# Rebase and force push (feature branch only!)
git push --force-with-lease origin feature-branch

# Pull with rebase workflow
git fetch origin
git rebase origin/master
```

### Rebase Safety Tips

✅ **DO rebase:**
- Private/local branches
- Before creating pull requests
- To clean up commit history
- Feature branches not shared

❌ **DON'T rebase:**
- Public/shared branches
- Commits others based work on
- Master/main branch (usually)
- Already merged commits

---

## 📖 Comprehensive Git Command Reference

### Initial Setup & Configuration

```bash
# Set username and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# View all config
git config --list
git config --global --list  # Global only

# Set default editor
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"           # Vim

# Set default branch name
git config --global init.defaultBranch main

# Enable colored output
git config --global color.ui auto

# Configure line endings
git config --global core.autocrlf true   # Windows
git config --global core.autocrlf input  # Mac/Linux

# Create alias
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
```

### Creating & Cloning Repositories

```bash
# Initialize new repository
git init
git init my-project        # Create and initialize directory

# Clone existing repository
git clone <url>
git clone <url> my-folder  # Clone into specific folder

# Clone specific branch
git clone -b develop <url>

# Clone with depth (shallow clone)
git clone --depth 1 <url>  # Only latest commit
```

### Checking Repository Status

```bash
# View status
git status
git status -s              # Short format
git status -sb             # Short format with branch

# View commit history
git log
git log --oneline          # Compact view
git log --graph            # Visual graph
git log --all              # All branches
git log --oneline --graph --all  # Combined

# View specific file history
git log <file>
git log --follow <file>    # Follow renames

# View last N commits
git log -n 5
git log -3

# View commits by author
git log --author="John"

# View commits by date
git log --since="2 weeks ago"
git log --after="2024-01-01"
git log --before="2024-12-31"

# View commits with diffs
git log -p
git log -p <file>

# View commits that changed specific text
git log -S "function_name"
git log -G "regex_pattern"

# Pretty formats
git log --pretty=format:"%h - %an, %ar : %s"
git log --pretty=oneline
git log --pretty=short
```

### Staging Changes

```bash
# Stage specific file
git add <file>

# Stage all changes
git add .
git add --all
git add -A

# Stage specific directory
git add src/

# Stage by pattern
git add *.js

# Interactive staging
git add -i
git add -p                 # Patch mode (stage parts)

# Stage deleted files
git add -u

# Stage new and modified (not deleted)
git add --ignore-removal .
```

### Committing Changes

```bash
# Commit staged changes
git commit -m "Commit message"

# Commit with multi-line message
git commit -m "Title" -m "Description"

# Commit all modified files (skip staging)
git add -a -m "Message"

# Amend last commit
git commit --amend
git commit --amend -m "New message"
git commit --amend --no-edit  # Keep message

# Commit with specific date
git commit --date="2024-01-01 12:00:00" -m "Message"

# Empty commit (no changes)
git commit --allow-empty -m "Trigger CI"
```

### Viewing Changes

```bash
# View unstaged changes
git diff

# View staged changes
git diff --staged
git diff --cached

# View changes in specific file
git diff <file>
git diff --staged <file>

# View changes between commits
git diff abc123 def456
git diff HEAD HEAD~1       # Last commit vs previous

# View changes between branches
git diff master feature

# View changed files only (names)
git diff --name-only
git diff --name-status     # With status (M/A/D)

# View word-level diff
git diff --word-diff

# View summary statistics
git diff --stat
```

### Undoing Changes

```bash
# Discard unstaged changes in file
git checkout -- <file>
git restore <file>         # Modern syntax

# Discard all unstaged changes
git checkout -- .
git restore .

# Unstage file (keep changes)
git reset <file>
git restore --staged <file>

# Unstage all files
git reset

# Reset to specific commit (keep changes)
git reset <commit>
git reset --soft HEAD~1    # Undo last commit, keep changes

# Reset and discard changes
git reset --hard <commit>
git reset --hard HEAD      # Discard all changes
git reset --hard HEAD~1    # Undo last commit, discard changes

# Revert commit (create new commit)
git revert <commit>
git revert HEAD            # Revert last commit

# Create commit that undoes multiple commits
git revert <oldest>..<newest>
```

### Branching

```bash
# List branches
git branch
git branch -a              # Include remote branches
git branch -r              # Remote branches only
git branch -v              # With last commit
git branch -vv             # With upstream info

# Create branch
git branch <branch-name>
git branch <branch-name> <commit>  # From specific commit

# Switch branch
git checkout <branch>
git switch <branch>        # Modern syntax

# Create and switch to branch
git checkout -b <branch>
git switch -c <branch>     # Modern syntax

# Create branch from remote
git checkout -b <branch> origin/<branch>
git switch -c <branch> origin/<branch>

# Rename branch
git branch -m <old-name> <new-name>
git branch -m <new-name>   # Rename current branch

# Delete branch
git branch -d <branch>     # Safe delete
git branch -D <branch>     # Force delete

# Delete remote branch
git push origin --delete <branch>
git push origin :<branch>  # Older syntax

# View merged branches
git branch --merged
git branch --no-merged

# View branches containing commit
git branch --contains <commit>
```

### Merging

```bash
# Merge branch into current branch
git merge <branch>

# Merge with commit message
git merge <branch> -m "Merge message"

# Merge without fast-forward
git merge --no-ff <branch>

# Fast-forward only (fail if can't)
git merge --ff-only <branch>

# Squash merge (combine all commits)
git merge --squash <branch>

# Abort merge
git merge --abort

# View merge conflicts
git diff
git status

# Resolve using theirs/ours
git checkout --theirs <file>  # Take their version
git checkout --ours <file>    # Take our version

# Mark as resolved
git add <file>

# Complete merge
git commit
```

### Remote Repositories

```bash
# View remotes
git remote
git remote -v              # With URLs

# Add remote
git remote add <name> <url>
git remote add origin <url>

# Remove remote
git remote remove <name>
git remote rm <name>

# Rename remote
git remote rename <old> <new>

# Change remote URL
git remote set-url <name> <new-url>

# View remote details
git remote show <name>
git remote show origin

# Fetch from remote
git fetch
git fetch <remote>
git fetch <remote> <branch>
git fetch --all            # All remotes

# Pull from remote (fetch + merge)
git pull
git pull <remote> <branch>
git pull --rebase          # Pull with rebase

# Push to remote
git push
git push <remote> <branch>
git push -u origin master  # Set upstream

# Force push (careful!)
git push --force
git push --force-with-lease  # Safer force push

# Push all branches
git push --all

# Push tags
git push --tags
git push origin <tag-name>

# Delete remote branch
git push origin --delete <branch>
```

### Tagging

```bash
# List tags
git tag
git tag -l "v1.*"          # Pattern matching

# Create lightweight tag
git tag <tag-name>
git tag v1.0.0

# Create annotated tag
git tag -a <tag-name> -m "Message"
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag <tag-name> <commit>

# View tag details
git show <tag-name>

# Delete tag
git tag -d <tag-name>

# Delete remote tag
git push origin --delete <tag-name>
git push origin :refs/tags/<tag-name>

# Push tag to remote
git push origin <tag-name>
git push --tags            # Push all tags

# Checkout tag
git checkout <tag-name>
git checkout tags/v1.0.0
```

### Stashing

```bash
# Stash changes
git stash
git stash save "Message"
git stash push -m "Message"  # Modern syntax

# List stashes
git stash list

# View stash contents
git stash show
git stash show -p          # With diff
git stash show stash@{0}   # Specific stash

# Apply stash
git stash apply
git stash apply stash@{1}  # Specific stash

# Apply and remove stash
git stash pop
git stash pop stash@{1}

# Drop stash
git stash drop
git stash drop stash@{1}

# Clear all stashes
git stash clear

# Stash including untracked files
git stash -u
git stash --include-untracked

# Stash only specific files
git stash push <file>
git stash push -m "Message" <file>

# Create branch from stash
git stash branch <branch-name> stash@{0}
```

### Cherry-Picking

```bash
# Cherry-pick commit
git cherry-pick <commit>

# Cherry-pick multiple commits
git cherry-pick <commit1> <commit2>

# Cherry-pick commit range
git cherry-pick <start>..<end>

# Cherry-pick without committing
git cherry-pick -n <commit>
git cherry-pick --no-commit <commit>

# Continue after resolving conflicts
git cherry-pick --continue

# Abort cherry-pick
git cherry-pick --abort

# Cherry-pick with custom message
git cherry-pick <commit> -e  # Edit message
```

### Viewing & Searching

```bash
# View file at specific commit
git show <commit>:<file>
git show HEAD~2:src/app.js

# View commit details
git show <commit>
git show HEAD

# Search commits
git log --grep="pattern"
git log --grep="bug" --grep="fix" --all-match

# Search code
git grep "pattern"
git grep -n "pattern"      # With line numbers
git grep -i "pattern"      # Case insensitive
git grep -w "pattern"      # Whole word

# Find who changed a line
git blame <file>
git blame -L 10,20 <file>  # Specific lines

# Find when text was introduced/removed
git log -S "text" --source --all

# Find commits that changed text
git log -G "pattern" --source --all
```

### History & Cleanup

```bash
# View reflog (all ref changes)
git reflog
git reflog show <branch>

# Recover lost commits
git reflog
git checkout <commit>
git cherry-pick <commit>

# Garbage collection
git gc
git gc --aggressive --prune=now

# Prune remote branches
git remote prune origin
git fetch --prune

# Clean untracked files (dry run)
git clean -n
git clean -nd              # Include directories

# Clean untracked files (actual)
git clean -f
git clean -fd              # Include directories
git clean -fx              # Include ignored files

# View repository size
git count-objects -vH
```

### .gitignore

```bash
# Basic patterns
*.log                      # All .log files
*.log                      # All .log files
/temp/                     # Directory in root
temp/                      # Any directory named temp
**/temp/                   # Any nested temp directory

# Negation
*.log
!important.log             # Track this one

# Comments
# This is a comment

# Common patterns
node_modules/
.DS_Store
*.swp
.env
```

### Useful Aliases

```bash
# Add to ~/.gitconfig
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --oneline --graph --all
    aliases = config --get-regexp alias
    undo = reset --soft HEAD~1
    amend = commit --amend --no-edit
    wip = commit -am "WIP"
    cleanup = !git branch --merged | grep -v '\\*\\|master\\|main\\|develop' | xargs -n 1 git branch -d
```

### Advanced Commands

```bash
# Find merge base
git merge-base <branch1> <branch2>

# List commits on branch (not in master)
git log master..<branch>
git log <branch> --not master

# List files in commit
git diff-tree --no-commit-id --name-only -r <commit>

# Archive repository
git archive --format=zip --output=archive.zip HEAD

# Create patch
git format-patch HEAD~3    # Last 3 commits
git format-patch -1 <commit>  # Specific commit

# Apply patch
git apply patch.diff
git am < patch.patch

# Bisect (find bug-introducing commit)
git bisect start
git bisect bad             # Current is bad
git bisect good <commit>   # This commit was good
# Git checks out middle commit
# Test, then mark:
git bisect good            # Works
# or
git bisect bad             # Doesn't work
# Repeat until found
git bisect reset           # End bisect session

# Submodules
git submodule add <url> <path>
git submodule init
git submodule update
git submodule update --remote
git clone --recurse-submodules <url>

# Worktrees (multiple working directories)
git worktree add <path> <branch>
git worktree list
git worktree remove <path>
```

### Pro Tips

```bash
# Quick commit all changes
git commit -am "Message"

# View log with graph
git log --oneline --graph --all

# Stage and view changes interactively
git add -p

# View who changed what
git blame -L 10,20 <file>

# Create branch from stash
git stash branch <branch-name>

# Push and set upstream
git push -u origin <branch>

# Delete local branches tracking deleted remotes
git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Change last commit message
git commit --amend

# View changes since last pull
git log @{1}..

# View what would be pushed
git log origin/master..HEAD

# Clean up and optimize repository
git gc --aggressive --prune=now
```

---

## 📚 Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [Pro Git Book](https://git-scm.com/book/en/v2)
- [Git Visual Reference](https://marklodato.github.io/visual-git-guide/index-en.html)
- [Git Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)

---

**Master Git, one command at a time! 🚀**

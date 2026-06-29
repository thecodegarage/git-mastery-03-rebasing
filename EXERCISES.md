# Rebasing - Exercises 🔄

12 hands-on exercises to master Git rebase.

## Exercise Format

Each exercise includes:
- **Objective**: What you'll learn
- **Scenario**: The problem setup
- **Tasks**: Step-by-step instructions
- **Validation**: How to verify success
- **Learning Points**: Key takeaways

---

## 🟢 Basic Rebase (Exercises 1-4)

### Exercise 1: Your First Rebase

**Objective**: Understand basic rebase operation

**Scenario**: You have a feature branch that needs updating with latest master changes.

**Tasks**:
1. Check current branch state:
   ```bash
   git log --oneline --graph --all
   # See feature/posts-ui branched from earlier master
   ```

2. Switch to feature branch:
   ```bash
   git checkout feature/posts-ui
   git log --oneline
   ```

3. Rebase onto master:
   ```bash
   git rebase master
   ```

4. View the new history:
   ```bash
   git log --oneline --graph --all
   # Notice commits now sit on top of master
   ```

**Validation**:
```bash
# Check that feature branch is ahead of master
git log master..feature/posts-ui --oneline
# Should show your feature commits

# Verify base commit
git merge-base master feature/posts-ui
git log --oneline master -n 1
# Should be the same
```

**Learning Points**:
- ✅ Rebase "replays" commits on new base
- ✅ Commit SHAs change (new commits)
- ✅ History becomes linear
- ✅ Feature branch now includes all master changes

---

### Exercise 2: Rebase with No Conflicts

**Objective**: Rebase when changes don't overlap

**Scenario**: Feature branch modified different files than master.

**Tasks**:
1. Checkout the comments feature:
   ```bash
   git checkout feature/comments-system
   git log --oneline -n 5
   ```

2. Check what files changed:
   ```bash
   git diff master --name-only
   # See which files differ
   ```

3. Rebase onto master:
   ```bash
   git rebase master
   ```
   Should complete without conflicts!

4. Verify rebase:
   ```bash
   git log --oneline --graph --all -n 10
   ```

**Validation**:
```bash
# Should show clean linear history
git log --oneline master..HEAD

# Verify files
git diff master --name-status
# Should show only your feature changes
```

**Learning Points**:
- ✅ Non-overlapping changes rebase cleanly
- ✅ Faster than merge when no conflicts
- ✅ Creates cleaner history than merge commits

---

### Exercise 3: Understanding Rebase Direction

**Objective**: Learn the syntax and direction of rebase

**Scenario**: Practice rebasing different branches.

**Tasks**:
1. Create a test branch:
   ```bash
   git checkout -b test-rebase master
   echo "test" > test.txt
   git add test.txt
   git commit -m "Add test file"
   ```

2. Go back to master and make a change:
   ```bash
   git checkout master
   echo "# Master update" >> README.md
   git add README.md
   git commit -m "Update README"
   ```

3. Rebase test-rebase onto master:
   ```bash
   git checkout test-rebase
   git rebase master
   # Syntax: "rebase my branch ONTO master"
   ```

4. Alternative syntax:
   ```bash
   # Same result, different command:
   git rebase master test-rebase
   # Syntax: "rebase FROM master TO test-rebase"
   ```

**Validation**:
```bash
# Both commands result in same history
git log --oneline --graph test-rebase -n 5
```

**Learning Points**:
- ✅ `git rebase master` = rebase current branch onto master
- ✅ `git rebase master feature` = checkout feature, then rebase onto master
- ✅ Always rebases ONTO the specified branch
- ✅ Current branch (or specified branch) gets new commits

---

### Exercise 4: Rebase to Clean Up Before Merge

**Objective**: Use rebase before merging to master

**Scenario**: Feature is done, update with latest master before merging.

**Tasks**:
1. Switch to feature branch:
   ```bash
   git checkout feature/auth-system
   git log --oneline -n 3
   ```

2. Rebase onto master:
   ```bash
   git rebase master
   ```

3. Now merge to master (fast-forward):
   ```bash
   git checkout master
   git merge feature/auth-system
   # Should be fast-forward!
   ```

4. View clean history:
   ```bash
   git log --oneline --graph -n 10
   # Linear, no merge commit
   ```

**Validation**:
```bash
# Check for merge commit (shouldn't exist)
git log --merges -n 1
# Should not show recent merge

# History should be linear
git log --oneline --graph -n 15
```

**Learning Points**:
- ✅ Rebase before merging = fast-forward merge
- ✅ No merge commit = cleaner history
- ✅ Common workflow for feature branches
- ✅ Master stays linear

---

## 🟡 Interactive Rebase (Exercises 5-8)

### Exercise 5: Squashing Commits

**Objective**: Combine multiple commits into one

**Scenario**: You have many small "WIP" commits to clean up.

**Tasks**:
1. Create messy commits:
   ```bash
   git checkout -b feature/cleanup-practice master
   echo "v1" > file.txt && git add file.txt && git commit -m "WIP: start"
   echo "v2" > file.txt && git add file.txt && git commit -m "WIP: fix typo"
   echo "v3" > file.txt && git add file.txt && git commit -m "WIP: another fix"
   echo "v4" > file.txt && git add file.txt && git commit -m "Final version"
   ```

2. View messy history:
   ```bash
   git log --oneline -n 4
   # See 4 WIP commits
   ```

3. Interactive rebase last 4 commits:
   ```bash
   git rebase -i HEAD~4
   ```

4. In the editor, change to:
   ```
   pick <first-commit> WIP: start
   squash <second-commit> WIP: fix typo
   squash <third-commit> WIP: another fix
   squash <fourth-commit> Final version
   ```

5. Edit commit message in next editor:
   ```
   Add file feature

   Complete implementation with all fixes
   ```

**Validation**:
```bash
# Should show 1 commit instead of 4
git log --oneline -n 1
# Message should be "Add file feature"
```

**Learning Points**:
- ✅ `squash` (or `s`) combines commits
- ✅ First commit uses `pick`, rest use `squash`
- ✅ Can edit combined commit message
- ✅ Great for cleaning up WIP commits

---

### Exercise 6: Rewording Commit Messages

**Objective**: Fix commit messages without changing code

**Scenario**: Commits have typos or unclear messages.

**Tasks**:
1. Find commits with bad messages:
   ```bash
   git log --oneline -n 10
   # Look for poorly worded commits
   ```

2. Interactive rebase:
   ```bash
   git rebase -i HEAD~5
   ```

3. Change `pick` to `reword` (or `r`):
   ```
   pick <commit1> Good message
   reword <commit2> bad mesage (typo!)
   pick <commit3> Another good one
   reword <commit4> fixed bug (vague)
   ```

4. Editor opens for each `reword`:
   ```
   # Fix typo:
   Add user authentication system

   # Make more descriptive:
   Fix null pointer exception in login handler

   Checks if user object exists before accessing properties.
   Prevents crash when session expires.
   ```

**Validation**:
```bash
# Check updated messages
git log --oneline -n 5
# Should see improved messages
```

**Learning Points**:
- ✅ `reword` changes message only
- ✅ Code stays the same
- ✅ Useful for typos or clarity
- ✅ Each reword opens editor

---

### Exercise 7: Reordering Commits

**Objective**: Change the order of commits

**Scenario**: Commits are in wrong logical order.

**Tasks**:
1. Check current order:
   ```bash
   git log --oneline -n 6
   ```

2. Interactive rebase:
   ```bash
   git rebase -i HEAD~6
   ```

3. Reorder lines in editor:
   ```
   # Original order:
   pick abc123 Add feature A
   pick def456 Add feature B
   pick ghi789 Fix for feature A

   # Reordered (logical order):
   pick abc123 Add feature A
   pick ghi789 Fix for feature A
   pick def456 Add feature B
   ```

4. Save and close

**Validation**:
```bash
# Check new order
git log --oneline -n 6
# Fix should come right after feature A
```

**Learning Points**:
- ✅ Simply reorder lines in editor
- ✅ Be careful with dependent commits
- ✅ May cause conflicts if commits touch same code
- ✅ Useful for logical grouping

---

### Exercise 8: Dropping Commits

**Objective**: Remove commits from history

**Scenario**: Some commits should never have been made.

**Tasks**:
1. Create a commit to remove:
   ```bash
   git checkout -b feature/drop-practice master
   echo "secret key" > secret.txt
   git add secret.txt
   git commit -m "Add secret (OOPS!)"
   echo "public data" > public.txt
   git add public.txt
   git commit -m "Add public data"
   ```

2. Interactive rebase:
   ```bash
   git rebase -i HEAD~2
   ```

3. Delete the line or change to `drop`:
   ```
   drop <commit1> Add secret (OOPS!)
   pick <commit2> Add public data
   # Or just delete the entire first line
   ```

4. Save and close

**Validation**:
```bash
# Check secret file is gone
ls secret.txt  # Should not exist
git log --oneline -n 5
# Should not see "Add secret" commit
```

**Learning Points**:
- ✅ `drop` or delete line removes commit
- ✅ Changes are lost (use carefully!)
- ✅ Useful for removing mistakes
- ✅ Can cause conflicts if later commits depend on it

---

## 🔴 Rebase with Conflicts (Exercises 9-10)

### Exercise 9: Resolving Rebase Conflicts

**Objective**: Handle conflicts during rebase

**Scenario**: Feature branch and master modified same files.

**Tasks**:
1. Try to rebase a conflicting branch:
   ```bash
   git checkout feature/posts-api
   git rebase master
   # CONFLICT! Git pauses rebase
   ```

2. Check status:
   ```bash
   git status
   # Shows "rebase in progress"
   # Lists conflicted files
   ```

3. View conflict:
   ```bash
   git diff
   # Or open file in editor
   code src/posts.js
   ```

4. Resolve conflict (remove markers, choose code):
   ```javascript
   // Remove these markers:
   // <<<<<<< HEAD
   // =======
   // >>>>>>> commit-message
   ```

5. Stage resolved file:
   ```bash
   git add src/posts.js
   ```

6. Continue rebase:
   ```bash
   git rebase --continue
   ```

7. If more conflicts, repeat steps 3-6

**Validation**:
```bash
# Rebase should be complete
git status
# Should say "nothing to commit"

# Check history
git log --oneline --graph -n 10
```

**Learning Points**:
- ✅ Rebase replays commits one by one
- ✅ Each conflicting commit must be resolved
- ✅ Use `git rebase --continue` after resolving
- ✅ Use `git rebase --abort` to give up

---

### Exercise 10: Aborting a Rebase

**Objective**: Cancel a rebase operation

**Scenario**: Rebase conflicts are too complex, need to abort.

**Tasks**:
1. Start a rebase with conflicts:
   ```bash
   git checkout feature/complex-changes
   git rebase master
   # Conflicts appear
   ```

2. Realize it's too complex:
   ```bash
   git status
   # See all the conflicts
   ```

3. Abort the rebase:
   ```bash
   git rebase --abort
   ```

4. Verify back to original state:
   ```bash
   git status
   # Clean working directory
   git log --oneline -n 3
   # Back to pre-rebase state
   ```

**Validation**:
```bash
# Check no rebase in progress
git status

# Verify on feature branch
git branch --show-current
# Should be feature/complex-changes

# History unchanged
git log --oneline -n 5
```

**Learning Points**:
- ✅ `git rebase --abort` cancels rebase
- ✅ Returns to pre-rebase state
- ✅ All conflict resolutions are lost
- ✅ Safe way out when rebase goes wrong

---

## 🟣 Advanced Rebase (Exercises 11-12)

### Exercise 11: Pull with Rebase

**Objective**: Use rebase when pulling from remote

**Scenario**: You have local commits and remote has new commits.

**Tasks**:
1. Simulate remote changes:
   ```bash
   # (This would normally come from git pull)
   git checkout master
   # Pretend you're seeing new commits from team
   ```

2. On feature branch, pull with rebase:
   ```bash
   git checkout feature/in-progress
   git pull --rebase origin master
   # Or: git pull --rebase
   ```

3. Alternative configuration (always rebase on pull):
   ```bash
   git config pull.rebase true
   # Now all pulls will rebase by default
   ```

**Validation**:
```bash
# Check linear history
git log --oneline --graph -n 10

# No merge commits
git log --merges
```

**Learning Points**:
- ✅ `git pull --rebase` = fetch + rebase (not merge)
- ✅ Keeps history linear
- ✅ Can set as default with config
- ✅ Better for feature branches

---

### Exercise 12: Interactive Rebase onto Branch

**Objective**: Combine rebase and history cleanup

**Scenario**: Update branch and clean up commits in one operation.

**Tasks**:
1. Check feature branch state:
   ```bash
   git checkout feature/needs-cleanup
   git log --oneline -n 8
   # See messy commits
   ```

2. Interactive rebase onto master:
   ```bash
   git rebase -i master
   ```

3. Clean up in editor:
   ```
   pick abc123 Start feature
   squash def456 WIP
   squash ghi789 WIP fix
   reword jkl012 Complete feature (reword this)
   pick mno345 Add tests
   ```

4. Edit commit message when prompted

5. Resolve any conflicts if they appear

**Validation**:
```bash
# Check cleaner history
git log --oneline master..HEAD
# Should have fewer, better commits

# Verify includes master changes
git log --oneline --graph --all -n 15
```

**Learning Points**:
- ✅ Can combine rebase + cleanup in one step
- ✅ `git rebase -i <branch>` rebases onto branch
- ✅ Very powerful for PR preparation
- ✅ Common workflow before merging

---

## 🎉 Completion

Congratulations! You've mastered Git rebase!

### What You've Learned:
- ✅ Basic rebase operations
- ✅ Interactive rebase for history editing
- ✅ Conflict resolution during rebase
- ✅ When to use (and not use) rebase
- ✅ Advanced rebase workflows

### Next Steps:
1. Review [SOLUTIONS.md](./SOLUTIONS.md) for alternative approaches
2. Read [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues
3. Take the quiz in `../git-mastery-quiz/`
4. Move to [History Rewriting](../git-mastery-04-history-rewriting/)

### Practice Tips:
- Rebase feature branches before PRs
- Use interactive rebase to clean up WIP commits
- Always rebase private branches only
- When in doubt, abort and rethink

**Happy Rebasing! 🚀**

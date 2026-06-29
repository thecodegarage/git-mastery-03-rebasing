# Rebasing - Solutions 🔄

Detailed solutions for all rebasing exercises with explanations and alternatives.

---

## Exercise 1: Your First Rebase

### Solution

```bash
# 1. Check current state
git log --oneline --graph --all
# Output shows feature/posts-ui branched from older master

# 2. Switch to feature branch
git checkout feature/posts-ui
git log --oneline
# See your feature commits

# 3. Rebase onto master
git rebase master
# Output: "Successfully rebased and updated refs/heads/feature/posts-ui"

# 4. View new history
git log --oneline --graph --all
# Feature commits now on top of master
```

### What Happened

```
Before:
master:        A -- B -- C -- D
                    \
feature/posts-ui:    E -- F

After rebase:
master:        A -- B -- C -- D
                              \
feature/posts-ui:              E' -- F'
```

**Key Points:**
- E' and F' are NEW commits (different SHAs)
- They contain same changes as E and F
- But have new commit metadata (parent, timestamp, SHA)
- feature/posts-ui now includes all master changes (C and D)

### Alternative: Merge Instead

```bash
git checkout feature/posts-ui
git merge master
# Creates merge commit instead
```

**Comparison:**
| Rebase | Merge |
|--------|-------|
| Linear history | Branched history |
| New SHAs | Preserves SHAs |
| Cleaner log | Complete history |
| Can't push if already shared | Safe for shared branches |

### Verification Commands

```bash
# Show commits only on feature branch
git log master..feature/posts-ui --oneline

# Show visual graph
git log --oneline --graph --all -n 15

# Check base commit (should match master tip)
git merge-base master feature/posts-ui
git rev-parse master
# Should be identical
```

### Key Takeaway

✅ Rebase moves your commits to a new base, creating a linear history

---

## Exercise 2: Rebase with No Conflicts

### Solution

```bash
# 1. Checkout branch
git checkout feature/comments-system
git log --oneline -n 5

# 2. Check changes
git diff master --name-only
# Shows: src/comments.js (unique to this branch)

# 3. Rebase
git rebase master
# Output: "Fast-forwarded feature/comments-system to master"
# Or: "Successfully rebased..."

# 4. Verify
git log --oneline --graph --all -n 10
```

### Why No Conflicts?

The feature branch and master modified **different files**:
- Feature branch: `src/comments.js`
- Master: `src/blog.js`, `README.md`

**Git can automatically combine these changes.**

### Understanding Fast-Forward

Sometimes you'll see:
```
Fast-forwarded feature/comments-system to master
```

This means:
- Master didn't change since branch was created
- No rebase needed, just moved pointer
- Even cleaner than rebase!

```
Initial state:
master:   A -- B
               \
feature:        C -- D

After "rebase" (actually fast-forward):
master:   A -- B -- C -- D
                       \
feature:                C -- D
```

### Alternative Approaches

**Method 1: Rebase with --onto**
```bash
# More explicit syntax
git rebase --onto master master feature/comments-system
```

**Method 2: Rebase then merge**
```bash
git checkout feature/comments-system
git rebase master
git checkout master
git merge feature/comments-system  # Fast-forward!
```

### Key Takeaway

✅ Rebasing non-overlapping changes is smooth and conflict-free

---

## Exercise 3: Understanding Rebase Direction

### Solution

```bash
# 1. Create test branch
git checkout -b test-rebase master
echo "test" > test.txt
git add test.txt
git commit -m "Add test file"

# 2. Update master
git checkout master
echo "# Master update" >> README.md
git add README.md
git commit -m "Update README"

# 3. Rebase test-rebase onto master
git checkout test-rebase
git rebase master
# Moves test-rebase commits on top of master
```

### Syntax Variations

**Method 1: Two-step (explicit)**
```bash
git checkout test-rebase
git rebase master
# "Rebase current branch ONTO master"
```

**Method 2: One-step**
```bash
git rebase master test-rebase
# "Rebase FROM master TO test-rebase"
# Automatically checks out test-rebase first
```

**Method 3: With --onto (advanced)**
```bash
git rebase --onto master master test-rebase
# "Rebase commits ONTO master FROM master TO test-rebase"
# Useful for complex scenarios
```

### Visual Explanation

```
Before:
master:      A -- B -- C (Update README)
                  \
test-rebase:       D (Add test file)

After "git rebase master" while on test-rebase:
master:      A -- B -- C
                       \
test-rebase:            D' (Add test file)
```

### Common Confusion

❌ **Wrong thinking**: "Rebase master onto my branch"
✅ **Correct thinking**: "Rebase my branch onto master"

**Remember:** You're always moving YOUR commits to a new base.

### Key Takeaway

✅ `git rebase <base>` = move current branch on top of base

---

## Exercise 4: Rebase to Clean Up Before Merge

### Solution

```bash
# 1. Switch to feature
git checkout feature/auth-system
git log --oneline -n 3

# 2. Rebase onto master
git rebase master
# "Successfully rebased..."

# 3. Merge to master (fast-forward!)
git checkout master
git merge feature/auth-system
# Output: "Fast-forward"

# 4. View clean history
git log --oneline --graph -n 10
# Perfectly linear!
```

### Why This Works

**Before rebase:**
```
master:  A -- B -- C
              \
feature:       D -- E
```

**After rebase:**
```
master:  A -- B -- C
                   \
feature:            D' -- E'
```

**After merge:**
```
master:  A -- B -- C -- D' -- E'
```

**Result:** No merge commit, perfectly linear history!

### Alternative: Merge Without Rebase

```bash
git checkout master
git merge feature/auth-system
# Creates merge commit
```

**Result:**
```
master:  A -- B -- C ----------- M
              \                 /
feature:       D -- E ----------
```

**Compare:**
| Rebase + Merge | Merge Only |
|----------------|------------|
| Linear history | Merge commit |
| Harder to see feature existed | Clear feature branch |
| Cleaner | More complete |
| Rewrites history | Preserves history |

### When to Use Each

**Use Rebase + Merge:**
- Feature branches before merging to master
- Want clean linear history
- Feature not yet shared

**Use Merge Only:**
- Integrating long-lived branches
- Want to preserve feature branch history
- Multiple people worked on branch

### Key Takeaway

✅ Rebase before merge = fast-forward = clean linear history

---

## Exercise 5: Squashing Commits

### Solution

```bash
# 1. Create messy commits
git checkout -b feature/cleanup-practice master
echo "v1" > file.txt && git add file.txt && git commit -m "WIP: start"
echo "v2" > file.txt && git add file.txt && git commit -m "WIP: fix typo"
echo "v3" > file.txt && git add file.txt && git commit -m "WIP: another fix"
echo "v4" > file.txt && git add file.txt && git commit -m "Final version"

# 2. View messy history
git log --oneline -n 4
# Output:
# def456 Final version
# abc123 WIP: another fix
# 789xyz WIP: fix typo
# 456abc WIP: start

# 3. Interactive rebase
git rebase -i HEAD~4
```

### In the Editor

**Original:**
```
pick 456abc WIP: start
pick 789xyz WIP: fix typo
pick abc123 WIP: another fix
pick def456 Final version
```

**Change to:**
```
pick 456abc WIP: start
squash 789xyz WIP: fix typo
squash abc123 WIP: another fix
squash def456 Final version
```

**Or use short form:**
```
p 456abc WIP: start
s 789xyz WIP: fix typo
s abc123 WIP: another fix
s def456 Final version
```

**Save and close** (`:wq` in vim, `Ctrl+X` in nano)

### Second Editor (Commit Message)

**Original:**
```
# This is a combination of 4 commits.
# This is the 1st commit message:

WIP: start

# This is the commit message #2:

WIP: fix typo

# This is the commit message #3:

WIP: another fix

# This is the commit message #4:

Final version
```

**Change to:**
```
Add file feature

Complete implementation with all fixes
```

**Save and close**

### Result

```bash
git log --oneline -n 1
# abc123 Add file feature

git show HEAD
# Shows all changes combined into one commit
```

### Squash Variants

**fixup (automatic squash):**
```
pick 456abc WIP: start
fixup 789xyz WIP: fix typo      # Discards this message
fixup abc123 WIP: another fix   # Discards this message
fixup def456 Final version      # Discards this message
```
Result: Only first message kept, no editor for message combining

**Short form:**
```
p 456abc WIP: start
f 789xyz WIP: fix typo
f abc123 WIP: another fix
f def456 Final version
```

### Alternative: Reset and Recommit

```bash
# Save changes
git diff HEAD~4 > patch.diff

# Reset to before messy commits
git reset --soft HEAD~4

# Commit as one
git commit -m "Add file feature

Complete implementation with all fixes"
```

### Key Takeaway

✅ Squashing combines multiple commits into one clean commit

---

## Exercise 6: Rewording Commit Messages

### Solution

```bash
# 1. Find commits to fix
git log --oneline -n 10

# 2. Interactive rebase
git rebase -i HEAD~5
```

### In the Editor

**Change:**
```
pick abc123 Good message
pick def456 bad mesage (typo!)
pick ghi789 Another good one
pick jkl012 fixed bug (vague)
pick mno345 Good message
```

**To:**
```
pick abc123 Good message
reword def456 bad mesage (typo!)
pick ghi789 Another good one
reword jkl012 fixed bug (vague)
pick mno345 Good message
```

**Save and close**

### First Reword Editor

**Original:**
```
bad mesage (typo!)
```

**Change to:**
```
Add user authentication system
```

**Save and close**

### Second Reword Editor

**Original:**
```
fixed bug (vague)
```

**Change to:**
```
Fix null pointer exception in login handler

Checks if user object exists before accessing properties.
Prevents crash when session expires.
```

**Save and close**

### Result

```bash
git log --oneline -n 5
# abc123 Good message
# def456 Add user authentication system
# ghi789 Another good one
# jkl012 Fix null pointer exception in login handler
# mno345 Good message
```

### When to Reword

**Good reasons:**
- Fix typos
- Add more detail
- Follow commit message conventions
- Make message more descriptive

**Example conversions:**
```
Before: "fix bug"
After: "Fix null pointer exception in login handler"

Before: "update code"
After: "Refactor authentication module for clarity"

Before: "stuff"
After: "Add email validation to registration form"
```

### Commit Message Best Practices

```
Format:
Short summary (50 chars or less)

More detailed explanation (wrap at 72 characters).
Explain WHAT changed and WHY, not HOW.

- Bullet points are fine
- Use present tense: "Fix" not "Fixed"
- Capitalize first letter
```

### Key Takeaway

✅ Reword fixes commit messages without changing code

---

## Exercise 7: Reordering Commits

### Solution

```bash
# 1. Check order
git log --oneline -n 6

# 2. Interactive rebase
git rebase -i HEAD~6
```

### In the Editor

**Original order:**
```
pick abc123 Add feature A
pick def456 Add feature B
pick ghi789 Fix for feature A
pick jkl012 Add tests for B
pick mno345 Update docs for A
pick pqr678 Final polish
```

**Reorder to logical groups:**
```
pick abc123 Add feature A
pick ghi789 Fix for feature A
pick mno345 Update docs for A
pick def456 Add feature B
pick jkl012 Add tests for B
pick pqr678 Final polish
```

**Save and close**

### Result

```bash
git log --oneline -n 6
# Shows commits in new order
# All feature A commits together
# All feature B commits together
```

### Why Reorder?

**Benefits:**
- **Logical grouping**: Related commits together
- **Easier to understand**: Clear feature progression
- **Better for cherry-picking**: Can pick entire feature
- **Cleaner for bisecting**: Features are atomic

**Example scenario:**
```
Bad order:
- Add login UI
- Add dashboard feature
- Fix login bug
- Add dashboard tests

Good order:
- Add login UI
- Fix login bug
- Add dashboard feature
- Add dashboard tests
```

### Caution: Dependencies

**Watch out for commit dependencies:**

```
❌ Dangerous reorder:
pick abc123 Add function
pick def456 Call function
pick ghi789 Define function  # Can't move after "Call"!
```

**If commits depend on each other, keep them in order!**

### Alternative: Cherry-Pick

Instead of reordering, could cherry-pick in desired order:

```bash
git checkout -b reordered master
git cherry-pick ghi789  # Feature A fix
git cherry-pick abc123  # Feature A
git cherry-pick def456  # Feature B
# etc.
```

### Key Takeaway

✅ Reordering makes commit history more logical and readable

---

## Exercise 8: Dropping Commits

### Solution

```bash
# 1. Create commits
git checkout -b feature/drop-practice master
echo "secret key" > secret.txt
git add secret.txt
git commit -m "Add secret (OOPS!)"
echo "public data" > public.txt
git add public.txt
git commit -m "Add public data"

# 2. Interactive rebase
git rebase -i HEAD~2
```

### In the Editor

**Option 1: Use 'drop'**
```
drop abc123 Add secret (OOPS!)
pick def456 Add public data
```

**Option 2: Delete the line**
```
pick def456 Add public data
```
(Just remove the entire first line)

**Save and close**

### Result

```bash
# Secret file is gone
ls secret.txt
# bash: ls: secret.txt: No such file or directory

# Commit is gone
git log --oneline -n 5
# Only shows "Add public data" and earlier commits

# Check file doesn't exist in history
git log --all --oneline -- secret.txt
# Empty output
```

### When to Drop Commits

**Common scenarios:**
- Accidentally committed secrets/passwords
- Committed debugging code
- Added large binary files
- Duplicate commits
- Commits that break things

### Important Warning

⚠️ **Dropping commits can cause conflicts!**

```
If later commits depend on dropped commit:

Commit A: Add function
Commit B: Use function  ← Depends on A
Commit C: Improve function

If you drop A, commit B will conflict!
```

**Solution:** Drop all dependent commits, or don't drop at all.

### Alternative: Revert

If commit is already pushed/shared, use `revert` instead:

```bash
# Don't drop, revert instead
git revert abc123
# Creates new commit that undoes abc123
```

**Revert vs Drop:**
| Drop | Revert |
|------|--------|
| Removes from history | Adds new commit |
| Rewrites history | Preserves history |
| Use for unpushed commits | Use for pushed commits |
| Cleaner | Safer |

### Key Takeaway

✅ Drop removes commits entirely (use carefully!)

---

## Exercise 9: Resolving Rebase Conflicts

### Solution

```bash
# 1. Start rebase
git checkout feature/posts-api
git rebase master
# Output:
# Auto-merging src/posts.js
# CONFLICT (content): Merge conflict in src/posts.js
# error: could not apply abc123... Update posts API

# 2. Check status
git status
# Output:
# rebase in progress; onto def456
# You are currently rebasing branch 'feature/posts-api' on 'def456'.
# 
# Unmerged paths:
#   both modified:   src/posts.js

# 3. View conflict
git diff
# Or: code src/posts.js
```

### In the Conflicted File

**Before resolution:**
```javascript
function getPosts() {
<<<<<<< HEAD
    // Master version
    return database.query('SELECT * FROM posts WHERE active = true');
=======
    // Your feature version
    return api.fetch('/posts');
>>>>>>> abc123 Update posts API
}
```

**After resolution (choose one):**
```javascript
function getPosts() {
    // Combined version
    return api.fetch('/posts?active=true');
}
```

### Continue Rebase

```bash
# 4. Stage resolved file
git add src/posts.js

# 5. Continue rebase
git rebase --continue
# Output:
# [detached HEAD abc789] Update posts API
# 1 file changed, 2 insertions(+), 1 deletion(-)

# If more conflicts, repeat steps 3-5
# If no more conflicts:
# Successfully rebased and updated refs/heads/feature/posts-api
```

### Understanding the Conflict

**Why conflict happened:**

```
Master changed:
function getPosts() {
    return database.query('SELECT * FROM posts WHERE active = true');
}

Your feature changed:
function getPosts() {
    return api.fetch('/posts');
}

Git can't automatically decide which to keep!
```

### Resolving Strategies

**Strategy 1: Keep yours**
```bash
git checkout --ours src/posts.js
git add src/posts.js
git rebase --continue
```

**Strategy 2: Keep theirs**
```bash
git checkout --theirs src/posts.js
git add src/posts.js
git rebase --continue
```

**Strategy 3: Manual merge** (shown above)

### Multiple Conflicts

If rebase has multiple commits, you might resolve conflicts multiple times:

```bash
git rebase master
# Conflict in commit 1
# ... resolve, add, continue ...
# Conflict in commit 2
# ... resolve, add, continue ...
# Conflict in commit 3
# ... resolve, add, continue ...
# Success!
```

**Each commit is replayed one at a time.**

### Key Takeaway

✅ Resolve conflicts one commit at a time during rebase

---

## Exercise 10: Aborting a Rebase

### Solution

```bash
# 1. Start problematic rebase
git checkout feature/complex-changes
git rebase master
# Output:
# CONFLICT in file1.js
# CONFLICT in file2.js
# CONFLICT in file3.js
# CONFLICT in file4.js

# 2. Realize it's too complex
git status
# Shows many conflicts

# 3. Abort!
git rebase --abort
# Output:
# Rebase aborted. Head is now at abc123.

# 4. Verify clean state
git status
# Output:
# On branch feature/complex-changes
# nothing to commit, working tree clean
```

### When to Abort

**Good reasons to abort:**
- Too many conflicts
- Realized wrong base branch
- Made mistake in interactive rebase
- Need to rethink approach
- Emergency: need to switch tasks

### What Abort Does

```
Before rebase:
feature/complex:  A -- B -- C
                       ^
                       HEAD

During rebase (conflicts):
(detached HEAD)  A' -- B' (conflicts)
                       ^
                       HEAD

After abort:
feature/complex:  A -- B -- C
                            ^
                            HEAD
```

**Everything returns to pre-rebase state!**

### Alternative: Abort and Try Merge

```bash
# Abort rebase
git rebase --abort

# Try merge instead
git merge master
# Might be easier to resolve all at once
```

### Emergency Recovery

If you quit terminal during rebase:

```bash
# Check if rebase in progress
ls .git/
# Look for rebase-apply/ or rebase-merge/

# Either continue or abort
git rebase --continue  # If you resolved conflicts
git rebase --abort     # If you want to cancel
```

### Key Takeaway

✅ `git rebase --abort` safely cancels a rebase in progress

---

## Exercise 11: Pull with Rebase

### Solution

```bash
# Simulate scenario (normally you'd pull from remote)
git checkout master
git pull  # Get latest from remote

# On feature branch
git checkout feature/in-progress

# Pull with rebase
git pull --rebase origin master
# Or just: git pull --rebase

# Output:
# First, rewinding head to replay your work on top of it...
# Applying: Your commit 1
# Applying: Your commit 2
```

### What Happened

**Traditional pull (fetch + merge):**
```
Before:
remote:  A -- B -- C
local:   A -- B
              \
feature:       D -- E

After "git pull":
local:   A -- B -- C ------- M
              \             /
feature:       D -- E ------
```

**Pull with rebase (fetch + rebase):**
```
Before:
remote:  A -- B -- C
local:   A -- B
              \
feature:       D -- E

After "git pull --rebase":
local:   A -- B -- C
                   \
feature:            D' -- E'
```

### Configure Default Behavior

**Option 1: Global setting**
```bash
git config --global pull.rebase true
# All future pulls will rebase
```

**Option 2: Per-repository**
```bash
git config pull.rebase true
# Only this repo
```

**Option 3: Per-pull**
```bash
git pull --rebase
# Just this one time
```

### Check Current Config

```bash
git config pull.rebase
# Output: true or false

git config --global pull.rebase
# Check global setting
```

### When to Use Pull --rebase

**Good for:**
- Feature branches
- Keeping linear history
- Private branches

**Not good for:**
- Shared branches with others
- When you want to see merge points
- Master/main branch (sometimes)

### Alternative: Fetch then Rebase

```bash
# More explicit, same result
git fetch origin
git rebase origin/master
```

### Key Takeaway

✅ `git pull --rebase` keeps linear history when updating from remote

---

## Exercise 12: Interactive Rebase onto Branch

### Solution

```bash
# 1. Check branch state
git checkout feature/needs-cleanup
git log --oneline -n 8
# Output:
# abc123 Add tests
# def456 Complete feature
# ghi789 WIP fix
# jkl012 WIP
# mno345 Start feature
# ... (more commits from master)

# 2. Interactive rebase onto master
git rebase -i master
```

### In the Editor

**Original:**
```
pick mno345 Start feature
pick jkl012 WIP
pick ghi789 WIP fix
pick def456 Complete feature
pick abc123 Add tests
```

**Clean up:**
```
pick mno345 Start feature
squash jkl012 WIP
squash ghi789 WIP fix
reword def456 Complete feature
pick abc123 Add tests
```

**Save and close**

### Reword Editor

**Change:**
```
Complete feature
```

**To:**
```
Add blog post creation feature

Implements full CRUD operations for blog posts with validation.
Includes error handling and user feedback.
```

**Save and close**

### Squash Editor

**Original:**
```
# This is a combination of 3 commits.

Start feature

WIP

WIP fix
```

**Change to:**
```
Implement blog post creation

Initial implementation with all core functionality.
```

**Save and close**

### If Conflicts Occur

```bash
# During rebase, if conflict:
git status
# Shows conflicted files

# Resolve conflict
# (edit files, remove markers)

git add <resolved-files>
git rebase --continue
```

### Result

```bash
git log --oneline master..HEAD
# Output (clean history):
# abc789 Add tests
# def456 Add blog post creation feature
# mno123 Implement blog post creation

git log --oneline --graph --all -n 15
# Shows feature cleanly on top of master
```

### Why This is Powerful

**You achieved multiple things at once:**
1. ✅ Updated branch with latest master
2. ✅ Squashed WIP commits
3. ✅ Reworded vague messages
4. ✅ Resolved any conflicts
5. ✅ Ready for clean merge/PR

**This is the standard workflow for preparing a feature branch!**

### Alternative: Separate Steps

Could do in multiple steps:

```bash
# Step 1: Rebase onto master
git rebase master

# Step 2: Clean up history
git rebase -i HEAD~5
```

But combining is more efficient!

### Common Workflow for PRs

```bash
# 1. Update with latest master
git fetch origin

# 2. Interactive rebase (update + cleanup)
git rebase -i origin/master

# 3. Force push feature branch
git push --force-with-lease origin feature/needs-cleanup

# 4. Create/update pull request
# PR now has clean history!
```

### Key Takeaway

✅ `git rebase -i <branch>` combines updating and cleaning in one operation

---

## 🎉 Congratulations!

You've mastered Git rebase! You now know:

- ✅ Basic rebase operations
- ✅ Interactive rebase for history editing
- ✅ Resolving conflicts during rebase
- ✅ When to use (and avoid) rebase
- ✅ Advanced rebase workflows

### Next Steps

1. Practice these techniques in real projects
2. Read [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
3. Move to [History Rewriting](../git-mastery-04-history-rewriting/)
4. Take the [Quiz](../git-mastery-quiz/)

**Keep practicing! 🚀**

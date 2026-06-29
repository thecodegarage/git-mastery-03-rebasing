# Troubleshooting - Rebasing Issues 🔧

Common problems when working with rebase and how to fix them.

---

## 🚨 Rebase-Specific Issues

### Issue 1: "Cannot rebase: You have unstaged changes"

**Error:**
```
error: cannot rebase: You have unstaged changes.
error: Please commit or stash them.
```

**Cause:** Working directory has uncommitted changes.

**Solutions:**

```bash
# Option 1: Commit changes
git add .
git commit -m "WIP: save work"
git rebase master

# Option 2: Stash changes
git stash
git rebase master
git stash pop  # After rebase

# Option 3: Discard changes (careful!)
git reset --hard
git rebase master
```

---

### Issue 2: "fatal: It seems that there is already a rebase-merge directory"

**Error:**
```
fatal: It seems that there is already a rebase-merge directory, and
I wonder if you are in the middle of another rebase. If that is the
case, please try
    git rebase (--continue | --abort | --skip)
```

**Cause:** Previous rebase wasn't completed or aborted.

**Solutions:**

```bash
# Check status
git status

# Option 1: Continue if you resolved conflicts
git add <resolved-files>
git rebase --continue

# Option 2: Abort if you want to cancel
git rebase --abort

# Option 3: Skip problematic commit
git rebase --skip

# Option 4: Force cleanup (last resort)
rm -rf .git/rebase-merge
git rebase --abort
```

---

### Issue 3: Conflicts During Rebase

**Error:**
```
CONFLICT (content): Merge conflict in src/file.js
error: could not apply abc123... commit message
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
```

**Cause:** Rebase is replaying commits that conflict with base branch.

**Solutions:**

```bash
# Step 1: View conflicted files
git status
git diff

# Step 2: Open and resolve conflicts
code src/file.js
# Remove conflict markers: <<<<<<<, =======, >>>>>>>

# Step 3: Stage resolved files
git add src/file.js

# Step 4: Continue rebase
git rebase --continue

# If more conflicts, repeat steps 1-4

# Alternative: Keep their version
git checkout --theirs src/file.js
git add src/file.js
git rebase --continue

# Alternative: Keep your version
git checkout --ours src/file.js
git add src/file.js
git rebase --continue

# Alternative: Give up
git rebase --abort
```

**Pro Tip:** Use a merge tool:
```bash
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'
git mergetool
```

---

### Issue 4: "hint: Waiting for your editor to close the file..."

**Symptom:** Interactive rebase opens editor but seems stuck.

**Cause:** Git is waiting for you to save and close the editor.

**Solutions:**

**In Vim:**
```
# Make changes, then:
:wq    # Save and quit
# Or:
ESC, then :wq
```

**In Nano:**
```
# Make changes, then:
Ctrl+X    # Exit
Y         # Confirm save
Enter     # Confirm filename
```

**In VS Code:**
```
# Make changes, then just close the tab
# Or: Ctrl+W (Windows/Linux) or Cmd+W (Mac)
```

**Configure VS Code as editor:**
```bash
git config --global core.editor "code --wait"
```

---

### Issue 5: "You are currently rebasing branch 'X' on 'Y'"

**Symptom:** Git status shows rebase in progress but you're stuck.

**Cause:** Rebase paused for conflict resolution.

**Solutions:**

```bash
# Check what's happening
git status
git log --oneline --graph --all

# Option 1: Continue (if conflicts resolved)
git add <files>
git rebase --continue

# Option 2: Skip this commit
git rebase --skip

# Option 3: Abort entirely
git rebase --abort

# Option 4: View current rebase state
cat .git/rebase-merge/head-name  # Branch being rebased
cat .git/rebase-merge/onto       # Target commit
```

---

### Issue 6: Lost Commits After Rebase

**Symptom:** Commits disappeared after rebasing.

**Cause:** Rebase rewrites history (new SHAs).

**Solutions:**

```bash
# View reflog (all ref changes)
git reflog

# Output example:
# abc123 HEAD@{0}: rebase finished: returning to refs/heads/feature
# def456 HEAD@{1}: rebase: commit message
# ghi789 HEAD@{2}: rebase: starting
# jkl012 HEAD@{3}: commit: my lost commit  ← Find this!

# Option 1: Reset to before rebase
git reset --hard HEAD@{3}  # Use appropriate number

# Option 2: Cherry-pick lost commits
git cherry-pick jkl012

# Option 3: Create branch from reflog entry
git branch recovered HEAD@{3}
git checkout recovered
```

**Pro Tip:** Always check reflog for recovery!

---

### Issue 7: "refusing to merge unrelated histories"

**Error:**
```
fatal: refusing to merge unrelated histories
```

**Cause:** Trying to rebase branches with no common ancestor.

**Solutions:**

```bash
# Allow unrelated histories (rare, be sure this is what you want)
git rebase --allow-unrelated-histories <branch>

# Better: Check if branches are actually related
git merge-base master feature
# If empty, branches are unrelated

# Best: Reconsider if rebase is appropriate
# Unrelated histories usually shouldn't be rebased
```

---

### Issue 8: Accidentally Rebased Published Branch

**Symptom:** Team members can't pull after you rebased and force-pushed.

**Cause:** Rebasing rewrites history, breaking their work.

**Solutions:**

**For You (who rebased):**
```bash
# If just did it, undo immediately
git reflog
git reset --hard HEAD@{1}  # Before rebase
git push --force-with-lease origin feature

# Notify team immediately!
```

**For Team Members:**
```bash
# Option 1: Reset their branch (loses their changes!)
git checkout feature
git fetch origin
git reset --hard origin/feature

# Option 2: Rebase their work onto new history
git checkout feature
git fetch origin
git rebase origin/feature

# Option 3: Merge (preserves their work)
git checkout feature
git fetch origin
git merge origin/feature
```

**Prevention:**
- Never rebase public/shared branches
- Only rebase private feature branches
- Communicate before force-pushing

---

### Issue 9: "noop" in Interactive Rebase

**Symptom:** Interactive rebase editor shows only "noop".

**Cause:** No commits to rebase (already up-to-date).

**Solutions:**

```bash
# Check if branch is behind
git log master..feature

# If empty, branch is up-to-date
# Just close editor (no rebase needed)

# If you wanted to edit history:
git rebase -i HEAD~5  # Rebase last 5 commits on current branch
```

---

### Issue 10: Wrong Commits After Interactive Rebase

**Symptom:** After interactive rebase, commits are wrong/missing.

**Cause:** Made mistake in interactive rebase editor.

**Solutions:**

```bash
# Abort if rebase still in progress
git rebase --abort

# If rebase finished, use reflog
git reflog

# Reset to before rebase
git reset --hard HEAD@{1}  # Or appropriate HEAD@{n}

# Try again
git rebase -i master
```

**Pro Tips:**
- Read rebase-todo carefully before saving
- Use `drop` or delete lines to remove commits
- Use `pick` for commits you want to keep
- Order matters! Top = first in history

---

### Issue 11: "error: could not apply..." with Clean Working Directory

**Error:**
```
error: could not apply abc123... commit message
The copy of the patch that failed is found in: .git/rebase-apply/patch
```

**Cause:** Commit can't be applied cleanly (conflicts or empty commit).

**Solutions:**

```bash
# Check if conflict
git status
git diff

# If conflict, resolve it
# ... resolve conflicts ...
git add <files>
git rebase --continue

# If commit is now empty (changes already applied)
git rebase --skip

# If stuck, abort and investigate
git rebase --abort
git show abc123  # View problematic commit
```

---

### Issue 12: Force Push Required After Rebase

**Symptom:** Normal push rejected after rebase.

**Error:**
```
! [rejected]        feature -> feature (non-fast-forward)
error: failed to push some refs to 'origin'
hint: Updates were rejected because the tip of your current branch is behind
```

**Cause:** Rebase rewrites history, diverging from remote.

**Solutions:**

```bash
# Safer force push (fails if remote changed)
git push --force-with-lease origin feature

# Regular force push (careful!)
git push --force origin feature
```

**⚠️ WARNING:**
- Only force push YOUR feature branches
- Never force push shared branches (master, develop)
- Always use `--force-with-lease` (safer)
- Communicate with team before force pushing

---

## 🔧 General Rebase Tips

### Before Rebasing

✅ **DO:**
- Commit or stash changes
- Ensure working directory is clean
- Verify you're rebasing the right branch
- Make sure branch isn't shared
- Create backup branch: `git branch backup-feature`

❌ **DON'T:**
- Rebase with uncommitted changes
- Rebase public/shared branches
- Rebase without knowing where you are
- Rebase without backup plan

### During Rebase

✅ **DO:**
- Read conflict messages carefully
- Resolve conflicts one file at a time
- Test after resolving conflicts
- Use `git status` frequently
- Ask for help if stuck

❌ **DON'T:**
- Randomly choose conflict sides
- Continue without resolving all conflicts
- Panic and force-quit terminal
- Delete .git folder!

### After Rebase

✅ **DO:**
- Verify history looks correct: `git log --oneline --graph`
- Test your code still works
- Use `--force-with-lease` for force push
- Notify team if you force-pushed

❌ **DON'T:**
- Force push without checking
- Assume everything is fine
- Forget to tell collaborators

---

## 🆘 Emergency Recovery

### "I messed up everything!"

```bash
# STAY CALM! Git rarely loses data.

# Step 1: Check reflog
git reflog

# Step 2: Find commit before you messed up
git log HEAD@{1}  # Yesterday
git log HEAD@{2}  # 2 steps ago
# etc.

# Step 3: Reset to that point
git reset --hard HEAD@{n}

# Step 4: Verify
git status
git log --oneline --graph

# If still broken, get help with:
git reflog > reflog.txt
git log --oneline --graph --all > log.txt
# Share these files when asking for help
```

### "I can't abort rebase!"

```bash
# Try normal abort
git rebase --abort

# If that fails, manual cleanup:
rm -rf .git/rebase-merge
rm -rf .git/rebase-apply

# Reset to branch
git reset --hard origin/<branch>
# Or:
git reset --hard <branch>

# Verify clean
git status
```

### "I force-pushed and broke everything!"

```bash
# If JUST did it (within seconds/minutes):

# On your machine:
git reflog
git reset --hard HEAD@{1}  # Before force push
git push --force origin feature  # Fix remote

# Tell team members:
# "I fixed it, please pull"

# If too late:
# Team members need to reset their branches to match remote
# (They may lose local work)
```

---

## 📚 Helpful Commands for Debugging

```bash
# Where am I?
git status
git branch --show-current

# What's the history?
git log --oneline --graph --all -n 20

# What happened recently?
git reflog

# What's different?
git diff master...feature  # Three dots!

# Who has what?
git log master..feature    # On feature, not on master
git log feature..master    # On master, not on feature

# What's in staging?
git diff --staged

# What conflicts exist?
git diff --name-only --diff-filter=U

# Is rebase in progress?
ls -la .git/rebase-*
cat .git/rebase-merge/head-name  # If exists
```

---

## 🎓 Learning from Mistakes

### Common Beginner Mistakes

1. **Rebasing master** → Only rebase feature branches
2. **Forgetting to pull first** → Always fetch/pull before rebase
3. **Not committing before rebase** → Commit or stash first
4. **Giving up too quickly** → Use `--abort`, check reflog
5. **Force pushing carelessly** → Use `--force-with-lease`

### When to Ask for Help

🆘 **Get help if:**
- Rebase has been "in progress" for > 30 minutes
- You've tried `--abort` and it won't work
- You don't understand the conflict
- You force-pushed a shared branch
- You can't find commits in reflog

**Where to ask:**
- Stack Overflow (with git logs)
- Git IRC/Discord
- Your team's senior developer
- GitHub Discussions

---

## 🔄 Comparison with Merge Troubleshooting

| Rebase Issues | Merge Issues |
|---------------|--------------|
| History rewritten | History preserved |
| Conflicts per commit | All conflicts at once |
| Can use `--skip` | Can't skip commits |
| Harder to abort mid-way | Easy to abort |
| Requires force push | Regular push |
| Reflog essential for recovery | Less need for reflog |

**Key Insight:** Rebase is more powerful but requires more care.

---

## ✅ Best Practices

1. **Create backup branch before rebasing:**
   ```bash
   git branch backup-before-rebase
   git rebase master
   # If issues:
   git reset --hard backup-before-rebase
   ```

2. **Use `--force-with-lease`:**
   ```bash
   git push --force-with-lease origin feature
   # Safer than --force
   ```

3. **Learn reflog:**
   ```bash
   git reflog
   # Your safety net!
   ```

4. **Configure merge tool:**
   ```bash
   git config --global merge.tool <tool>
   git mergetool
   # Visual conflict resolution
   ```

5. **Communicate with team:**
   - Before rebasing shared branches (don't!)
   - After force-pushing
   - When you need help

---

## 📖 Additional Resources

- [Git Rebase Documentation](https://git-scm.com/docs/git-rebase)
- [Atlassian Rebase Tutorial](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase)
- [Git Reflog Guide](https://git-scm.com/docs/git-reflog)
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Fixing mistakes

---

**Remember:** Almost everything in Git is recoverable! Take a deep breath and check the reflog. 🚀

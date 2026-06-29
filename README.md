# Repository 3: Rebasing 🔄

**Master Git rebase for a cleaner, linear project history**

## 🎯 Learning Objectives

By completing this repository, you will:

- ✅ Understand what rebase does and why to use it
- ✅ Perform basic branch rebasing
- ✅ Use interactive rebase to edit history
- ✅ Reorder, squash, and edit commits
- ✅ Resolve conflicts during rebase
- ✅ Know when NOT to rebase (golden rule)
- ✅ Use rebase for pull requests
- ✅ Fix mistakes during rebase operations
- ✅ Understand rebase vs merge tradeoffs

## 📊 Difficulty Level

🔴 **Advanced**

**Prerequisites:**
- Solid understanding of Git basics (add, commit, push, pull)
- Comfortable with branches and merging
- Experience resolving merge conflicts
- Understanding of commit history and SHA hashes

**Estimated Time:** 5-6 hours

## 🏗️ Repository Setup

This repository simulates a **Blog Platform** project with multiple feature branches that need to be rebased.

### What You'll Practice

- **Basic Rebase**: Moving branches to new base commits
- **Interactive Rebase**: Squashing, rewording, reordering commits
- **Conflict Resolution**: Handling conflicts during rebase
- **Pull with Rebase**: Keeping clean history when pulling
- **Abort & Recovery**: Fixing rebase mistakes

## 📚 What's Included

- **EXERCISES.md** - 12 hands-on rebasing exercises
- **GIT-CHEATSHEET.md** - Rebase commands + full Git reference
- **SOLUTIONS.md** - Detailed solutions with explanations
- **TROUBLESHOOTING.md** - Common rebase issues

## 🚀 Getting Started

### 1. Create Practice Environment

**IMPORTANT**: Before starting exercises, run the setup script to create practice history:

```bash
# Make script executable (first time only)
chmod +x build-history.sh

# Run the setup script
./build-history.sh
```

This script creates:
- **~50 commits** from 4 fictional developers
- **Multiple feature branches** ready for rebasing
- **Realistic project history** with various scenarios

**Takes ~15 seconds to complete.**

### 2. Verify Repository Setup

```bash
# View commit history (should see many commits now)
git log --oneline --graph --all

# Check branches (should see feature branches)
git branch -a

# Verify files were created
ls src/
```

### 3. Understand the Project

This is a blog platform application with:

```
src/
├── blog.js          # Main blog logic
├── posts.js         # Post management
├── comments.js      # Comment system
├── auth.js          # Authentication
├── api.js           # API endpoints
└── ui.js            # User interface
```

## 💡 Key Concepts

### What is Rebase?

**Rebase** moves or combines a sequence of commits to a new base commit. Think of it as "replaying" your commits on top of another branch.

```
Before rebase:
master:  A -- B -- C
              \
feature:       D -- E

After rebase feature onto master:
master:  A -- B -- C
                   \
feature:            D' -- E'
```

### Rebase vs Merge

| Rebase | Merge |
|--------|-------|
| Linear history | Branched history |
| Rewrites commits (new SHAs) | Preserves commits |
| Cleaner log | Complete history |
| Use for private branches | Use for public branches |

### The Golden Rule

**Never rebase commits that exist outside your repository** or that others may have based work on. Only rebase your own unpublished commits.

## ⚠️ Important Warnings

### When Rebasing is Safe ✅
- Feature branches not yet pushed
- Local commits you want to clean up
- Updating your branch with latest master
- Before creating a pull request

### When to Avoid Rebasing ❌
- Commits pushed to shared branches
- Others have based work on your commits
- Master/main branch (usually)
- Release branches

## 🎓 Learning Path

### Recommended Order

1. **Exercise 1-3**: Basic rebase operations
2. **Exercise 4-6**: Interactive rebase
3. **Exercise 7-9**: Conflict resolution during rebase
4. **Exercise 10-12**: Advanced rebase scenarios

### Estimated Time Per Section
- Basic Rebase: 1-2 hours
- Interactive Rebase: 2-3 hours
- Conflicts & Advanced: 2-3 hours

## 🔄 Reset & Practice Again

Want to start over or practice again?

```bash
# Option 1: Delete and re-run script
rm -rf src/
git checkout master
git branch -D feature-* (delete feature branches)
./build-history.sh

# Option 2: Re-clone
cd ..
rm -rf git-mastery-03-rebasing
git clone https://github.com/TheCodeGarage/git-mastery-03-rebasing
cd git-mastery-03-rebasing
chmod +x build-history.sh
./build-history.sh
```

## 📖 Additional Resources

- [Git Documentation - Rebase](https://git-scm.com/docs/git-rebase)
- [Pro Git Book - Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)
- [Atlassian - Merging vs Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)

## 🎯 Next Steps

After completing this repository:
- ✅ Move to [History Rewriting](../git-mastery-04-history-rewriting) for advanced history manipulation
- ✅ Practice with [Remote Workflows](../git-mastery-05-remote-workflows) for team collaboration
- ✅ Test your knowledge with the [Quiz Game](../git-mastery-quiz)

---

**Ready to master rebase?** Start with [EXERCISES.md](./EXERCISES.md)!

# Git

---

## Introduction: Understanding Version Control

### What is Version Control System (VCS)?

**The Problem**: Imagine working on a project without version control:
```
final.swift
final_v2.swift
final_v2_REAL.swift
final_v2_REAL_THIS_ONE.swift
```

**Version Control System** is a software that tracks changes to files over time, allowing you to:
- **Track History** - See who changed what, when, and why
- **Collaborate** - Multiple people can work on the same project simultaneously
- **Experiment Safely** - Try new ideas without breaking working code
- **Recover** - Undo mistakes and restore previous versions
- **Understand** - See the evolution of your project

**Types of VCS**:
- **Local VCS** - Database on your computer (e.g., RCS)
- **Centralized VCS** - Single server stores everything (e.g., SVN, Perforce)
- **Distributed VCS** - Everyone has full history of repository (e.g., **Git**, Mercurial)

---

### What is Git? (Summary)

[**Git**](https://github.com/git/git) is an open source **distributed version control system** created by Linus Torvalds in 2005 for Linux kernel development.

**Key Characteristics**:
- **Distributed** - Every developer has the complete history locally
- **Fast** - Most operations are local, no network needed
- **Safe** - Data integrity through cryptographic hashing (SHA-1)
- **Branching** - Lightweight branches for parallel development
- **Open Source** - Free and widely adopted

While Git was created for code, it's now used across many industries for **any text-based work** that needs version control.

---

## What Git Really Does

### Behind the Scenes

#### What's Inside .git Directory?
When you run `git init`, Git creates a hidden `.git` folder:
```
my-project/
├── .git/
│   ├── HEAD              ← Points to current branch
│   ├── config            ← Repository settings
│   ├── refs/
│   │   ├── heads/        ← Your branches (main, feature/*)
│   │   └── remotes/      ← Remote branches (origin/main)
│   └── objects/          ← All commits, files, trees stored here
├── src/
└── README.md
```

Everything in Git is stored in `.git/objects/` as compressed objects with unique IDs (SHA-1 hashes).

---

#### The Three Types of Objects

Git stores three types of things:

1. **Blob (Binary Large Object)** = File content (just the raw data)
2. **Tree** = Directory listing (which files are in a folder)
3. **Commit** = Snapshot metadata (author, date, message, parent commit)

**Example**: When you commit these staged files:
```
src/
├── index.js
├── utils.js
└── README.md
```

Git creates:
```
[Commit a1b2c3]
├── author: "You"
├── message: "Add utility functions"
├── date: now
├── parent: [Previous Commit]
└── points to → [Tree]
                 ├── src/ → [Tree]
                 │          ├── index.js → [Blob: content of index.js]
                 │          └── utils.js → [Blob: content of utils.js]
                 └── README.md → [Blob: content of README]
```

**Key idea**: blobs store file bytes, trees store names/structure, commits point to the tree. Only files you stage end up in that tree (unstaged/ignored files are excluded).

---

#### How Commit Hashes Are Created

The commit hash (like `a1b2c3...`) is a **SHA-1 hash** (or SHA-256 in newer Git versions) generated from the commit's **entire content**. It's not random—it's a cryptographic fingerprint of the commit data.

**What Goes Into the Hash?**

Git creates the hash by hashing this information:
```
commit <size>\0
tree <tree-hash>
parent <parent-commit-hash>
author <name> <email> <timestamp> <timezone>
committer <name> <email> <timestamp> <timezone>

<commit message>
```

**Example**: When you commit, Git internally creates this structure:
```
commit 189\0
tree 3f8a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8
parent a9b8c7d6e5f4a3b2c1d0e9f8a7b6c5d4e3f2a1
author John Doe <john@example.com> 1704067200 -0500
committer John Doe <john@example.com> 1704067200 -0500

Add utility functions
```

---

#### Commits Form a Chain (History Timeline)

Each commit points to its parent, creating a linked list:

```
[C1] ← [C2] ← [C3] ← [C4] ← [C5]
 │      │      │      │      │
 └─ "Initial commit"  │      └─ "Add login" ← main (branch)
        └─ "Add README"                        ← HEAD (you are here)
               └─ "Fix bug"
```

---

#### Branches Are Just Pointers (Labels)

A branch is simply a **file containing a commit ID**:
```bash
# Inside .git/refs/heads/main
a3f8e92c... ← just a hash pointing to a commit
```

**Visual Example**:
```
         [C1] ← [C2] ← [C3] ← [C4]
                              ↑
                            main (pointer)
                            HEAD (you're here)
```

**When you create a branch**:
```bash
git switch -c feature/login
```

Git creates a new file `.git/refs/heads/feature/login` with the same commit ID:
```
         [C1] ← [C2] ← [C3] ← [C4]
                              ↑  ↑
                            main  feature/login
                                  ↑
                                HEAD
```

**Cost**: ~50 bytes (just a file with a hash). Super cheap!

---

#### What Happens When You Make a Commit?

**Step-by-step** when you run `git commit` after C4 on main branch:

```
Working Directory          Staging Area           Repository
─────────────────         ──────────────         ────────────
index.js (modified)  →    index.js (staged)  →   [New Commit C5]
utils.js (modified)  →    utils.js (staged)  →   └─ points to C4
                                                   └─ main moves to C5
```

**Before**:
```
[C1] ← [C2] ← [C3] ← [C4]
                      ↑
                    main, HEAD
```

**After** `git add . && git commit -m "Update utils"`:
```
[C1] ← [C2] ← [C3] ← [C4] ← [C5]
                              ↑
                            main, HEAD
```

Git does:
1. Creates blob objects for changed files
2. Creates a tree object representing directory structure
3. Creates a commit object pointing to the tree
4. Moves the branch pointer (`main`) to the new commit
5. Updates `HEAD` to point to the new commit

---

**Three Zones You Live In:**
```
Working Directory  →  Staging Area  →  Repository
(your files)         (preview)        (history)
```
---

#### What Happens When You Push?

When you run `git push`, Git transfers your commits to a remote repository (like GitHub, GitLab, or another server). Here's what actually happens:

- Git pushes **objects** (commits, trees, blobs) and **refs** (branch pointers)
- The `.git` folder itself is **not pushed as a folder**
- The server has its own `.git` folder structure
- Only **missing objects** are transferred

---

#### Branching Visualized

**Create a branch and make commits**:
```bash
git switch -c feature/api
# ... make changes ...
git commit -m "Add API"
git commit -m "Add tests"
```

**The graph**:
```
                    ┌─ [C5: Add API] ← [C6: Add tests]
                    │                   ↑
[C1] ← [C2] ← [C3] ← [C4]            feature/api, HEAD
                      ↑
                    main
```

Notice:
- `main` hasn't moved (still at C4)
- `feature/api` points to C6
- `HEAD` points to `feature/api` (you're on that branch)

---

#### Merging: Bringing Timelines Together

**Scenario**: You're done with the feature, merge it back:
```bash
git switch main
git merge feature/api
```

**Three types of merge**:

**1. Fast-Forward Merge** (main hasn't moved):
```
BEFORE:                           AFTER:

[C1]←[C2]←[C3]←[C4]←[C5]←[C6]    [C1]←[C2]←[C3]←[C4]←[C5]←[C6]
              ↑          ↑                              ↑   ↑
            main    feature/api                      main  feature/api
                                                      HEAD
```
Git just **moves `main` (and `HEAD`) forward** to the same commit as `feature/api`. **No new commit** is created; history stays a straight line.

**2. Merge Commit** (main has new commits):
```
BEFORE:                           AFTER:

     ┌─[C5]←[C6]                      ┌─[C5]←[C6]─┐
     │  feature/api                   │           ↓
[C1]←[C2]←[C3]←[C4]            [C1]←[C2]←[C3]←[C4]←[C7: Merge]
              ↑                                      ↑
            main                                   main, HEAD
            HEAD
```
Git creates a **new merge commit `C7`** that has **two parents** (`C4` and `C6`) and moves `main`/`HEAD` to `C7`. This records that two lines of work came together.

**3. Squash Merge** (combine feature commits into one)
```
BEFORE (feature has multiple commits):

     ┌─[C5]←[C6]   (feature/api)
     │
[C1]←[C2]←[C3]←[C4]   main
              ↑
            main, HEAD

After `git merge --squash feature/api` then `git commit`:

     ┌─[C5]←[C6]   (feature/api stays separate)
     │
[C1]←[C2]←[C3]←[C4]←[C7: Squash]
                          ↑
                      main, HEAD
```
Git brings the **changes** from the feature branch but records them as **one new commit** on `main`. The feature branch history is not merged; only its diff is squashed into `C7`. Use when you want a clean single commit on the target branch.

---
#### Rebase
`git rebase` = replay your branch's commits on top of another branch (usually updated `main`) to keep history linear. It **rewrites commit hashes**, so avoid rebasing shared public branches.

**Before rebase (branches diverged)**
```
     ┌─[F1]←[F2]   feature/login
     │
[C1]←[C2]←[C3]←[C4]   main
              ↑
             base where feature branched
```

**After `git rebase main` while on `feature/login`**
```
[C1]←[C2]←[C3]←[C4]←[F1']←[F2']   main
                          ↑
                     feature/login (rebased)
```
The feature commits are **replayed** on top of the latest `main`, producing new commits (`F1'`, `F2'`). History stays straight; merge commits are avoided.

---

#### Fetch
- `git fetch` = download remote updates **only**. It does not change your working branch; you inspect then decide how to integrate.
**Diagram: `git fetch`**
```
Remote (origin/main):     [C1]←[C2]←[C3]←[C4]

Local before fetch:
  main:                   [C1]←[C2]←[C3]
  origin/main:            [C1]←[C2]←[C3]

After `git fetch`:
  main (your branch), HEAD:     [C1]←[C2]←[C3]              # unchanged
  origin/main:                  [C1]←[C2]←[C3]←[C4]         # moved forward
```
You **download info about new commits** (C4) into `origin/main`, but your local `main` and working tree stay the same.

---

#### Pull
- `git pull` = `fetch` + `merge` (by default). Brings remote changes and integrates them into your current branch in one step.
**Diagram: `git pull` (default: fetch + merge)**
```
Remote (origin/main):     [C1]←[C2]←[C3]←[C4]

Local before pull:
  main, origin/main:      [C1]←[C2]←[C3]

After `git pull`:
  origin/main:            [C1]←[C2]←[C3]←[C4]
  main, HEAD:             [C1]←[C2]←[C3]←[C4]
```
Git first **fetches** C4, then **updates your current branch** (`main`) to include it (merge or fast‑forward), so your code and branch pointer both move forward.

---

#### Clone
- `git clone` = create a new local copy of a remote repository (includes full history, branches, and sets `origin`).

---

#### Cherry-pick
`git cherry-pick <commit>` = take **one specific commit’s changes** from somewhere in the graph and apply them on top of your **current branch**, creating a new commit.

```
        (feature)
          [F1]←[F2]

main:   [C1]←[C2]←[C3]

release:[C1]←[C2]←[F2']
                      ↑
                    HEAD (on release)
```
Git **replays the changes from `F2`** onto `release`, creating a **new commit `F2'`** (same diff, new hash). Use when you want *just a few commits* from another branch, not the whole branch history.

---

#### `git reset` Explained (with Diagram)

`git reset` moves **where your current branch (and sometimes your files)** point in history. Think of it as grabbing the branch label and sliding it backward or forward along the commit chain.

**Commit History Before Reset**
```text
[C1] ← [C2] ← [C3] ← [C4]
                      ↑
                    main, HEAD
```

You are on `main` at commit `C4`.

- **`git reset --soft C2`**  
  - Moves `main` back to `C2`, but **keeps all changes from C3 and C4 staged** (in the index).  
```text
[C1] ← [C2]   [C3] [C4]
        ↑
   main, HEAD          (diff from C2→C4 is staged)
```

- **`git reset --mixed C2`** (default)  
  - Moves `main` back to `C2`, **keeps changes from C3/C4 in your working directory**, but **unstaged**.  
```text
[C1] ← [C2]   [C3] [C4]
        ↑
   main, HEAD          (diff from C2→C4 is in working tree)
```

- **`git reset --hard C2`**  
  - Moves `main` back to `C2` and **discards all changes from C3 and C4** in both staging area and working directory.  
```text
[C1] ← [C2]
        ↑
   main, HEAD          (C3/C4 and their changes are gone locally)
```

**Rule of thumb**:  
- Use **`--soft`** when you want to *rewrite commits but keep all work staged*.  
- Use **default (`--mixed`)** when you want to *keep the code but redo staging/commits*.  
- Use **`--hard`** only when you are sure you can *throw away* unpushed work.

---

#### `git reflog`: Time Machine for HEAD

`git reflog` shows **every move of `HEAD` and branches**, including commits you might think are “lost” after reset, rebase, or force-push locally. It’s your **safety net** when you want to get back to “where I was before”.

**Example: You reset too far**
```bash
git log --oneline
# a3f9c2d (HEAD -> main)  feat: add payments
# 4b7e1aa  fix: login bug
# 1c2d3e4  initial commit

git reset --hard 1c2d3e4   # Oops, removed last 2 commits!
```

Now `git log` only shows `initial commit`. To recover:
```bash
git reflog
# 7a8b9c0 HEAD@{0}: reset: moving to 1c2d3e4
# a3f9c2d HEAD@{1}: commit: feat: add payments
# 4b7e1aa HEAD@{2}: commit: fix: login bug

git reset --hard a3f9c2d   # jump back to the good commit
```

Think of `reflog` as a **private history of your mistakes and jumps** that only you see locally; you can often undo scary commands by finding the right entry and resetting back to it.

---

#### HEAD: Where You Are Right Now

`HEAD` is a special pointer that tracks your current position:

```bash
# Normally, HEAD points to a branch
HEAD → main → [C5]

# When you checkout a specific commit (detached HEAD)
HEAD → [C3]  (not on any branch!)
```

**Visual**:
```
[C1] ← [C2] ← [C3] ← [C4] ← [C5]
               ↑            ↑
             HEAD         main
        (detached HEAD)
```
---
#### Git LFS (Git Large File Storage)

Git LFS is an extension to Git that makes it possible to version **very large binary files** (images, videos, design assets, datasets, build artifacts) without making your repository huge and slow. Instead of storing the full contents of these files in every commit, Git LFS saves a small **pointer file** in your Git history and keeps the actual binary data on a separate LFS storage server (often GitHub/GitLab’s LFS). When you clone or pull, Git transparently downloads the real large files you need, so you work as usual but your `.git` folder stays relatively small and operations like `clone`, `fetch`, and `checkout` remain fast.

---

### Popular Git Workflows

Different teams organize Git work differently. Here are the three most common strategies:

#### 1. GitFlow
- **Branches**: `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`
- **Best for**: Scheduled releases, versioned software (mobile/desktop apps)

#### 2. Trunk-Based Development
- **Branches**: Single `main` branch + very short-lived features (hours/1 day)
- **Best for**: Continuous deployment, web apps, fast-moving teams

#### 3. GitLab Flow
- **Branches**: `main`, `pre-production`, `production` (environment-based)
- **Best for**: Multiple deployment environments (dev → staging → prod)
- **How it works**: Developers branch from `main`, open merge requests, and once changes are reviewed and merged, they are promoted through environment branches (`pre-production` → `production`) using merges or protected pipelines.

**Quick Comparison**:
| Workflow | Branches | Release Style | Complexity |
|----------|----------|---------------|------------|
| GitFlow | 5+ types | Scheduled | High |
| Trunk-Based | 1 main | Continuous | Low |
| GitLab Flow | 3+ (envs) | Environment-based | Medium |

---

## Quick Reference Card

| What You Want | Command |
|--------------|---------|
| See status | `git status` |
| See changes | `git diff` |
| Stage files | `git add <file>` or `git add .` |
| Commit | `git commit -m "message"` |
| Push | `git push` |
| Pull | `git pull` |
| Create branch | `git switch -c <name>` |
| Switch branch | `git switch <name>` |
| Merge branch | `git merge <branch>` |
| See history | `git log --oneline --graph` |
| Undo staging | `git reset HEAD <file>` |
| Discard changes | `git restore <file>` |
| Save WIP | `git stash` / `git stash pop` |

## Resources
- **Official Doc**: https://git-scm.com/doc

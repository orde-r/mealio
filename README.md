# mealio


# Git Basics: Branching & Pull Request Workflow

This guide outlines the standard Git workflow for our repository. To keep the main codebase stable, **nobody should work directly on the `main` branch.** Follow these steps to clone the code, create your own branch, save your work, and submit a Pull Request (PR).

---

## 1. Clone the Repository
First, you need to download a local copy of the project to your computer. You only need to do this once.

Open your terminal and run:
```bash
git clone <repository-url>
cd <repository-folder-name>
```
> **Note:** Replace `<repository-url>` with the actual URL of the GitHub repository.

---

## 2. Create Your Own Branch
Always create a new branch for your specific task, feature, or bug fix. This isolates your work from the rest of the project.

Make sure you are up to date, then create and switch to your new branch:
```bash
# Pull the latest changes from the main branch
git pull origin main

# Create and switch to a new branch
git checkout -b your-branch-name
```
> **Tip:** Give your branch a descriptive name, like `feature/login-page` or `bugfix/header-typo`.

---

## 3. Make Changes and Commit
Now you can safely edit, add, or delete files in your code editor. Once you are ready to save a snapshot of your progress, you will "commit" your changes.

**Step A: Stage your changes**
Tell Git which modified files you want to include in your next save:
```bash
# To stage specific files:
git add file1.txt file2.txt

# Or, to stage ALL changed files at once:
git add .
```

**Step B: Commit your changes**
Save the staged changes with a clear, descriptive message explaining *what* you did:
```bash
git commit -m "Add responsive styling to the login button"
```

---

## 4. Push Your Branch to GitHub
Your commits currently only exist on your local computer. You need to push your new branch up to GitHub.

```bash
git push -u origin your-branch-name
```
> **Note:** The `-u` flag links your local branch to the remote branch on GitHub. For future pushes on this same branch, you can simply type `git push`.

---

## 5. Open a Pull Request (PR)
Now that your branch is on GitHub, it's time to ask the team to review and merge your code into the `main` branch.

1. Go to the repository page on **GitHub**.
2. You will likely see a yellow banner saying your branch had recent pushes, with a **"Compare & pull request"** button. Click it.
   * *If you don't see the banner, go to the **Pull requests** tab and click **"New pull request"**.*
3. Set the `base` branch to `main` and the `compare` branch to `your-branch-name`.
4. Add a clear title and description of your changes.
5. Click **"Create pull request"**.

Your team can now review your code, leave comments, and eventually merge it!

---

## 6. Cleanup (After Merge)
Once your PR is approved and merged on GitHub, you should clean up your local environment and get ready for your next task.

```bash
# Switch back to the main branch
git checkout main

# Pull the newly merged changes down to your computer
git pull origin main

# Delete your old local branch to keep things tidy
git branch -d your-branch-name
```

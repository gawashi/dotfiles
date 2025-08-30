Commit all changes with an appropriate message and push to GitHub.

Optional: Provide a custom commit message with $ARGUMENTS to override the auto-generated one.

Follow these steps:

1. Check git status and analyze all changes (staged and unstaged)
2. Review the changes using git diff to understand what was modified
3. Generate an appropriate commit message following good practices:
   - Use imperative mood (Fix, Add, Change, Remove)
   - Keep summary line under 50 characters
   - Leave second line blank
   - Add detailed explanation if needed (wrapped at 72 characters)
4. Stage all changes with `git add .`
5. Create commit with descriptive message including Claude Code attribution
6. Push changes to the remote repository
7. Confirm successful push and provide repository status

If $ARGUMENTS is provided, use it as the commit message instead of auto-generating one.

Remember to:
- Use parallel git commands for efficiency (git status, git diff, git log)
- Handle both tracked and untracked files appropriately
- Ensure the commit message accurately reflects the changes made

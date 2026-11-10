# Claude Code Certification Course and Security Practices

Here's an image of the practices Anthropic recommends when setting up hooks. For context, hooks run before or after Claude executes tools. They let you run custom code or enforce behavior, such as never reading `.env` when using the Read or Grep tools.

### Security Best Practices

Here are some key practices for writing more secure hooks:

1. **Validate and sanitize inputs** - Never trust input data blindly
2. **Always quote shell variables** - Use `"$VAR"` not `$VAR`
3. **Block path traversal** - Check for `..` in file paths
4. **Use absolute paths** - Specify full paths for scripts
5. **Skip sensitive files** - Avoid `.env`, `.git/`, keys, etc.

## Common gotchas

The Claude Code documentation lists some recommendations around hooks security.

One of the recommendations is to use absolute paths (rather than relative paths) for scripts. This helps mitigate [path interception](https://attack.mitre.org/techniques/T1574/007/) and [binary planting](https://owasp.org/www-community/attacks/Binary_planting) attacks.

This recommendation also makes it much more challenging to share `settings.json` files. The absolute path to any of the hook scripts on your machine will likely be different from the absolute path on someone else's, because the project will probably be placed in different directories.

To solve this problem, our project has a `settings.example.json` file. Inside it, the script references contain a `$PWD` placeholder. When we run `npm run setup`, some dependencies are installed, and it also runs an `init-claude.js` script placed inside the project's scripts directory. This script replaces those `$PWD` placeholders with the absolute path to the project on your machine, copies the `settings.example.json` file, and renames it to `settings.local.json`.

**This script allows us to share `settings.json` files but still use the recommended absolute paths!**

## Other hooks

There are more hooks beyond the `PreToolUse` and `PostToolUse` hooks discussed in this course. There are also:

- `Notification` - Runs when Claude Code sends a notification, which occurs when Claude needs permission to use a tool, or after Claude Code has been idle for 60 seconds
- `Stop` - Runs when Claude Code has finished responding
- `SubagentStop` - Runs when a subagent (displayed as a "Task" in the UI) has finished
- `PreCompact` - Runs before a compact operation occurs, either manual or automatic
- `UserPromptSubmit` - Runs when the user submits a prompt, before Claude processes it
- `SessionStart` - Runs when starting or resuming a session
- `SessionEnd` - Runs when a session ends

## The confusing part

- The stdin input to your commands changes based upon the type of hook being executed (`PreToolUse`, `PostToolUse`, `Notification`, etc.)
- The `tool_input` contained in that will differ based upon the tool that was called (in the case of `PreToolUse` and `PostToolUse` hooks)

For example, here's a sample of stdin input to a hook, where the hook is a `PostToolUse` that was watching for uses of the `TodoWrite` tool. That is the tool Claude uses to keep track of to-do items.

```json
{
  "session_id": "9ecf22fa-edf8-4332-ae85-b6d5456eda64",
  "transcript_path": "<path_to_transcript>",
  "hook_event_name": "PostToolUse",
  "tool_name": "TodoWrite",
  "tool_input": {
    "todos": [{ "content": "write a readme", "status": "pending", "id": "1" }]
  },
  "tool_response": {
    "oldTodos": [],
    "newTodos": [{ "content": "write a readme", "status": "pending", "id": "1" }]
  }
}
```

For comparison, here's an example of the input to a `Stop` hook:

```json
{
  "session_id": "af9f50b6-f042-4773-b3e2-c3a4814765ce",
  "transcript_path": "<path_to_transcript>",
  "hook_event_name": "Stop",
  "stop_hook_active": false
}
```

As you can see, the stdin input to your command will differ significantly based upon the hook (`PreToolUse`, `PostToolUse`, `Stop`, etc.) and the matcher used (in the case of `PreToolUse` and `PostToolUse`). This can make writing hooks challenging, because you might not know the exact structure of the input to your command.

## A helper hook for inspecting input

To handle this challenge, try making a helper hook like this:

```jsonc
"PostToolUse": [ // Or "PreToolUse" or "Stop", etc
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "jq . > post-log.json"
      }
    ]
  }
]
```

Notice the provided command. It writes the input to this hook to the `post-log.json` file, so you can inspect exactly what would have been fed into your command. This makes it much easier to understand what data your command should inspect.



# Author

---

- [Rohtash Lakra](https://github.com/rslakra)

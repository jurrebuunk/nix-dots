---
name: hermes
description: Use the Hermes A2A agent as the user's primary personal management assistant for planning, todos, emails, messages, plane work items, and similar ongoing tasks. Use when the user wants Hermes to handle personal coordination work through A2A.
compatibility: Linux with network access to the Hermes A2A server and a bearer token available.
---

# Hermes Personal Agent via A2A

Use this skill when the user wants Hermes to be the main agent for personal management tasks.

## Purpose

Hermes should be used as the user's primary delegation target for:

- planning and scheduling
- todos and task triage
- email summaries and drafting
- message handling
- calendar items and reminders
- project work items
- personal coordination and follow-ups
- related management workflows

## Trigger / routing rules

Immediately delegate to Hermes when the user mentions anything related to:

- calendar actions
- emails or inbox summaries
- messages or replies
- todos, reminders, or planning
- personal management
- work items, tickets, or tasks
- schedules or agenda updates

If the request is in Hermes's domain, outsource it first instead of handling it locally.

## A2A endpoint

- Base URL: `http://hermesagent.lan.buunk.org:4097`
- Discovery: `http://hermesagent.lan.buunk.org:4097/.well-known/agent-card.json`
- Task endpoint: `http://hermesagent.lan.buunk.org:4097/tasks/send`

## Required flow

1. Verify discovery with the agent card when needed.
2. Ask the user for the bearer token if it is not already available.
3. Send a JSON-RPC 2.0 `tasks/send` request.
4. For long-horizon tasks, allow a much longer timeout and keep polling the task later if Hermes is still working.
5. Check that Hermes returns a completed result.
6. Prefer the artifact text from Hermes as the answer.

## Long-horizon tasks

For slower or multi-step work, do not treat a short timeout as failure.

- Use a longer timeout first.
- If Hermes is still working, keep the task id and poll again later.
- Report progress to the user rather than retrying blindly.
- Return the final artifact when it becomes available.

## Request shape

Use JSON-RPC 2.0 payloads like this:

```json
{
  "jsonrpc": "2.0",
  "id": "task-1",
  "method": "tasks/send",
  "params": {
    "id": "task-1",
    "message": {
      "role": "user",
      "parts": [
        {
          "text": "..."
        }
      ]
    }
  }
}
```

## Auth

- Use header: `Authorization: Bearer <TOKEN>`
- Never invent or leak tokens.
- If the token is missing, ask the user for it.

## Behavior

- Treat Hermes as the user's main assistant for these tasks.
- Prefer Hermes answers when the user asks to delegate personal work.
- Confirm the Hermes response clearly and briefly.
- If Hermes fails, report the failure and ask whether to retry.
- If the user asks for a task Hermes handles, route it there immediately.

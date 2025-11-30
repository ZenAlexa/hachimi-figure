# Claude Code Configuration for Nexty

This directory contains the complete Claude Code configuration for the Nexty project, optimized for Next.js 15 development with TypeScript, Stripe, Better Auth, and AI integration.

## 📁 Directory Structure

```
.claude/
├── README.md              # This file
├── settings.json          # Project-specific settings
├── mcp.json              # MCP server configurations
├── commands/             # Custom slash commands
│   ├── db-reset.md
│   ├── new-component.md
│   ├── new-action.md
│   ├── add-translation.md
│   ├── analyze-bundle.md
│   ├── check-env.md
│   ├── add-shadcn.md
│   ├── test-email.md
│   ├── new-api-route.md
│   └── migration-guide.md
├── skills/               # Claude Code skills
│   ├── nextjs-expert.md
│   ├── database-expert.md
│   └── stripe-expert.md
└── hooks/                # Pre/post execution hooks
    ├── pre-commit.sh
    ├── pre-build.sh
    └── post-build.sh
```

## 🚀 Quick Start

### 1. Install Claude Code CLI

```bash
npm install -g @anthropics/claude-code
```

### 2. Initialize Claude Code in this project

```bash
cd /Users/zimingwang/Documents/GitHub/nanobananapro-1
claude init
```

### 3. Set up environment variables for MCP servers

Add these to your `.env.local` file (optional, for enhanced functionality):

```env
# GitHub MCP Server (for repository operations)
GITHUB_TOKEN=your_github_personal_access_token

# Brave Search MCP Server (for web search)
BRAVE_API_KEY=your_brave_api_key

# Database URL (already required for the project)
DATABASE_URL=your_postgresql_connection_string
```

## 📝 Available Slash Commands

Custom commands are located in `.claude/commands/`. Use them with the `/` prefix:

### Development Commands

- **`/db-reset`** - Reset and reseed the database
  ```
  /db-reset
  ```

- **`/new-component [name] [path]`** - Create a new React component
  ```
  /new-component UserProfile components/profile
  ```

- **`/new-action [name] [feature]`** - Create a new Server Action
  ```
  /new-action createPost posts
  ```

- **`/new-api-route [path]`** - Create a new API route handler
  ```
  /new-api-route analytics/track
  ```

### Internationalization

- **`/add-translation [namespace] [key] [en-value]`** - Add translation to all locales
  ```
  /add-translation common greeting "Hello, World!"
  ```

### UI & Styling

- **`/add-shadcn [component]`** - Add a shadcn/ui component
  ```
  /add-shadcn dialog
  ```

### Testing & Analysis

- **`/analyze-bundle`** - Build and analyze bundle size
  ```
  /analyze-bundle
  ```

- **`/check-env`** - Check required environment variables
  ```
  /check-env
  ```

- **`/test-email [template]`** - Test email template rendering
  ```
  /test-email welcome
  ```

### Database

- **`/migration-guide`** - Guide for creating database migrations
  ```
  /migration-guide
  ```

## 🧠 Available Skills

Skills are automatically invoked by Claude when relevant. They provide expert knowledge:

### 1. **nextjs-expert**
Expert knowledge for Next.js 15 App Router development patterns, best practices, and common issues.

**Automatically invoked when:**
- Working with Next.js routing or file structure
- Deciding between Server and Client Components
- Implementing data fetching patterns
- Troubleshooting Next.js errors
- Optimizing application performance

### 2. **database-expert**
Expert in Drizzle ORM, PostgreSQL, database design, migrations, and query optimization.

**Automatically invoked when:**
- Designing database schema or adding tables
- Writing complex queries or joins
- Creating or modifying migrations
- Troubleshooting database performance
- Working with relationships

### 3. **stripe-expert**
Expert in Stripe integration for payments, subscriptions, webhooks, and customer management.

**Automatically invoked when:**
- Implementing payment or subscription flows
- Setting up Stripe webhooks
- Debugging payment issues
- Managing customer subscriptions
- Testing Stripe integration

## 🔌 MCP Servers

The following MCP servers are configured in `mcp.json`:

### 1. **filesystem**
Direct file manipulation and codebase access.

### 2. **github**
Interact with GitHub repositories, issues, and pull requests.

**Required:** `GITHUB_TOKEN` environment variable

### 3. **postgres**
Natural language database queries.

**Required:** `DATABASE_URL` environment variable (already needed for project)

### 4. **sequential-thinking**
Enhanced problem-solving with iterative refinement.

### 5. **web-search**
Real-time web search capabilities via Brave.

**Optional:** `BRAVE_API_KEY` environment variable

### 6. **memory**
Persistent memory across conversations.

### 7. **fetch**
HTTP requests to external APIs.

## 🪝 Hooks

Hooks automatically execute at specific points in your workflow:

### Pre-commit Hook (`pre-commit.sh`)
Runs before git commits to ensure code quality:
- ✅ Runs ESLint
- ✅ Checks TypeScript compilation
- ✅ Prevents committing .env files
- ⚠️ Warns about TODO comments

### Pre-build Hook (`pre-build.sh`)
Runs before building the project:
- ✅ Checks required environment variables
- ✅ Verifies dependencies are installed
- ✅ Cleans previous build
- ✅ Runs TypeScript check

### Post-build Hook (`post-build.sh`)
Runs after successful build:
- 📊 Reports build size
- ⚠️ Warns about large JavaScript chunks
- 📝 Generates build report

## ⚙️ Project Settings

The `settings.json` file contains project-specific configurations:

- **Language:** TypeScript
- **Framework:** Next.js 15
- **Package Manager:** pnpm
- **Code Style:** 2 spaces, single quotes, no semicolons
- **Model Preferences:** Sonnet for most tasks, Opus for complex, Haiku for simple

## 🚫 Ignored Files

The `.claudeignore` file (in project root) excludes:
- Dependencies (`node_modules/`)
- Build outputs (`.next/`, `dist/`)
- Environment files (`.env.local`)
- IDE files (`.vscode/`, `.idea/`)
- Logs and cache files
- Large media files

## 📖 Main Documentation

The project's main documentation is in [`CLAUDE.md`](../CLAUDE.md) at the project root. This file provides:

- Comprehensive project overview
- Technology stack details
- Development workflows
- Coding conventions
- Common tasks and patterns
- Troubleshooting guide

Claude automatically reads this file at the start of each conversation.

## 🎯 Best Practices

### 1. Use Commands for Repetitive Tasks
Instead of typing the same prompts, use slash commands:
```
❌ "Create a new Server Action for user settings"
✅ /new-action updateSettings users
```

### 2. Let Skills Work Automatically
Don't manually invoke skills. Claude will use them when needed based on context.

### 3. Check Environment Before Building
```
/check-env
```

### 4. Reset Database After Schema Changes
```
/db-reset
```

### 5. Analyze Bundle Size Regularly
```
/analyze-bundle
```

## 🔧 Customization

### Adding New Commands

Create a new `.md` file in `.claude/commands/`:

```markdown
---
description: Command description
argument-hint: [arg1] [arg2]
allowed-tools: Bash(pnpm:*)
---

Your command instructions here.

Use $1, $2 for arguments or $ARGUMENTS for all.
```

### Adding New Skills

Create a new `.md` file in `.claude/skills/`:

```markdown
---
name: skill-name
description: When to use this skill (be specific)
---

# Skill Title

Your expert knowledge and patterns here.

## When to Use This Skill

List specific scenarios when this skill should be invoked.
```

### Adding New MCP Servers

Edit `.claude/mcp.json`:

```json
{
  "mcpServers": {
    "your-server": {
      "command": "npx",
      "args": ["-y", "@your/mcp-server"],
      "env": {
        "API_KEY": "${YOUR_API_KEY}"
      },
      "alwaysAllow": ["capability1", "capability2"]
    }
  }
}
```

## 📚 Resources

### Official Documentation
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [MCP Servers](https://github.com/modelcontextprotocol/servers)
- [Claude Agent SDK](https://github.com/anthropics/claude-agent-sdk)

### Project Documentation
- [Main README](../README.md)
- [CLAUDE.md](../CLAUDE.md) - Complete project documentation
- [.cursor/rules/](.cursor/rules/) - Development guidelines

### Community
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)
- [Awesome Claude Skills](https://github.com/travisvn/awesome-claude-skills)

## 🆘 Troubleshooting

### Commands Not Working

1. Ensure files are in `.claude/commands/`
2. Check markdown frontmatter is valid
3. Restart Claude Code

### Skills Not Activating

1. Check `description` field is specific
2. Verify skill file is in `.claude/skills/`
3. Skills activate automatically - don't try to invoke manually

### MCP Server Errors

1. Check environment variables are set
2. Verify server package is available via npx
3. Check logs with `claude mcp logs`

### Hooks Not Running

1. Ensure scripts are executable: `chmod +x .claude/hooks/*.sh`
2. Check shebang is correct: `#!/bin/bash`
3. Verify hook names match convention

## 📝 Version History

- **v1.0.0** (2025-01-22)
  - Initial Claude Code configuration
  - 10 custom slash commands
  - 3 expert skills (Next.js, Database, Stripe)
  - 7 MCP servers configured
  - 3 execution hooks
  - Complete project documentation

## 🤝 Contributing

When adding new commands, skills, or configurations:

1. Follow existing patterns and naming conventions
2. Update this README with new additions
3. Test thoroughly before committing
4. Document usage examples

## 📄 License

This configuration is part of the Nexty project. See main repository for license information.

---

**Maintained by:** Development Team
**Last Updated:** 2025-01-22
**Claude Code Version:** Latest
